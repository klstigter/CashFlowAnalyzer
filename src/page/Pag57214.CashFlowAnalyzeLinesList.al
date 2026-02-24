page 57214 "CashFlowAnalyzeLines List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cashflow Analyse Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Entry Line No."; Rec."Entry Line No.")
                {
                    ToolTip = 'Specifies the value of the Entry Line No. field.', Comment = '%';
                }
                field("Place of Birth"; Rec."Place of Birth")
                {
                    ToolTip = 'Specifies the value of the Place of Birth field.', Comment = '%';
                }
                field("Applied Document Entry No."; Rec."Applied Document Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document Entry No. field.', Comment = '%';
                }
                field("Applied Posting Date"; Rec."Applied Posting Date")
                {
                    ToolTip = 'Specifies the value of the Applied Posting Date field.', Comment = '%';
                }
                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document No. field.', Comment = '%';
                }
                field("Applied Document Type"; Rec."Applied Document Type")
                {
                    ToolTip = 'Specifies the value of the Applied Document Type field.', Comment = '%';
                }
                field("Cash Flow Category"; Rec."Cash Flow Category")
                {
                    ToolTip = 'Specifies the value of the Cash Flow Category field.', Comment = '%';
                }
                field("Cash Flow Category Amount"; Rec."Cash Flow Category Amount")
                {
                    ToolTip = 'Specifies the value of the Cash Flow Category Amount field.', Comment = '%';
                }
                field("Amount to Analyze"; Rec."Amount to Analyze")
                {
                    ToolTip = 'Specifies the value of the Amount to Analyze field.', Comment = '%';
                }
                field("Cash Flow Category Desc."; Rec."Cash Flow Category Desc.")
                {
                    ToolTip = 'Specifies the value of the Cash Flow Category Desc. field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                }
                field("Error message unbalance"; Rec."Error message unbalance")
                {
                    ToolTip = 'Specifies the value of the Error message unbalance field.', Comment = '%';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                }
                field("G/L Account Description"; Rec."G/L Account Description")
                {
                    ToolTip = 'Specifies the value of the G/L Account Description field.', Comment = '%';
                }
                field("Is Grip"; Rec."Is Grip")
                {
                    ToolTip = 'Specifies the value of the Is Grip field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Realized Type"; Rec."Realized Type")
                {
                    ToolTip = 'Specifies the value of the Realized Type field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
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