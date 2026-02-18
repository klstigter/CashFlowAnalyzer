page 57206 "GRIP Invoice data"
{
    CaptionML = ENU = 'CashFlow Category GRIP Invoice', NLD = 'Kasstroomcategorie GRIP factuur';
    PageType = List;
    SourceTable = "GRIP Invoice Analyze Data";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Exploitation No."; Rec."Exploitation No.")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the exploitation number.', NLD = 'Specificeert het exploitantnummer.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the document type.', NLD = 'Specificeert het documenttype.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the document number.', NLD = 'Specificeert het documentnummer.';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the G/L account.', NLD = 'Specificeert de G/L-rekening.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the amount.', NLD = 'Specificeert het bedrag.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the global dimension 1 code.', NLD = 'Specificeert de globale dimensie 1-code.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the global dimension 2 code.', NLD = 'Specificeert de globale dimensie 2-code.';
                }

                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies when the record was created.', NLD = 'Specificeert wanneer het record is aangemaakt.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies who created the record.', NLD = 'Specificeert wie het record heeft aangemaakt.';
                }
            }
        }
    }
}
