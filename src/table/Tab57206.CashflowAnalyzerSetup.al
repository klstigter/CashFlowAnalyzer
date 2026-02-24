table 57206 "Cashflow Analyzer Setup"
{
    DataClassification = ToBeClassified;
    CaptionML = ENU = 'Cash Flow Analyzer Setup', NLD = 'Kasstroomanalyse instellingen';
    Description = 'Task 2241';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "VAT Settlement G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            CaptionML = ENU = 'VAT Settlement G/L Account No.', NLD = 'BTW-vereffeningsrekening nr.';
        }
        field(11; ShowTestButtons; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Show Testbuttons', NLD = 'Toon testknoppen';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
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
    begin

    end;

    trigger OnRename()
    begin

    end;

}