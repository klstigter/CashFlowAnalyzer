page 57201 "G/L Entry Cash to Analyze List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "G/L Entry CashFlow Card";
    SourceTable = "G/L Entry Cash to Analyze";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Transaction No. Start"; Rec."Transaction No. Start")
                {
                    ApplicationArea = All;
                }
                field("Transaction No. End"; Rec."Transaction No. End")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end transaction number.';
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount.';
                }
            }
        }
        area(Factboxes)
        {
            part(CashAnalyzerFactBox; "CashAnalyzerFactBox")
            {
                ApplicationArea = All;
                SubPageLink = "G/L Entry No." = field("Entry No.");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            group("Create Cash Flow Entries")
            {
                CaptionML = ENU = 'Create Cash Flow Entries', NLD = 'Kasstroomposten Aanmaken';
                action("Per Template and Documents")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Create Per Template and Documents', NLD = 'Aanmaken per documentnummer';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTipML = NLD = 'Maak nieuwe kasstroomposten aan voor het geselecteerde dagboeksjabloon, batch en documentnummer.', ENU = 'Create new cash flow entries for selected journal template, batch and document number.';

                    trigger OnAction()
                    var
                        CreateCashFlowDialog: Page "Opt. Create Cash Flow Dialog";
                        RealizedCashflowMgt: Codeunit "Opt. Realized Cashflow Mgt.";
                        GenJournalTemplate: Code[10];
                        JournalBatch: Code[10];
                        DocumentNoFilter: Text;
                        Lbl: Label 'Please fill in all required fields.', Comment = 'NLD=Vul alle verplichte velden in.;ENU=Please fill in all required fields.';
                        bankEntryNoFilter: Integer;
                    begin
                        GenJournalTemplate := 'BNG152';
                        JournalBatch := 'DEFAULT';
                        DocumentNoFilter := 'BNG152-10081';
                        bankEntryNoFilter := 1440904;
                        CreateCashFlowDialog.SetValues(GenJournalTemplate, JournalBatch, DocumentNoFilter, bankEntryNoFilter);
                        if CreateCashFlowDialog.RunModal() = Action::OK then begin
                            CreateCashFlowDialog.GetValues(GenJournalTemplate, JournalBatch, DocumentNoFilter, bankEntryNoFilter);
                            if (GenJournalTemplate <> '') and (JournalBatch <> '') and (DocumentNoFilter <> '') then begin
                                RealizedCashflowMgt.CreateCashFlowAnalyzeEntries(GenJournalTemplate, JournalBatch, DocumentNoFilter, bankEntryNoFilter);
                            end else
                                Message(lbl);
                        end;
                    end;
                }

                action("Per Date Range")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Create Per Date Range', NLD = 'Aanmaken per datum';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTipML = NLD = 'Maak nieuwe kasstroomposten aan op basis van datumfilter.', ENU = 'Create new cash flow entries based on date filter.';
                    RunObject = report "Opt. Cash Flow Entries Calc.";
                }
            }
            group(Development_Tools)
            {
                Caption = 'Development Tools - Will be deleted';
                action("DeleteAllEntries")
                {
                    ApplicationArea = All;
                    Caption = 'Delete All Entries';
                    Image = DeleteRow;

                    trigger OnAction()
                    var
                        Cashflowheader: record "G/L Entry Cash to Analyze";
                        ConfirmLbl: Label 'This will delete ALL Cash Flow Analyzer Header entries. Do you want to continue?', Comment = 'NLD=Dit zal ALLE kasstroomanalysator-kopteksten verwijderen. Wilt u doorgaan?;ENU=This will delete ALL Cash Flow Analyzer Header entries. Do you want to continue?';
                    begin
                        if not confirm(ConfirmLbl, false) then
                            exit;
                        Cashflowheader.Reset();
                        Cashflowheader.DeleteAll(true);
                    end;
                }
            }
        }
    }
}