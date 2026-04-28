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
                    Visible = ShowTestFields;
                }
                field("Last Entry No."; Rec."Last Entry No.")
                {
                    ToolTip = 'Specifies the value of the Last Entry No. field.', Comment = '%';
                    Visible = ShowTestFields;
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the total amount of the entries.', Comment = '%';
                }
                field("Amount of Records"; Rec."Amount of Records")
                {
                    ToolTip = 'Specifies the value of the Amount of Records field.', Comment = '%';
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
                    Visible = ShowTestFields;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the source number.';
                    Visible = ShowTestFields;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the source code.';
                    Visible = ShowTestFields;
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
                CaptionML = ENU = 'Collect postings', NLD = 'Verzamelen mutaties';
                RunObject = Codeunit CreateCashEntryPostingNoList;
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
            }

            action(runProcess)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Run process', NLD = 'Verwerken mutaties';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecSelection: Record "Cash Entry Posting No.";
                    ALL_t1, ALL_t2 : time;
                    t1, t2 : time;
                    duration: Duration;
                    log: Record "Log Cashflow Analyzer";
                    LblMsg: Label 'Aantal %1 records voor verwerking. Wilt u doorgaan?', comment = 'ENU=Selected %1 records for processing. Do you want to continue?,NLD=Er zijn %1 records geselecteerd voor verwerking. Wilt u doorgaan?';
                begin
                    CurrPage.SetSelectionFilter(RecSelection);
                    if RecSelection.Count <> 0 then begin
                        if not Confirm(StrSubstNo(LblMsg, RecSelection.Count), false) then
                            exit;
                        ALL_t1 := Time();
                        RecSelection.FindSet(); //set to top
                        repeat
                            //Rec := RecSelection;
                            //Rec.Find();

                            t1 := Time();
                            if cu.Fill_All_Buffer(RecSelection) then begin
                                t2 := Time();
                                duration := t2 - t1;
                                log.createLog(0, t1, t2, 'Duration Fetch all buffers');
                            end;

                            t1 := Time();
                            Cu.CreateAnalyze();
                            t2 := Time();
                            duration := t2 - t1;
                            log.createLog(0, t1, t2, 'Duration Create analyze lines');
                        until RecSelection.Next() = 0;
                        ALL_t2 := Time();
                        duration := ALL_t2 - ALL_t1;
                        Message('Proces verwerkt. \Duur: %1', duration);
                    end;
                end;
            }
            action(runFillbuffers)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Gegevens ophalen in ALLE buffers, ook GRIP', NLD = 'Gegevens ophalen in ALLE buffers, ook GRIP';
                Visible = ShowTestFields;

                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                begin
                    t1 := Time();
                    if cu.Fill_All_Buffer(Rec) then begin
                        t2 := Time();
                        duration := t2 - t1;
                        Message('Data is opgehaald en opgeslagen in buffers. \Duur: %1', duration);
                    end else
                        Message('Geen gegevens opgehaald voor het geselecteerde record.');

                end;
            }
            action(runCreateAnalyzeLines)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Stap 3: Aanmaken analyse regels (buffer moet eerst worden gevuld)', NLD = 'Stap 3: Analyse regels maken (buffer moet eerst worden gevuld)';
                Visible = ShowTestFields;


                trigger OnAction()
                var
                    t1, t2 : time;
                    duration: Duration;
                begin
                    t1 := Time();
                    Cu.CreateAnalyze();
                    t2 := Time();
                    duration := t2 - t1;
                    Message('Analyse regels succesvol aangemaakt. \Duur: %1', duration);
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
                CaptionML = ENU = 'Show Transaction Buffer', NLD = 'Toon transactiebuffer';
                Visible = ShowTestFields;

                trigger OnAction()
                var
                begin
                    Cu.ShowTransactionBufferPage();
                end;
            }
            action(showDetailedLedger)
            {

                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Show detailed ledger Buffer', NLD = 'Toon gedetailleerde grootboekbuffer';
                Visible = ShowTestFields;
                trigger OnAction()
                var
                begin
                    Cu.ShowDetailedLedgerPage();
                end;
            }

            action(AnalyzeListPage)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Analyze List', NLD = 'Kasstroomposten';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    cashFlowheader: Record "CashFlow Analyze Header";
                    cashflowAnalyzeList: Page "CashFlow Analyze List";
                begin
                    //Pass parameters to the page through global variables in codeunit, as the page is called from action on repeater which has source as temp table.
                    cashFlowheader.setrange("Posting Date", Rec."Posting Date");
                    cashFlowheader.setrange("Document No.", Rec."Document No.");
                    cashflowAnalyzeList.SetTableView(cashFlowheader);
                    cashflowAnalyzeList.Run();
                end;
            }
        }
    }
    var
        CU: Codeunit "CashflowAnalyzer Helper";
        ShowTestFields: Boolean;

    trigger OnOpenPage()
    var
        CashflowSetup: Record "Cashflow Analyzer Setup";
    begin
        if not CashflowSetup.get() then begin
            CashflowSetup.init;
            CashflowSetup.Insert();
        end;
        ShowTestFields := CashflowSetup.ShowTestButtons;

    end;
}