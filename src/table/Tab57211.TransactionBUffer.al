table 57211 "Transaction Buffer"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Gl_EntryNo_Bnk"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "GL_EntryNo Start"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "GL_EntryNo End"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Balance Amount"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Cashflow Amount"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Amount of Lines"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Description; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Journal Templ. Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Journal Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(20; "Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
        }
        field(21; "Source No."; Code[20])
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
        field(22; "Counter Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; RelatedFromEntryNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(31; RelatedToEntryNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(32; "GL Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Gl_EntryNo_Bnk")
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