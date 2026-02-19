query 57204 "Get Grip"
{
    QueryType = Normal;

    elements
    {
        dataitem(GRIPInvoice; "CashFlow Category GRIP Invoice")
        {
            column(Exploitation_No_; "Exploitation No.") { }
            column(Document_Type; "Document Type") { }
            column(Document_No_; "Document No.") { }
            column(GL_Account; "G/L Account") { }
            column(Amount; Amount) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}