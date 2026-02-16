query 57201 GetRelatedCustLedgerEntries
{
    QueryType = Normal;

    elements
    {
        dataitem(DetCustLed; "Detailed Cust. Ledg. Entry")
        {

            DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");

            filter(TransactionNoFilter; "Transaction No.") { }

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
                column(DocNoTarget; "Document No.")
                {
                }
                column(PostingDateTarget; "Posting Date")
                {
                }


            }


        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}

