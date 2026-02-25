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
                    CashLine: Record "Cashflow Analyse Line";
                    NoAppliedDocMsg: Label 'There isn''t applied document number available for this line.', comment = 'ENU=There isn''t applied document number available for this line.,NLD =Er is geen vereffend documentnummer beschikbaar voor deze regel.';
                begin

                    CurrPage.CashFlowAnalyzerSubform.Page.GetCurrRecordFromSub(CashLine);
                    if CashLine."Applied Document No." <> '' then begin
                        Navigate.SetDoc(CashLine."Applied Posting Date", CashLine."Applied Document No.");
                        Navigate.Run();
                    end else
                        Message(NoAppliedDocMsg);
                end;
            }

            action(ShowGlEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show G/L Entries';

                trigger OnAction()
                var
                    GLEntriesPage: page "General Ledger Entries";
                    GLEntry: Record "G/L Entry";
                begin

                    GLEntry.SetRange("Entry No.", Rec."Entry No.");
                    GLEntriesPage.SetTableView(GLEntry);
                    GLEntriesPage.Run();
                end;
            }

            action(ShowLedgers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Ledgers';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Ledger;


                trigger OnAction()
                var
                    CustLedgerEntries: page "Customer Ledger Entries";
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                    VendLedgerEntries: page "Vendor Ledger Entries";
                    VendLedgerEntry: Record "Vendor Ledger Entry";
                begin
                    case rec."Source Type" of
                        rec."Source Type"::Customer:
                            begin
                                CustLedgerEntry.SetRange("Customer No.", Rec."Source No.");
                                CustLedgerEntry.setrange("Posting Date", Rec."Posting Date");
                                CustLedgerEntry.setrange("Document No.", Rec."Document No.");
                                CustLedgerEntries.SetTableView(CustLedgerEntry);
                                CustLedgerEntries.Run();
                            end;
                        rec."Source Type"::Vendor:
                            begin
                                VendLedgerEntry.SetRange("Vendor No.", Rec."Source No.");
                                VendLedgerEntry.setrange("Posting Date", Rec."Posting Date");
                                VendLedgerEntry.setrange("Document No.", Rec."Document No.");
                                VendLedgerEntries.SetTableView(VendLedgerEntry);
                                VendLedgerEntries.Run();
                            end;

                    end;
                end;
            }

        }
    }

    var
        myInt: Integer;
}