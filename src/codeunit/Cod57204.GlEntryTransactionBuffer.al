codeunit 57204 GlEntryTransactionBuffer
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        TEMPbuffer_Bnk: Record "Transaction Buffer";
        TEMPDetCusLed: Record "DetailCustLed2DocNo Buffer";



    procedure FillBuffer("CashRec": Record "Cash Entry Posting No.") FilterTransactionNo: text;
    var
        GLentry: Record "G/L Entry";

    begin
        TEMPbuffer_Bnk.reset;
        TEMPbuffer_Bnk.DeleteAll();
        GLentry.SetCurrentKey("Entry No.");
        GLentry.SetLoadFields("Entry No.", "Entry No.", Amount, "Source No.", "Source Type");
        GLentry.SetRange("Document No.", "CashRec"."Document No.");
        GLentry.SetRange("Posting Date", "CashRec"."Posting Date");
        GLentry.SetRange("Source Code", "CashRec"."Source Code");
        GLentry.SetFilter(Amount, '<>%1', 0);
        if GLentry.FindLast() then
            FilterTransactionNo := format(GLentry."Transaction No.");
        GLentry.SetRange("Source Type", CashRec."Source Type");
        GLentry.SetRange("Source No.", CashRec."Source No.");
        if GLentry.FindSet() then
            repeat
                TEMPbuffer_Bnk.Init();
                TEMPbuffer_Bnk."Entry No." := GLentry."Entry No.";
                TEMPbuffer_Bnk."Document Type" := GLentry."Document Type";
                if GLentry."Source Type" <> GLentry."Source Type"::" " then
                    TEMPbuffer_Bnk."Source Type" := GLentry."Source Type";
                if GLentry."Source No." <> '' then
                    TEMPbuffer_Bnk."Source No." := GLentry."Source No.";
                TEMPbuffer_Bnk."Credit Amount" += GLentry.Amount;
                TEMPbuffer_Bnk.Insert();
            until GLentry.Next() = 0;

        FilterTransactionNo := format(GLentry."Transaction No.") + '..' + FilterTransactionNo;

        GLentry.SetRange("Source Type");
        GLentry.SetRange("Source No.");
        TEMPbuffer_Bnk.setrange("Entry No.");
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                if GLentry.Next() = 0 then
                    break;
                TEMPbuffer_Bnk."Balance Entry No. start" := GLentry."Entry No.";
                repeat
                    TEMPbuffer_Bnk."Debit Amount" += GLentry.Amount;
                    TEMPbuffer_Bnk."Balance Entry No. End" := GLentry."Entry No.";
                    if -1 * TEMPbuffer_Bnk."Debit Amount" >= TEMPbuffer_Bnk."Credit Amount" then
                        break;
                until GLentry.Next() = 0;
                TEMPbuffer_Bnk.Modify();
            until TEMPbuffer_Bnk.Next() = 0;
    end;

    procedure ShowPage()
    var
        TransactionBufferPage: Page "Transaction Buffer";
    begin
        page.Run(Page::"Transaction Buffer", TEMPbuffer_Bnk);
    end;

    procedure FillDetCustLedgBuffer(TransactionNoFilter: text)
    var
        CustLedgerEntry: Query GetRelatedCustLedgerEntries;
        n: Integer;
    begin
        TEMPDetCusLed.Reset();
        TEMPDetCusLed.DeleteAll();
        CustLedgerEntry.SetFilter(TransactionNoFilter, TransactionNoFilter);

        CustLedgerEntry.Open();
        while CustLedgerEntry.Read() do begin
            TEMPDetCusLed.Init();
            n += 1;
            TEMPDetCusLed."Entry No." := n;
            TEMPDetCusLed."Entry No." := CustLedgerEntry.EntryNo;
            TEMPDetCusLed."Cust. Ledger Entry No." := CustLedgerEntry.CustLedgEntryNo;
            TEMPDetCusLed."Applied Cust. Ledger Entry No." := CustLedgerEntry.AppliedCustLedEntrNo;
            TEMPDetCusLed."Entry Type" := CustLedgerEntry.EntryType;
            TEMPDetCusLed."Transaction No." := CustLedgerEntry.TransactionNo;
            TEMPDetCusLed."Document No. Bnk" := CustLedgerEntry.DocNoTarget;
            TEMPDetCusLed."Posting Date Bnk" := CustLedgerEntry.PostingDateTarget;
            TEMPDetCusLed."Entry No. Target" := CustLedgerEntry.EntryNoTarget;
            TEMPDetCusLed."Document No. Target" := CustLedgerEntry.DocNoTarget;
            TEMPDetCusLed."Posting Date Target" := CustLedgerEntry.PostingDateTarget;
            TEMPDetCusLed."Amount" := CustLedgerEntry.Amount;
            TEMPDetCusLed.Insert();
        end;
    end;

    procedure ShowPageDetCustLedg()
    var
        DetCustLedgPage: Page "Det. Cust. Ledg2DocNo.";
    begin
        page.Run(Page::"Det. Cust. Ledg2DocNo.", TEMPDetCusLed);
    end;

    procedure CreateAnalyzerFromBuffer()
    begin
        TEMPbuffer_Bnk.Reset();
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                CreateCashFlowHeader();
            until TEMPbuffer_Bnk.Next() = 0;
    end;

    local procedure CreateCashFlowHeader()
    var
        GLentry2Analyze: record "G/L Entry Cash to Analyze";
        RealizedCashFlow: Record "Cashflow Analyse Result";
        GLentry: Record "G/L Entry";
    begin
        GLentry.Get(TEMPbuffer_Bnk."Entry No.");
        GLentry2Analyze.Init();
        GLentry2Analyze."Entry No." := GLentry."Entry No.";
        GLentry2Analyze."Posting Date" := GLentry."Posting Date";
        GLentry2Analyze."Document No." := GLentry."Document No.";
        GLentry2Analyze.Description := GLentry.Description;
        GLentry2Analyze.Amount := GLentry.Amount;

        GLentry2Analyze."Source Type" := GLentry2Analyze."Source Type"::"Bank Account";

        GLentry2Analyze."Journal Templ. Name" := GLentry."Journal Templ. Name";
        GLentry2Analyze."Journal Batch Name" := GLentry."Journal Batch Name";
        GLentry2Analyze."Transaction No. Start" := GLentry."Transaction No.";
        if not GLentry2Analyze.Insert() then
            GLentry2Analyze.Modify();

        RealizedCashFlow.SetRange("G/L Entry No.", GLentry2Analyze."Entry No.");
        if RealizedCashFlow.FindSet() then
            RealizedCashFlow.DeleteAll();
        CreateCashFlowLine();
    end;

    local procedure CreateCashFlowLine()
    begin
        TEMPDetCusLed.Reset();
        TEMPDetCusLed.SetRange("Applied Cust. Ledger Entry No.", TEMPbuffer_Bnk."Balance Entry No. Start", TEMPbuffer_Bnk."Balance Entry No. End");
        if TEMPDetCusLed.FindSet() then
            repeat
                if TEMPDetCusLed."Applied Cust. Ledger Entry No." <> TEMPDetCusLed."Entry No. Target" then begin
                    CreateCashFlowLineFromDetailCustLedger(TEMPDetCusLed);
                end;
            until TEMPDetCusLed.Next() = 0;
    end;

    local procedure CreateCashFlowLineFromDetailCustLedger(var DetailCustLed: Record "DetailCustLed2DocNo Buffer")
    var
        RealizedCashFlow: Record "Cashflow Analyse Result";    //"Realized Cash Flow";
        GLentry: Record "G/L Entry";
        CLE_Applied: Record "Cust. Ledger Entry";
        DetailedCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        SourceType: enum "Realized Cash Flow Source Type";
        Sign: Integer;
    begin
        DetailedCustLedgerEntry.Get(DetailCustLed."Entry No.");
        CLE_Applied.Get(DetailedCustLedgerEntry."Cust. Ledger Entry No.");
        Sign := -1;
        GLentry.Get(TEMPbuffer_Bnk."Entry No.");
        // Bank/Cash Block
        RealizedCashFlow."G/L Entry No." := GLentry."Entry No.";
        RealizedCashFlow."Posting Date" := GLentry."Posting Date";
        RealizedCashFlow."Dimension Set ID" := GLentry."Dimension Set ID";
        RealizedCashFlow."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
        RealizedCashFlow."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";
        RealizedCashFlow."Amount to Analyze" := GLentry.Amount;

        // Realized block
        RealizedCashFlow."G/L Account" := GLentry."G/L Account No.";
        RealizedCashFlow."Cash Flow Category" := GetCashFlowCategory(RealizedCashFlow."G/L Account", RealizedCashFlow."Posting Date");
        RealizedCashFlow."Cash Flow Category Amount" := Sign * DetailedCustLedgerEntry.Amount;

        case CLE_Applied."Document Type" of
            CLE_Applied."Document Type"::Invoice:
                RealizedCashFlow."Applied Document Type" := RealizedCashFlow."Applied Document Type"::Invoice;
            CLE_Applied."Document Type"::"Credit Memo":
                RealizedCashFlow."Applied Document Type" := RealizedCashFlow."Applied Document Type"::"Credit Memo";
            CLE_Applied."Document Type"::"Finance Charge Memo":
                RealizedCashFlow."Applied Document Type" := RealizedCashFlow."Applied Document Type"::"Finance Charge Memo";
            CLE_Applied."Document Type"::Payment:
                RealizedCashFlow."Applied Document Type" := RealizedCashFlow."Applied Document Type"::Payment;
            CLE_Applied."Document Type"::Refund:
                RealizedCashFlow."Applied Document Type" := RealizedCashFlow."Applied Document Type"::Refund;
            CLE_Applied."Document Type"::Reminder:
                RealizedCashFlow."Applied Document Type" := RealizedCashFlow."Applied Document Type"::Reminder;
        end;

        RealizedCashFlow."Applied Document No." := CLE_Applied."Document No.";
        RealizedCashFlow."Applied Document Entry No." := CLE_Applied."Entry No.";
        RealizedCashFlow."Realized Type" := RealizedCashFlow."Realized Type"::"Customer Ledger Entry";
        RealizedCashFlow.GetLastEntryNo();
        RealizedCashFlow.Validate("Dimension Set ID", CLE_Applied."Dimension Set ID");
        RealizedCashFlow."Place of Birth" := 'Applied Customer Ledger Entry';
        RealizedCashFlow."Transaction No." := CLE_Applied."Transaction No.";
        RealizedCashFlow.Insert();
    end;

    local procedure GetCashFlowCategory(GLAccNo: Code[20]; pPostingDate: Date) CashFlowCategory: Code[20]
    var
        CashFlowCategoryGLAccount: record "Cash Flow Category G/L Account";
        recExist: Boolean; //Task 2240: manage dummy cashflow category
    begin
        CashFlowCategoryGLAccount.SetRange("G/L Account No.", GLAccNo);
        CashFlowCategoryGLAccount.SetFilter("Start Date", '%1|..%2', 0D, pPostingDate);
        recExist := CashFlowCategoryGLAccount.FindLast();
        if not recExist then begin
            CashFlowCategoryGLAccount.SetFilter("G/L Account No.", '');
            CashFlowCategoryGLAccount.FindFirst(); //will get blank 
        end;
        CashFlowCategoryGLAccount.TestField("Cash Flow Category");
        exit(CashFlowCategoryGLAccount."Cash Flow Category");
    end;
}
