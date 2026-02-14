table 57208 "Cashflow Analyzer Tasks"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "G/L Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Taskid"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; IsCash; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; IsDone; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Taskid Running"; Guid)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "G/L Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Taskid")
        {
            Clustered = false;
        }
    }


}