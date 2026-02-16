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
            TEMPDetCusLed.Insert();
        end;
    end;

    procedure ShowPageDetCustLedg()
    var
        DetCustLedgPage: Page "Det. Cust. Ledg2DocNo.";
    begin
        page.Run(Page::"Det. Cust. Ledg2DocNo.", TEMPDetCusLed);
    end;
}
