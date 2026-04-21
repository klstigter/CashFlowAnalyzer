query 57210 "VAT Settlement Check Opt."
{
    QueryType = Normal;

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(GL_Entry_No_; "Entry No.") { }

            filter(Document_Type_filter; "Document Type") { }
            filter(Document_No_filter; "Document No.") { }

            dataitem(G_L_Entry___VAT_Entry_Link; "G/L Entry - VAT Entry Link")
            {
                DataItemLink = "G/L Entry No." = G_L_Entry."Entry No.";

                column(VAT_Entry_No_; "VAT Entry No.") { }

                dataitem(VAT_Entry; "VAT Entry")
                {
                    DataItemLink = "Entry No." = G_L_Entry___VAT_Entry_Link."VAT Entry No.";
                    DataItemTableFilter = "Closed" = filter(true);

                    column(Amount; "Amount") { }
                    column(TransactionNo; "Transaction No.") { }
                    column(Type; Type) { }
                    column(Document_Type; "Document Type") { }
                    column(DocNo; "Document No.") { }
                    column(PostingDate; "Posting Date") { }
                    column(Closed; "Closed") { }
                    column(Closed_by_Entry_No_; "Closed by Entry No.") { }
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