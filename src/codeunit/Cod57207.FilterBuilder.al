codeunit 57207 FilterBuilder
{
    var
        Chunks: List of [Text];
        CurrChunk: Text;
        i: Integer;

    procedure BuildEntryNoFilter(var Buf: Record "Transaction Buffer") Chunks: List of [Text]
    var
        StartRangeNo: Text;
        EndRangeNo: Text;
        SingleFilter: Text;
        EndRange: Integer;
        AddToRange: Boolean;
        HasPrevious: Boolean;
    begin
        ClearGlobalvars();
        if not Buf.FindSet(false) then
            exit(Chunks);
        repeat
            if HasPrevious then
                AddToRange := buf."Entry No." = EndRange + 1;
            BuildChunks(format(buf."Entry No."), StartRangeNo, EndRangeNo, AddToRange);
            EndRange := Buf."Entry No.";
            HasPrevious := true;
        until Buf.Next() = 0;
        SingleFilter := CreateRangeFilter(StartRangeNo, EndRangeNo);
        AddToChunks(SingleFilter);

        if CurrChunk <> '' then
            Chunks.Add(CurrChunk);
        exit(Chunks);
    end;

    procedure GetFilterChunk(i: Integer): Text
    begin
        Chunks.Get(i, CurrChunk);
        exit(CurrChunk);
    end;

    procedure BuildEntryNoFilter(var Buf: Record "DetailLedger2DocNo Buffer"): Integer
    var
        StartRangeNo: Text;
        EndRangeNo: Text;
        SingleFilter: Text;
        AddToRange: Boolean;
        HasPrevious: Boolean;
    begin
        ClearGlobalvars();
        if not Buf.FindSet(false) then
            exit(0);
        repeat
            if HasPrevious then
                AddToRange := buf."led_Document No." = incstr(EndRangeNo);
            BuildChunks(buf."led_Document No.", StartRangeNo, EndRangeNo, AddToRange);
            HasPrevious := true;
        until Buf.Next() = 0;
        SingleFilter := CreateRangeFilter(StartRangeNo, EndRangeNo);
        AddToChunks(SingleFilter);

        if CurrChunk <> '' then
            Chunks.Add(CurrChunk);
        exit(i);
    end;

    local procedure ClearGlobalvars()
    begin
        CurrChunk := '';
        Clear(Chunks);
        i := 0;
    end;

    local procedure BuildChunks(SingleStrValue: Text; var StartRangeNo: Text; var EndRangeNo: Text; var AddToRange: Boolean)
    var
        SingleFilterRng: Text;
    begin
        if StartRangeNo = '' then begin
            StartRangeNo := SingleStrValue;
            EndRangeNo := SingleStrValue;
        end else begin
            if AddToRange then
                EndRangeNo := SingleStrValue
            else begin
                // Flush previous range into chunk
                if StartRangeNo = EndRangeNo then begin
                    AddToChunks(StartRangeNo);
                end else begin
                    SingleFilterRng := CreateRangeFilter(StartRangeNo, EndRangeNo);
                    AddToChunks(SingleFilterRng);
                end;

                // Start new range
                StartRangeNo := SingleStrValue;
                EndRangeNo := SingleStrValue;
            end;
        end;
    end;

    local procedure CreateRangeFilter(StartNo: Text; EndNo: Text): Text
    begin
        if StartNo = EndNo then
            exit(StartNo);
        exit(StartNo + '..' + EndNo);
    end;

    local procedure AddToChunks(SingleRngFilter: Text)
    var
        Candidate: Text;
    begin
        if CurrChunk = '' then begin
            CurrChunk := SingleRngFilter;
            exit;
        end;

        Candidate := CurrChunk + '|' + SingleRngFilter;

        if StrLen(Candidate) <= 1024 then
            CurrChunk := Candidate
        else begin
            i += 1;
            Chunks.Add(CurrChunk);
            CurrChunk := SingleRngFilter;
        end;
    end;
}

