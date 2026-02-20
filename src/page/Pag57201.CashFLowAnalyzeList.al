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
                field("Cashflow to Analyze"; Rec."Cashflow to Analyze")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount to analyze.';
                }
                field("Cashflow Amount"; Rec."Cashflow Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cash flow amount.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount.';
                }
                field("Processed Amount"; Rec."Processed Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the processed amount for cash flow analysis.';
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
            action(ShowDetailedLedgers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Detailed Ledgers';

                trigger OnAction()
                var
                    DetCustLedgEntries: page "Detailed Cust. Ledg. Entries";
                    DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                begin

                    DetCustLedgEntry.SetRange("Customer No.", Rec."Source No.");
                    DetCustLedgEntries.SetTableView(DetCustLedgEntry);
                    DetCustLedgEntries.Run();
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
        }
        area(Processing)
        {
            group("Create Cash Flow Entries")
            {
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
                action(ShowDetailedLedgerPage)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Detailed Ledger Page';

                    trigger OnAction()
                    begin
                        cu.ShowDetailedLedgerPage();
                    end;
                }
                action(ShowTransactionBUfferPage)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Transaction Buffer Page';

                    trigger OnAction()
                    begin
                        cu.ShowTransactionBufferPage();
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
            }
        }
    }
    var
        CU: Codeunit MyCodeunit;
}