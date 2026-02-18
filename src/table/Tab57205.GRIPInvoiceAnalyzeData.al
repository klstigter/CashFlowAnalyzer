table 57205 "GRIP Invoice Analyze Data"
{
    CaptionML = ENU = 'CashFlow Category GRIP Invoice', NLD = 'Kasstroomcategorie GRIP factuur';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Exploitation No."; Integer)
        {
            CaptionML = ENU = 'Explotation No.', NLD = 'Exploitatiepost Nr.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(20; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type', NLD = 'Documentsoort';
            //OptionCaption = 'Invoice,Credit Memo,Payment,Refund';
            OptionCaptionML = ENU = 'Invoice,Credit Memo,Payment,Refund', NLD = 'Factuur,Creditnota,Betaling,Terugbetaling';
            OptionMembers = Invoice,"Credit Memo",Payment,Refund;
            DataClassification = CustomerContent;
        }
        field(30; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', NLD = 'Documentnr.';
            DataClassification = CustomerContent;
        }
        field(40; "G/L Account"; Code[20])
        {
            CaptionML = ENU = 'G/L Account', NLD = 'Grootboekrekening';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(50; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount', NLD = 'Bedrag';
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(60; "Global Dimension 1 Code"; Code[20])
        {

            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin

            end;
        }
        field(70; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin

            end;
        }
        field(80; "Created DateTime"; DateTime)
        {
            CaptionML = ENU = 'Created DateTime', NLD = 'Aangemaakt op';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(90; "Created By"; Code[50])
        {
            CaptionML = ENU = 'Created By', NLD = 'Aangemaakt door';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "Remaning Amount"; Decimal)
        {
            CaptionML = ENU = 'Remaining Amount', NLD = 'Resterend bedrag';
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Remaining Amount" where("Document No." = field("Document No.")));
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Exploitation No.")
        {
            Clustered = true;
        }
        key(DocumentKey; "Document Type", "Document No.")
        {
        }
        key(GLAccountKey; "G/L Account")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created DateTime" := CurrentDateTime;
        "Created By" := UserId;
    end;


}
