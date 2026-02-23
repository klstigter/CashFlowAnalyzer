query 57206 VatEntries
{
    QueryType = Normal;

    elements
    {
        dataitem(VatEntries; "VAT Entry")
        {
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Document_No_Filter; "Document No.") { }
            filter(Document_Type_Filter; "Document Type") { }
            column(EntryNo; "Entry No.") { }
            column(Amount; "Amount") { }
            column(TransactionNo; "Transaction No.") { }
            column(Type; Type) { }
            column(Document_Type; "Document Type") { }
            column(DocNo; "Document No.") { }
            column(PostingDate; "Posting Date") { }

            dataitem("Link"; "G/L Entry - VAT Entry Link")
            {
                DataItemLink = "VAT Entry No." = VatEntries."Entry No.";
                column("GLEntryNo"; "G/L Entry No.") { }
                dataitem("GLEntry"; "G/L Entry")
                {
                    DataItemLink = "Entry No." = Link."G/L Entry No.";
                    column(GLaccountNo; "G/L Account No.") { }
                    column("Dim1"; "Global Dimension 1 Code") { }
                    column("Dim2"; "Global Dimension 2 Code") { }
                    column(Dim_Set_ID; "Dimension Set ID") { }
                }


            }
        }
    }

}