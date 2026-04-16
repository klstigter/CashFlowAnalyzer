page 57217 DateSelector
{
    PageType = StandardDialog;
    ApplicationArea = All;
    CaptionML = ENU = 'Select Date Range', NLD = 'Kasstroomposten aanmaken per datum';

    layout
    {
        area(Content)
        {
            field(DateFilter; DateFilter)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Date Filter', NLD = 'Datumfilter';

                trigger OnValidate()
                var
                    FilterTokens: Codeunit "Filter Tokens";
                begin
                    FilterTokens.MakeDateFilter(DateFilter);
                end;
            }
        }
    }

    var
        DateFilter: Text;

    procedure GetDateFilter(): Text
    begin
        exit(DateFilter);
    end;

    procedure GetValues(var FromDate: Date; var ToDate: Date)
    var
        FilterTokens: Codeunit "Filter Tokens";
        NormalizedFilter: Text;
        Parts: List of [Text];
        FromText: Text;
        ToText: Text;
    begin
        FromDate := 0D;
        ToDate := 0D;

        NormalizedFilter := DateFilter;
        if NormalizedFilter = '' then
            exit;

        FilterTokens.MakeDateFilter(NormalizedFilter);

        if NormalizedFilter.Contains('..') then begin
            Parts := NormalizedFilter.Split('..');
            FromText := Parts.Get(1);
            ToText := Parts.Get(2);
            if FromText <> '' then
                Evaluate(FromDate, FromText);
            if ToText <> '' then
                Evaluate(ToDate, ToText);
        end else
            if Evaluate(FromDate, NormalizedFilter) then
                ToDate := FromDate;
    end;
}