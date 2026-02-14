page 57207 "Log Cashflow Analyzer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Log Cashflow Analyzer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Bank Flow"; Rec."Bank Flow")
                {
                    ToolTip = 'Specifies the value of the Bank Flow field.', Comment = '%';
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the value of the Created DateTime field.', Comment = '%';
                }
                field("Customer Flow"; Rec."Customer Flow")
                {
                    ToolTip = 'Specifies the value of the Customer Flow field.', Comment = '%';
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.', Comment = '%';
                }
                field("G/L Flow"; Rec."G/L Flow")
                {
                    ToolTip = 'Specifies the value of the G/L Flow field.', Comment = '%';
                }
                field("Session ID"; Rec."Session ID")
                {
                    ToolTip = 'Specifies the value of the Session ID field.', Comment = '%';
                }
                field("Source Line Counter"; Rec."Source Line Counter")
                {
                    ToolTip = 'Specifies the value of the Total Source Line Counter field.', Comment = '%';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("Total Time"; Rec."Total Time")
                {
                    ToolTip = 'Specifies the value of the Total Time field.', Comment = '%';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                }
                field("Vendor Flow"; Rec."Vendor Flow")
                {
                    ToolTip = 'Specifies the value of the Vendor Flow field.', Comment = '%';
                }
            }
        }
        area(Factboxes)
        {

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
}