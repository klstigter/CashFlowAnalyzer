pageextension 57200 "Business Mngr Role Ext" extends "Business Manager Role Center"
{
    actions
    {
        // Add changes to page layout here
        addafter(Action41)
        {
            group(cashflowAnalyzerGroup)
            {
                CaptionML = ENU = 'Cash Flow Analyzer', NLD = 'Kasstroomanalyse';
                ToolTip = 'Analyze and forecast your cash flow based on various financial data sources.';
                action(CashEntryPostings)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = ENU = 'Cash Entry Postings', NLD = 'Kas- en Bankmutaties';
                    RunObject = Page "Cash Entry Postings";
                    ToolTip = 'View and manage cash entry postings to analyze your cash flow based on actual transactions.';
                }
                action(CashFlowAnalyzeLinesList)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = ENU = 'Cash Flow Analyze Lines', NLD = 'Gedetailleerde Kasstroomposten';
                    RunObject = Page "CashFlowAnalyzeLines List";
                    ToolTip = 'View Cash Flow Analyze Lines.';
                }
                action("Cashflow Analyze` List")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = ENU = 'G/L Entry List', NLD = 'Te analyseren kasstromen';
                    RunObject = Page "Cashflow Analyze List";
                }
                action("ChartofCashFlowCategory")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = ENU = 'Chart of CashFlow Category', NLD = 'Kasstroomcategorieën';
                    RunObject = Page "Chart of CashFlow Category";
                    ToolTip = 'View and manage cash flow categories to classify your cash flow entries for better analysis and reporting.';
                }

                group(AnalyzerHistory)
                {
                    CaptionML = ENU = 'Analyzer History', NLD = 'Analyse log';
                    ToolTip = 'Review the history of your cash flow analyses to track changes and monitor trends in your company''s cash position over time.';
                    action("GRIPInvoiceData")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'GRIP Invoice Data', NLD = 'Kasstroomcategorie GRIP factuur';
                        RunObject = Page "GRIP Invoice data";
                        ToolTip = 'Review the history of your cash flow analyses to track changes and monitor trends in your company''s cash position over time.';
                    }
                    action(log)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Creation Log', NLD = 'Logboekvermeldingen';
                        RunObject = Page "Log Cashflow Analyzer";
                        ToolTip = 'Review the log of cash flow analysis creation to track performance and identify any issues during the analysis process.';
                    }
                }
                group(AnalyzerSetup)
                {
                    CaptionML = ENU = 'Analyzer Setup', NLD = 'Kasstromen instellingen';
                    ToolTip = 'Set up your cash flow analysis parameters and categories to ensure accurate forecasting and reporting.';
                    action("Cashflow Category Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'CashFlow Category Setup', NLD = 'Kasstroomcategorie grootboekrekening';
                        RunObject = Page "Cash Flow Categories Setup";
                        ToolTip = 'Set up cash flow categories to classify your cash flow entries for better analysis and reporting.';
                    }
                    action("Analyzer VAT Settlement Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Analyzer VAT Settlement Setup', NLD = 'Kasstroom BTW-aangifte instellingen';
                        RunObject = Page "Analyzer VAT Settlement Setup";
                        ToolTip = 'Configure VAT settlement settings for your cash flow analysis to ensure accurate forecasting and reporting of VAT-related cash flow impacts.';
                    }
                }
                group(CopyData)
                {
                    Caption = 'Copy Data';
                    ToolTip = 'Copy financial data to create new cash flow analyses based on existing data for efficient forecasting and reporting.';
                    action("Copy Cashflow Analyzer")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Copy CashFlow Analyzer';
                        RunObject = Codeunit "Copy Data to CashFlow Analyzer";
                        ToolTip = 'Copy financial data to create new cash flow analyses based on existing data for efficient forecasting and reporting.';
                    }
                    action("Copy GRIP Invoice Data")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Get list of Posting no. from G/L Entry';
                        RunObject = Codeunit CreateCashEntryPostingNoList;
                        ToolTip = 'Get a list of posting numbers from G/L Entry for cash flow analysis.';
                    }
                }

            }
        }
    }
}