query 57208 "Get Vendor Ledger Entry Opt."
{
    QueryType = Normal;

    elements
    {
        dataitem(Vendor_Gl_Entry; "G/L Entry")
        {
            DataItemTableFilter = "Document Type" = filter(Invoice | "Credit Memo");
            filter(Entry_No_; "Entry No.") { }

            column(Init_Entry_No_; "Entry No.") { }
            column(Document_No_; "Document No.") { }
            column(Document_Type; "Document Type") { }
            dataitem(G_L_Entry; "G/L Entry")
            {
                DataItemLink = "Posting Date" = Vendor_Gl_Entry."Posting Date",
                     "Document No." = Vendor_Gl_Entry."Document No.";
                //Init_Entry No is not the same as this entry no;

                column(G_L_Account_No_; "G/L Account No.") { }
                column(Amount; Amount) { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}