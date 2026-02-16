codeunit 57202 "Copy Data to CashFlow Analyzer"
{
    trigger OnRun()
    begin
        if not Confirm('This action will copy data from the old CashFlow Category GRIP Invoice table to the new GRIP Invoice Analyze Data table. Do you want to continue?', false) then
            exit;

        GripInvoiceDataCounter := 0;
        CashFlowCategoryCounter := 0;
        CashFlowCategoriesSetupCounter := 0;
        getGRIPInvoiceData();
        getCashFlow_Category();
        getCashFlowCategoriesSetup();
        Message('Data copy completed. %1 records were copied from Grip invoice.', GripInvoiceDataCounter);
        Message('Data copy completed. %1 records were copied from CashFlow Category.', CashFlowCategoryCounter);
        Message('Data copy completed. %1 records were copied from CashFlow Categories Setup.', CashFlowCategoriesSetupCounter);
    end;

    var
        GripInvoiceDataCounter: Integer;
        CashFlowCategoryCounter: Integer;
        CashFlowCategoriesSetupCounter: Integer;

    local procedure getGRIPInvoiceData()
    var
        GRIPInvoicedata: Record "GRIP Invoice Analyze Data";
        GripOldData: Record "CashFlow Category GRIP Invoice";
    begin
        if GripOldData.FindSet() then
            repeat
                GRIPInvoicedata.TransferFields(GripOldData);
                if GRIPInvoicedata.Insert() then
                    GripInvoiceDataCounter += 1;

            until GripOldData.Next() = 0;
    end;

    local procedure getCashFlow_Category()
    var
        CashFlowCategory: Record "CashFlow_Category";
        CategoryOld: Record "CashFlow Category";
    begin
        if CategoryOld.FindSet() then
            repeat
                CashFlowCategory.TransferFields(CategoryOld);
                if CashFlowCategory.Insert() then
                    CashFlowCategoryCounter += 1;

            until CategoryOld.Next() = 0;
    end;

    local procedure getCashFlowCategoriesSetup()
    var
        CashFlowCatSetup: Record "CashFlow Categories Setup";
        "CashFlowCatGLAccOld": Record "Cash Flow Category G/L Account";
    begin
        if "CashFlowCatGLAccOld".FindSet() then
            repeat
                CashFlowCatSetup.TransferFields("CashFlowCatGLAccOld");
                CashFlowCatSetup."Cash Flow Category" := "CashFlowCatGLAccOld"."Cash Flow Category";
                if CashFlowCatSetup.Insert() then
                    CashFlowCategoriesSetupCounter += 1;

            until "CashFlowCatGLAccOld".Next() = 0;

    end;
}