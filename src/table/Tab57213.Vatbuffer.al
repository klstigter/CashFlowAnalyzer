table 57213 Vatbuffer
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = AccountData;
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(6; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(7; "Amount"; Decimal)
        {
            DataClassification = AccountData;
        }
        field(8; "Transaction No."; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Type"; Option)
        {
            OptionMembers = Purchase,Sale,Settlement;
            DataClassification = AccountData;
        }
        field(10; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            TableRelation = "G/L Entry"."Entry No.";
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }


}