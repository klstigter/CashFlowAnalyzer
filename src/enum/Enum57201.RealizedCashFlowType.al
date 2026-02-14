enum 57201 "Realized_Cash Flow Type"
{
    Extensible = true;

    value(0; "")
    {
    }
    value(1; "Customer Ledger Entry")
    {
        CaptionML = ENU = 'Customer Ledger Entry', NLD = 'Klantmutatie';
    }
    value(2; "Vendor Ledger Entry")
    {
        CaptionML = ENU = 'Vendor Ledger Entry', NLD = 'Leveranciersmutatie';
    }
    value(3; "Bank Ledger Entry")
    {
        CaptionML = ENU = 'Bank Ledger Entry', NLD = 'Bankmutatie';
    }
    value(4; "G/L Ledger Entry")
    {
        CaptionML = ENU = 'G/L Ledger Entry', NLD = 'Grootboekmutatie';
    }
    value(5; "CashFlow Category GRIP Invoice")
    {
        CaptionML = ENU = 'CashFlow Category GRIP Invoice', NLD = 'Kasstroomcategorie GRIP factuur';
    }
    value(6; "G/L Entry Review Entry")
    {
        CaptionML = ENU = 'G/L Entry Review Entry', NLD = 'Controlepost van grootboekpost';
    }
    value(7; "G/L Entry Review Entry - Reversed VAT")
    {
        CaptionML = ENU = 'G/L Entry Review Entry - Reversed VAT', NLD = 'Controlepost van grootboekpost - Reversed VAT';
    }

    value(8; "G/L Ledger Entry - CustLE")
    {
        CaptionML = ENU = 'G/L Ledger Entry - CustLE', NLD = 'Grootboekmutatie - Klantmutatie';
    }
    value(9; "G/L Ledger Entry - VendLE")
    {
        CaptionML = ENU = 'G/L Ledger Entry - VendLE', NLD = 'Grootboekmutatie - Leveranciersmutatie';
    }
}