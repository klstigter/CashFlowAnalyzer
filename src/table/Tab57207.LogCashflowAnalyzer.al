table 57207 "Log Cashflow Analyzer"
{
    Caption = 'Creation Cash Flow rec';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', NLD = 'Volgnummer';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; "User ID"; Code[50])
        {
            CaptionML = ENU = 'User ID', NLD = 'Gebruikers-ID';
            DataClassification = EndUserIdentifiableInformation;
        }

        field(3; "Start Time"; Time)
        {
            CaptionML = ENU = 'Start Time', NLD = 'Starttijd';
        }

        field(4; "End Time"; Time)
        {
            CaptionML = ENU = 'End Time', NLD = 'Eindtijd';
        }

        field(5; "Total Time"; Duration)
        {
            CaptionML = ENU = 'Total Time', NLD = 'Duur';
        }

        field(6; "Source Line Counter"; Integer)
        {
            CaptionML = ENU = 'Total Source Line Counter', NLD = 'Aantal regels in de code';
        }

        field(7; "Vendor Flow"; Integer)
        {
            CaptionML = ENU = 'Vendor Flow', NLD = 'Leveranciersstroom';
        }

        field(8; "Customer Flow"; Integer)
        {
            CaptionML = ENU = 'Customer Flow', NLD = 'Klantenstroom';
        }

        field(9; "Bank Flow"; Integer)
        {
            CaptionML = ENU = 'Bank Flow', NLD = 'Bankstroom';
        }

        field(10; "G/L Flow"; Integer)
        {
            CaptionML = ENU = 'G/L Flow', NLD = 'Grootboekstroom';
        }

        field(11; "Created DateTime"; DateTime)
        {
            CaptionML = ENU = 'Created DateTime', NLD = 'Aangemaakt op';
        }
        field(12; "Session ID"; Integer)
        {
            CaptionML = ENU = 'Session ID', NLD = 'Sessie-ID';
        }
        field(13; "Company"; Text[30])
        {
            CaptionML = ENU = 'Company', NLD = 'Bedrijf';
        }
        field(14; "Comment"; Text[50])
        {
            CaptionML = ENU = 'Comment', NLD = 'Opmerking';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(UserTimeIdx; "User ID", "Created DateTime")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := GetNextEntryNo();

        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime();
    end;

    local procedure GetNextEntryNo(): Integer
    var
        RecRef: Record "Log Cashflow Analyzer";
    begin
        if RecRef.FindLast() then
            exit(RecRef."Entry No." + 1)
        else
            exit(1);
    end;

    procedure PopulateLogMetrics(StartTime: time; EndTIme: time; TotalTime: duration; TotSourceLineCounter: integer;
    VendorFlow: Integer; CustomerFlow: Integer; BankFlow: Integer; GLEFlow: Integer): Integer
    begin
        rec.Init();
        rec."User ID" := UserId();
        rec."Start Time" := StartTime;
        rec."End Time" := EndTime;
        rec."Total Time" := TotalTime;

        rec."Source Line Counter" := TotSourceLineCounter;
        rec."Vendor Flow" := VendorFlow;
        rec."Customer Flow" := CustomerFlow;
        rec."Bank Flow" := BankFlow;
        rec."G/L Flow" := GLEFlow;
        rec."Session ID" := SessionId();
        rec."Company" := CompanyName();
        rec.Insert(true);
        exit(rec."Entry No.")
    end;

    procedure CreateMessage(EntrNo: Integer) StrFmt: Text
    begin
        rec.get(EntrNo);
        StrFmt := StrSubstNo('To find the cash flow there are used a total %1 source records.', rec."Source Line Counter");
        StrFmt += StrSubstNo('\\Total Time: %1\, Vendor Flow: %2\, Customer Flow: %3\, Bank Flow: %4\, G/L Flow: %5',
            rec."Total Time", rec."Vendor Flow", rec."Customer Flow", rec."Bank Flow", rec."G/L Flow");
        exit(StrFmt);
    end;

    procedure createLog(Counter: Integer; t1: time; t2: time; Comment: Text)
    var
        Log: Record "Log Cashflow Analyzer";
    begin
        log.init;
        log."User ID" := UserId();
        Log."Created DateTime" := CurrentDateTime();
        log."Start Time" := t1;
        log."End Time" := t2;
        log."Total Time" := t2 - t1;
        log."Source Line Counter" := Counter;
        log."Vendor Flow" := 0;
        log."Customer Flow" := 0;
        log."Bank Flow" := 0;
        log.Comment := Comment;
        log.Insert();
        commit;
    end;
}
