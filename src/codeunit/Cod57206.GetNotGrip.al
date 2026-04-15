codeunit 57206 GetNotGrip
{


    trigger OnRun()
    begin

    end;

    Procedure FindNotGripSalesInvoices(var TEMP_: Record "DetailLedger2DocNo Buffer" temporary;
                    var TEMPgrip: record "GRIP Invoice Analyze Data" temporary;
                    var TEMP_NotFound: Record "DetailLedger2DocNo Buffer" temporary): Boolean
    begin
        TEMP_.FindSet();
        repeat
            if not TEMPgrip.Get(TEMP_."led_Document No.") then begin
                TEMPgrip.SetRange("Document Type", TEMP_."led_Document Type");
                TEMPgrip.setrange("Document No.", TEMP_."led_Document No.");
                if TEMPgrip.IsEmpty then begin
                    TEMP_NotFound."led_Document No." := TEMP_."led_Document No.";
                    TEMP_NotFound."led_Document Type" := TEMP_."led_Document Type";
                    TEMP_NotFound.Insert();
                end;
            end;
        until TEMP_.Next() = 0;
        TEMP_NotFound.reset();
        exit(not TEMP_NotFound.IsEmpty);

    end;

}