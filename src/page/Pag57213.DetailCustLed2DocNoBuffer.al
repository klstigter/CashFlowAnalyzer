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
                field("Init Ledger Entry No."; Rec."Init Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Init Cust. Ledger Entry No. field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Ledger Entry No."; Rec."Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Ledger Entry No. field.', Comment = '%';
                }

                field("Applied Ledger Entry No."; Rec."Applied Ledger Entry No.")
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
                field("Led_Entry No."; Rec."led_Entry No.")
                {
                    ToolTip = 'Specifies the value of the Led Entry No. field.', Comment = '%';
                }
                field("Led Document Type"; Rec."led_Document Type")
                {
                    ToolTip = 'Specifies the value of the Led Document Type field.', Comment = '%';
                }
                field("Led Document No."; Rec."led_Document No.")
                {
                    ToolTip = 'Specifies the value of the Led Document No. field.', Comment = '%';
                }
                field("Led Posting Date"; Rec."led_Posting Date")
                {
                    ToolTip = 'Specifies the value of the Led Posting Date field.', Comment = '%';
                }
                field("Led Account No."; Rec."led_Account No.")
                {
                    ToolTip = 'Specifies the value of the Led Account No. field.', Comment = '%';
                }
                field("Led Amount"; Rec."led_Amount")
                {
                    ToolTip = 'Specifies the value of the Led Amount field.', Comment = '%';
                }
                field(Cle_Dimension_Set_ID; Rec."led_Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                }
                field("Query Nr."; Rec."Query Nr.")
                {
                    ToolTip = 'Specifies the value of the Query Nr. field.', Comment = '%';
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