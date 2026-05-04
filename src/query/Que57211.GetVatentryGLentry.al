query 57211 "GetVatentry_GLentry"
{
    QueryType = Normal;
    elements
    {
        dataitem("ReviewLog"; "G/L Entry Review Log")
        {
            filter(IdentifierFilter; "Reviewed Identifier")
            {
            }
            filter(entryNoFilter; "G/L Entry No.")
            {
            }
            column("Identifier"; "Reviewed Identifier")
            {
            }
            column(G_L_Entry_No_; "G/L Entry No.")
            {
            }
            column(G_L_Account_No_; "G/L Account No.")
            {
            }
            dataitem(GLentry; "g/l entry")
            {
                dataitemlink = "Entry No." = ReviewLog."G/L Entry No.";
                SqlJoinType = LeftOuterJoin;

                column(glAmount; Amount)
                {
                }
                dataitem(GLentry2; "g/l entry")
                {
                    DataItemLink = "Document No." = GLentry."Document No.",
                        "Posting Date" = GLentry."Posting Date";

                    SqlJoinType = LeftOuterJoin;

                    column(GL_Entry_No; "Entry No.")
                    {
                    }
                    column(AccountName2; "G/L Account No.")
                    {
                    }
                    column(Document_Type; "Document Type") { }
                    column(Document_No_; "Document No.") { }
                    column(postingDate2; "Posting Date") { }
                    column(Amount_GLentry; Amount) { }
                    column(Dimension_Set_ID; "Dimension Set ID") { }
                    column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                    column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }

                    dataitem(Link2; "G/L Entry - VAT Entry Link")
                    {
                        DataItemLink = "G/L Entry No." = GLentry2."Entry No.";
                        SqlJoinType = LeftOuterJoin;

                        dataitem(DataItemName2; "VAT Entry")
                        {
                            DataItemLink = "Entry No." = link2."VAT Entry No.";
                            SqlJoinType = LeftOuterJoin;
                            column(VATentryNo; "Entry No.")
                            {
                            }
                            column(Amount; Amount)
                            {
                            }
                            column(Non_Deductible_VAT_Amount; "Non-Deductible VAT Amount") { }
                            column(VAT_Bus__Posting_Group; "VAT Bus. Posting Group") { }
                            column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }

                        }
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