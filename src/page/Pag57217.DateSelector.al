page 57217 DateSelector
{
    PageType = StandardDialog;
    ApplicationArea = All;
    CaptionML = ENU = 'Select Date Range', NLD = 'Kasstroomposten aanmaken per datum';

    layout
    {
        area(Content)
        {
            field("Start Date"; StartDate)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Start Date', NLD = 'Startdatum';
            }
            field("End Date"; EndDate)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'End Date', NLD = 'Einddatum';
            }
        }
        area(Factboxes)
        {

        }
    }
    // In your StandardDialog page
    var
        StartDate: Date;
        EndDate: Date;


    procedure GetValues(var FromDate: Date; var ToDate: Date)
    begin
        FromDate := StartDate;
        ToDate := EndDate;
    end;
}