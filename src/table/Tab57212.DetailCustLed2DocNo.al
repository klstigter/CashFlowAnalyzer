table 57212 "DetailCustLed2DocNo Buffer"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Det. Cust. Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Cust. Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Applied Cust. Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Entry Type"; Enum "Detailed CV Ledger Entry Type")
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Transaction No."; Integer)
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
    begin

    end;

    trigger OnRename()
    begin

    end;

}