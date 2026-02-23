pageextension 57202 DetCusLedEntries extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
            {
                ToolTip = 'Specifies the value of the Applied Cust. Ledger Entry No. field.', Comment = '%';
            }
        }
        modify("Cust. Ledger Entry No.")
        {
            ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
            Visible = true;
        }

    }
    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}