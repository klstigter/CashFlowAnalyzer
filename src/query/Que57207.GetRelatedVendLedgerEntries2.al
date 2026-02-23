query 57207 GetRelatedVendLedgerEntries2
{
    QueryType = Normal;

    elements
    {
        dataitem(DetVendLed; "Detailed Vendor Ledg. Entry")
        {
            DataItemTableFilter = "Entry Type" = filter("Initial Entry");

            filter(TransactionNoFilter; "Transaction No.") { }
            filter(DocNoFilter; "Document No.") { }
            filter(PostingDateFilter; "Posting Date") { }
            column(Init_EntryNo; "Entry No.") { }
            column(Init_VendLedgEntryNo; "Vendor Ledger Entry No.") { }
            dataitem(DetNotInit; "Detailed Vendor Ledg. Entry")
            {
                DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");
                DataItemLink = "Vendor Ledger Entry No." = DetVendLed."Vendor Ledger Entry No.",
                    //"Document No." = DetVendLed."Document No.",
                    //"Transaction No." = DetVendLed."Transaction No.",
                    //"Posting Date" = DetVendLed."Posting Date",
                    "vendor No." = DetVendLed."Vendor No.";

                column(EntryNo; "Entry No.") { }
                column(VendLedgEntryNo; "Vendor Ledger Entry No.") { }
                column(AppliedVendLedgEntryNo; "Applied Vend. Ledger Entry No.") { }
                column(TransactionNo; "Transaction No.") { }
                column(EntryType; "Entry Type") { }
                column(DocumentNo; "Document No.") { }
                column(PostingDate; "Posting Date") { }
                column(Amount; Amount) { }

                dataitem(VendLedger; "Vendor Ledger Entry")
                {
                    DataItemLink = "Entry No." = DetNotInit."Applied Vend. Ledger Entry No.";
                    //DataItemTableFilter = "Document Type" = filter(<> Payment & <> Refund);
                    column(Cle_EntryNo; "Entry No.")
                    {
                    }
                    column(Cle_DocType; "Document Type")
                    {
                    }
                    column(Cle_DocNo; "Document No.")
                    {
                    }
                    column(Cle_PostingDate; "Posting Date")
                    {
                    }
                    column(Cle_AccountNo; "Vendor No.")
                    {
                    }
                    column(Cle_Amount; Amount)
                    {
                    }
                    Column(Cle_Dimension_Set_ID; "Dimension Set ID")
                    {
                    }
                }
            }
        }
    }


}

