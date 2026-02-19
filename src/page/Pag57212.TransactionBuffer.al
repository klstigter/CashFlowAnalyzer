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
                field("Gl Entry No. Bank"; Rec."Gl_EntryNo_Bnk")
                {
                    ToolTip = 'Specifies the value of the Gl Entry No. Bank field.', Comment = '%';
                }
                field(amount; Rec.amount)
                {
                    ToolTip = 'Specifies the value of the amount field.', Comment = '%';
                }
                field("Amount of Lines"; Rec."Amount of Lines")
                {
                    ToolTip = 'Specifies the value of the Amount of Lines field.', Comment = '%';
                }
                field("GL Entry No. End"; Rec."GL_EntryNo End")
                {
                    ToolTip = 'Specifies the value of the GL Entry No. End field.', Comment = '%';
                }
                field("GL Entry No. Start"; Rec."GL_EntryNo Start")
                {
                    ToolTip = 'Specifies the value of the GL Entry No. Start field.', Comment = '%';
                }
                field("Counter Posting"; Rec."Counter Posting")
                {
                    ToolTip = 'Specifies the value of the Counter Posting field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Cashflow Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Balance Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ToolTip = 'Specifies the value of the Journal Templ. Name field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(RelatedFromEntryNo; Rec.RelatedFromEntryNo)
                {
                    ToolTip = 'Specifies the value of the RelatedFromEntryNo field.', Comment = '%';
                }
                field(RelatedToEntryNo; Rec.RelatedToEntryNo)
                {
                    ToolTip = 'Specifies the value of the RelatedToEntryNo field.', Comment = '%';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field.', Comment = '%';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                }
                field("GL Account No."; Rec."GL Account No.")
                {
                    ToolTip = 'Specifies the value of the GL Account No. field.', Comment = '%';
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