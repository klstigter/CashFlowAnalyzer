table 57200 "CashFLow Analyze Header"
{
    DataClassification = ToBeClassified;
    Caption = 'CashFlow Analyze Header';
    LookupPageId = "cashflow analyze List";
    DrillDownPageId = "cashflow analyze List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Entry No.', NLD = 'Volgnummer';
        }
        field(2; "Balance Entry No. Start"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Balance Entry No. Start', NLD = 'Beginnend balansvolgnummer';
        }
        field(3; "Balance Entry No. End"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Balance Entry No. End', NLD = 'Eindigend balansvolgnummer';
        }

        field(10; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting Date', NLD = 'Boekingsdatum';
        }
        field(20; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', NLD = 'Documentnr.';
        }
        field(30; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', NLD = 'Omschrijving';
        }
        field(31; "Source Type"; Enum "Gen. Journal Source Type")
        {
            CaptionML = ENU = 'Source Type', NLD = 'Bronsoort';
        }
        field(32; "Source No."; Code[20])
        {
            CaptionML = ENU = 'Source No.', NLD = 'Bronnr.';
            TableRelation = if ("Source Type" = const(Customer)) Customer
            else
            if ("Source Type" = const(Vendor)) Vendor
            else
            if ("Source Type" = const("Bank Account")) "Bank Account"
            else
            if ("Source Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Source Type" = const(Employee)) Employee;
        }
        field(40; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            captionML = ENU = 'Amount', NLD = 'Bedrag';
        }
        field(50; "Analyse Type"; enum "Analyse Type")
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
            CaptionML = ENU = 'Transaction No. Start', NLD = 'Transactienummer start';
        }
        field(55; "Transaction No. End"; integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transaction No. End', NLD = 'Transactienummer einde';
        }
        field(60; "Cashflow Category Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Cashflow Analyse Line"."Cash Flow Category Amount" where("G/L Entry No." = field("Entry No.")));
            captionML = ENU = 'Cashflow Category Amount', NLD = 'Bedrag kasstroomcategorie';
        }
        field(61; "Cashflow to Analyze"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Cashflow Analyse Line"."Amount to Analyze" where("G/L Entry No." = field("Entry No.")));
            captionML = ENU = 'Amount to Analyze', NLD = 'Bedrag te analyseren';
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
        CashFlowLines: record "Cashflow Analyse Line";
    begin
        CashFlowLines.SetRange("G/L Entry No.", Rec."Entry No.");
        if CashFlowLines.FindLast() then
            CashFlowLines.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}