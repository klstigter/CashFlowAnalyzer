page 57208 "Analyzer VAT Settlement Setup"
{
    PageType = Card;
    CaptionML = ENU = 'Analyzer VAT Settlement Setup', NLD = 'Analyse BTW-vereffening Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cashflow Analyzer Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Description = 'Task 2241';

    layout
    {
        area(Content)
        {
            group(VATSetup)
            {
                Caption = 'VAT Settlement Account';

                field("VAT Settlement G/L Account No."; Rec."VAT Settlement G/L Account No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Test)
            {
                Caption = 'Test';

                field("Show Testbuttons"; Rec."ShowTestButtons")
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    /*
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
    */

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    var
    //myInt: Integer;
}