query 57202 GetRelatedVendLedgerEntries
{
    QueryType = Normal;

    elements
    {
        dataitem(DetVendLed; "Detailed Vendor Ledg. Entry")
        {

            DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");
            filter(TransactionNoFilter; "Transaction No.") { }
            filter(DocNoFilter; "Document No.") { }
            filter(PostingDateFilter; "Posting Date") { }

            dataitem(DetNotInit; "Detailed vendor Ledg. Entry")
            {
                DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");
                DataItemLink = "Vendor Ledger Entry No." = DetVendLed."Vendor Ledger Entry No.";
                column(EntryNo; "Entry No.") { }
                column(VendLedgEntryNo; "Vendor Ledger Entry No.") { }
                column(AppliedVendLedgEntryNo; "Applied Vend. Ledger Entry No.") { }
                column(TransactionNo; "Transaction No.") { }
                column(EntryType; "Entry Type") { }
                column(DocumentNoBnk; "Document No.") { }
                column(PostingDateBnk; "Posting Date") { }
                column(Amount; Amount) { }

                dataitem(VendLedger; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Entry No." = DetVendLed."Vendor Ledger Entry No.";


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
                    column(AccountNo; "Vendor No.")
                    {
                    }
                    column(TargetAmount; Amount)
                    {
                    }
                }
            }
        }
    }

}