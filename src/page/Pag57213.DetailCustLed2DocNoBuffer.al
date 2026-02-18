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

                field(n; Rec.n)
                {
                    ToolTip = 'Specifies the value of the n field.', Comment = '%';
                }
                field("Is Init"; Rec."Is Init")
                {
                    ToolTip = 'Specifies the value of the Is Init field.', Comment = '%';
                }
                field("Init Entry No."; Rec."Init Entry No.")
                {
                    ToolTip = 'Specifies the value of the Init Entry No. field.', Comment = '%';
                }
                field("Init Cust. Ledger Entry No."; Rec."Init Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Init Cust. Ledger Entry No. field.', Comment = '%';
                }
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
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Cle_Entry No."; Rec."Cle_Entry No.")
                {
                    ToolTip = 'Specifies the value of the Cle Entry No. field.', Comment = '%';
                }
                field("Cle Document Type"; Rec."Cle_Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type Target field.', Comment = '%';
                }
                field("Cle_Document No."; Rec."Cle_Document No.")
                {
                    ToolTip = 'Specifies the value of the Document Type Target field.', Comment = '%';
                }
                field("Cle Posting Date"; Rec."Cle_Posting Date")
                {
                    ToolTip = 'Specifies the value of the Cle Posting Date field.', Comment = '%';
                }
                field("Cle Account No."; Rec."Cle_Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
                field("Cle Amount"; Rec."Cle_Amount")
                {
                    ToolTip = 'Specifies the value of the Target Amount field.', Comment = '%';
                }
                field(Cle_Dimension_Set_ID; Rec."Cle_Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
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