query 57208 "Get Vendor Ledger Entry Opt."
{
    QueryType = Normal;

    elements
    {
        dataitem(Vendor_Ledger_Entry; "Vendor Ledger Entry")
        {


            column(Document_No_; "Document No.") { }
            column(Entry_No_; "Entry No.") { }
            column(Document_Type; "Document Type") { }
            column(Amount; Amount) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            dataitem(G_L_Entry; "G/L Entry")
            {
                DataItemLink = "Entry No." = Vendor_Ledger_Entry."Entry No.";
                column(G_L_Account_No_; "G/L Account No.") { }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}