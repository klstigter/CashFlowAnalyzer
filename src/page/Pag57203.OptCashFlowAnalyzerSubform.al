page 57203 "Opt. CashFlow Analyzer Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cashflow Analyse Line";
    Editable = false;
    Caption = 'CashFlow Analyzer Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(EntryNo; Rec."G/L Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(EntryLineNo; Rec."Entry Line No.")
                {
                    ApplicationArea = All;
                }

                field("Applied Posting Date"; Rec."Applied Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Applied Document Entry No."; Rec."Applied Document Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Applied Document Type"; Rec."Applied Document Type")
                {
                    ApplicationArea = All;
                }

                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
                field("G/L Account Description"; Rec."G/L Account Description")
                {
                    ApplicationArea = All;
                }
                field("Cash Flow Category"; Rec."Cash Flow Category")
                {
                    ApplicationArea = All;
                }
                field("Cash Flow Category Desc."; Rec."Cash Flow Category Desc.")
                {
                    ApplicationArea = All;
                }
                field("Cash Flow Category Amount"; Rec."Cash Flow Category Amount")
                {
                    ApplicationArea = All;
                }
                field("Is Grip"; Rec."Is Grip")
                {
                    ApplicationArea = All;
                    Caption = 'Is Grip';
                }
                field(globalDimension1; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(globalDimension2; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field(shortcutDimension6; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Realized Type"; Rec."Realized Type")
                {
                    ApplicationArea = All;
                }
                field("Error message unbalance"; Rec."Error message unbalance")
                {
                    ApplicationArea = All;
                }
                field("Location Creation Record"; Rec."Location Creation Record")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    procedure GetCurrRecordFromSub(var CashLine: Record "Cashflow Analyse Line")
    begin
        CashLine := Rec;
    end;

}

