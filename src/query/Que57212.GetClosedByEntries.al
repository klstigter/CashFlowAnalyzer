query 57212 "GetClosedBy_Entries"
{
    QueryType = Normal;
    elements
    {
        dataitem("VatEntry"; "VAT Entry")
        {
            filter(ClosedByNoFilter; "Closed by Entry No.") { }
            column(ClosedByEntryNo; "Closed by Entry No.") { }
            column(Entry_No_; "Entry No.") { }
            column(VAT_Bus__Posting_Group; "VAT Bus. Posting Group") { }
            column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
            column(Document_Type; "Document Type") { }
            column(Document_No_; "Document No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Non_Deductible_VAT_Base; "Non-Deductible VAT Base") { }
            column(Non_Deductible_VAT_Amount; "Non-Deductible VAT Amount") { }

            dataitem(GLentry; "g/l entry")
            {
                dataitemlink = "document No." = VatEntry."Document No.",
                    "posting Date" = VatEntry."Posting Date",
                    "vat Prod. Posting Group" = VatEntry."VAT Prod. Posting Group",
                    "vat Bus. Posting Group" = VatEntry."VAT Bus. Posting Group";
                SqlJoinType = LeftOuterJoin;
                column(EntryNo; "Entry No.") { }
                column(G_L_Account_No_; "G/L Account No.") { }
                column(Amount; Amount) { }
                column(Dimension_Set_ID; "Dimension Set ID") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }

                dataitem(Link; "G/L Entry - VAT Entry Link")
                {
                    DataItemLink = "G/L Entry No." = GLentry."Entry No.";
                    SqlJoinType = LeftOuterJoin;
                    dataitem(GLentry2; "g/l entry")
                    {
                        dataitemlink = "Entry No." = link."G/L Entry No.";
                        SqlJoinType = LeftOuterJoin;
                        column(EntryNo2; "Entry No.") { }
                        column(AccountName2; "G/L Account No.") { }
                        column(Amount_GLentry; Amount) { }

                    }
                }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}