page 57213 "DetailedLedger2DocNo Buffer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "DetailLedger2DocNo Buffer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
                }

                field("Applied Cust. Ledger Entry No."; Rec."Applied Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Cust. Ledger Entry No. field.', Comment = '%';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
                }

                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No. Bnk")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date Bnk")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Entry No. Target"; Rec."Entry No. Target")
                {
                    ToolTip = 'Specifies the value of the Entry No. Target field.', Comment = '%';
                }
                field("Document No. Target"; Rec."Document No. Target")
                {
                    ToolTip = 'Specifies the value of the Document No. Target field.', Comment = '%';
                }
                field("Posting Date Target"; Rec."Posting Date Target")
                {
                    ToolTip = 'Specifies the value of the Posting Date Target field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
                field("Target Amount"; Rec."Target Amount")
                {
                    ToolTip = 'Specifies the value of the Target Amount field.', Comment = '%';
                }
                field("Document Type Target"; Rec."Document Type Target")
                {
                    ToolTip = 'Specifies the value of the Document Type Target field.', Comment = '%';

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
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}