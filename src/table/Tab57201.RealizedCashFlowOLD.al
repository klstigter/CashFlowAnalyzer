table 57201 "Realized_Cash Flow OLD"
{
    DataClassification = ToBeClassified;
    Caption = 'CashFlow Analyzer Line';

    fields
    {
        field(1; "Cash Flow Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cash Flow Entry No.', NLD = 'Volgnummer kasstroompost';
        }
        field(2; "Source Type"; enum "Realized Cash Flow Source Type")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Type', NLD = 'Bronsoort';
        }

        field(3; "Source Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Entry No.', NLD = 'Bron volgnummer';
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting Date', NLD = 'Boekingsdatum';
        }
        field(5; "Gen. Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Gen. Journal Template', NLD = 'Financieel dagboeksjabloon';
            TableRelation = "Gen. Journal Template";
        }
        field(6; "Journal Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Journal Batch', NLD = 'Dagboekbatch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Gen. Journal Template"));
        }
        field(7; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', NLD = 'Documentnr.';
        }
        field(8; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', NLD = 'Omschrijving';
        }
        field(9; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', NLD = 'Bedrag';
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
            TableRelation = "CashFlow Category";

            trigger OnValidate()
            begin
                CalcFields("Cash Flow Category Desc.");
            end;
        }
        field(16; "Cash Flow Category Desc."; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("CashFlow Category".Description WHERE(Code = FIELD("Cash Flow Category")));
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
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(19; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(20; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(3)));
        }
        field(21; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(4)));
        }
        field(22; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(5)));
        }
        field(23; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(6)));
        }
        field(24; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(7)));
        }
        field(25; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(8)));
        }
        field(50; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
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

        field(60; "Realized Type"; enum "Realized Cash Flow Type")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Realized Type', NLD = 'Kasstroom oorsprong';
        }
        field(70; "Error message unbalance"; text[250])
        {
            DataClassification = ToBeClassified;
            CaptionMl = ENU = 'Error message when unbalance detected', NLD = 'Foutmelding bij een gevonden onbelans';
        }
        field(61; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Customer No.', NLD = 'Klantnr.';
            TableRelation = Customer;
        }
        field(62; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor No.', NLD = 'Leveranciersnr.';
            TableRelation = Vendor;
        }
        field(63; "Place of Birth"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Place of Birth', NLD = 'Geboorteplaats';
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
        key(Key1; "Cash Flow Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date", "Cash Flow Category")
        {
        }
        key(Key3; "G/L Account", "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cash Flow Entry No.", "Posting Date", "Description", "Amount")
        {
        }
        fieldgroup(Brick; "Cash Flow Entry No.", "Posting Date", "Description", "Amount")
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
        RealizedCashFlow: Record "Realized Cash Flow";
    begin
        RealizedCashFlow.Reset();
        if RealizedCashFlow.FindLast() then
            Rec."Cash Flow Entry No." := RealizedCashFlow."Cash Flow Entry No." + 1
        else
            Rec."Cash Flow Entry No." := 1;
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Cash Flow Entry No."));
    end;
}

