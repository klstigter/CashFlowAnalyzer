page 57211 "Cash Entry Postings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Entry Posting No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Last Entry No."; Rec."Last Entry No.")
                {
                    ToolTip = 'Specifies the value of the Last Entry No. field.', Comment = '%';
                }
                field("Amount of Records"; Rec."Amount of Records")
                {
                    ToolTip = 'Specifies the value of the Amount of Records field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date.';
                }

                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ToolTip = 'Specifies the value of the Journal Templ. Name field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the debit amount.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the credit amount.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the source type.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the source number.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the source code.';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Copy GRIP Invoice Data")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Get list of Posting no. from G/L Entry';
                RunObject = Codeunit CreateCashEntryPostingNoList;
            }
            action(runMyCodeunit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'run my codeunit';
                RunObject = Codeunit MyCodeunit;
            }
        }
    }
}