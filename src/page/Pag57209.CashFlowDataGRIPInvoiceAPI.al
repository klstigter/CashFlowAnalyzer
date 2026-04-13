page 57209 "CashFlowData GRIP Invoice API"
{
    CaptionML = ENU = 'CashFlow GRIP Invoice API', NLD = 'Kasstroomcategorie GRIP factuur API';
    PageType = API;
    APIPublisher = 'brilliantideas';
    APIGroup = 'youngdevelopers';
    APIVersion = 'v2.0';
    EntityName = 'cashflowdataGRIPInvoice';
    EntitySetName = 'cashflowdataGRIPInvoices';
    SourceTable = "CashFlow Category GRIP Invoice";
    DelayedInsert = true;
    ODataKeyFields = "Exploitation No.";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(exploitationNo; Rec."Exploitation No.")
                {
                    Caption = 'Exploitation No.';
                    Editable = false;
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(glAccount; Rec."G/L Account")
                {
                    Caption = 'G/L Account';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                }

                field(createdDateTime; Rec."Created DateTime")
                {
                    Caption = 'Created DateTime';
                    Editable = false;
                }
                field(createdBy; Rec."Created By")
                {
                    Caption = 'Created By';
                    Editable = false;
                }
            }
        }
    }
}
