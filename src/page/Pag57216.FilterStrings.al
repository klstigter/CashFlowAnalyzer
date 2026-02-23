page 57216 FilterStrings
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Integer;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Index; rec.Number)
                {
                }
                field(String; string)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        i: Record Integer;
    begin
        i.setrange(Number, 1, FilterStrings.Count());
        if i.FindSet() then
            repeat
                rec.Number := i.Number;
                rec.insert;
            until i.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        String := FilterStrings.Get(rec.Number);
    end;


    var
        Index: Integer;
        FilterValue: Text;
        FilterStrings: list of [Text];
        String: Text;


    procedure SetFIlterValue(i: integer; FilterString: Text)
    var
    begin
        FilterStrings.Add(FilterString);

    end;
}