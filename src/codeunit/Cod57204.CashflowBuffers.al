codeunit 57204 "Cashflow Buffers"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        TEMPbuffer_Bnk: Record "Transaction Buffer" temporary;
        TEMPDetailedLedger: Record "DetailLedger2DocNo Buffer" temporary;
        TEMPDetailedLedger_EntryNo: Integer;
        TEMPgrip: record "GRIP Invoice Analyze Data" temporary;
        TEMPCashFlowCategory: record "Cash Flow Category G/L Account" temporary;
        GripFilters: List of [Text];
        GripFiltersCrMemo: List of [Text];
        CashFlowLineNo: Integer;

    procedure ShowPage()
    var
        TransactionBufferPage: Page "Transaction Buffer";
    begin
        page.Run(Page::"Transaction Buffer", TEMPbuffer_Bnk);
    end;

    procedure ShowPageDetailedLedg()
    var
        DetailedLedgerPage: Page "DetailedLedger2DocNo Buffer";
    begin
        page.Run(Page::"DetailedLedger2DocNo Buffer", TEMPDetailedLedger);
    end;

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
                TEMPbuffer_Bnk."Posting Date" := GLentry."Posting Date";
                TEMPbuffer_Bnk."Document No." := GLentry."Document No.";
                TEMPbuffer_Bnk."Document Type" := GLentry."Document Type";
                if GLentry."Source Type" <> GLentry."Source Type"::" " then
                    TEMPbuffer_Bnk."Source Type" := GLentry."Source Type";
                if GLentry."Source No." <> '' then
                    TEMPbuffer_Bnk."Source No." := GLentry."Source No.";
                TEMPbuffer_Bnk."Cashflow Amount" += GLentry.Amount;
                TEMPbuffer_Bnk."Journal Templ. Name" := GLentry."Journal Templ. Name";
                TEMPbuffer_Bnk."Journal Batch Name" := GLentry."Journal Batch Name";
                TEMPbuffer_Bnk."Transaction No." := GLentry."Transaction No.";
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
                TEMPbuffer_Bnk."Init LedgerEntryNo Start" := GLentry."Entry No.";
                repeat
                    TEMPbuffer_Bnk."Balance Amount" += GLentry.Amount;
                    TEMPbuffer_Bnk."Init LedgerEntryNo End" := GLentry."Entry No.";
                    TEMPbuffer_Bnk."Source Type" := GLentry."Source Type";
                    TEMPbuffer_Bnk."Source No." := GLentry."Source No.";
                    TEMPbuffer_Bnk."GL Account No." := GLentry."G/L Account No.";
                    if -1 * TEMPbuffer_Bnk."Balance Amount" >= TEMPbuffer_Bnk."Cashflow Amount" then
                        break;
                until GLentry.Next() = 0;
                TEMPbuffer_Bnk.Modify();
            until TEMPbuffer_Bnk.Next() = 0;
    end;

    procedure DeleteDetailedLedger()
    begin
        TEMPDetailedLedger.Reset();
        TEMPDetailedLedger.DeleteAll();
        TEMPDetailedLedger_EntryNo := 0;
    end;

    procedure FillDetCustLedgBuffer(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text)
    var
        CustLedgerEntry: Query GetRelatedCustLedgerEntries;
    begin
        CustLedgerEntry.SetFilter("DocNoFilter", '=%1', PostRec."Document No.");
        CustLedgerEntry.SetFilter("PostingDateFilter", '=%1', PostRec."Posting Date");

        CustLedgerEntry.Open();
        while CustLedgerEntry.Read() do begin
            TEMPDetailedLedger_EntryNo += 1;
            TEMPDetailedLedger.Init();
            TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
            TEMPDetailedLedger."Is Init" := CustLedgerEntry.Init_CustLedgEntryNo = CustLedgerEntry.CustLedgEntryNo;
            TEMPDetailedLedger."Init Entry No." := CustLedgerEntry.Init_EntryNo;
            TEMPDetailedLedger."Init Ledger Entry No." := CustLedgerEntry.Init_CustLedgEntryNo;
            TEMPDetailedLedger."Entry No." := CustLedgerEntry.EntryNo;
            TEMPDetailedLedger."Ledger Entry No." := CustLedgerEntry.CustLedgEntryNo;
            TEMPDetailedLedger."Applied Ledger Entry No." := CustLedgerEntry.AppliedCustLedEntrNo;
            TEMPDetailedLedger."Entry Type" := CustLedgerEntry.EntryType;
            TEMPDetailedLedger."Transaction No." := CustLedgerEntry.TransactionNo;
            TEMPDetailedLedger."Document No." := CustLedgerEntry.DocumentNo;
            TEMPDetailedLedger."Amount" := CustLedgerEntry.Amount;
            TEMPDetailedLedger."Posting Date" := CustLedgerEntry.PostingDate;
            TEMPDetailedLedger."led_Entry No." := CustLedgerEntry.Cle_EntryNo;
            TEMPDetailedLedger."led_Document Type" := CustLedgerEntry.Cle_DocType;
            TEMPDetailedLedger."led_Document No." := CustLedgerEntry.Cle_DocNo;
            TEMPDetailedLedger."led_Posting Date" := CustLedgerEntry.Cle_PostingDate;
            TEMPDetailedLedger."led_Account No." := CustLedgerEntry.Cle_AccountNo;
            TEMPDetailedLedger."led_Amount" := CustLedgerEntry.Cle_Amount;
            TEMPDetailedLedger."led_Dimension Set ID" := CustLedgerEntry.Cle_Dimension_Set_ID;
            TEMPDetailedLedger.Insert();
        end;
    end;

    procedure FillDetVendorLedgBuffer(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text)
    var
        VendorLedgerEntry: Query GetRelatedVendLedgerEntries;
    begin
        VendorLedgerEntry.SetFilter("DocNoFilter", '=%1', PostRec."Document No.");
        VendorLedgerEntry.SetFilter("PostingDateFilter", '=%1', PostRec."Posting Date");

        VendorLedgerEntry.Open();
        while VendorLedgerEntry.Read() do begin
            TEMPDetailedLedger_EntryNo += 1;
            TEMPDetailedLedger.Init();
            TEMPDetailedLedger."Entry No." := TEMPDetailedLedger_EntryNo;
            TEMPDetailedLedger."Vendor Ledger Entry No." := VendorLedgerEntry.VendLedgEntryNo;
            TEMPDetailedLedger."Applied Ledger Entry No." := VendorLedgerEntry.AppliedVendLedgEntryNo;
            TEMPDetailedLedger."Entry Type" := VendorLedgerEntry.EntryType;
            TEMPDetailedLedger."Transaction No." := VendorLedgerEntry.TransactionNo;
            TEMPDetailedLedger."Document No." := VendorLedgerEntry.DocumentNoBnk;
            TEMPDetailedLedger."Posting Date" := VendorLedgerEntry.PostingDateBnk;
            TEMPDetailedLedger."led_Entry No." := VendorLedgerEntry.EntryNoTarget;
            TEMPDetailedLedger."led_Document No." := VendorLedgerEntry.DocNoTarget;
            TEMPDetailedLedger."led_Posting Date" := VendorLedgerEntry.PostingDateTarget;
            TEMPDetailedLedger."Amount" := VendorLedgerEntry.Amount;
            TEMPDetailedLedger."led_Account No." := VendorLedgerEntry.AccountNo;
            TEMPDetailedLedger."led_Amount" := VendorLedgerEntry.TargetAmount;
            TEMPDetailedLedger.Insert();
        end;
    end;

    procedure CreateAnalyze()
    var
        FilterBuilder: Codeunit FilterBuilder;
        i, n : Integer;
        DocFilter: Text;
        testMode: Boolean;
    begin
        testMode := true;
        DeleteOldAnalyzes();
        CreateCashFlowHeaders();
        FillTEMPCashFlowCategory();
        TEMPDetailedLedger.setrange("led_Document Type", TEMPDetailedLedger."led_Document Type"::Invoice);
        TEMPDetailedLedger.SetFilter("led_Document No.", '%1..', 'VF25');
        TEMPDetailedLedger.SetCurrentKey("led_Document Type", "led_Document No.");
        if not TEMPDetailedLedger.IsEmpty() then
            n := FilterBuilder.BuildEntryNoFilter(TEMPDetailedLedger);
        for i := 1 to n do begin
            DocFilter := FilterBuilder.GetFilterChunk(i);
            if not testMode then
                FillTempGrip(DocFilter);
            TEMPDetailedLedger.SetFilter("led_Document No.", DocFilter);
            TEMPDetailedLedger.SetFilter("Ledger Entry No.", '<>%1', 0);
            if TEMPDetailedLedger.FindSet() then
                repeat
                    //TEMPDetailedLedger.SetRange("Is Init", true);
                    TEMPDetailedLedger.SetRange("Init Ledger Entry No.", TEMPDetailedLedger."Init Ledger Entry No.");
                    TEMPDetailedLedger.FindFirst();

                    if TEMPDetailedLedger."Is Init" then
                        TEMPbuffer_Bnk.SetRange("Init LedgerEntryNo Start", TEMPDetailedLedger."Init Entry No.")
                    else
                        TEMPbuffer_Bnk.SetRange("Init LedgerEntryNo Start", TEMPDetailedLedger."Init Ledger Entry No.");
                    TEMPbuffer_Bnk.FindFirst();
                    CreateCashFlowLine(testMode);

                    TEMPDetailedLedger.SetRange("Init Ledger Entry No.", TEMPbuffer_Bnk."Init LedgerEntryNo Start");
                    TEMPDetailedLedger.findlast;
                    TEMPDetailedLedger.SetRange("Init Ledger Entry No.");

                    TEMPbuffer_Bnk.Delete();


                until TEMPDetailedLedger.Next() = 0;
        end;
        // non grip loop here
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                //TEMPDetailedLedger.SetRange("Is Init", true / false;
                TEMPDetailedLedger.SetRange("Led_Entry No.", TEMPbuffer_Bnk."Init LedgerEntryNo Start");
                CreateCashFlowLine(testMode);

            until TEMPbuffer_Bnk.Next() = 0;

    end;

    local procedure DeleteOldAnalyzes()
    var
        FilterBuilder: Codeunit FilterBuilder;
        Filters: List of [Text];
        i, n : Integer;
        analyzeHeader: record "CashFLow Analyze Header";
        analyzeLine: record "Cashflow Analyse Line";
    begin
        Filters := FilterBuilder.BuildEntryNoFilter(TEMPbuffer_Bnk);
        n := Filters.Count();
        for i := 1 to n do begin
            analyzeHeader.SetFilter("Entry No.", Filters.Get(i));
            if not analyzeHeader.IsEmpty() then
                analyzeHeader.DeleteAll(false);
            analyzeLine.SetFilter("G/L Entry No.", Filters.Get(i));
            if not analyzeLine.IsEmpty() then
                analyzeLine.DeleteAll(false);
        end;
    end;

    local procedure CreateCashFlowHeaders()
    var
        AnalyzeHeader: record "CashFLow Analyze Header";
        GLentry: Record "G/L Entry";
    begin
        TEMPbuffer_Bnk.Reset();
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                AnalyzeHeader.Init();
                AnalyzeHeader."Entry No." := TEMPbuffer_Bnk."Entry No.";
                AnalyzeHeader."Posting Date" := TEMPbuffer_Bnk."Posting Date";
                AnalyzeHeader."Document No." := TEMPbuffer_Bnk."Document No.";
                AnalyzeHeader.Description := TEMPbuffer_Bnk.Description;
                AnalyzeHeader.Amount := TEMPbuffer_Bnk."Cashflow Amount";
                if TEMPbuffer_Bnk."Source Type" = TEMPbuffer_Bnk."Source Type"::"Bank Account" then
                    AnalyzeHeader."Analyse Type" := AnalyzeHeader."Analyse Type"::"Bank Account"
                else
                    AnalyzeHeader."Analyse Type" := AnalyzeHeader."Analyse Type"::"Cash Statement";
                AnalyzeHeader."Journal Templ. Name" := TEMPbuffer_Bnk."Journal Templ. Name";
                AnalyzeHeader."Journal Batch Name" := TEMPbuffer_Bnk."Journal Batch Name";
                AnalyzeHeader."Transaction No. Start" := TEMPbuffer_Bnk."Transaction No.";
                AnalyzeHeader."Source No." := TEMPbuffer_Bnk."Source No.";
                AnalyzeHeader."Source Type" := TEMPbuffer_Bnk."Source Type";
                AnalyzeHeader.Insert();
            until TEMPbuffer_Bnk.Next() = 0;
    end;

    local procedure CreateCashFlowLine(testMode: Boolean)
    var
        SourceType: enum "Realized Cash Flow Source Type";
        n: Integer;
    begin

        case TEMPbuffer_Bnk."Source Type" of
            TEMPbuffer_Bnk."Source Type"::" ":
                begin
                    TEMPDetailedLedger.SetFilter("Vendor Ledger Entry No.", '=%1', 0);
                    TEMPDetailedLedger.SetFilter("Ledger Entry No.", '=%1', 0);

                end;
            TEMPbuffer_Bnk."Source Type"::Customer:
                begin
                    TEMPDetailedLedger.Setrange("Applied Ledger Entry No.", TEMPbuffer_Bnk."Init LedgerEntryNo Start", TEMPbuffer_Bnk."Init LedgerEntryNo End");
                    // TEMPDetailedLedger.Setrange("Cle_Account No.", TEMPbuffer_Bnk."Source No.");
                    // TEMPDetailedLedger.FilterGroup(-1);
                    // TEMPDetailedLedger.SetFilter("Cust. Ledger Entry No.", '%1', TEMPbuffer_Bnk."Balance Entry No. End");
                    // TEMPDetailedLedger.SetFilter("Applied Ledger Entry No.", '%1', TEMPbuffer_Bnk."Balance Entry No. Start");
                    // TEMPDetailedLedger.FilterGroup(0);
                end;
            TEMPbuffer_Bnk."Source Type"::Vendor:
                begin
                    //TEMPDetailedLedger.Setrange("Account No.", TEMPbuffer_Bnk."Source No.");
                    //TEMPDetailedLedger.Setrange("Target Amount", TEMPbuffer_Bnk."Cashflow Amount");
                end;
            else
                ;
        end;
        // if TEMPDetailedLedger.FindSet() then begin
        //     CashFlowLineNo := 0;

        //     //if TEMPbuffer_Bnk."Source Type" = TEMPbuffer_Bnk."Source Type"::Customer then
        //     //    InsertwithGrip()
        //     //else
        //     InsertwithDetailBuffer(testMode);
        // end;
        InsertwithDetailBuffer(testMode);
    end;

    local procedure InsertwithDetailBuffer(testMode: Boolean)
    var
        CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
        GLentry: Record "G/L Entry";
        GLaccount: Record "G/L Account";
        Sign: Integer;
    begin
        if not TEMPDetailedLedger.FindSet() then
            exit;
        CashFlowLineNo := 0;
        repeat
            if not TEMPDetailedLedger."Is Init" then begin
                TEMPgrip.SetRange("Document No.", TEMPDetailedLedger."led_Document No.");
                if (Not TEMPgrip.findset) or testMode then begin
                    Sign := -1;
                    GLentry.Get(TEMPbuffer_Bnk."Entry No.");
                    // Bank/Cash Block
                    CashFlowLine."G/L Entry No." := GLentry."Entry No.";
                    CashFlowLine."Posting Date" := GLentry."Posting Date";
                    CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
                    CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
                    CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";
                    CashFlowLine."Amount to Analyze" := GLentry.Amount;

                    // Realized block
                    CashFlowLine."G/L Account" := GLentry."G/L Account No.";
                    CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
                    CashFlowLine."Cash Flow Category Amount" := Sign * TEMPDetailedLedger."Amount";

                    case TEMPDetailedLedger."led_Document Type" of
                        TEMPDetailedLedger."led_Document Type"::Invoice:
                            CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
                        TEMPDetailedLedger."led_Document Type"::"Credit Memo":
                            CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::"Credit Memo";
                        TEMPDetailedLedger."led_Document Type"::"Finance Charge Memo":
                            CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::"Finance Charge Memo";
                        TEMPDetailedLedger."led_Document Type"::Payment:
                            CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Payment;
                        TEMPDetailedLedger."led_Document Type"::Refund:
                            CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Refund;
                        TEMPDetailedLedger."led_Document Type"::Reminder:
                            CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Reminder;
                    end;

                    CashFlowLine."Applied Document No." := TEMPDetailedLedger."led_Document No.";
                    CashFlowLine."Applied Document Entry No." := TEMPDetailedLedger."led_Entry No.";
                    CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"Customer Ledger Entry";
                    CashFlowLineNo += 1;
                    CashFlowLine."Entry Line No." := CashFlowLineNo;
                    //CashFlowLine.Validate("Dimension Set ID", CLE_Applied."Dimension Set ID");
                    CashFlowLine."Place of Birth" := 'Applied Customer Ledger Entry';
                    CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";
                    CashFlowLine.Insert();
                end else begin
                    GLentry.Get(TEMPbuffer_Bnk."Entry No.");
                    // Bank/Cash Block
                    CashFlowLine."G/L Entry No." := GLentry."Entry No.";
                    CashFlowLine."Posting Date" := GLentry."Posting Date";
                    CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
                    CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
                    CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";
                    CashFlowLine."Amount to Analyze" := GLentry.Amount;

                    // Realized block
                    CashFlowLine."Is Grip" := true;
                    GLaccount.get(TEMPgrip."G/L Account");
                    CashFlowLine."G/L Account" := TEMPgrip."G/L Account";
                    CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");

                    CashFlowLine."Cash Flow Category Amount" := 1;//TEMPgrip.GetAmountFromDocumentNo(); //TEMPgrip.Amount;

                    CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
                    CashFlowLine."Applied Document No." := TEMPgrip."Document No.";
                    CashFlowLine."Applied Document Entry No." := TEMPgrip."Exploitation No.";
                    CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"CashFlow Category GRIP Invoice";

                    CashFlowLineNo += 1;
                    CashFlowLine."Entry Line No." := CashFlowLineNo;
                    //CashFlowLine.Validate("Dimension Set ID", CLE_Applied."Dimension Set ID");
                    CashFlowLine."Place of Birth" := 'CreateRealizedCashFlowFromGRIPInvoice 01';
                    CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";
                    CashFlowLine.insert();
                end;
            end;
        until TEMPDetailedLedger.Next() = 0;
    end;

    // local procedure InsertwithGrip()
    // var
    //     CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
    //     GLaccount: Record "G/L Account";
    //     GLentry: Record "G/L Entry";
    //     Sign: Integer;
    // begin
    //     repeat
    //         TEMPgrip.SetRange("Document No.", TEMPDetailedLedger."Cle_Document No.");
    //         if Not TEMPgrip.findset then begin
    //             //TEMPDetailedLedger.SetRange("Entry No.", TEMPDetailedLedger."Entry No.");
    //             InsertwithDetailBuffer();
    //             //TEMPDetailedLedger.SetRange("Entry No.");
    //         end else
    //             repeat
    //                 GLentry.Get(TEMPbuffer_Bnk."Entry No.");
    //                 // Bank/Cash Block
    //                 CashFlowLine."G/L Entry No." := GLentry."Entry No.";
    //                 CashFlowLine."Posting Date" := GLentry."Posting Date";
    //                 CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
    //                 CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
    //                 CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";
    //                 CashFlowLine."Amount to Analyze" := GLentry.Amount;

    //                 // Realized block
    //                 CashFlowLine."Is Grip" := true;
    //                 GLaccount.get(TEMPgrip."G/L Account");
    //                 CashFlowLine."G/L Account" := TEMPgrip."G/L Account";
    //                 CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
    //                 CashFlowLine."Cash Flow Category Amount" := TEMPgrip.Amount;
    //                 CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
    //                 CashFlowLine."Applied Document No." := TEMPgrip."Document No.";
    //                 CashFlowLine."Applied Document Entry No." := TEMPgrip."Exploitation No.";
    //                 CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"CashFlow Category GRIP Invoice";

    //                 CashFlowLineNo += 1;
    //                 CashFlowLine."Entry Line No." := CashFlowLineNo;
    //                 //CashFlowLine.Validate("Dimension Set ID", CLE_Applied."Dimension Set ID");
    //                 CashFlowLine."Place of Birth" := 'CreateRealizedCashFlowFromGRIPInvoice 01';
    //                 CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";
    //                 CashFlowLine.insert();
    //             until TEMPgrip.Next() = 0;
    //     until TEMPDetailedLedger.Next() = 0;
    // end;

    local procedure GetCashFlowCategory(GLAccNo: Code[20]; pPostingDate: Date) CashFlowCategory: Code[20]
    var
        recExist: Boolean; //Task 2240: manage dummy cashflow category
    begin
        TEMPCashFlowCategory.SetRange("G/L Account No.", GLAccNo);
        TEMPCashFlowCategory.SetFilter("Start Date", '%1|..%2', 0D, pPostingDate);
        recExist := TEMPCashFlowCategory.FindLast();
        if not recExist then begin
            TEMPCashFlowCategory.SetFilter("G/L Account No.", '');
            TEMPCashFlowCategory.FindFirst(); //will get blank 
        end;
        TEMPCashFlowCategory.TestField("Cash Flow Category");
        exit(TEMPCashFlowCategory."Cash Flow Category");
    end;

    local procedure FillTEMPCashFlowCategory()
    var
        CashFlowCategoryGLAccount: record "Cash Flow Category G/L Account";
    begin
        TEMPCashFlowCategory.Reset();
        TEMPCashFlowCategory.DeleteAll();
        if CashFlowCategoryGLAccount.FindSet() then
            repeat
                TEMPCashFlowCategory.Init();
                TEMPCashFlowCategory := CashFlowCategoryGLAccount;
                TEMPCashFlowCategory.Insert();
            until CashFlowCategoryGLAccount.Next() = 0;
    end;


    local procedure FillTempGrip(DocFilter: Text)
    var
        GRIPdata: record "GRIP Invoice Analyze Data";
        i, n : Integer;
        GRIPdataOLD: Record "CashFlow Category GRIP Invoice";
    begin
        TEMPgrip.Reset();
        TEMPgrip.DeleteAll();
        n := GripFilters.Count();
        for i := 1 to n do begin
            GRIPdataOLD.SetFilter("Document No.", DocFilter);
            if GRIPdataOLD.FindSet() then
                repeat
                    TEMPgrip.TransferFields(GRIPdataOLD);
                    TEMPgrip.Insert();
                until GRIPdataOLD.Next() = 0;
        end;
    end;

}



