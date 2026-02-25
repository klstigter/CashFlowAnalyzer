query 57200 "GetPostingNo From GLEntry"
{
    Caption = 'G/L Entry by Journal Batch';

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            filter(SourceTypeFilter; "Source Type")
            {
                Caption = 'Source Type Filter';
            }
            filter(JournalTemplNameFlt; "Journal Templ. Name")
            {
                Caption = 'Journal Template Name Filter';
            }
            filter(PostingDateFilter; "Posting Date")
            {
            }
            column("SourceType"; "Source Type")
            {
            }
            column("SourceNo"; "Source No.")
            {
            }
            column(Source_Code; "Source Code")
            {
            }
            column(PostingDate; "Posting Date")
            {

            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Journal_Templ__Name; "Journal Templ. Name")
            {
            }
            column(JournalBatchName; "Journal Batch Name")
            {
            }
            column(PostingDate2; "Posting Date")
            {
                Caption = 'Posting Date';
            }

            column(firstEntryNo; "Entry No.")
            {
                Method = Min;
            }
            column(lastEntryNo; "Entry No.")
            {
                Method = Max;
            }
            column(EntryCount)
            {
                Method = Count;
            }
        }
    }
}