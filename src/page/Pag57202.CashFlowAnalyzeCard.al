page 57202 "CashFlow Analyze Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CashFLow Analyze Header";
    Caption = 'CashFlow Analyzer';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                }
                group(Amounts)
                {
                    Caption = 'Cash Flow Analysis';
                    ShowCaption = false;
                    field(Amount; Rec.Amount)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the amount.';
                    }

                    field("Cashflow CategoryAmount"; Rec."Cashflow Category Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the cash flow amount.';
                    }
                    field("Cashflow to Analyze"; Rec."Cashflow to Analyze")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the amount to analyze.';
                    }

                }
                field("Analyse Type"; Rec."Analyse Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the analysis type.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source type.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source number.';
                }
            }
            part(CashFlowAnalyzerSubform; "Opt. CashFlow Analyzer Subform")
            {
                ApplicationArea = All;
                SubPageLink = "G/L Entry No." = FIELD("Entry No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Find Entries")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Find Entries', NLD = 'Posten zoeken';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTipML = ENU = 'Find related entries for the selected document number.', NLD = 'Zoek gerelateerde posten voor het geselecteerde documentnummer.';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }

        }
    }

    var
        myInt: Integer;
}