query 57203 GetRelatedCustLedgerEntriesBCK
{
    QueryType = Normal;

    elements
    {
        dataitem(DetCustLed; "Detailed Cust. Ledg. Entry")
        {

            DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");

            filter(TransactionNoFilter; "Transaction No.") { }
            filter(DocNoFilter; "Document No.") { }
            filter(PostingDateFilter; "Posting Date") { }

            column(EntryNo; "Entry No.") { }
            column(CustLedgEntryNo; "Cust. Ledger Entry No.") { }
            column(AppliedCustLedEntrNo; "Applied Cust. Ledger Entry No.") { }
            column(TransactionNo; "Transaction No.") { }
            column(EntryType; "Entry Type") { }
            column(DocumentNoBnk; "Document No.") { }
            column(PostingDateBnk; "Posting Date") { }
            column(Amount; Amount) { }

            dataitem(CustLedger; "Cust. Ledger Entry")
            {
                DataItemLink = "Entry No." = DetCustLed."Cust. Ledger Entry No.";


                column(EntryNoTarget; "Entry No.")
                {
                }
                column(DocTypeTarget; "Document Type")
                {
                }
                column(DocNoTarget; "Document No.")
                {
                }
                column(PostingDateTarget; "Posting Date")
                {
                }
                column(AccountNo; "Customer No.")
                {
                }
                column(TargetAmount; Amount)
                {
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}

