table 57212 "DetailLedger2DocNo Buffer"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; n; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(4; "Cust. Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Is Init"; Boolean)
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
        field(13; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Cle_Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        Field(31; "Cle_Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        Field(32; "Cle_Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Cle_Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Cle_Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Cle_Document Type"; Enum "Gen. Journal Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Init Entry No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Init Cust. Ledger Entry No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(82; "Cle_Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "n")
        {
            Clustered = true;
        }
        key(Key2; "Cle_Document No.")
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