page 57214 "CashFlowAnalyzeLines List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cashflow Analyse Line";
    CaptionML = ENU = 'Cash Flow Analysis Lines', NLD = 'Gedetailleerde Kasstroomposten';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Entry Line No."; Rec."Entry Line No.")
                {
                    ToolTip = 'Specifies the value of the Entry Line No. field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Applied Document Entry No."; Rec."Applied Document Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document Entry No. field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Applied Posting Date"; Rec."Applied Posting Date")
                {
                    ToolTip = 'Specifies the value of the Applied Posting Date field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document No. field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Applied Document Type"; Rec."Applied Document Type")
                {
                    ToolTip = 'Specifies the value of the Applied Document Type field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Cash Flow Category"; Rec."Cash Flow Category")
                {
                    ToolTip = 'Specifies the value of the Cash Flow Category field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Cash Flow Category Amount"; Rec."Cash Flow Category Amount")
                {
                    ToolTip = 'Specifies the value of the Cash Flow Category Amount field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Amount to Analyze"; Rec."Amount to Analyze")
                {
                    ToolTip = 'Specifies the value of the Amount to Analyze field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Is Non Deductable VAT"; Rec."Is Non Deductable VAT")
                {
                    ToolTip = 'Specifies the value of the Is Non Deductable VAT field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Cash Flow Category Desc."; Rec."Cash Flow Category Desc.")
                {
                    ToolTip = 'Specifies the value of the Cash Flow Category Desc. field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Error message unbalance"; Rec."Error message unbalance")
                {
                    ToolTip = 'Specifies the value of the Error message unbalance field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("G/L Account Description"; Rec."G/L Account Description")
                {
                    ToolTip = 'Specifies the value of the G/L Account Description field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ToolTip = 'Specifies the value of the Journal Templ. Name field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.', Comment = '%';
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code field.', Comment = '%';
                    StyleExpr = rec."Is Non Deductable VAT";
                    Style = AttentionAccent;
                }


            }
        }
        area(Factboxes)
        {

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
            action("Find Applied Document Entries")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Find Applied Document Entries', NLD = 'Posten zoeken met vereffend document';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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