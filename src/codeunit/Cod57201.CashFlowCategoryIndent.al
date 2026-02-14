codeunit 57201 "CashFlow_Category-Indent"
{
    trigger OnRun()
    begin
        Indent();
    end;

    var
        CashFlowCategoryIndentQst: Label 'This function updates the indentation of all cash flow categories in the chart of cash flow categories. All categories between a Begin-Total and the matching End-Total are indented one level. The Totaling for each End-total is also updated.\\Do you want to indent the chart of cash flow categories?';
        IndentingCashFlowCategoriesTxt: Label 'Indenting Cash Flow Categories #1##########';
        EndTotalMissingErr: Label 'End-Total %1 is missing a matching Begin-Total.', Comment = '%1 = Cash Flow Category Code';
        ArrayExceededErr: Label 'You can only indent %1 levels for cash flow categories of the type Begin-Total.', Comment = '%1 = A number bigger than 1';
        Window: Dialog;
        CashFlowCategoryCode: array[10] of Code[20];
        i: Integer;

    procedure Indent()
    var
        CashFlowCategory: Record "CashFlow_Category";
    begin
        if not Confirm(CashFlowCategoryIndentQst, false) then
            exit;

        Window.Open(IndentingCashFlowCategoriesTxt);

        if CashFlowCategory.Find('-') then
            repeat
                Window.Update(1, CashFlowCategory.Code);

                if CashFlowCategory."CashFlow Category Type" = CashFlowCategory."CashFlow Category Type"::"End-Total" then begin
                    if i < 1 then
                        Error(EndTotalMissingErr, CashFlowCategory.Code);
                    CashFlowCategory.Totaling :=
                      CashFlowCategoryCode[i] + '..' + CashFlowCategory.Code;
                    i := i - 1;
                end;
                CashFlowCategory.Indent := i;
                CashFlowCategory.Modify();

                if CashFlowCategory."CashFlow Category Type" = CashFlowCategory."CashFlow Category Type"::"Begin-Total" then begin
                    i := i + 1;
                    CashFlowCategoryCode[i] := CashFlowCategory.Code;
                    if i > ArrayLen(CashFlowCategoryCode) then
                        Error(ArrayExceededErr, ArrayLen(CashFlowCategoryCode));
                end;


            until CashFlowCategory.Next() = 0;

        Window.Close();
    end;
}
