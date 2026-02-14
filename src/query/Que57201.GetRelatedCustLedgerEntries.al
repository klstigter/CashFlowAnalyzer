query 57201 GetRelatedCustLedgerEntries
{
    QueryType = Normal;

    elements
    {
        dataitem(DetCustLed; "Detailed Cust. Ledg. Entry")
        {

            DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");

            column(EntryNo; "Entry No.") { }
            column(CustLedgEntryNo; "Cust. Ledger Entry No.") { }
            column(AppliedCustLedEntrNo; "Applied Cust. Ledger Entry No.") { }
            column(TransactionNo; "Transaction No.") { }
            column(EntryType; "Entry Type") { }
            filter(TransactionNoFilter; "Transaction No.") { }
            dataitem(CustLedger; "Cust. Ledger Entry")
            {
                DataItemLink = "Entry No." = DetCustLed."Cust. Ledger Entry No.";


                column(DocNo; "Document No.")
                {

                }
                column(PostingDate; "Posting Date")
                {
                }

            }


        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}

