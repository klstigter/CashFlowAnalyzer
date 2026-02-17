enum 57200 "Analyse Type"
{
    Extensible = true;
    Caption = 'Cash Flow Source Type';

    value(0;
    "")
    {
    }
    value(1; "Bank Account")
    {
        CaptionML = ENU = 'Bank Account', NLD = 'Bankrekening';
    }
    value(2; "Cash Statement")
    {
        CaptionML = ENU = 'Cash Statement', NLD = 'Kasboek';
    }
}