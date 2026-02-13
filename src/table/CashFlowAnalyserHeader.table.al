table 57200 "Opt. Cashflow Analyser Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Cashflow Analyser Header';
    LookupPageId = "Opt. CashFlow Analyzer List";
    DrillDownPageId = "Opt. CashFlow Analyzer List";

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
        field(40; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
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
        CashFlowLines: record "Realized Cash Flow";
    begin
        CashFlowLines.SetRange("Cash Flow Entry No.", Rec."Entry No.");
        if CashFlowLines.FindLast() then
            CashFlowLines.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}