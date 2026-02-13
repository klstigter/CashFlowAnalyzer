report 57200 "Opt. Cash Flow Entries Calc."
{
    UsageCategory = ReportsAndAnalysis;
    CaptionML = ENU = 'Create Cash Flow Entries', NLD = 'Kasstroomposten aanmaken per datum';
    ApplicationArea = All;
    ProcessingOnly = true;
    //DefaultRenderingLayout = LayoutName;

    dataset
    {

    }

    requestpage
    {
        AboutTitle = 'Create Cash Flow Entries';
        AboutText = 'Create Cash Flow Entries';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    CaptionML = ENU = 'Options', NLD = 'Opties';

                    field(DateFilters; DateFilter)
                    {
                        ApplicationArea = Basic;
                        CaptionML = ENU = 'Date Filter', NLD = 'Datumfilter';

                        trigger OnValidate()
                        var
                            GLAcc: Record "G/L Account";
                            FilterTokens: Codeunit "Filter Tokens";
                        begin
                            FilterTokens.MakeDateFilter(DateFilter);
                            GLAcc.SetFilter("Date Filter", DateFilter);
                            DateFilter := GLAcc.GetFilter("Date Filter");
                        end;
                    }
                }
            }
        }

        // actions
        // {
        //     area(processing)
        //     {
        //         action(LayoutName)
        //         {

        //         }
        //     }
        // }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = Excel;
    //         LayoutFile = 'mySpreadsheet.xlsx';
    //     }
    // }

    trigger OnInitReport()
    begin
        DateFilter := StrSubstNo('%1..%2', DMY2Date(1, 7, 2025), DMY2Date(31, 7, 2025));
    end;

    trigger OnPreReport()
    var
        RealizedCashflowMgt: Codeunit "Opt. Realized Cashflow Mgt.";
        MsgLbl: Label 'Invalid date filter';
    begin
        if DateFilter = '' then
            Error(MsgLbl);
        RealizedCashflowMgt.CreateCashFlowAnalyzeEntries(DateFilter);
    end;

    var
        DateFilter: Text;
}