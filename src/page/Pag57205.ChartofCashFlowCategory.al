page 57205 "Chart of CashFlow Category"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CashFlow_Category";
    CaptionML = ENU = 'CashFlow Categories', NLD = 'Kasstroomcategorieën';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                IndentationColumn = NameIndent;
                IndentationControls = "Description";

                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the cash flow category.';
                    style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description for the cash flow category.';
                    style = Strong;
                    StyleExpr = Emphasize;
                    Width = 60;
                }
                field("CashFlow Category Type"; Rec."CashFlow Category Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of cash flow category.';
                }
                field("Totaling"; Rec."Totaling")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the totaling for the cash flow category.';
                }
                field("Mutation"; Rec."Mutation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the mutation amount for the cash flow category.';
                    BlankZero = true;
                    StyleExpr = Emphasize;
                }
                field("Saldo"; Rec."Saldo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balance for the cash flow category.';
                    BlankZero = true;
                    StyleExpr = Emphasize;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Indent Cash Flow Categories")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Indent Cash Flow Categories', NLD = 'Kasstroomcategorieën Inspringen';
                Image = Indent;
                ToolTip = 'Indent the cash flow categories. This function updates the indentation of all cash flow categories in the chart of cash flow categories. All categories between a Begin-Total and the matching End-Total are indented one level. The totaling for each End-Total is also updated.';

                trigger OnAction()
                var
                    CashFlowCategoryIndent: Codeunit "CashFlow_Category-Indent";
                begin
                    CashFlowCategoryIndent.Indent();
                end;
            }
        }
        area(Promoted)
        {

        }
    }

    trigger OnAfterGetRecord()
    begin
        SetEmphasize();
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Code");
    end;

    local procedure SetEmphasize()
    begin
        Emphasize := Rec."CashFlow Category Type" <> Rec."CashFlow Category Type"::Posting;
        NameIndent := Rec.Indent;
    end;

    var
        Emphasize: Boolean;
        NameIndent: Integer;
}
