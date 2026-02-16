codeunit 57203 CreateCashEntryPostingNoList
{
    trigger OnRun()
    begin
        if not CreateCashEntryPostingNoList() then
            Message(GetLastErrorText)
        else
            Message('Process completed. Total records inserted: %1', counter);
    end;

    var
        counter: Integer;

    [TryFunction]
    procedure CreateCashEntryPostingNoList()
    var
        CashEntryPostingNo: Record "Cash Entry Posting No.";
        qry: query "GetPostingNo From GLEntry";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        //TODO filter on date and source type, delete table remove
        CashEntryPostingNo.DeleteAll();
        SourceType := SourceType::"Bank Account";
        qry.setfilter(SourceTypeFilter, '%1', SourceType);
        qry.SetFilter(PostingDateFilter, '%1..%2', 20250101D, 20251231D);

        qry.Open();
        while qry.Read() do begin
            CashEntryPostingNo.Init();
            CashEntryPostingNo."Entry No." := qry.firstEntryNo;
            CashEntryPostingNo."Posting Date" := qry.PostingDate;
            CashEntryPostingNo."Document No." := qry.DocumentNo;
            CashEntryPostingNo."Journal Templ. Name" := qry.Journal_Templ__Name;
            CashEntryPostingNo."Journal Batch Name" := qry.JournalBatchName;
            CashEntryPostingNo."Last Entry No." := qry.lastEntryNo;
            CashEntryPostingNo."Amount of Records" := qry.EntryCount;
            CashEntryPostingNo."Source Type" := qry.SourceType;
            CashEntryPostingNo."Source No." := qry.SourceNo;
            CashEntryPostingNo."Source Code" := qry.Source_Code;
            if not CashEntryPostingNo.Insert() then
                CashEntryPostingNo.Modify();
            counter += 1;
        end;
    end;

    var
        myInt: Integer;

    Local procedure CalcFiltersGlentryBank(DateFilter: Text; var GLentryBank: Record "G/L Entry")
    begin
        // Transaction based on GL Entry of Bank 
        if DateFilter <> '' then
            GLentryBank.SetFilter("Posting Date", DateFilter);
        GLentryBank.SetRange("Source Type", GLentryBank."Source Type"::"Bank Account");
        GLentryBank.SetFilter("Source No.", '<>%1', '');
    end;

    local procedure CalcFiltersGlentryCash(DateFilter: Text; var GLentryCash: Record "G/L Entry") StopProcess: Boolean
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GLentryCash.Setfilter("Journal Batch Name", GetFilterCashTemplates);
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
}
