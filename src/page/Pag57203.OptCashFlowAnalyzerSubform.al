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

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(EntryNo; Rec."G/L Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                }
                field(EntryLineNo; Rec."Entry Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry Line No.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
                field("Applied Document Entry No."; Rec."Applied Document Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Applied Document Entry No.';
                }
                field("Applied Document Type"; Rec."Applied Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Applied Document Type';
                }
                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Applied Document No.';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account';
                }
                field("G/L Account Description"; Rec."G/L Account Description")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account Description';
                }
                field("Cash Flow Category"; Rec."Cash Flow Category")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Flow Category';
                }
                field("Cash Flow Category Desc."; Rec."Cash Flow Category Desc.")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Flow Category Desc.';
                }
                field("Cash Flow Category Amount"; Rec."Cash Flow Category Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Flow Category Amount';
                }
                field("Is Grip"; Rec."Is Grip")
                {
                    ApplicationArea = All;
                    Caption = 'Is Grip';
                }
                field(globalDimension1; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Global Dimension 2 Code';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 3 Code';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 4 Code';
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 5 Code';
                }
                field(shortcutDimension6; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 6 Code';
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 7 Code';
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 8 Code';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension Set ID';
                }
                field("Realized Type"; Rec."Realized Type")
                {
                    ApplicationArea = All;
                    Caption = 'Realized Type';
                }
                field("Error message unbalance"; Rec."Error message unbalance")
                {
                    ApplicationArea = All;
                    Caption = 'Error message unbalance';
                }
                field("Place of Birth"; Rec."Place of Birth")
                {
                    ApplicationArea = All;
                    Caption = 'Place of Birth';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    Caption = 'Transaction No.';
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
}