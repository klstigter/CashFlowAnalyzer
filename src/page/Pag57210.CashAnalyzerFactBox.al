page 57210 CashAnalyzerFactBox
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Cashflow Analyse Result";

    layout
    {
        area(Content)
        {
            repeater(AnalyzeResult)
            {
                field(Name; rec."Cash Flow Category")
                {

                }
                field(Amount; rec."Cash Flow Category Amount")
                {

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}