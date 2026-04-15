codeunit 57206 GetNotGrip
{


    trigger OnRun()
    begin

    end;

    Procedure FindNotGripSalesInvoices(var TEMP_: Record "DetailLedger2DocNo Buffer" temporary;
                    var TEMPgrip: record "GRIP Invoice Analyze Data" temporary;
                    var TEMP_NotFound: Record "DetailLedger2DocNo Buffer" temporary): Boolean
    begin
        if not TEMP_.FindSet() then
            exit(false);
        repeat
            TEMPgrip.SetRange("Document Type", TEMP_."led_Document Type");
            TEMPgrip.setrange("Document No.", TEMP_."led_Document No.");
            if TEMPgrip.IsEmpty then begin
                TEMP_NotFound."led_Entry No." := TEMP_."led_Entry No.";
                TEMP_NotFound."led_Document No." := TEMP_."led_Document No.";
                TEMP_NotFound."led_Document Type" := TEMP_."led_Document Type";
                TEMP_NotFound.Insert();
            end;
        until TEMP_.Next() = 0;
        TEMP_NotFound.reset();
        TEMPgrip.reset();
        exit(not TEMP_NotFound.IsEmpty);

    end;

}