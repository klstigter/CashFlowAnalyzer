page 57210 CashAnalyzerFactBox
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Cashflow Analyse Line";

    layout
    {
        area(Content)
        {
            repeater(AnalyzeResult)
            {
                field(Name; rec."Cash Flow Category")
                {
                    ApplicationArea = All;
                }
                field(Amount; rec."Cash Flow Category Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount to Analyze"; Rec."Amount to Analyze")
                {
                    ApplicationArea = All;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Find Applied Document Entries")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Find Applied Document Entries', NLD = 'Posten zoeken met vereffend document';
                Image = Navigate;

                ToolTipML = ENU = 'Find related entries for the applied document number.', NLD = 'Zoek gerelateerde posten voor het vereffende documentnummer.';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                    GLEntry: record "G/L Entry";
                    NoAppliedDocMsg: Label 'There isn''t applied document number available for this line.', comment = 'ENU=There isn''t applied document number available for this line.,NLD =Er is geen vereffend documentnummer beschikbaar voor deze regel.';
                begin
                    if Rec."Applied Document No." <> '' then begin
                        if GLEntry.Get(Rec."Applied Document Entry No.") then
                            Navigate.SetDoc(GLEntry."Posting Date", Rec."Applied Document No.")
                        else
                            Navigate.SetDoc(0D, Rec."Applied Document No.");
                        Navigate.Run();
                    end else
                        Message(NoAppliedDocMsg);
                end;
            }
        }
    }
}