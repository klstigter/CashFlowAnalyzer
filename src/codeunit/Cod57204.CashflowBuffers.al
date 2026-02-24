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
        TEMPgrip_Vendor: record "GRIP Invoice Analyze Data" temporary;
        TEMPCashFlowCategory: record "Cash Flow Category G/L Account" temporary;
        CashFlowLineNo: Integer;

    procedure ShowTransactionBufferPage()
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

    procedure ShowPageFilterStrings()
    var
        FilterStringPage: Page "FilterStrings";
        FilterBuilder: Codeunit FilterBuilder;
        i, n : Integer;
    begin
        TEMPDetailedLedger.setrange("led_Document Type", TEMPDetailedLedger."led_Document Type"::Invoice);
        TEMPDetailedLedger.SetFilter("led_Document No.", '%1..', 'VF25');
        TEMPDetailedLedger.SetCurrentKey("led_Document Type", "led_Document No.");
        if not TEMPDetailedLedger.IsEmpty() then
            n := FilterBuilder.BuildEntryNoFilter(TEMPDetailedLedger);
        for i := 1 to n do
            FilterStringPage.SetFIlterValue(i, FilterBuilder.GetFilterChunk(i));
        FilterStringPage.Run(); //Run the page after setting the filter values to display them on the page.
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
                TEMPbuffer_Bnk."Gl_EntryNo_Bnk" := GLentry."Entry No.";
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
                TEMPbuffer_Bnk."Dimension Set ID" := GLentry."Dimension Set ID";
                TEMPbuffer_Bnk.Insert();
            until GLentry.Next() = 0;

        FilterTransactionNo := format(GLentry."Transaction No.") + '..' + FilterTransactionNo;

        GLentry.SetRange("Source Type");
        GLentry.SetRange("Source No.");
        TEMPbuffer_Bnk.setrange("Gl_EntryNo_Bnk");
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                if GLentry.Next() = 0 then
                    break;
                TEMPbuffer_Bnk."GL_EntryNo Start" := GLentry."Entry No.";
                repeat
                    TEMPbuffer_Bnk."Balance Amount" += GLentry.Amount;
                    TEMPbuffer_Bnk."GL_EntryNo End" := GLentry."Entry No.";
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

    procedure CreateDummyLedgBuffer(GLEntryNo: Integer; Amount: Decimal)
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.get(GLEntryNo);
        TEMPDetailedLedger_EntryNo += 1;
        TEMPDetailedLedger.Init();
        TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
        TEMPDetailedLedger."Is Init" := true; //CustLedgerEntry.Init_CustLedgEntryNo = CustLedgerEntry.CustLedgEntryNo;
        TEMPDetailedLedger."Init Entry No." := GLEntry."Entry No."; //CustLedgerEntry.Init_EntryNo;
        TEMPDetailedLedger."Init Ledger Entry No." := 0;//CustLedgerEntry.Init_CustLedgEntryNo;
        TEMPDetailedLedger."Entry No." := 0; //CustLedgerEntry.EntryNo;
        TEMPDetailedLedger."Ledger Entry No." := GLEntry."Entry No."; //CustLedgerEntry.CustLedgEntryNo;
        TEMPDetailedLedger."Applied Ledger Entry No." := 0; //CustLedgerEntry.AppliedCustLedEntrNo;
        TEMPDetailedLedger."Entry Type" := 0; //CustLedgerEntry.EntryType;
        TEMPDetailedLedger."Transaction No." := GLEntry."Transaction No."; //CustLedgerEntry.TransactionNo;
        TEMPDetailedLedger."Document No." := GLEntry."Document No."; //CustLedgerEntry.DocumentNo;
        TEMPDetailedLedger."Amount" := Amount; //CustLedgerEntry.Amount;
        TEMPDetailedLedger."Posting Date" := GLEntry."Posting Date"; //CustLedgerEntry.PostingDate;
        TEMPDetailedLedger."led_Entry No." := 0; //CustLedgerEntry.Cle_EntryNo;
        TEMPDetailedLedger."led_Document Type" := GLEntry."Document Type"; //CustLedgerEntry.Cle_DocType;
        TEMPDetailedLedger."led_Document No." := GLEntry."Document No."; //CustLedgerEntry.Cle_DocNo;
        TEMPDetailedLedger."led_Posting Date" := GLEntry."Posting Date"; //CustLedgerEntry.Cle_PostingDate;
        TEMPDetailedLedger."led_Account No." := GLEntry."G/L Account No."; //CustLedgerEntry.Cle_AccountNo;
        TEMPDetailedLedger."led_Amount" := 0; //GLEntry.Amount; //CustLedgerEntry.Cle_Amount;
        TEMPDetailedLedger."led_Dimension Set ID" := GLEntry."Dimension Set ID";
        TEMPDetailedLedger."Is Dummy Record" := true;

    end;

    procedure FillDetCustLedgBuffer1(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text)
    var
        CustLedgerEntry: Query GetRelatedCustLedgerEntries1;
    begin
        CustLedgerEntry.SetFilter("DocNoFilter", '=%1', PostRec."Document No.");
        CustLedgerEntry.SetFilter("PostingDateFilter", '=%1', PostRec."Posting Date");

        CustLedgerEntry.Open();
        while CustLedgerEntry.Read() do begin
            if CustLedgerEntry.Init_CustLedgEntryNo <> CustLedgerEntry.CustLedgEntryNo then begin
                TEMPDetailedLedger_EntryNo += 1;
                TEMPDetailedLedger.Init();
                TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
                TEMPDetailedLedger."Is Init" := (CustLedgerEntry.Init_CustLedgEntryNo = CustLedgerEntry.CustLedgEntryNo);
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
                TEMPDetailedLedger."Query Nr." := 1;
                TEMPDetailedLedger.Insert();
            end;
        end;
    end;

    procedure FillDetCustLedgBuffer2(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text)
    var
        CustLedgerEntry: Query GetRelatedCustLedgerEntries2;
    begin
        CustLedgerEntry.SetFilter("DocNoFilter", '=%1', PostRec."Document No.");
        CustLedgerEntry.SetFilter("PostingDateFilter", '=%1', PostRec."Posting Date");

        CustLedgerEntry.Open();
        while CustLedgerEntry.Read() do begin
            if (CustLedgerEntry.CustLedgEntryNo = CustLedgerEntry.Init_CustLedgEntryNo)
                and (CustLedgerEntry.AppliedCustLedEntrNo <> CustLedgerEntry.CustLedgEntryNo)

                 then begin
                TEMPDetailedLedger_EntryNo += 1;
                TEMPDetailedLedger.Init();
                TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
                TEMPDetailedLedger."Is Init" := (CustLedgerEntry.Init_CustLedgEntryNo = CustLedgerEntry.CustLedgEntryNo);
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
                TEMPDetailedLedger."Query Nr." := 2;
                TEMPDetailedLedger.Insert();
            end;
        end;
    end;

    procedure FillDetVendorLedgBuffer1(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text)
    var
        VendorLedgerEntry: Query GetRelatedVendLedgerEntries1;
    begin
        VendorLedgerEntry.SetFilter("DocNoFilter", '=%1', PostRec."Document No.");
        VendorLedgerEntry.SetFilter("PostingDateFilter", '=%1', PostRec."Posting Date");

        VendorLedgerEntry.Open();
        while VendorLedgerEntry.Read() do begin
            if VendorLedgerEntry.Init_VendLedgEntryNo <> VendorLedgerEntry.VendLedgEntryNo then begin
                TEMPDetailedLedger_EntryNo += 1;
                TEMPDetailedLedger.Init();
                TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
                TEMPDetailedLedger."Is Init" := (VendorLedgerEntry.Init_VendLedgEntryNo = VendorLedgerEntry.VendLedgEntryNo);
                TEMPDetailedLedger."Init Entry No." := VendorLedgerEntry.Init_EntryNo;
                TEMPDetailedLedger."Init Ledger Entry No." := VendorLedgerEntry.Init_VendLedgEntryNo;
                TEMPDetailedLedger."Entry No." := VendorLedgerEntry.EntryNo;
                TEMPDetailedLedger."Vendor Ledger Entry No." := VendorLedgerEntry.VendLedgEntryNo;
                TEMPDetailedLedger."Applied Ledger Entry No." := VendorLedgerEntry.AppliedVendLedgEntryNo;
                TEMPDetailedLedger."Entry Type" := VendorLedgerEntry.EntryType;
                TEMPDetailedLedger."Transaction No." := VendorLedgerEntry.TransactionNo;
                TEMPDetailedLedger."Document No." := VendorLedgerEntry.DocumentNo;
                TEMPDetailedLedger."Amount" := VendorLedgerEntry.Amount;
                TEMPDetailedLedger."Posting Date" := VendorLedgerEntry.PostingDate;
                TEMPDetailedLedger."led_Entry No." := VendorLedgerEntry.Cle_EntryNo;
                TEMPDetailedLedger."led_Document Type" := VendorLedgerEntry.Cle_DocType;
                TEMPDetailedLedger."led_Document No." := VendorLedgerEntry.Cle_DocNo;
                TEMPDetailedLedger."led_Posting Date" := VendorLedgerEntry.Cle_PostingDate;
                TEMPDetailedLedger."led_Account No." := VendorLedgerEntry.Cle_AccountNo;
                TEMPDetailedLedger."led_Amount" := VendorLedgerEntry.Cle_Amount;
                TEMPDetailedLedger."led_Dimension Set ID" := VendorLedgerEntry.Cle_Dimension_Set_ID;
                TEMPDetailedLedger."Query Nr." := 3;
                TEMPDetailedLedger.Insert();
            end;
        end;
    end;

    procedure FillDetVendorLedgBuffer2(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text)
    var
        VendorLedgerEntry: Query GetRelatedVendLedgerEntries2;

    begin
        VendorLedgerEntry.SetFilter("DocNoFilter", '=%1', PostRec."Document No.");
        VendorLedgerEntry.SetFilter("PostingDateFilter", '=%1', PostRec."Posting Date");

        VendorLedgerEntry.Open();
        while VendorLedgerEntry.Read() do begin
            if (VendorLedgerEntry.VendLedgEntryNo = VendorLedgerEntry.Init_VendLedgEntryNo)
                and (VendorLedgerEntry.AppliedVendLedgEntryNo <> VendorLedgerEntry.VendLedgEntryNo)

                 then begin
                TEMPDetailedLedger_EntryNo += 1;
                TEMPDetailedLedger.Init();
                TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
                TEMPDetailedLedger."Is Init" := (VendorLedgerEntry.Init_VendLedgEntryNo = VendorLedgerEntry.VendLedgEntryNo);
                TEMPDetailedLedger."Init Entry No." := VendorLedgerEntry.Init_EntryNo;
                TEMPDetailedLedger."Init Ledger Entry No." := VendorLedgerEntry.Init_VendLedgEntryNo;
                TEMPDetailedLedger."Entry No." := VendorLedgerEntry.EntryNo;
                TEMPDetailedLedger."Vendor Ledger Entry No." := VendorLedgerEntry.VendLedgEntryNo;
                TEMPDetailedLedger."Applied Ledger Entry No." := VendorLedgerEntry.AppliedVendLedgEntryNo;
                TEMPDetailedLedger."Entry Type" := VendorLedgerEntry.EntryType;
                TEMPDetailedLedger."Transaction No." := VendorLedgerEntry.TransactionNo;
                TEMPDetailedLedger."Document No." := VendorLedgerEntry.DocumentNo;
                TEMPDetailedLedger."Amount" := VendorLedgerEntry.Amount;
                TEMPDetailedLedger."Posting Date" := VendorLedgerEntry.PostingDate;
                TEMPDetailedLedger."led_Entry No." := VendorLedgerEntry.Cle_EntryNo;
                TEMPDetailedLedger."led_Document Type" := VendorLedgerEntry.Cle_DocType;
                TEMPDetailedLedger."led_Document No." := VendorLedgerEntry.Cle_DocNo;
                TEMPDetailedLedger."led_Posting Date" := VendorLedgerEntry.Cle_PostingDate;
                TEMPDetailedLedger."led_Account No." := VendorLedgerEntry.Cle_AccountNo;
                TEMPDetailedLedger."led_Amount" := VendorLedgerEntry.Cle_Amount;
                TEMPDetailedLedger."led_Dimension Set ID" := VendorLedgerEntry.Cle_Dimension_Set_ID;
                TEMPDetailedLedger."Query Nr." := 4;
                TEMPDetailedLedger.Insert();
            end;
        end;
    end;

    procedure CreateAnalyze(var AnalyzeHeader: Record "CashFLow Analyze Header")
    var
        Factor: Decimal;
        CashFlowLine: Record "Cashflow Analyse Line";
        ProcessAmount: Decimal;
        Rest: Decimal;
    begin
        TEMPbuffer_Bnk.get(AnalyzeHeader."Entry No.");
        CashFlowLine.SetRange("G/L Entry No.", TEMPbuffer_Bnk."Gl_EntryNo_Bnk");
        CashFlowLine.DeleteAll();
        CashFlowLineNo := 0;
        if TEMPbuffer_Bnk."Source No." = '' then
            InsertTransactionBuffer(1, ProcessAmount)
        else begin
            TEMPDetailedLedger.Reset();
            TEMPDetailedLedger.SetRange("Init Ledger Entry No.", TEMPbuffer_Bnk."GL_EntryNo Start");
            TEMPDetailedLedger.SetFilter(Amount, '<>%1', 0);
            IF TEMPDetailedLedger.FindSet() THEN begin
                repeat
                    factor := TEMPDetailedLedger."Amount" / TEMPDetailedLedger."led_Amount";
                    TEMPgrip.DeleteAll();
                    TEMPgrip_Vendor.DeleteAll();
                    case TEMPbuffer_Bnk."Source Type" of
                        TEMPbuffer_Bnk."Source Type"::Customer:
                            begin
                                IF FillTempGrip(TEMPDetailedLedger."led_Document No.") THEN
                                    InsertGrip(factor, ProcessAmount)
                                ELSE
                                    InsertDetailedLedBuffer(factor, ProcessAmount);
                            end;
                        TEMPbuffer_Bnk."Source Type"::Vendor:
                            begin
                                IF FillTempGrip_Vendor(Format(TEMPDetailedLedger."led_Entry No.")) THEN
                                    InsertGrip_vendor(factor, ProcessAmount)
                                ELSE
                                    InsertDetailedLedBuffer(factor, ProcessAmount);
                            end;
                        else
                            InsertDetailedLedBuffer(factor, ProcessAmount);
                    end;
                until TEMPDetailedLedger.Next() = 0;
                rest := round(abs(ProcessAmount), 0.01) - round(abs(TEMPbuffer_Bnk."Cashflow Amount"), 0.01);
                if rest <> 0 then
                    InsertDummyDetailedLedBuffer(TEMPbuffer_Bnk."GL_EntryNo Start", Rest);
            end else
                InsertDummyDetailedLedBuffer(TEMPbuffer_Bnk."GL_EntryNo Start", TEMPbuffer_Bnk."Cashflow Amount");
        end;
    end;

    procedure CreateAnalyze()
    var
        Factor: Decimal;
        n: Integer;
        ProgressDlg: Dialog;
        ProcessAmount: Decimal;
        t1, t2 : time;
        Log: Record "Log Cashflow Analyzer";
        Rest: Decimal;
    begin
        DeleteOldAnalyzes();
        CreateCashFlowHeaders();
        ProgressDlg.Open('Processing #1####');
        t1 := Time();
        TEMPbuffer_Bnk.Reset();
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                CashFlowLineNo := 0;
                ProcessAmount := 0;
                if TEMPbuffer_Bnk."Source No." = '' then
                    InsertTransactionBuffer(1, ProcessAmount)
                else begin
                    TEMPDetailedLedger.Reset();
                    TEMPDetailedLedger.SetRange("Init Ledger Entry No.", TEMPbuffer_Bnk."GL_EntryNo Start");
                    TEMPDetailedLedger.SetFilter(Amount, '<>%1', 0);
                    IF TEMPDetailedLedger.FindSet() THEN begin
                        repeat
                            factor := TEMPDetailedLedger."Amount" / TEMPDetailedLedger."led_Amount";
                            TEMPgrip.SetRange("Document No.", TEMPDetailedLedger."led_Document No.");
                            IF TEMPgrip.FindSet() THEN
                                InsertGrip(factor, ProcessAmount)
                            ELSE begin
                                TEMPgrip_Vendor.SetRange("Document No.", TEMPDetailedLedger."led_Document No.");
                                IF TEMPgrip_Vendor.FindSet() THEN begin
                                    InsertGrip_vendor(factor, ProcessAmount)
                                end ELSE
                                    InsertDetailedLedBuffer(factor, ProcessAmount);
                            end;
                        until TEMPDetailedLedger.Next() = 0;
                        REST := round(abs(ProcessAmount), 0.01) - round(abs(TEMPbuffer_Bnk."Cashflow Amount"), 0.01);
                        if REST <> 0 then
                            InsertDummyDetailedLedBuffer(TEMPbuffer_Bnk."GL_EntryNo Start", Rest);
                    end else
                        InsertDummyDetailedLedBuffer(TEMPbuffer_Bnk."GL_EntryNo Start", TEMPbuffer_Bnk."Cashflow Amount");
                end;
                n += 1;
                if n mod 100 = 0 then begin
                    t2 := time();
                    log.CreateLog(n, t1, t2, '');
                end;
                ProgressDlg.Update(1, n);
            until (TEMPbuffer_Bnk.Next() = 0); // or (n = 1000);
        ProgressDlg.Close();
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
                AnalyzeHeader."Entry No." := TEMPbuffer_Bnk."Gl_EntryNo_Bnk";
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

    local procedure InsertDummyDetailedLedBuffer(EntryNo: integer; var Rest: Decimal);

    begin
        CreateDummyLedgBuffer(EntryNo, rest);
        TEMPDetailedLedger."Birth place" := 'Not all amount analyzed';
        InsertDetailedLedBuffer(1, Rest);

    end;

    local procedure InsertTransactionBuffer(factor: Decimal; var ProcessAmount: Decimal);
    var
        CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
        GLentry: Record "G/L Entry";
        GLaccount: Record "G/L Account";
        Sign: Integer;
        TEMPDetailedLedger: text;
    begin
        Sign := -1;
        CashFlowLineNo += 1;
        CashFlowLine."G/L Entry No." := TEMPbuffer_Bnk."Gl_EntryNo_Bnk";
        CashFlowLine."Entry Line No." := CashFlowLineNo;
        // Bank/Cash Block
        GLentry.Get(TEMPbuffer_Bnk."Gl_EntryNo_Bnk");
        CashFlowLine."Document No." := GLentry."Document No.";
        CashFlowLine."Posting Date" := GLentry."Posting Date";
        CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
        CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
        CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";

        // Realized block
        CashFlowLine."G/L Account" := GLentry."G/L Account No.";
        CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
        CashFlowLine."Cash Flow Category Amount" := round(Sign * TEMPbuffer_Bnk."Balance Amount", 0.001);
        ProcessAmount += CashFlowLine."Cash Flow Category Amount";
        CashFlowLine."Applied Posting Date" := TEMPbuffer_Bnk."Posting Date";

        CashFlowLine."Applied Document No." := TEMPbuffer_Bnk."Document No.";
        //CashFlowLine."Applied Document Entry No." := TEMPbuffer_Bnk."Init Entry No.";
        //CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"Customer Ledger Entry";
        CashFlowLine.Validate("Dimension Set ID", TEMPbuffer_Bnk."Dimension Set ID");
        CashFlowLine."Transaction No." := TEMPbuffer_Bnk."Transaction No.";
        CashFlowLine."Dimension Set ID" := TEMPbuffer_Bnk."Dimension Set ID";
        CashFlowLine.Insert();
    end;

    local procedure InsertDetailedLedBuffer(factor: Decimal; var ProcessAmount: Decimal);
    var
        CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
        GLentry: Record "G/L Entry";
        GLaccount: Record "G/L Account";
        Sign: Integer;
    begin
        Sign := -1;
        CashFlowLineNo += 1;
        CashFlowLine."G/L Entry No." := TEMPbuffer_Bnk."Gl_EntryNo_Bnk";
        CashFlowLine."Entry Line No." := CashFlowLineNo;
        // Bank/Cash Block
        GLentry.Get(TEMPbuffer_Bnk."Gl_EntryNo_Bnk");
        CashFlowLine."Document No." := GLentry."Document No.";
        CashFlowLine."Posting Date" := GLentry."Posting Date";
        CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
        CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
        CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";

        // Realized block
        CashFlowLine."G/L Account" := GLentry."G/L Account No.";
        CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
        if TEMPDetailedLedger."Is Dummy Record" then
            CashFlowLine."Amount to Analyze" := round(Sign * TEMPDetailedLedger."Amount", 0.001)
        else
            CashFlowLine."Cash Flow Category Amount" := round(Sign * TEMPDetailedLedger."Amount", 0.001);
        ProcessAmount += CashFlowLine."Cash Flow Category Amount";
        CashFlowLine."Applied Posting Date" := TEMPDetailedLedger."led_Posting Date";

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
        if TEMPbuffer_Bnk."Source Type" = TEMPbuffer_Bnk."Source Type"::"vendor" then
            CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"Vendor Ledger Entry";
        if TEMPbuffer_Bnk."Source Type" = TEMPbuffer_Bnk."Source Type"::"Customer" then
            CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"Customer Ledger Entry";
        CashFlowLine.Validate("Dimension Set ID", TEMPDetailedLedger."Led_Dimension Set ID");
        CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";
        CashFlowLine."Place of Birth" := TEMPDetailedLedger."Birth place";

        CashFlowLine.Insert();
    end;

    local procedure InsertGrip_Vendor(Factor: Decimal; var ProcessAmount: Decimal);
    var
        CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
        GLaccount: Record "G/L Account";
        GLentry: Record "G/L Entry";
        Sign: Integer;
    begin
        TEMPgrip_Vendor.SetRange("Document No.", TEMPDetailedLedger."led_Document No.");
        if TEMPgrip_Vendor.FindSet() then
            repeat
                CashFlowLineNo += 1;
                CashFlowLine."G/L Entry No." := TEMPbuffer_Bnk."Gl_EntryNo_Bnk";
                CashFlowLine."Entry Line No." := CashFlowLineNo;
                // Bank/Cash Block
                GLentry.Get(TEMPbuffer_Bnk."Gl_EntryNo_Bnk");
                CashFlowLine."Document No." := GLentry."Document No.";
                CashFlowLine."Posting Date" := GLentry."Posting Date";
                CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
                CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
                CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";


                // Realized block
                CashFlowLine."Is Grip" := true;
                GLaccount.get(TEMPgrip_Vendor."G/L Account");
                CashFlowLine."G/L Account" := TEMPgrip_Vendor."G/L Account";
                CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
                CashFlowLine."Cash Flow Category Amount" := round(TEMPgrip_Vendor.Amount * Factor, 0.001);
                ProcessAmount += CashFlowLine."Cash Flow Category Amount";
                CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
                CashFlowLine."Applied Posting Date" := TEMPDetailedLedger."led_Posting Date";
                CashFlowLine."Applied Document No." := TEMPgrip_Vendor."Document No.";
                CashFlowLine."Applied Document Entry No." := TEMPgrip_Vendor."Exploitation No.";
                CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"CashFlow Category GRIP Invoice";

                CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";
                CashFlowLine."Place of Birth" := TEMPDetailedLedger."Birth place";
                CashFlowLine.insert();
            until TEMPgrip_Vendor.Next() = 0;
    end;

    local procedure InsertGrip(Factor: Decimal; var ProcessAmount: Decimal);
    var
        CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
        GLaccount: Record "G/L Account";
        GLentry: Record "G/L Entry";
        Sign: Integer;
    begin
        TEMPgrip.SetRange("Document No.", TEMPDetailedLedger."led_Document No.");
        if TEMPgrip.FindSet() then
            repeat
                CashFlowLineNo += 1;
                CashFlowLine."G/L Entry No." := TEMPbuffer_Bnk."Gl_EntryNo_Bnk";
                CashFlowLine."Entry Line No." := CashFlowLineNo;
                // Bank/Cash Block
                GLentry.Get(TEMPbuffer_Bnk."Gl_EntryNo_Bnk");
                CashFlowLine."Document No." := GLentry."Document No.";
                CashFlowLine."Posting Date" := GLentry."Posting Date";
                CashFlowLine."Dimension Set ID" := GLentry."Dimension Set ID";
                CashFlowLine."Global Dimension 1 Code" := GLentry."Global Dimension 1 Code";
                CashFlowLine."Global Dimension 2 Code" := GLentry."Global Dimension 2 Code";


                // Realized block
                CashFlowLine."Is Grip" := true;
                GLaccount.get(TEMPgrip."G/L Account");
                CashFlowLine."G/L Account" := TEMPgrip."G/L Account";
                CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
                CashFlowLine."Cash Flow Category Amount" := round(TEMPgrip.Amount * Factor, 0.001);
                ProcessAmount += CashFlowLine."Cash Flow Category Amount";
                CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
                CashFlowLine."Applied Posting Date" := TEMPDetailedLedger."led_Posting Date";
                CashFlowLine."Applied Document No." := TEMPgrip."Document No.";
                CashFlowLine."Applied Document Entry No." := TEMPgrip."Exploitation No.";
                CashFlowLine."Realized Type" := CashFlowLine."Realized Type"::"CashFlow Category GRIP Invoice";

                CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";
                CashFlowLine."Place of Birth" := TEMPDetailedLedger."Birth place";
                CashFlowLine.insert();
            until TEMPgrip.Next() = 0;
    end;

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

    procedure FillTEMPCashFlowCategory()
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

    procedure FillTempGrip()
    var
        FilterBuilder: Codeunit FilterBuilder;
        i, n : Integer;
        DocFilter: Text;
        Filters: List of [Text];
    begin
        TEMPgrip.Reset();
        TEMPgrip.DeleteAll();
        TEMPgrip_Vendor.Reset();
        TEMPgrip_Vendor.DeleteAll();
        TEMPDetailedLedger.setrange("led_Document Type", TEMPDetailedLedger."led_Document Type"::Invoice);
        TEMPDetailedLedger.SetFilter("led_Document No.", '%1..', 'VF25');
        TEMPDetailedLedger.SetCurrentKey("led_Document Type", "led_Document No.");
        if not TEMPDetailedLedger.IsEmpty() then
            n := FilterBuilder.BuildEntryNoFilter(TEMPDetailedLedger);
        for i := 1 to n do begin
            DocFilter := FilterBuilder.GetFilterChunk(i);
            FillTempGrip(DocFilter);
        end;
        TEMPDetailedLedger.Reset();

        //LAGI: Vendor scope here
        n := 0;
        TEMPDetailedLedger.SetRange("Query Nr.", 3, 4);
        TEMPDetailedLedger.Setrange("led_Entry No.", 693772);
        message('force test for 693772 only');
        TEMPDetailedLedger.SetCurrentKey("led_Document Type", "led_Document No.");
        if not TEMPDetailedLedger.IsEmpty() then begin
            Filters := FilterBuilder.BuildEntryNoFilter2(TEMPDetailedLedger);
            n := Filters.Count();
        end;
        for i := 1 to n do begin
            DocFilter := Filters.Get(i);
            FillTempGrip_Vendor(DocFilter);
        end;
        TEMPDetailedLedger.Reset();
    end;

    local procedure FillTempGrip_Vendor(DocFilter: Text) HasRecords: Boolean; //LAGI
    var
        GripQry: Query "Get Vendor Ledger Entry Opt.";
        Inserted: Boolean;
        x: Integer;
    begin
        GripQry.SetFilter(Entry_No_, DocFilter);
        GripQry.Open();
        while GripQry.Read() do begin
            if (GripQry.Init_Entry_No_ <> GripQry.G_L_Entry_No_) then begin
                TEMPgrip_Vendor.Init();
                TEMPgrip_Vendor."Exploitation No." := GripQry.G_L_Entry_No_;
                case GripQry.Document_Type of
                    GripQry.Document_Type::Invoice,
                    GripQry.Document_Type::" ":
                        TEMPgrip_Vendor."Document Type" := TEMPgrip_Vendor."Document Type"::Invoice;
                    GripQry.Document_Type::"Credit Memo":
                        TEMPgrip_Vendor."Document Type" := TEMPgrip_Vendor."Document Type"::"Credit Memo";
                    GripQry.Document_Type::Refund:
                        TEMPgrip_Vendor."Document Type" := TEMPgrip_Vendor."Document Type"::Refund;
                    GripQry.Document_Type::Payment:
                        TEMPgrip_Vendor."Document Type" := TEMPgrip_Vendor."Document Type"::Payment;
                end;
                if GripQry.Document_No_ = 'IF25-107888' then
                    x := 1;
                TEMPgrip_Vendor."Document No." := GripQry.Document_No_;
                TEMPgrip_Vendor."G/L Account" := GripQry.G_L_Account_No_;
                TEMPgrip_Vendor."Amount" := GripQry.Amount;
                TEMPgrip_Vendor."Global Dimension 1 Code" := GripQry.Global_Dimension_1_Code;
                TEMPgrip_Vendor."Global Dimension 2 Code" := GripQry.Global_Dimension_2_Code;
                Inserted := TEMPgrip_Vendor.Insert();
                if not HasRecords and Inserted then
                    HasRecords := true;
            end;
        end;
        GripQry.Close();
        if not HasRecords then
            exit(false);

    end;

    local procedure FillTempGrip(DocFilter: Text) HasRecords: Boolean;
    var
        GripQry: Query "Get Grip";
        VatQry: Query "VATEntries";
        Inserted: Boolean;
        log: Record "Log Cashflow Analyzer";
        t1, t2 : time;
        n: Integer;
    // GRIPdata: record "GRIP Invoice Analyze Data";
    // i, n : Integer;
    // GRIPdataOLD: Record "CashFlow Category GRIP Invoice";
    begin
        // TEMPgrip.Reset();
        // TEMPgrip.DeleteAll();
        GripQry.SetFilter("Document_No_", DocFilter);
        GripQry.Open();
        while GripQry.Read() do begin
            TEMPgrip.Init();
            TEMPgrip."Exploitation No." := GripQry."Exploitation_No_";
            TEMPgrip."Document Type" := GripQry.Document_Type;
            TEMPgrip."Document No." := GripQry.Document_No_;
            TEMPgrip."G/L Account" := GripQry.GL_Account;
            TEMPgrip."Amount" := GripQry.Amount;
            TEMPgrip."Global Dimension 1 Code" := GripQry.Global_Dimension_1_Code;
            TEMPgrip."Global Dimension 2 Code" := GripQry.Global_Dimension_2_Code;
            Inserted := TEMPgrip.Insert();
            if not HasRecords and Inserted then
                HasRecords := true;
        end;
        GripQry.Close();
        if not HasRecords then
            exit(false);

        VatQry.SetFilter("Document_No_Filter", DocFilter);
        VatQry.Open();
        while VatQry.Read() do begin
            TEMPgrip.Init();
            TEMPgrip."Exploitation No." := -VatQry.EntryNo;
            case VatQry.Document_Type of
                VatQry.Document_Type::Invoice:
                    TEMPgrip."Document Type" := TEMPgrip."Document Type"::Invoice;
                VatQry.Document_Type::"Credit Memo":
                    TEMPgrip."Document Type" := TEMPgrip."Document Type"::"Credit Memo";
                VatQry.Document_Type::Payment:
                    TEMPgrip."Document Type" := TEMPgrip."Document Type"::Payment;
                VatQry.Document_Type::Refund:
                    TEMPgrip."Document Type" := TEMPgrip."Document Type"::Refund;
            end;
            TEMPgrip."Document No." := VatQry.DocNo;
            TEMPgrip."G/L Account" := VatQry.GLaccountNo;
            TEMPgrip."Amount" := -1 * VatQry.Amount;
            TEMPgrip."Global Dimension 1 Code" := VatQry.Dim1;
            TEMPgrip."Global Dimension 2 Code" := VatQry.Dim2;
            if not TEMPgrip.Insert() then
                log.CreateLog(n, t1, t2, StrSubstNo('Double vat_id %1', VatQry.EntryNo));
        end;
        VatQry.Close();
    end;

}



