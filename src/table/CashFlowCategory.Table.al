table 57203 "CashFlow Category"
{
    DataClassification = ToBeClassified;
    CaptionML = ENU = 'CashFlow Category', NLD = 'Kasstroomcategorie';
    LookupPageID = "CashFlow Category List";
    DrillDownPageID = "CashFlow Category List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code';
            NotBlank = true;
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', NLD = 'Omschrijving';
        }
        field(3; "CashFlow Category Type"; Option)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'CashFlow Category Type', NLD = 'Kasstroomcategoriesoort';
            OptionCaptionML = ENU = 'Posting,Heading,Total,Begin-Total,End-Total', NLD = 'Boeking,Koptekst,Totaal,Begintotaal,Eindtotaal';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
        }
        field(4; "Totaling"; Text[250])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Totaling', NLD = 'Samentelling';
            TableRelation = "CashFlow Category";
            ValidateTableRelation = false;
        }
        field(5; "Mutation"; Decimal)
        {
            CaptionML = ENU = 'Mutation', NLD = 'Mutatie';
            FieldClass = FlowField;
            CalcFormula = Sum("Realized Cash Flow"."Cash Flow Category Amount" WHERE("Cash Flow Category" = field(Code),
                                                        "Cash Flow Category" = FIELD(filter("Totaling")),
                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                        "Posting Date" = field("Date Filter")
                                                        ));

            Editable = false;
        }
        field(6; "Saldo"; Decimal)
        {
            CaptionML = ENU = 'Saldo', NLD = 'Saldo';
            FieldClass = FlowField;
            CalcFormula = Sum("Realized Cash Flow"."Cash Flow Category Amount" WHERE("Cash Flow Category" = field(Code)
                                                        , "Cash Flow Category" = FIELD(filter("Totaling"))
                                                        , "Global Dimension 1 Code" = field("Global Dimension 1 Filter")
                                                        , "Global Dimension 2 Code" = field("Global Dimension 2 Filter")
                                                        //, "Posting Date" = field(upperlimit("Date Filter"))
                                                        ));
            Editable = false;
        }
        field(7; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', NLD = 'Datumfilter';
        }
        field(8; "Global Dimension 1 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Global Dimension 1 Filter', NLD = 'Globale dimensiecode1 filter';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Global Dimension 2 Filter', NLD = 'Globale dimensiecode2 filter';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Indent"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Indent', NLD = 'Inspringen';
            MinValue = 0;
            MaxValue = 10;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Description", "CashFlow Category Type")
        {
        }
        fieldgroup(Brick; "Code", "Description", "CashFlow Category Type")
        {
        }
    }

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
