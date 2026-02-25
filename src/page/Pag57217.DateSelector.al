page 57217 DateSelector
{
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("Start Date"; StartDate)
            {
                ApplicationArea = All;
            }
            field("End Date"; EndDate)
            {
                ApplicationArea = All;
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