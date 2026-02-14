codeunit 57205 MyCodeunit
{
    TableNo = 57209;

    trigger OnRun()
    var
        FilterTxt: text;
    begin
        FilterTxt := TransActionBuffer.FillBuffer(Rec);
        TransActionBuffer.ShowPage();
        TransActionBuffer.FillDetCustLedgBuffer(FilterTxt);
        TransActionBuffer.ShowPageDetCustLedg();
    end;

    var
        TransActionBuffer: Codeunit GlEntryTransactionBuffer;
}