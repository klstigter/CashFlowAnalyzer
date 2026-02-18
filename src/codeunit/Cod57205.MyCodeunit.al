codeunit 57205 MyCodeunit
{
    TableNo = 57209;

    trigger OnRun()
    var
        FilterTxt: text;
    begin
        FilterTxt := TransActionBuffer.FillBuffer(Rec);
        TransActionBuffer.DeleteDetailedLedger();
        TransActionBuffer.FillDetCustLedgBuffer(Rec, FilterTxt);
        TransActionBuffer.FillDetVendorLedgBuffer(Rec, FilterTxt);
    end;

    var
        TransActionBuffer: Codeunit "Cashflow Buffers";

    procedure CreateAnalyze();
    begin
        TransActionBuffer.CreateAnalyze();
    end;

    procedure ShowPages()
    begin
        TransActionBuffer.ShowPage();
        TransActionBuffer.ShowPageDetailedLedg();
    end;

}