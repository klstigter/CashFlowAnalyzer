codeunit 57206 GetNotGrip
{


    trigger OnRun()
    begin

    end;

    Procedure FindNotGripSalesInvoices(var TEMP_: Record "DetailLedger2DocNo Buffer" temporary;
                    var TEMPgrip: record "GRIP Invoice Analyze Data" temporary;
                    var TEMP_NotFound: Record "DetailLedger2DocNo Buffer" temporary): Boolean
    var
        n: Integer;
    begin
        if not TEMP_.FindSet() then
            exit(false);
        repeat
            TEMPgrip.SetRange("Document Type", convertDocType(TEMP_."led_Document Type"));
            TEMPgrip.setrange("Document No.", TEMP_."led_Document No.");
            if TEMPgrip.IsEmpty then begin
                n := 1;
                TEMP_NotFound.Reset();
                if TEMP_NotFound.FindLast() then
                    n := TEMP_NotFound.n + 1;
                TEMP_NotFound.Setrange("led_Entry No.", TEMP_."led_Entry No.");
                TEMP_NotFound.Setrange("led_Document No.", TEMP_."led_Document No.");
                TEMP_NotFound.Setrange("led_Document Type", TEMP_."led_Document Type");
                if not TEMP_NotFound.FindLast() then begin
                    TEMP_NotFound.n := n;
                    TEMP_NotFound."led_Entry No." := TEMP_."led_Entry No.";
                    TEMP_NotFound."led_Document No." := TEMP_."led_Document No.";
                    TEMP_NotFound."led_Document Type" := TEMP_."led_Document Type";
                    TEMP_NotFound.Insert();
                end;
            end;
        until TEMP_.Next() = 0;
        TEMP_NotFound.reset();
        TEMPgrip.reset();
        exit(not TEMP_NotFound.IsEmpty);

    end;

    local procedure convertDocType(type: Enum Microsoft.Finance.GeneralLedger.Journal."Gen. Journal Document Type"): Option
    var
        NewType: Option "Invoice","Credit Memo",Payment,Refund;
    begin
        case type of
            Type::Invoice:
                NewType := NewType::Invoice;
            Type::"Credit Memo":
                NewType := NewType::"Credit Memo";
            Type::Payment:
                NewType := NewType::Payment;
            Type::Refund:
                NewType := NewType::Refund;
        end;
        exit(NewType);


    end;
}