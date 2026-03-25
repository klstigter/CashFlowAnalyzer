permissionset 57201 CashflowAnalyzer
{
    Assignable = true;
    Caption = 'Cashflow Analyzer';

    Permissions =
        tabledata "CashFLow Analyze Header" = RIMD,
        tabledata "Realized_Cash Flow OLD" = RIMD,
        tabledata "Opt. Creation Cash Flow Log" = RIMD,
        tabledata "CashFlow_Category" = RIMD,
        tabledata "CashFlow Categories Setup" = RIMD,
        tabledata "GRIP Invoice Analyze Data" = RIMD,
        tabledata "Cashflow Analyzer Setup" = RIMD,
        tabledata "Log Cashflow Analyzer" = RIMD,
        tabledata "Cashflow Analyzer Tasks" = RIMD,
        tabledata "Cash Entry Posting No." = RIMD,
        tabledata "Cashflow Analyse Line" = RIMD;
}