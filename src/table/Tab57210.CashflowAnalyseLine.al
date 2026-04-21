table 57210 "Cashflow Analyse Line"
{
    DataClassification = ToBeClassified;
    CaptionML = ENU = 'Realized Cash Flow', NLD = 'Gerealiseerde kasstroom';
    LookupPageId = "CashFlowAnalyzeLines List";
    DrillDownPageId = "CashFlowAnalyzeLines List";

    fields
    {
        field(1; "G/L Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'G/L Entry No.', NLD = 'Volgnummer grootboekpost';
        }
        field(2; "Entry Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Entry Line No.', NLD = 'Volgnummer kasstroompost';
        }
        field(3; "Is Grip"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Is Grip', NLD = 'Is Grip';
        }
        field(6; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', NLD = 'Vereffend documentnr.';
        }
        field(7; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting Date', NLD = 'Boekingsdatum';
        }
        field(9; "Applied Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applied Posting Date', NLD = 'Vereffende boekingsdatum';
        }
        field(10; "Applied Document Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applied Document Entry No.', NLD = 'Volgnummer vereffend document';
        }
        field(11; "Applied Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applied Document Type', NLD = 'Vereffend documentsoort';
            //OptionCaption = 'Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Bank,GLEntry';
            OptionCaptionML = ENU = 'Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Bank,GLEntry', NLD = 'Betaling,Factuur,Creditnota,Rentebericht,Herinnering,Terugbetaling,Bank,Grootboekpost';
            OptionMembers = Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Bank,GLEntry;
        }
        field(12; "Applied Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applied Document No.', NLD = 'Vereffend documentnr.';
        }
        field(13; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'G/L Account', NLD = 'Grootboekrekening';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CalcFields("G/L Account Description");
            end;
        }
        field(14; "G/L Account Description"; Text[100])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account")));
            CaptionML = ENU = 'G/L Account Description', NLD = 'Grootboekrekeningomschrijving';
        }
        field(15; "Cash Flow Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cash Flow Category', NLD = 'Kasstroomcategorie';
            TableRelation = "CashFlow_Category";

            trigger OnValidate()
            begin
                CalcFields("Cash Flow Category Desc.");
            end;
        }
        field(16; "Cash Flow Category Desc."; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("CashFlow_Category".Description WHERE(Code = FIELD("Cash Flow Category")));
            CaptionML = ENU = 'Cash Flow Category Description', NLD = 'Kasstroomcategorie omschrijving';
            Editable = false;
        }
        field(17; "Cash Flow Category Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cash Flow Category Amount', NLD = 'Bedrag kasstroomcategorie';
        }
        field(18; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code', NLD = 'Globale dimensie 1 code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(19; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code', NLD = 'Globale dimensie 2 code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(20; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            CaptionML = ENU = 'Shortcut Dimension 3 Code', NLD = 'Snelkoppeling dimensie 3 code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(3)));
        }
        field(21; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            CaptionML = ENU = 'Shortcut Dimension 4 Code', NLD = 'Snelkoppeling dimensie 4 code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(4)));
        }
        field(22; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            CaptionML = ENU = 'Shortcut Dimension 5 Code', NLD = 'Snelkoppeling dimensie 5 code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(5)));
        }
        field(23; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            CaptionML = ENU = 'Shortcut Dimension 6 Code', NLD = 'Snelkoppeling dimensie 6 code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(6)));
        }
        field(24; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            CaptionML = ENU = 'Shortcut Dimension 7 Code', NLD = 'Snelkoppeling dimensie 7 code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(7)));
        }
        field(25; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            CaptionML = ENU = 'Shortcut Dimension 8 Code', NLD = 'Snelkoppeling dimensie 8 code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(8)));
        }

        field(50; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', NLD = 'Dimensie Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDimensions();
            end;

            trigger OnValidate()
            var
                ShortcutDimCode: array[8] of Code[20];
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
            end;
        }

        field(60; "Realized Type"; enum "Realized_Cash Flow Type")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Realized Type', NLD = 'Kasstroom oorsprong';
        }
        field(70; "Error message unbalance"; text[250])
        {
            DataClassification = ToBeClassified;
            CaptionMl = ENU = 'Error message when unbalance detected', NLD = 'Foutmelding bij een gevonden onbelans';
        }

        field(63; "Location Creation Record"; Text[100])
        {
            DataClassification = SystemMetadata;

        }
        field(64; "Transaction No."; integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transaction No.', NLD = 'Transactienummer';
        }
        Field(65; "Amount to Analyze"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount to Analyze', NLD = 'Bedrag te analyseren';
        }
    }

    keys
    {
        key(Key1; "G/L Entry No.", "Entry Line No.")
        {
            Clustered = true;
            SumIndexFields = "Cash Flow Category Amount",
                             "Amount to Analyze";
        }
        key(key2; "Cash Flow Category")
        {

        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "G/L Entry No.")
        {
        }
        fieldgroup(Brick; "G/L Entry No.")
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

    var
        DimMgt: Codeunit DimensionManagement;

    procedure GetLastEntryNo()
    var
        CashFlowResult: Record "Cashflow Analyse Line";
    begin
        CashFlowResult.Reset();
        CashFlowResult.SetRange("G/L Entry No.", Rec."G/L Entry No.");
        if CashFlowResult.FindLast() then
            Rec."Entry Line No." := CashFlowResult."Entry Line No." + 1
        else
            Rec."Entry Line No." := 1;
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "G/L Entry No."));
    end;
}
