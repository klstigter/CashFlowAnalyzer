codeunit 57205 MyCodeunit
{
    TableNo = 57209;

    var
        TransActionBuffer: Codeunit "Cashflow Buffers";

    Procedure Fill_NOT_GripBuffer(rec: Record "Cash Entry Posting No."): Boolean
    var
        FilterTxt: text;
    begin
        TransActionBuffer.DeleteDetailedLedger();
        TransActionBuffer.FillDetCustLedgBuffer1(Rec, FilterTxt);
        TransActionBuffer.FillDetCustLedgBuffer2(Rec, FilterTxt);
        TransActionBuffer.FillDetVendorLedgBuffer1(Rec, FilterTxt);
        TransActionBuffer.FillDetVendorLedgBuffer2(Rec, FilterTxt);
        FilterTxt := TransActionBuffer.FillBuffer(Rec);
        TransActionBuffer.FillTEMPCashFlowCategory();
        exit(true);
    end;

    Procedure Fill_All_Buffer(rec: Record "Cash Entry Posting No."): Boolean
    var
        FilterTxt: text;
    begin
        if Fill_NOT_GripBuffer(rec) then
            TransActionBuffer.FillTempGrip();
        exit(true);
    end;

    procedure CreateAnalyze();
    begin
        TransActionBuffer.CreateAnalyze();
    end;

    procedure CreateAnalyze(var AnalyzeHder: Record "CashFLow Analyze Header");
    begin
        TransActionBuffer.CreateAnalyze(AnalyzeHder);
    end;

    procedure ShowTransactionBufferPage()
    begin
        TransActionBuffer.ShowTransactionBufferPage();
    end;

    procedure ShowDetailedLedgerPage()
    begin
        TransActionBuffer.ShowPageDetailedLedg();
    end;

    procedure ShowPageFilterStrings()
    begin
        TransActionBuffer.ShowPageFilterStrings();
    end;

    procedure FillTempGrip()

    begin
        TransActionBuffer.FillTempGrip();
    end;





}
