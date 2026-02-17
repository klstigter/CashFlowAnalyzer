table 57212 "DetailLedger2DocNo Buffer"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Vendor Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Cust. Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Applied Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Entry Type"; Enum "Detailed CV Ledger Entry Type")
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Document No. Bnk"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Posting Date Bnk"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Entry No. Target"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        Field(31; "Document No. Target"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        Field(32; "Posting Date Target"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Target Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Document Type Target"; Enum "Gen. Journal Document Type")
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
        key(Key2; "Document No. Target")
        {
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