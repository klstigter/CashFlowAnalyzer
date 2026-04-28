codeunit 57205 "CashflowAnalyzer Helper"
{
    TableNo = 57209;

    var
        TransActionBuffer: Codeunit "Cashflow Buffers";

    Procedure Fill_NOT_GripBuffer(var rec: Record "Cash Entry Posting No."): Boolean
    var
        FilterTxt: text;
        nRec: Integer;
    begin
        TransActionBuffer.DeleteDetailedLedger();
        nRec += TransActionBuffer.FillDetCustLedgBuffer1(Rec, FilterTxt);
        nRec += TransActionBuffer.FillDetCustLedgBuffer2(Rec, FilterTxt);
        nRec += TransActionBuffer.FillDetVendorLedgBuffer1(Rec, FilterTxt);
        nRec += TransActionBuffer.FillDetVendorLedgBuffer2(Rec, FilterTxt);

        if nRec = 0 then begin
            nRec += TransActionBuffer.FillVATSettlement(Rec);
            if nRec <> 0 then begin
                Rec."Is VAT Settlement" := true;
                Rec.Modify();
            end
        end;
        FilterTxt := TransActionBuffer.FillBuffer(Rec);
        TransActionBuffer.FillTEMPCashFlowCategory();
        exit(true);
    end;

    Procedure Fill_All_Buffer(var rec: Record "Cash Entry Posting No."): Boolean
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
