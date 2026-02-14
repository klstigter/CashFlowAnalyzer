table 57200 "G/L Entry Cash to Analyze"
{
    DataClassification = ToBeClassified;
    Caption = 'G/L Entry Cash to Analyze';
    LookupPageId = "G/L Entry Cash to Analyze List";
    DrillDownPageId = "G/L Entry Cash to Analyze List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Balance Entry No. Start"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Balance Entry No. End"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(10; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(40; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Source Type"; enum "Cash_Flow Source Type")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Type', NLD = 'Bronsoort';
        }

        field(51; "Source Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Entry No.', NLD = 'Bron volgnummer';
        }
        field(52; "Journal Templ. Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Gen. Journal Template', NLD = 'Financieel dagboeksjabloon';
            TableRelation = "Gen. Journal Template";
        }
        field(53; "Journal Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Journal Batch', NLD = 'Dagboekbatch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ. Name"));
        }
        field(54; "Transaction No. Start"; integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Is Analyzed', NLD = 'Geanalyseerd';
        }
        field(55; "Transaction No. End"; integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Is Analyzed', NLD = 'Geanalyseerd';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        CashFlowLines: record "Cashflow Analyse Result";
    begin
        CashFlowLines.SetRange("G/L Entry No.", Rec."Entry No.");
        if CashFlowLines.FindLast() then
            CashFlowLines.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}