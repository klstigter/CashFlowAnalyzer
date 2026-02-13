page 57203 "Opt. CashFlow Analyzer Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Realized Cash Flow";
    Editable = false;
    Caption = 'CashFlow Analyzer Subform';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(EntryNo; Rec."Cash Flow Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                }
                field(EntryLineNo; Rec."Entry Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry Line No.';
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