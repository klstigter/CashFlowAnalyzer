page 57211 "Cash Entry Postings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Entry Posting No.";
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
                field("Last Entry No."; Rec."Last Entry No.")
                {
                    ToolTip = 'Specifies the value of the Last Entry No. field.', Comment = '%';
                }
                field("Amount of Records"; Rec."Amount of Records")
                {
                    ToolTip = 'Specifies the value of the Amount of Records field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date.';
                }

                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ToolTip = 'Specifies the value of the Journal Templ. Name field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Cash Flow Category Amount"; Rec."Cash Flow Category Amount")
                {
                    ToolTip = 'Specifies the credit amount.';
                }
                field("Amount to Analyze"; Rec."Amount to Analyze")
                {
                    ToolTip = 'Specifies the debit amount.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the source type.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the source number.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the source code.';
                }

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
            action("Copy GRIP Invoice Data")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Step 1: Get list from G/L Entry';
                RunObject = Codeunit CreateCashEntryPostingNoList;
            }
            action(runFilbuffers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Step 2: Fetch data in ALL buffers, also GRIP';

                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                begin
                    t1 := Time();
                    if cu.Fill_All_Buffer(Rec) then begin
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
                Caption = 'Step 3: Create Analyze Lines (buffer must be filled first)';


                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                begin
                    t1 := Time();
                    Cu.CreateAnalyze();
                    t2 := Time();
                    duration := t2 - t1;
                    Message('Analyze lines created successfully. \Time taken: %1', duration);
                end;
            }
            action(runProcess)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Run process';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                    log: Record "Log Cashflow Analyzer";
                begin
                    t1 := Time();
                    if cu.Fill_All_Buffer(Rec) then begin
                        t2 := Time();
                        duration := t2 - t1;
                        log.createLog(0, t1, t2, 'Duration Fetch all buffers');
                    end;

                    t1 := Time();
                    Cu.CreateAnalyze();
                    t2 := Time();
                    duration := t2 - t1;
                    log.createLog(0, t1, t2, 'Duration Create analyze lines');

                    Message('Process is completely done. \Time taken: %1', duration);
                end;
            }

        }
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


            action(ShowtransactionBUfferPage)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Transaction Buffer';
                trigger OnAction()
                var
                begin
                    Cu.ShowTransactionBufferPage();
                end;
            }
            action(showDetailedLedger)
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Show detailed ledger Buffer';
                trigger OnAction()
                var
                begin
                    Cu.ShowDetailedLedgerPage();
                end;
            }

            action(AnalyzeListPage)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Analyze List';
                trigger OnAction()
                var
                    cashFlowheader: Record "CashFlow Analyze Header";
                    cashflowAnalyzeList: Page "CashFlow Analyze List";
                begin
                    //Pass parameters to the page through global variables in codeunit, as the page is called from action on repeater which has source as temp table.
                    cashFlowheader.setrange("Document No.", Rec."Document No.");
                    cashflowAnalyzeList.SetTableView(cashFlowheader);
                    cashflowAnalyzeList.Run();
                end;
            }
        }
    }
    var
        CU: Codeunit MyCodeunit;

}