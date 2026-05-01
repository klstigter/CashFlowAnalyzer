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

    procedure FillBuffer("CashRec": Record "Cash Entry Posting No.")
    var
        GLentry: Record "G/L Entry";
        TEMPGLentry: Record "G/L Entry" temporary;
        SourceTypeEnum: Enum "Gen. Journal Source Type";
        n: integer;
    begin
        TEMPbuffer_Bnk.reset;
        TEMPbuffer_Bnk.DeleteAll();
        GLentry.SetCurrentKey("Entry No.");
        GLentry.SetLoadFields("Entry No.", "Document No.", "Posting Date", "Source Type", "Source No.", Amount, "G/L Account No.", "Journal Templ. Name", "Journal Batch Name", "Transaction No.", "Dimension Set ID", "Document Type");
        GLentry.SetRange("Document No.", "CashRec"."Document No.");
        GLentry.SetRange("Posting Date", "CashRec"."Posting Date");
        GLentry.SetRange("Source Code", "CashRec"."Source Code");
        GLentry.SetFilter(Amount, '<>%1', 0);
        GLentry.SetAutoCalcFields("Reviewed Identifier");
        if GLentry.FindSet() then
            repeat
                TransferGLEntyFields(GLentry, TEMPGLentry);
            until GLentry.Next() = 0;

        TEMPGLentry.SetCurrentKey("Entry No.");

        if CashRec."Source Type" = SourceTypeEnum::" " then begin
            TEMPGLentry.setrange("System-Created Entry", true);
        end else begin
            TEMPGLentry.setrange("System-Created Entry");
            TEMPGLentry.SetRange("Source Type", CashRec."Source Type");
            TEMPGLentry.SetRange("Source No.", CashRec."Source No.");
        end;
        if TEMPGLentry.FindSet() then begin
            repeat
                TEMPbuffer_Bnk.Init();
                TEMPbuffer_Bnk."Gl_EntryNo_Bnk" := TEMPGLentry."Entry No.";
                TEMPbuffer_Bnk."Posting Date" := TEMPGLentry."Posting Date";
                TEMPbuffer_Bnk."Document No." := TEMPGLentry."Document No.";
                TEMPbuffer_Bnk."Document Type" := TEMPGLentry."Document Type";
                if TEMPGLentry."Source Type" <> TEMPGLentry."Source Type"::" " then
                    TEMPbuffer_Bnk."Source Type" := TEMPGLentry."Source Type";
                if TEMPGLentry."Source No." <> '' then
                    TEMPbuffer_Bnk."Source No." := TEMPGLentry."Source No.";
                TEMPbuffer_Bnk."Cashflow Amount" += TEMPGLentry.Amount;
                TEMPbuffer_Bnk."Journal Templ. Name" := TEMPGLentry."Journal Templ. Name";
                TEMPbuffer_Bnk."Journal Batch Name" := TEMPGLentry."Journal Batch Name";
                TEMPbuffer_Bnk."Transaction No." := TEMPGLentry."Transaction No.";
                TEMPbuffer_Bnk."Dimension Set ID" := TEMPGLentry."Dimension Set ID";
                TEMPbuffer_Bnk."Global Dimension 1 Code" := TEMPGLentry."Global Dimension 1 Code";
                TEMPbuffer_Bnk."Global Dimension 2 Code" := TEMPGLentry."Global Dimension 2 Code";
                TEMPbuffer_Bnk.Insert();
            until TEMPGLentry.Next() = 0;
        end;

        RemoveNulTransactions(TEMPGLentry);
        TEMPGLentry.reset;
        if CashRec."Source Type" = SourceTypeEnum::" " then begin
            //Qry2 cash receives
            TEMPGLentry.setrange("System-Created Entry", false);
            TEMPGLentry.SetRange("Journal Batch Name", "CashRec"."Journal Batch Name");
            TEMPGLentry.SetRange("Journal Templ. Name", "CashRec"."Journal Templ. Name");
            TEMPGLentry.SetRange("Document No.", "CashRec"."Document No.");
        end else begin
            TEMPGLentry.SetFilter("Source Type", '<>%1', CashRec."Source Type");
            TEMPGLentry.SetFilter("Source No.", '<>%1', CashRec."Source No.");
        end;
        n := TEMPGLentry.Count;
        TEMPGLentry.SetCurrentKey("Entry No.");
        TEMPbuffer_Bnk.setrange("Gl_EntryNo_Bnk");
        if TEMPbuffer_Bnk.FindSet() then
            repeat
                if TEMPGLentry.Next() = 0 then
                    break;
                TEMPGLentry.setrange("Transaction No.", TEMPGLentry."Transaction No.");

                TEMPbuffer_Bnk."GL_EntryNo Start" := TEMPGLentry."Entry No.";
                repeat
                    TEMPbuffer_Bnk."Balance Amount" += TEMPGLentry.Amount;
                    TEMPbuffer_Bnk."GL_EntryNo End" := TEMPGLentry."Entry No.";
                    TEMPbuffer_Bnk."Source Type" := TEMPGLentry."Source Type";
                    TEMPbuffer_Bnk."Source No." := TEMPGLentry."Source No.";
                    TEMPbuffer_Bnk."GL Account No." := TEMPGLentry."G/L Account No.";
                    TEMPbuffer_Bnk."Reviewed Identifier" := TEMPGLentry."Reviewed Identifier";
                    if TEMPGLentry."Reversed by Entry No." <> 0 then begin //miuse Reversed be Entry No.
                        TEMPbuffer_Bnk."Is VAT Settlement" := true;
                        TEMPbuffer_Bnk."Reviewed Identifier" := TEMPGLentry."Reversed by Entry No.";
                        FillVATSettlement();
                    end;
                //if -1 * TEMPbuffer_Bnk."Balance Amount" >= TEMPbuffer_Bnk."Cashflow Amount" then
                //    break;
                until TEMPGLentry.Next() = 0;
                TEMPbuffer_Bnk.Modify();
                TEMPGLentry.setrange("Transaction No.");
            until TEMPbuffer_Bnk.Next() = 0;
    end;

    Local procedure TransferGLEntyFields(var GLentry: Record "G/L Entry"; var TEMPGLentry: Record "G/L Entry" temporary)
    begin
        TempGLentry."Entry No." := GLentry."Entry No.";
        TempGLentry."Document No." := GLentry."Document No.";
        TempGLentry."Posting Date" := GLentry."Posting Date";
        TempGLentry."Source Type" := GLentry."Source Type";
        TempGLentry."Source No." := GLentry."Source No.";
        TempGLentry.Amount := GLentry.Amount;
        TempGLentry."G/L Account No." := GLentry."G/L Account No.";
        TempGLentry."Journal Templ. Name" := GLentry."Journal Templ. Name";
        TempGLentry."Journal Batch Name" := GLentry."Journal Batch Name";
        TempGLentry."Transaction No." := GLentry."Transaction No.";
        TempGLentry."Dimension Set ID" := GLentry."Dimension Set ID";
        TempGLentry."Document Type" := GLentry."Document Type";
        TEMPGLentry."System-Created Entry" := GLentry."System-Created Entry";
        TEMPGLentry."Reversed by Entry No." := GLentry."Reviewed Identifier"; //miuse Reversed be Entry No.
        TEMPGLentry.insert;
    end;

    local procedure RemoveNulTransactions(var TEMPGLentry: Record "G/L Entry" temporary)
    var
        int: record integer temporary;
        CheckAmount: Decimal;
        EndOfRecords: Boolean;
        "SourceType": Enum Microsoft.Finance.GeneralLedger.Journal."Gen. Journal Source Type";
    begin
        TEMPGLentry.setrange("Source Type", SourceType::" ");
        TEMPGLentry.SetRange("Source No.", '');
        TEMPGLentry.SetCurrentKey("Entry No.");
        EndOfRecords := not TEMPGLentry.FindSet();
        while not EndOfRecords do begin
            TEMPGLentry.setrange("Transaction No.", TEMPGLentry."Transaction No.");
            if TEMPGLentry.FindSet() then
                repeat
                    CheckAmount += TEMPGLentry.Amount;
                until TEMPGLentry.Next() = 0;
            TEMPGLentry.SetRange("Transaction No.");
            if CheckAmount = 0 then begin
                int.Number := TEMPGLentry."Transaction No.";
                int.Insert();
            end;
            CheckAmount := 0;
            EndOfRecords := TEMPGLentry.next = 0
        end;
        if int.FindSet() then
            repeat
                TEMPGLentry.SetRange("Transaction No.", int.Number);
                TEMPGLentry.DeleteAll();
            until int.Next() = 0;
        TEMPGLentry.SetRange("Transaction No.");
        TEMPGLentry.setrange("Source Type");
        TEMPGLentry.SetRange("Source No.");
        IF TEMPGLentry.FindFirst() THEN;
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
        if not TEMPbuffer_Bnk."Is VAT Settlement" then
            TEMPDetailedLedger."Entry No." := 0 //CustLedgerEntry.EntryNo;
        else
            TEMPDetailedLedger."Entry No." := GLEntry."Entry No."; //CustLedgerEntry.EntryNo;
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
        TEMPDetailedLedger."Led_Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        TEMPDetailedLedger."Led_Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        TEMPDetailedLedger."Is Dummy Record" := true;
    end;

    procedure FillDetCustLedgBuffer1(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text): Integer
    var
        CustLedgerEntry: Query GetRelatedCustLedgerEntries1;
        GLEntry: record "G/L Entry";
        nRec: Integer;
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

                //<< Payment Tolerance
                if TEMPDetailedLedger."Entry Type" = TEMPDetailedLedger."Entry Type"::"Payment Tolerance" then begin
                    TEMPDetailedLedger."Amount" := -TEMPDetailedLedger."Amount";
                    GLEntry.SetRange("Posting Date", CustLedgerEntry.PostingDate);
                    GLEntry.SetRange("Document Type", GLEntry."Document Type"::Payment);
                    GLEntry.SetRange("Document No.", CustLedgerEntry.DocumentNo);
                    GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
                    GLEntry.SetRange("Source No.", CustLedgerEntry.CustomerNo);
                    GLEntry.Setfilter("Entry No.", '<>%1', CustLedgerEntry.CustLedgEntryNo);
                    if GLEntry.FindFirst then
                        TEMPDetailedLedger."Ledger Entry No." := GLEntry."Entry No.";
                end;
                //>>

                TEMPDetailedLedger."Posting Date" := CustLedgerEntry.PostingDate;
                TEMPDetailedLedger."led_Entry No." := CustLedgerEntry.Cle_EntryNo;
                TEMPDetailedLedger."led_Document Type" := CustLedgerEntry.Cle_DocType;
                TEMPDetailedLedger."led_Document No." := CustLedgerEntry.Cle_DocNo;
                TEMPDetailedLedger."led_Posting Date" := CustLedgerEntry.Cle_PostingDate;
                TEMPDetailedLedger."led_Account No." := CustLedgerEntry.Cle_AccountNo;
                TEMPDetailedLedger."led_Amount" := CustLedgerEntry.Cle_Amount;
                TEMPDetailedLedger."led_Dimension Set ID" := CustLedgerEntry.Cle_Dimension_Set_ID;
                TEMPDetailedLedger."Led_Global Dimension 1 Code" := CustLedgerEntry.Cle_Global_Dimension_1_Code;
                TEMPDetailedLedger."Led_Global Dimension 2 Code" := CustLedgerEntry.Cle_Global_Dimension_2_Code;
                TEMPDetailedLedger."Query Nr." := 1;
                TEMPDetailedLedger.Insert();
                nRec += 1;
            end;
        end;
        exit(nRec);
    end;

    procedure FillDetCustLedgBuffer2(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text): Integer
    var
        CustLedgerEntry: Query GetRelatedCustLedgerEntries2;
        GLEntry: record "G/L Entry";
        nRec: Integer;
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

                //<< Payment Tolerance
                if TEMPDetailedLedger."Entry Type" = TEMPDetailedLedger."Entry Type"::"Payment Tolerance" then begin
                    TEMPDetailedLedger."Amount" := -TEMPDetailedLedger."Amount";
                    GLEntry.SetRange("Posting Date", CustLedgerEntry.PostingDate);
                    GLEntry.SetRange("Document Type", GLEntry."Document Type"::Payment);
                    GLEntry.SetRange("Document No.", CustLedgerEntry.DocumentNo);
                    GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
                    GLEntry.SetRange("Source No.", CustLedgerEntry.CustomerNo);
                    GLEntry.Setfilter("Entry No.", '<>%1', CustLedgerEntry.CustLedgEntryNo);
                    if GLEntry.FindFirst then
                        TEMPDetailedLedger."Ledger Entry No." := GLEntry."Entry No.";
                end;
                //>>

                TEMPDetailedLedger."Posting Date" := CustLedgerEntry.PostingDate;
                TEMPDetailedLedger."led_Entry No." := CustLedgerEntry.Cle_EntryNo;
                TEMPDetailedLedger."led_Document Type" := CustLedgerEntry.Cle_DocType;
                TEMPDetailedLedger."led_Document No." := CustLedgerEntry.Cle_DocNo;
                TEMPDetailedLedger."led_Posting Date" := CustLedgerEntry.Cle_PostingDate;
                TEMPDetailedLedger."led_Account No." := CustLedgerEntry.Cle_AccountNo;
                TEMPDetailedLedger."led_Amount" := CustLedgerEntry.Cle_Amount;
                TEMPDetailedLedger."led_Dimension Set ID" := CustLedgerEntry.Cle_Dimension_Set_ID;
                TEMPDetailedLedger."Led_Global Dimension 1 Code" := CustLedgerEntry.Cle_Global_Dimension_1_Code;
                TEMPDetailedLedger."Led_Global Dimension 2 Code" := CustLedgerEntry.Cle_Global_Dimension_2_Code;
                TEMPDetailedLedger."Query Nr." := 2;
                TEMPDetailedLedger.Insert();
                nRec += 1;
            end;
        end;
        exit(nRec);
    end;

    procedure FillDetVendorLedgBuffer1(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text): Integer
    var
        VendorLedgerEntry: Query GetRelatedVendLedgerEntries1;
        nRec: Integer;
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
                TEMPDetailedLedger."Led_Global Dimension 1 Code" := VendorLedgerEntry.Cle_Global_Dimension_1_Code;
                TEMPDetailedLedger."Led_Global Dimension 2 Code" := VendorLedgerEntry.Cle_Global_Dimension_2_Code;
                TEMPDetailedLedger."Query Nr." := 3;
                TEMPDetailedLedger.Insert();
                nRec += 1;
            end;
        end;
        exit(nRec);
    end;

    procedure FillDetVendorLedgBuffer2(PostRec: Record "Cash Entry Posting No."; TransactionNoFilter: text): Integer
    var
        VendorLedgerEntry: Query GetRelatedVendLedgerEntries2;
        nRec: Integer;
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
                TEMPDetailedLedger."led_Global Dimension 1 Code" := VendorLedgerEntry.Cle_Global_Dimension_1_Code;
                TEMPDetailedLedger."led_Global Dimension 2 Code" := VendorLedgerEntry.Cle_Global_Dimension_2_Code;

                TEMPDetailedLedger."Query Nr." := 4;
                TEMPDetailedLedger.Insert();
                nRec += 1;
            end;
        end;
        exit(nRec);
    end;

    procedure GetReviewedVATentries(Identifier: Integer; EntryNo: Integer; var TEMPglEntry: record "G/L Entry" temporary)
    var
        LogReview: record "G/L Entry Review Log";
        GlEntry: record "G/L Entry";
        GlEntryOri: record "G/L Entry";
        VatEntriesSettlement: record "Vat Entry" temporary;
        VatEntry: record "vat Entry";
        Link: record "G/L Entry - VAT Entry Link";
        n1, n2 : Integer;
    begin
        TEMPglEntry.reset;
        TEMPglEntry.DeleteAll();
        LogReview.SetRange("Reviewed Identifier", Identifier);
        logReview.SetFilter("G/L Entry No.", '<>%1', EntryNo);
        if LogReview.FindSet() then
            repeat
                GlEntryOri.get(EntryNo);
                GlEntry.get(LogReview."G/L Entry No.");
                if (GlEntry."Document No." = GlEntryOri."Document No.") and (GlEntry."Posting Date" = GlEntryOri."Posting Date") then
                    continue;
                // VatEntry.setrange("Posting Date", GlEntry."Posting Date");
                // VatEntry.SetRange("Document No.", GlEntry."Document No.");
                // if VatEntry.FindSet() then
                //     repeat
                //         VatEntriesSettlement := VatEntry;
                //         Link.SetRange("VAT Entry No.", VatEntry."Entry No.");
                //         if Link.FindFirst() then
                //             VatEntriesSettlement."Transaction No." := link."G/L Entry No.";
                //         VatEntriesSettlement.Insert();
                //         n1 += 1;
                //     until VatEntry.Next() = 0;
                GlEntry.setrange("Posting Date", GlEntry."Posting Date");
                GlEntry.SetRange("Document No.", GlEntry."Document No.");
                if GlEntry.FindSet() then
                    repeat
                        TEMPglEntry := GlEntry;
                        Link.SetRange("VAT Entry No.");
                        Link.SetRange("G/l Entry No.", GlEntry."Entry No.");
                        if Link.FindFirst() then
                            TEMPglEntry."Transaction No." := link."VAT Entry No."
                        else
                            TEMPglEntry."Transaction No." := 0;
                        TEMPglEntry.Insert();
                        n2 += 1;
                    until GlEntry.Next() = 0;
            until LogReview.Next() = 0;
        TEMPglEntry.Delete(); //Last record is counter line
    end;

    procedure FillVATSettlement(): Integer
    var
        nRec: Integer;
        //VatEntriesSettlement: record "Vat Entry" temporary;
        TEMPglEntry: record "G/L Entry" temporary;
        GlEntry: record "G/L Entry";
    begin
        GetReviewedVATentries(TEMPbuffer_Bnk."Reviewed Identifier", TEMPbuffer_Bnk."GL_EntryNo_Bnk", TEMPglEntry);
        if TEMPglEntry.findset then
            repeat
                if not (TEMPglEntry.amount <> 0) then
                    continue;
                TEMPDetailedLedger_EntryNo += 1;
                TEMPDetailedLedger.Init();
                TEMPDetailedLedger.n := TEMPDetailedLedger_EntryNo;
                //TEMPDetailedLedger."Is Init" := (GLEntry2."Entry No." = GLEntrySettlement."Entry No.");
                TEMPDetailedLedger."Init Entry No." := TEMPbuffer_Bnk.Gl_EntryNo_Bnk;
                TEMPDetailedLedger."Init Ledger Entry No." := TEMPbuffer_Bnk."GL_EntryNo Start";
                TEMPDetailedLedger."Entry No." := TEMPbuffer_Bnk.Gl_EntryNo_Bnk; //misused

                //TEMPDetailedLedger."Vendor Ledger Entry No." := VendorLedgerEntry.VendLedgEntryNo;
                //TEMPDetailedLedger."Applied Ledger Entry No." := VendorLedgerEntry.AppliedVendLedgEntryNo;
                //TEMPDetailedLedger."Entry Type" := VendorLedgerEntry.EntryType;
                //TEMPDetailedLedger."Transaction No." := GLEntrySettlement."Transaction No.";

                TEMPDetailedLedger."Document No." := TEMPbuffer_Bnk."Document No.";

                TEMPDetailedLedger."Amount" := -1 * TEMPglEntry.Amount;
                TEMPDetailedLedger."Posting Date" := TEMPglEntry."Posting Date";
                TEMPDetailedLedger."led_Entry No." := TEMPglEntry."Entry No.";
                TEMPDetailedLedger."led_Document Type" := TEMPglEntry."Document Type";
                TEMPDetailedLedger."led_Document No." := TEMPglEntry."Document No.";
                TEMPDetailedLedger."led_Posting Date" := TEMPglEntry."Posting Date";
                TEMPDetailedLedger."led_Account No." := TEMPglEntry."G/L Account No.";

                TEMPDetailedLedger."led_Amount" := -1 * TEMPglEntry.Amount;
                TEMPDetailedLedger."led_Dimension Set ID" := TEMPglEntry."Dimension Set ID";
                TEMPDetailedLedger."Led_Global Dimension 1 Code" := TEMPglEntry."Global Dimension 1 Code";
                TEMPDetailedLedger."Led_Global Dimension 2 Code" := TEMPglEntry."Global Dimension 2 Code";
                TEMPDetailedLedger."Query Nr." := 5;
                TEMPDetailedLedger.Insert();
                nRec += 1;
            until TEMPglEntry.Next() = 0;

        exit(nRec);
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
        if (TEMPbuffer_Bnk."Source No." = '') and (TEMPbuffer_Bnk."Is VAT Settlement" = false) and (TEMPbuffer_Bnk."GL_EntryNo Start" <> 0) then
            InsertTransactionBuffer(1, ProcessAmount)
        else begin
            TEMPDetailedLedger.Reset();
            TEMPDetailedLedger.SetRange("Init Ledger Entry No.", TEMPbuffer_Bnk."GL_EntryNo Start");
            TEMPDetailedLedger.SetFilter(Amount, '<>%1', 0);
            IF TEMPDetailedLedger.FindSet() THEN begin
                repeat
                    Factor := 1;
                    if TEMPDetailedLedger."led_Amount" <> 0 then
                        Factor := TEMPDetailedLedger."Amount" / TEMPDetailedLedger."led_Amount";
                    TEMPgrip.DeleteAll();
                    TEMPgrip_Vendor.DeleteAll();
                    case TEMPbuffer_Bnk."Source Type" of
                        TEMPbuffer_Bnk."Source Type"::Customer:
                            begin
                                IF GetCounterBalanceDetails(TEMPDetailedLedger."led_Document No.", TEMPDetailedLedger."led_Entry No.") THEN
                                    InsertGrip(Factor, ProcessAmount)
                                ELSE
                                    InsertDetailedLedBuffer(Factor, ProcessAmount);
                            end;
                        TEMPbuffer_Bnk."Source Type"::Vendor:
                            begin
                                IF FillTempGrip_Vendor(Format(TEMPDetailedLedger."led_Entry No.")) THEN
                                    InsertGrip_vendor(Factor, ProcessAmount)
                                ELSE
                                    InsertDetailedLedBuffer(Factor, ProcessAmount);
                            end;
                        else
                            InsertDetailedLedBuffer(Factor, ProcessAmount);
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
                if (TEMPbuffer_Bnk."Source No." = '') and (TEMPbuffer_Bnk."Is VAT Settlement" = false) and (TEMPbuffer_Bnk."GL_EntryNo Start" <> 0) then
                    InsertTransactionBuffer(1, ProcessAmount)
                else begin
                    TEMPDetailedLedger.Reset();
                    TEMPDetailedLedger.SetRange("Init Ledger Entry No.", TEMPbuffer_Bnk."GL_EntryNo Start");
                    TEMPDetailedLedger.SetFilter(Amount, '<>%1', 0);
                    IF TEMPDetailedLedger.FindSet() THEN begin
                        repeat
                            factor := 1;
                            if TEMPDetailedLedger."led_Amount" <> 0 then
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
                        InsertDummyDetailedLedBuffer(TEMPbuffer_Bnk."Gl_EntryNo_Bnk", TEMPbuffer_Bnk."Cashflow Amount"); //TEMPbuffer_Bnk."GL_EntryNo Start"
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
        n := FilterBuilder.BuildEntryNoFilter(TEMPbuffer_Bnk);
        for i := 1 to n do begin
            analyzeHeader.SetFilter("Entry No.", FilterBuilder.GetFilterChunk(i));
            if not analyzeHeader.IsEmpty() then
                analyzeHeader.DeleteAll(false);
            analyzeLine.SetFilter("G/L Entry No.", FilterBuilder.GetFilterChunk(i));
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
        GLentry.Get(TEMPbuffer_Bnk."GL_EntryNo Start");
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

        //disable KAS25-0005
        // CashFlowLine."Dimension Set ID" := TEMPbuffer_Bnk."Dimension Set ID";
        // CashFlowLine."Global Dimension 1 Code" := TEMPbuffer_Bnk."Global Dimension 1 Code";
        // CashFlowLine."Global Dimension 2 Code" := TEMPbuffer_Bnk."Global Dimension 2 Code";

        CashFlowLine."Transaction No." := TEMPbuffer_Bnk."Transaction No.";

        CashFlowLine."Journal Templ. Name" := TEMPbuffer_Bnk."Journal Templ. Name";
        CashFlowLine."Journal Batch Name" := TEMPbuffer_Bnk."Journal Batch Name";

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
        if not TEMPbuffer_Bnk."Is VAT Settlement" then
            if TEMPDetailedLedger."Entry Type" = TEMPDetailedLedger."Entry Type"::"Payment Tolerance" then //<< Payment Tolerance
                GLentry.Get(TEMPDetailedLedger."Ledger Entry No.")
            else
                GLentry.Get(TEMPbuffer_Bnk."Gl_EntryNo_Bnk")
        else
            GLentry.Get(TEMPDetailedLedger."Led_entry No.");

        if TEMPbuffer_Bnk."Is VAT Settlement" then begin
            CashFlowLine."Document No." := TEMPbuffer_Bnk."Document No.";
            CashFlowLine."Posting Date" := TEMPbuffer_Bnk."Posting Date";
        end else begin
            CashFlowLine."Document No." := GLentry."Document No.";
            CashFlowLine."Posting Date" := GLentry."Posting Date";
        end;
        CashFlowLine."Dimension Set ID" := TEMPDetailedLedger."led_Dimension Set ID";
        CashFlowLine."Global Dimension 1 Code" := TEMPDetailedLedger."led_Global Dimension 1 Code";
        CashFlowLine."Global Dimension 2 Code" := TEMPDetailedLedger."led_Global Dimension 2 Code";

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
        if TEMPDetailedLedger."Led_Dimension Set ID" <> 0 then
            CashFlowLine.Validate("Dimension Set ID", TEMPDetailedLedger."Led_Dimension Set ID");
        CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";

        CashFlowLine."Journal Templ. Name" := TEMPbuffer_Bnk."Journal Templ. Name";
        CashFlowLine."Journal Batch Name" := TEMPbuffer_Bnk."Journal Batch Name";

        CashFlowLine.Insert();
    end;

    local procedure InsertGrip_Vendor(Factor: Decimal; var ProcessAmount: Decimal);
    var
        CashFlowLine: Record "Cashflow Analyse Line";    //"Realized Cash Flow";
        GLaccount: Record "G/L Account";
        GLentry: Record "G/L Entry";
        Sign: Integer;
        CalcType: Enum Microsoft.Foundation.Enums."Tax Calculation Type";
        vatAmount: Decimal;
    begin
        TEMPgrip_Vendor.SetRange("Document No.", TEMPDetailedLedger."led_Document No.");
        if TEMPgrip_Vendor.FindSet() then
            repeat
                if TEMPgrip_Vendor."VAT Calculation Type" = CalcType::"Reverse Charge VAT" then begin
                    vatAmount := abs(TEMPgrip_Vendor."VAT Amount");
                    vatAmount += abs(TEMPgrip_Vendor."Non-Deductible VAT Amount");
                end;
                if abs(TEMPgrip_Vendor.Amount) = vatAmount then
                    continue;

                CashFlowLineNo += 1;
                CashFlowLine."G/L Entry No." := TEMPbuffer_Bnk."Gl_EntryNo_Bnk";
                CashFlowLine."Entry Line No." := CashFlowLineNo;
                // Bank/Cash Block
                GLentry.Get(TEMPbuffer_Bnk."Gl_EntryNo_Bnk");
                CashFlowLine."Document No." := GLentry."Document No.";
                CashFlowLine."Posting Date" := GLentry."Posting Date";
                CashFlowLine."Global Dimension 1 Code" := TEMPgrip_Vendor."Global Dimension 1 Code";
                CashFlowLine."Global Dimension 2 Code" := TEMPgrip_Vendor."Global Dimension 2 Code";
                CashFlowLine."Dimension Set ID" := TEMPgrip_Vendor."Dimension Set ID";

                // Realized block
                GLaccount.get(TEMPgrip_Vendor."G/L Account");
                CashFlowLine."G/L Account" := TEMPgrip_Vendor."G/L Account";
                CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
                CashFlowLine."Cash Flow Category Amount" := round(TEMPgrip_Vendor.Amount * Factor, 0.001);
                ProcessAmount += CashFlowLine."Cash Flow Category Amount";
                CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
                CashFlowLine."Applied Posting Date" := TEMPDetailedLedger."led_Posting Date";
                CashFlowLine."Applied Document No." := TEMPgrip_Vendor."Document No.";
                CashFlowLine."Applied Document Entry No." := TEMPgrip_Vendor."Exploitation No.";

                CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";

                CashFlowLine."Journal Templ. Name" := TEMPbuffer_Bnk."Journal Templ. Name";
                CashFlowLine."Journal Batch Name" := TEMPbuffer_Bnk."Journal Batch Name";

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
                CashFlowLine."Dimension Set ID" := TEMPgrip."Dimension Set ID";
                CashFlowLine."Global Dimension 1 Code" := TEMPgrip."Global Dimension 1 Code";
                CashFlowLine."Global Dimension 2 Code" := TEMPgrip."Global Dimension 2 Code";


                // Realized block
                GLaccount.get(TEMPgrip."G/L Account");
                CashFlowLine."G/L Account" := TEMPgrip."G/L Account";
                CashFlowLine."Cash Flow Category" := GetCashFlowCategory(CashFlowLine."G/L Account", CashFlowLine."Posting Date");
                CashFlowLine."Cash Flow Category Amount" := round(TEMPgrip.Amount * Factor, 0.001);
                ProcessAmount += CashFlowLine."Cash Flow Category Amount";
                CashFlowLine."Applied Document Type" := CashFlowLine."Applied Document Type"::Invoice;
                CashFlowLine."Applied Posting Date" := TEMPDetailedLedger."led_Posting Date";
                CashFlowLine."Applied Document No." := TEMPgrip."Document No.";
                CashFlowLine."Applied Document Entry No." := TEMPgrip."Exploitation No.";

                CashFlowLine."Transaction No." := TEMPDetailedLedger."Transaction No.";

                CashFlowLine."Journal Templ. Name" := TEMPbuffer_Bnk."Journal Templ. Name";
                CashFlowLine."Journal Batch Name" := TEMPbuffer_Bnk."Journal Batch Name";

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
        TEMP_NotFound: Record "DetailLedger2DocNo Buffer" temporary;
        FilterBuilder: Codeunit FilterBuilder;
        GetNotGrip: Codeunit GetNotGrip;
        i, n : Integer;
        DocFilter: Text;
        Filters: List of [Text];
    begin
        TEMPgrip.Reset();
        TEMPgrip.DeleteAll();
        TEMPgrip_Vendor.Reset();
        TEMPgrip_Vendor.DeleteAll();
        TEMPDetailedLedger.SetRange("Query Nr.", 1, 2);
        TEMPDetailedLedger.setrange("led_Document Type", TEMPDetailedLedger."led_Document Type"::Invoice, TEMPDetailedLedger."led_Document Type"::"Credit Memo");
        TEMPDetailedLedger.SetCurrentKey("led_Document Type", "led_Document No.");
        if not TEMPDetailedLedger.IsEmpty() then
            n := FilterBuilder.BuildEntryNoFilter(TEMPDetailedLedger);
        for i := 1 to n do begin
            DocFilter := FilterBuilder.GetFilterChunk(i);
            FillTempGrip_Grip(DocFilter, True);
        end;
        if GetNotGrip.FindNotGripSalesInvoices(TEMPDetailedLedger, TEMPgrip, TEMP_NotFound) then begin
            n := FilterBuilder.BuildEntryNoFilter2(TEMP_NotFound);
            for i := 1 to n do begin
                DocFilter := FilterBuilder.GetFilterChunk(i);
                FillTempGrip_Customer(DocFilter);
            end;
        end;
        TEMPDetailedLedger.Reset();

        n := 0;
        TEMPDetailedLedger.SetRange("Query Nr.", 3, 4);
        TEMPDetailedLedger.SetFilter("led_Document Type", '%1|%2', TEMPDetailedLedger."led_Document Type"::Invoice, TEMPDetailedLedger."led_Document Type"::"Credit Memo");
        TEMPDetailedLedger.SetCurrentKey("led_Document Type", "led_Document No.");
        if not TEMPDetailedLedger.IsEmpty() then
            n := FilterBuilder.BuildEntryNoFilter2(TEMPDetailedLedger);
        for i := 1 to n do begin
            DocFilter := FilterBuilder.GetFilterChunk(i);
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
                TEMPgrip_Vendor."Document No." := GripQry.Document_No_;
                TEMPgrip_Vendor."G/L Account" := GripQry.G_L_Account_No_;
                TEMPgrip_Vendor."Amount" := GripQry.Amount;
                TEMPgrip_Vendor."Global Dimension 1 Code" := GripQry.Global_Dimension_1_Code;
                TEMPgrip_Vendor."Global Dimension 2 Code" := GripQry.Global_Dimension_2_Code;
                TEMPgrip_Vendor."Dimension Set ID" := GripQry.Dimension_Set_ID;

                TEMPgrip_Vendor."VAT Amount" := GripQry.VAT_Amount;
                TEMPgrip_Vendor."VAT Calculation Type" := GripQry."VAT_Calculation_Type";
                TEMPgrip_Vendor."Non-Deductible VAT Amount" := GripQry."Non_Deductible_VAT_Amount";

                Inserted := TEMPgrip_Vendor.Insert();
                if not HasRecords and Inserted then
                    HasRecords := true;
            end;
        end;
        GripQry.Close();
        if not HasRecords then
            exit(false);

    end;

    local procedure FillTempGrip_Grip(DocFilter: Text; IsGrip: Boolean) HasRecords: Boolean;
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
        // TEMPgrip.DeleteAll();k
        GripQry.SetFilter("Document_No_", DocFilter);
        GripQry.Open();
        while GripQry.Read() do begin
            TEMPgrip.Init();
            TEMPgrip.IsGrip := IsGrip;
            TEMPgrip."Exploitation No." := GripQry."Exploitation_No_";
            TEMPgrip."Document Type" := GripQry.Document_Type;
            TEMPgrip."Document No." := GripQry.Document_No_;
            TEMPgrip."G/L Account" := GripQry.GL_Account;
            TEMPgrip."Amount" := -1 * GripQry.Amount;
            TEMPgrip."Global Dimension 1 Code" := GripQry.Global_Dimension_1_Code;
            TEMPgrip."Global Dimension 2 Code" := GripQry.Global_Dimension_2_Code;
            //TEMPgrip."Dimension Set ID" := ;
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
            TEMPgrip."Amount" := VatQry.Amount;
            TEMPgrip."Global Dimension 1 Code" := VatQry.Dim1;
            TEMPgrip."Global Dimension 2 Code" := VatQry.Dim2;
            TEMPgrip."Dimension Set ID" := VatQry.Dim_Set_ID;
            if TEMPgrip."Amount" <> 0 then
                if not TEMPgrip.Insert() then
                    log.CreateLog(n, t1, t2, StrSubstNo('Double vat_id %1', VatQry.EntryNo));
        end;
        VatQry.Close();
    end;

    local procedure GetCounterBalanceDetails(Led_DocNo: Code[20]; led_Entry_No_: Integer) HasRecords: Boolean;
    begin
        HasRecords := FillTempGrip_Grip(Led_DocNo, False);
        if not HasRecords then
            HasRecords := FillTempGrip_Customer(format(led_Entry_No_));
    end;

    local procedure FillTempGrip_Customer(DocFilter: Text) HasRecords: Boolean;
    var
        GripQry: Query "Get Customer Ledger Entry Opt.";
        Inserted: Boolean;
        x: Integer;
    begin
        GripQry.SetFilter(Entry_No_, DocFilter);
        GripQry.Open();
        while GripQry.Read() do begin
            if (GripQry.Init_Entry_No_ <> GripQry.G_L_Entry_No_) then begin
                TEMPgrip.Init();
                TEMPgrip."Exploitation No." := GripQry.G_L_Entry_No_;
                case GripQry.Document_Type of
                    GripQry.Document_Type::Invoice,
                    GripQry.Document_Type::" ":
                        TEMPgrip."Document Type" := TEMPgrip."Document Type"::Invoice;
                    GripQry.Document_Type::"Credit Memo":
                        TEMPgrip."Document Type" := TEMPgrip."Document Type"::"Credit Memo";
                    GripQry.Document_Type::Refund:
                        TEMPgrip."Document Type" := TEMPgrip."Document Type"::Refund;
                    GripQry.Document_Type::Payment:
                        TEMPgrip."Document Type" := TEMPgrip."Document Type"::Payment;
                end;
                if GripQry.Document_No_ = 'IF25-107888' then
                    x := 1;
                TEMPgrip."Document No." := GripQry.Document_No_;
                TEMPgrip."G/L Account" := GripQry.G_L_Account_No_;
                TEMPgrip."Amount" := GripQry.Amount;
                TEMPgrip."Global Dimension 1 Code" := GripQry.Global_Dimension_1_Code;
                TEMPgrip."Global Dimension 2 Code" := GripQry.Global_Dimension_2_Code;
                TEMPgrip."Dimension Set ID" := GripQry.Dimension_Set_ID;
                Inserted := TEMPgrip.Insert();
                if not HasRecords and Inserted then
                    HasRecords := true;
            end;
        end;
        GripQry.Close();
        if not HasRecords then
            exit(false);

    end;


}



