query 57201 GetRelatedCustLedgerEntries
{
    QueryType = Normal;

    elements
    {
        dataitem(DetCustLed; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableFilter = "Entry Type" = filter("Initial Entry");

            filter(TransactionNoFilter; "Transaction No.") { }
            filter(DocNoFilter; "Document No.") { }
            filter(PostingDateFilter; "Posting Date") { }
            column(Init_EntryNo; "Entry No.") { }
            column(Init_CustLedgEntryNo; "Cust. Ledger Entry No.") { }
            dataitem(DetNotInit; "Detailed Cust. Ledg. Entry")
            {
                DataItemTableFilter = "Entry Type" = filter(<> "Initial Entry");
                DataItemLink = "Cust. Ledger Entry No." = DetCustLed."Cust. Ledger Entry No.",
                    //"Document No." = DetCustLed."Document No.",
                    //"Transaction No." = DetCustLed."Transaction No.",
                    //"Posting Date" = DetCustLed."Posting Date",
                    "customer No." = DetCustLed."Customer No.";

                column(EntryNo; "Entry No.") { }
                column(CustLedgEntryNo; "Cust. Ledger Entry No.") { }
                column(AppliedCustLedEntrNo; "Applied Cust. Ledger Entry No.") { }
                column(TransactionNo; "Transaction No.") { }
                column(EntryType; "Entry Type") { }
                column(DocumentNo; "Document No.") { }
                column(PostingDate; "Posting Date") { }
                column(Amount; Amount) { }

                dataitem(CustLedger; "Cust. Ledger Entry")
                {
                    DataItemLink = "Entry No." = DetNotInit."Cust. Ledger Entry No.";
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
                    column(Cle_AccountNo; "Customer No.")
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


    trigger OnBeforeOpen()
    begin

    end;
}

