page 57215 VatBufferPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Vatbuffer;
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Document Type"; Rec."Document Type") { }
                field("Document No."; Rec."Document No.") { }
                field("Amount"; Rec."Amount") { }
                field("Transaction No."; Rec."Transaction No.") { }
                field("Type"; Rec."Type") { }
                field(glentryno; Rec."G/L Entry No.") { }
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