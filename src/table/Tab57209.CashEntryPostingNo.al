table 57209 "Cash Entry Posting No."
{
    DataClassification = ToBeClassified;
    Caption = 'Cashflow Entry to Analys';
    //LookupPageId = "G/L Entry Cash to Analyze List";
    //DrillDownPageId = "G/L Entry Cash to Analyze List";

    fields
    {
        field(1; "Entry No."; Integer)
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
        field(40; "Debit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Credit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Journal Templ. Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Gen. Journal Template', NLD = 'Financieel dagboeksjabloon';
            TableRelation = "Gen. Journal Template";
        }
        field(60; "Journal Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Journal Batch', NLD = 'Dagboekbatch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ. Name"));
        }

        field(80; "Last Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Entry No.', NLD = 'Laatste volgnummer';
        }
        field(90; "Amount of Records"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount of Records', NLD = 'Aantal records';
        }
        field(100; "Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
        }
        field(101; "Source No."; Code[20])
        {
            Caption = 'Source No.';
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
        field(102; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
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
        CashFlowLines.SetRange("g/l Entry No.", Rec."Entry No.");
        if CashFlowLines.FindLast() then
            CashFlowLines.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}