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
        FilterTxt := TransActionBuffer.FillBuffer(Rec);
        TransActionBuffer.FillDetCustLedgBuffer(Rec, FilterTxt);
        TransActionBuffer.FillDetVendorLedgBuffer(Rec, FilterTxt);
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




}
