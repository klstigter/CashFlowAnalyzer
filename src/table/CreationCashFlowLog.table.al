table 57202 "Opt. Creation Cash Flow Log"
{
    Caption = 'Creation Cash Flow rec';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }

        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }

        field(3; "Start Time"; Time)
        {
            Caption = 'Start Time';
        }

        field(4; "End Time"; Time)
        {
            Caption = 'End Time';
        }

        field(5; "Total Time"; Duration)
        {
            Caption = 'Total Time';
        }

        field(6; "Source Line Counter"; Integer)
        {
            Caption = 'Total Source Line Counter';
        }

        field(7; "Vendor Flow"; Integer)
        {
            Caption = 'Vendor Flow';
        }

        field(8; "Customer Flow"; Integer)
        {
            Caption = 'Customer Flow';
        }

        field(9; "Bank Flow"; Integer)
        {
            Caption = 'Bank Flow';
        }

        field(10; "G/L Flow"; Integer)
        {
            Caption = 'G/L Flow';
        }

        field(11; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
        }
        field(12; "Session ID"; Integer)
        { }
        field(13; "Company"; Text[30])
        { }

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
        RecRef: Record "Opt. Creation Cash Flow Log";
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

}
