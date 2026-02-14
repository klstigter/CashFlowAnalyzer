page 57200 "Cash Flow Categories Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CashFlow Categories Setup";
    CaptionML = ENU = 'G/L Account Cash Flow Category', NLD = 'Kasstroomcategorie grootboekrekening';
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the G/L Account number.', NLD = 'Specificeert het grootboekrekeningnummer.';
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the name of the G/L Account.', NLD = 'Specificeert de naam van de grootboekrekening.';
                }
                field("Cash Flow Category"; Rec."Cash Flow Category")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the cash flow category for this G/L Account.', NLD = 'Specificeert de kasstroomcategorie voor deze grootboekrekening.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the start date for this cash flow category assignment.', NLD = 'Specificeert de begindatum voor deze kasstroomcategorie-toewijzing.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the end date for this cash flow category assignment.', NLD = 'Specificeert de einddatum voor deze kasstroomcategorie-toewijzing.';
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
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Create a new cash flow category G/L account assignment.';

                trigger OnAction()
                begin
                    // Insert a new record
                    Clear(Rec);
                    Rec.Insert(true);
                    CurrPage.Update();
                end;
            }
        }
        area(Navigation)
        {
            action("G/L Account")
            {
                ApplicationArea = All;
                Caption = 'G/L Account';
                Image = ChartOfAccounts;
                RunObject = Page "G/L Account Card";
                RunPageLink = "No." = FIELD("G/L Account No.");
                ToolTip = 'View or edit the G/L Account.';
            }
        }
    }
}
