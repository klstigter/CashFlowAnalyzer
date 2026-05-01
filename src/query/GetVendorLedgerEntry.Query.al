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

                column(G_L_Entry_No_; "Entry No.") { }
                column(G_L_Account_No_; "G/L Account No.") { }
                column(Amount; Amount) { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(Dimension_Set_ID; "Dimension Set ID") { }
                dataitem(VAT_Entry_Link; "G/L Entry - VAT Entry Link")
                {
                    DataItemLink = "G/L Entry No." = G_L_Entry."Entry No.";
                    column(VAT_Entry_No_; "VAT Entry No.") { }
                    dataitem(VAT_Entry; "VAT Entry")
                    {
                        DataItemLink = "Entry No." = VAT_Entry_Link."VAT Entry No.";
                        column(VAT_Calculation_Type; "VAT Calculation Type") { }
                        column(VAT_Amount; "Amount") { }
                        column(Non_Deductible_VAT_Amount; "Non-Deductible VAT Amount") { }
                    }
                }
            }
        }
    }
    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}