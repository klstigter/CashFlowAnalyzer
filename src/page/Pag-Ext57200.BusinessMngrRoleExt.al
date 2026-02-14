pageextension 57200 "Business Mngr Role Ext" extends "Business Manager Role Center"
{
    actions
    {
        // Add changes to page layout here
        addafter(Action41)
        {
            group(cashflowAnalyzerGroup)
            {
                Caption = 'Cash Flow Analyzer';
                ToolTip = 'Analyze and forecast your cash flow based on various financial data sources.';
                action(CashEntryPostings)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Entry Postings';
                    RunObject = Page "Cash Entry Postings";
                    ToolTip = 'View and manage cash entry postings to analyze your cash flow based on actual transactions.';
                }
                action("G/L Entry List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Entry List';
                    RunObject = Page "G/L Entry Cash to Analyze List";
                }
                action("ChartofCashFlowCategory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chart of CashFlow Category';
                    RunObject = Page "Chart of CashFlow Category";
                    ToolTip = 'View and manage cash flow categories to classify your cash flow entries for better analysis and reporting.';
                }

                group(AnalyzerHistory)
                {
                    Caption = 'Analyzer History';
                    ToolTip = 'Review the history of your cash flow analyses to track changes and monitor trends in your company''s cash position over time.';
                    action("GRIPInvoiceData")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'GRIP Invoice Data';
                        RunObject = Page "GRIP Invoice data";
                        ToolTip = 'Review the history of your cash flow analyses to track changes and monitor trends in your company''s cash position over time.';
                    }
                }
                group(AnalyzerSetup)
                {
                    Caption = 'Analyzer Setup';
                    ToolTip = 'Set up your cash flow analysis parameters and categories to ensure accurate forecasting and reporting.';
                    action("Cashflow Category Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'CashFlow Category Setup';
                        RunObject = Page "Cash Flow Categories Setup";
                        ToolTip = 'Set up cash flow categories to classify your cash flow entries for better analysis and reporting.';
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