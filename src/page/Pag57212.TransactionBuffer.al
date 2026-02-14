page 57212 "Transaction Buffer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Transaction Buffer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Transaction No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the debit amount field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the credit amount field.', Comment = '%';
                }
                field("Balance Entry No. Start"; Rec."Balance Entry No. Start")
                {
                    ToolTip = 'Specifies the value of the Balance Entry No. Start field.', Comment = '%';
                }
                field("Balance Entry No. End"; Rec."Balance Entry No. End")
                {
                    ToolTip = 'Specifies the value of the Balance Entry No. End field.', Comment = '%';
                }
                field("Counter Posting"; Rec."Counter Posting")
                {
                    ToolTip = 'Specifies the value of the Counter Posting field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }

                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field.', Comment = '%';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
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