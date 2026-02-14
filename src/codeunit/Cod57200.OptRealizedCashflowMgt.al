codeunit 57200 "Opt. Realized Cashflow Mgt."
{
    Permissions = TableData "G/L Entry" = rm;

    trigger OnRun()
    begin

    end;

    var
        log: Record "Opt. Creation Cash Flow Log";
        LogEnryNo: Integer;
        StartTime: time;
        EndTIme: time;
        TotalTime: duration;
        TotSourceLineCounter: integer;
        VendorFlow, CustomerFlow, BankFlow, GLEFlow : Integer;

    procedure CreateCashFlowAnalyzeEntries(DateFilter: text)
    begin
        //CleanupRecordsByDateFilter(DateFilter);
        CreateCashFlowAnalyzeEntries('', '', '', DateFilter, 0);
        EndTIme := Time();
        TotalTime := EndTIme - StartTime;
        LogEnryNo := log.PopulateLogMetrics(StartTime, EndTIme, TotalTime, TotSourceLineCounter, VendorFlow, CustomerFlow, BankFlow, GLEFlow);
        message(log.CreateMessage(LogEnryNo));
    end;

    procedure CreateCashFlowAnalyzeEntries(GenJournalTemplate: Code[10]; JournalBatch: Code[10]; DocumentNoFilter: Text; bankEntryNoFilter: Integer)
    begin
        CreateCashFlowAnalyzeEntries(GenJournalTemplate, JournalBatch, DocumentNoFilter, '', bankEntryNoFilter);
        EndTIme := Time();
        TotalTime := EndTIme - StartTime;
        LogEnryNo := log.PopulateLogMetrics(StartTime, EndTIme, TotalTime, TotSourceLineCounter, VendorFlow, CustomerFlow, BankFlow, GLEFlow);
        message(log.CreateMessage(LogEnryNo));
    end;

    local procedure CreateCashFlowAnalyzeEntries(GenJournalTemplate: Code[10]; JournalBatch: Code[10]; DocumentNoFilter: Text; DateFilter: Text; bankEntryNoFilter: Integer)
    var
        GLentry: Record "G/L Entry";
        GLentry2Analyze: record "G/L Entry Cash to Analyze";
        GLentry2AnalyzeCheck: record "G/L Entry Cash to Analyze";
        cashFlowType: Enum "Cash_Flow source Type";
        i: Integer;
        GlEntryNext0: Boolean;
    begin
        StartTime := Time();
        for i := 1 to 2 do begin
            case i of
                1:
                    CalcFiltersGlentryBank(GenJournalTemplate, JournalBatch, DocumentNoFilter, DateFilter, bankEntryNoFilter, GLentry);
                2:
                    CalcFiltersGlentryCash(GenJournalTemplate, JournalBatch, DocumentNoFilter, DateFilter, bankEntryNoFilter, GLentry);
            end;
            IF GLentry.FindSet() then begin
                TotSourceLineCounter := GLentry.Count();
                GLentry2AnalyzeCheck.SetLoadFields("Entry No.");
                repeat
                    if not GLentry2AnalyzeCheck.Get(GLentry."Entry No.") then begin
                        GLentry2Analyze.Init();
                        GLentry2Analyze."Entry No." := GLentry."Entry No.";
                        GLentry2Analyze."Posting Date" := GLentry."Posting Date";
                        GLentry2Analyze."Document No." := GLentry."Document No.";
                        GLentry2Analyze.Description := GLentry.Description;
                        GLentry2Analyze.Amount := GLentry.Amount;
                        case i of
                            1:
                                GLentry2Analyze."Source Type" := cashFlowType::"Bank Account";
                            2:
                                GLentry2Analyze."Source Type" := cashFlowType::"Cash Statement"
                        end;
                    end;
                    GLentry2Analyze."Journal Templ. Name" := GLentry."Journal Templ. Name";
                    GLentry2Analyze."Journal Batch Name" := GLentry."Journal Batch Name";
                    //TODO : do we need dimension here or on the child lines?
                    //RealizedCashFlow."Dimension Set ID" := GLE."Dimension Set ID";
                    //RealizedCashFlow."Global Dimension 1 Code" := GLE."Global Dimension 1 Code";
                    //RealizedCashFlow."Global Dimension 2 Code" := GLE."Global Dimension 2 Code";
                    GLentry2Analyze."Transaction No. Start" := GLentry."Transaction No.";
                    GlEntryNext0 := GLentry.Next() = 0;

                    //GLentry2Analyze."Transaction No. End" := getLastTransactionNo(GLentry);
                    GLentry2Analyze.Insert();
                    GLentry2Analyze.Mark(true);
                until GlEntryNext0;
            end;
        end;
        GLentry2Analyze.MarkedOnly(true);
        if GLentry2Analyze.FindSet() then begin
            repeat
            //Recalculate Realize Cash Flow
            // Current Codeunit:            
            //  1. Delete all record related bank record
            //  2. Create new records based on G/L Entry bank
            until GLentry2Analyze.Next() = 0;
        end;

    end;

    Local procedure CalcFiltersGlentryBank(GenJournalTemplate: Code[10]; JournalBatch: Code[10]; DocumentNoFilter: Text; DateFilter: Text; bankEntryNoFilter: Integer; var GLentryBank: Record "G/L Entry")
    begin
        // Transaction based on GL Entry of Bank 
        if GenJournalTemplate <> '' then
            GLentryBank.SetRange("Journal Templ. Name", GenJournalTemplate);
        if JournalBatch <> '' then
            GLentryBank.SetRange("Journal Batch Name", JournalBatch);
        if DocumentNoFilter <> '' then
            GLentryBank.SetFilter("Document No.", DocumentNoFilter);
        if DateFilter <> '' then
            GLentryBank.SetFilter("Posting Date", DateFilter);
        if bankEntryNoFilter <> 0 then
            GLentryBank.setrange("Entry No.", bankEntryNoFilter);
        GLentryBank.SetRange("Source Type", GLentryBank."Source Type"::"Bank Account");
        GLentryBank.SetFilter("Source No.", '<>%1', '');
    end;

    local procedure CalcFiltersGlentryCash(GenJournalTemplate: Code[10]; JournalBatch: Code[10]; DocumentNoFilter: Text; DateFilter: Text; bankEntryNoFilter: Integer; var GLentryCash: Record "G/L Entry") StopProcess: Boolean
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if GenJournalTemplate <> '' then begin
            GenJnlTemplate.Get(GenJournalTemplate);
            if not (GenJnlTemplate.Type in [GenJnlTemplate.Type::Cash, GenJnlTemplate.Type::"Cash Receipts"]) then
                exit(true);
            if GenJnlTemplate."Bal. Account Type" <> GenJnlTemplate."Bal. Account Type"::"G/L Account" then
                exit(true);
            GLentryCash.SetRange("Journal Templ. Name", GenJournalTemplate);
        end else
            GLentryCash.Setfilter("Journal Batch Name", GetFilterCashTemplates);
        if JournalBatch <> '' then
            GLentryCash.SetRange("Journal Batch Name", JournalBatch);
        if DateFilter <> '' then
            GLentryCash.SetFilter("Posting Date", DateFilter);

        GLentryCash.SetRange("System-Created Entry", True); //Header of CBG Statement
        GLentryCash.Setrange("CBG Statement", true);
        GLentryCash.Setrange("Source Type", GLentryCash."Source Type"::" ");
    end;

    Local Procedure GetFilterCashTemplates() FilterStr: text
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.SetFilter(Type, '%1|%2', GenJnlTemplate.Type::Cash, GenJnlTemplate.Type::"Cash Receipts");
        GenJnlTemplate.setrange("Bal. Account Type", GenJnlTemplate."Bal. Account Type"::"G/L Account");
        if GenJnlTemplate.FindSet() then
            repeat
                if filterstr = '' then
                    filterStr := genJnlTemplate.Name
                else
                    filterStr := filterStr + '|' + genJnlTemplate.Name;
            until GenJnlTemplate.Next() = 0;
    end;

    local procedure getBalance(var GLentry: Record "G/L Entry"): Integer
    var
        GLentry2: Record "G/L Entry";
    begin
        GLentry.CopyFilter("Document No.", GLentry2."Document No.");
        GLentry.CopyFilter("Posting Date", GLentry2."Posting Date");
        GLentry.SetFilter(Description, GLentry2.Description);

        if GLentry.FindLast() then
            exit(GLentry."Transaction No.");
        exit(0);
    end;


}
