table 57204 "CashFlow Categories Setup"
{
    DataClassification = ToBeClassified;
    CaptionML = ENU = 'Cash Flow Category G/L Account', NLD = 'Kasstroomcategorie Grootboekrekening';
    LookupPageID = "Cash Flow Categories Setup";
    DrillDownPageID = "Cash Flow Categories Setup";

    fields
    {
        field(1; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'G/L Account No.', NLD = 'Grootboekrekeningnr.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CalcFields("G/L Account Name");
            end;
        }
        field(2; "G/L Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            CaptionML = ENU = 'G/L Account Name', NLD = 'Grootboekrekeningnaam';
            Editable = false;
        }
        field(3; "Cash Flow Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cash Flow Category', NLD = 'Kasstroomcategorie';
            TableRelation = "CashFlow_Category";
            NotBlank = true;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Start Date', NLD = 'Begindatum';
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'End Date', NLD = 'Einddatum';
        }
    }

    keys
    {
        key(Key1; "G/L Account No.", "Start Date")
        {
            Clustered = true;
        }
        key(Key2; "Cash Flow Category", "Start Date")
        {
        }
        key(Key3; "Start Date", "End Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "G/L Account No.", "G/L Account Name", "Cash Flow Category")
        {
        }
        fieldgroup(Brick; "G/L Account No.", "G/L Account Name", "Cash Flow Category", "Start Date")
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateDateRange();
    end;

    trigger OnModify()
    begin
        ValidateDateRange();
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure ValidateDateRange()
    begin
        TestField("Cash Flow Category");
        // Validate that Start Date is not later than End Date
        if ("Start Date" <> 0D) and ("End Date" <> 0D) then
            if "Start Date" > "End Date" then
                Error('Start Date cannot be later than End Date');
    end;
}
