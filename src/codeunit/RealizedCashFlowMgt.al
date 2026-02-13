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
        Cashflowheader: record "Opt. Cashflow Analyser Header";
    begin
        StartTime := Time();

        CalcFiltersGlentryBank(GenJournalTemplate, JournalBatch, DocumentNoFilter, DateFilter, bankEntryNoFilter, GLentry);
        IF GLentry.FindSet() then begin
            TotSourceLineCounter := GLentry.Count();
            repeat
                if not Cashflowheader.Get(GLentry."Entry No.") then begin
                    Cashflowheader.Init();
                    Cashflowheader."Entry No." := GLentry."Entry No.";
                    Cashflowheader."Posting Date" := GLentry."Posting Date";
                    Cashflowheader."Document No." := GLentry."Document No.";
                    Cashflowheader.Description := GLentry.Description;
                    Cashflowheader.Amount := GLentry.Amount;
                    Cashflowheader.Insert();
                end;
                Cashflowheader.Mark(true);
            until GLentry.Next() = 0;
        end;

        Cashflowheader.MarkedOnly(true);
        if Cashflowheader.FindSet() then begin
            repeat
            //Recalculate Realize Cash Flow
            // Current Codeunit:            
            //  1. Delete all record related bank record
            //  2. Create new records based on G/L Entry bank
            until Cashflowheader.Next() = 0;
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

}
