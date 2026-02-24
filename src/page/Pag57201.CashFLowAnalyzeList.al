page 57201 "CashFLow Analyze List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "CashFlow Analyze Card";
    SourceTable = "CashFLow Analyze Header";
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
                field("Cashflow Category Amount"; Rec."Cashflow Category Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cash flow amount.';
                    Visible = true;
                }
                field("Cashflow to Analyze"; Rec."Cashflow to Analyze")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount to analyze.';
                    Visible = true;
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
            action(ShowDetailedLedgers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Detailed Ledgers';

                trigger OnAction()
                var
                    DetCustLedgEntries: page "Detailed Cust. Ledg. Entries";
                    DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    DetVendLedgEntries: page "Detailed Vendor Ledg. Entries";
                    DetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    case rec."Source Type" of
                        rec."Source Type"::Customer:
                            begin
                                DetCustLedgEntry.SetRange("Customer No.", Rec."Source No.");
                                DetCustLedgEntries.SetTableView(DetCustLedgEntry);
                                DetCustLedgEntries.Run();
                            end;
                        rec."Source Type"::Vendor:
                            begin
                                DetVendLedgEntry.SetRange("Vendor No.", Rec."Source No.");
                                DetVendLedgEntries.SetTableView(DetVendLedgEntry);
                                DetVendLedgEntries.Run();
                            end;

                    end;
                end;
            }
            action(ShowLedgers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Ledgers';

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
                                CustLedgerEntries.SetTableView(CustLedgerEntry);
                                CustLedgerEntries.Run();
                            end;
                        rec."Source Type"::Vendor:
                            begin
                                VendLedgerEntry.SetRange("Vendor No.", Rec."Source No.");
                                VendLedgerEntries.SetTableView(VendLedgerEntry);
                                VendLedgerEntries.Run();
                            end;

                    end;
                end;
            }
        }
        area(Processing)
        {


            action(ShowTransactionBUfferPage)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Transaction Buffer Page';

                trigger OnAction()
                begin
                    cu.ShowTransactionBufferPage();
                end;
            }
            action(ShowDetailedLedgerPage)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Detailed Ledger Page';

                trigger OnAction()
                begin
                    cu.ShowDetailedLedgerPage();
                end;
            }

            action(FillDetailelLedgerBuffer)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fill Buffers without gripBuffer';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                    CashEntryPostingNo: Record "Cash Entry Posting No.";

                begin
                    t1 := Time();
                    CashEntryPostingNo.setrange("Posting Date", Rec."Posting Date");
                    CashEntryPostingNo.setrange("Document No.", Rec."Document No.");
                    CashEntryPostingNo.FindFirst();
                    if cu.Fill_NOT_GripBuffer(CashEntryPostingNo) then begin
                        t2 := Time();
                        duration := t2 - t1;
                        Message('Data fetched successfully in all buffers. \Time taken: %1', duration);
                    end else
                        Message('No data fetched for the selected record.');
                end;
            }
            action(runMyCodeunit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Step 2: Fetch all data in all buffers';

                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                    CashEntryPostingNo: Record "Cash Entry Posting No.";

                begin
                    t1 := Time();
                    CashEntryPostingNo.setrange("Posting Date", Rec."Posting Date");
                    CashEntryPostingNo.setrange("Document No.", Rec."Document No.");
                    CashEntryPostingNo.FindFirst();
                    if cu.Run(CashEntryPostingNo) then begin
                        t2 := Time();
                        duration := t2 - t1;
                        Message('Data fetched successfully in all buffers. \Time taken: %1', duration);
                    end else
                        Message('No data fetched for the selected record.');

                end;
            }
            action(runCreateAnalyzeLines)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Step 3: Create Analyze Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                begin
                    t1 := Time();
                    Cu.CreateAnalyze(rec);
                    t2 := Time();
                    duration := t2 - t1;
                    Message('Analyze lines created successfully. \Time taken: %1', duration);
                end;
            }
            action(ShowFilterStrings)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Filter Strings';

                trigger OnAction()
                begin
                    cu.ShowPageFilterStrings();
                end;
            }
        }
    }
    var
        CU: Codeunit MyCodeunit;
}