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

        field(4; "Ledger Entry No."; Integer)
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
        field(30; "led_Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        Field(31; "led_Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        Field(32; "led_Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "led_Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "led_Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "led_Document Type"; Enum "Gen. Journal Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Init Entry No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Init Ledger Entry No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(82; "led_Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(90; "Birth place"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        Field(91; "Query Nr."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        Field(92; "Is Dummy Record"; Boolean)
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
        key(Key2; "led_Document No.")
        {
        }
    }

}