page 57204 "Opt. Create Cash Flow Dialog"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    CaptionML = ENU = 'Create Cash Flow Entries', NLD = 'Kasstroomposten aanmaken per documentnummer';

    layout
    {
        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', NLD = 'Algemeen';

                field("Gen. Journal Template"; GenJournalTemplate)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Gen. Journal Template', NLD = 'Financieel Dagboeksjabloon';
                    TableRelation = "Gen. Journal Template";
                    ToolTipML = NLD = 'Selecteer het financiële dagboeksjabloon voor het aanmaken van kasstroomposten.', ENU = 'Select the general journal template for creating cash flow entries.';

                    trigger OnValidate()
                    begin
                        JournalBatch := '';
                        CurrPage.Update();
                    end;
                }

                field("Journal Batch"; JournalBatch)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Journal Batch', NLD = 'Dagboekbatch';
                    ToolTipML = NLD = 'Selecteer de dagboekbatch voor het aanmaken van kasstroomposten.', ENU = 'Select the journal batch for creating cash flow entries.';

                    trigger OnAssistEdit()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        if GenJournalTemplate <> '' then begin
                            GenJournalBatch.SetRange("Journal Template Name", GenJournalTemplate);
                            if PAGE.RunModal(PAGE::"General Journal Batches", GenJournalBatch) = ACTION::LookupOK then begin
                                JournalBatch := GenJournalBatch.Name;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Get(GenJournalTemplate, JournalBatch);
                    end;
                }

                field("Document No."; DocumentNoFilter)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Document No.', NLD = 'Documentnr.';
                    ToolTipML = NLD = 'Voer het documentnummer in voor het aanmaken van kasstroomposten.', ENU = 'Enter the document number for creating cash flow entries.';
                }

                field("bank transaction nr."; bankEntryNoFilter)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Bank Ledger Entry No.', NLD = 'Bankvolgnummer';
                    ToolTipML = ENU = '', NLD = '';
                }
            }
        }
    }

    var
        GenJournalTemplate: Code[10];
        JournalBatch: Code[10];
        DocumentNoFilter: text;
        bankEntryNoFilter: Integer;

    procedure GetValues(var Template: Code[10]; var Batch: Code[10]; var DocNoFilter: Text; var bankEntryFltr: Integer)
    begin
        Template := GenJournalTemplate;
        Batch := JournalBatch;
        DocNoFilter := DocumentNoFilter;
        bankEntryFltr := bankEntryNoFilter;
    end;

    procedure SetValues(Template: Code[10]; Batch: Code[10]; DocNoFilter: Code[20]; bankEntryFltr: Integer)
    begin
        GenJournalTemplate := Template;
        JournalBatch := Batch;
        DocumentNoFilter := DocNoFilter;
        bankEntryNoFilter := bankEntryFltr;
    end;
}
