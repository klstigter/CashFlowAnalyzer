pageextension 57203 vatext extends "VAT Entries"
{
    layout
    {
        // Add changes to page layout here
    }
    actions
    {
        addafter(IncomingDocAttachFile)
        {
            action("runMyAction")
            {
                ApplicationArea = All;
                Caption = 'My Action';
                Image = Process;
                trigger OnAction()
                var
                    Qry: Query "GetClosedBy_Entries";
                    OutStr: OutStream;
                    instr: InStream;
                    txt: Text;
                    tempblob: Codeunit "Temp Blob";
                begin
                    Qry.SetFilter(ClosedByNoFilter, format(rec."Entry No."));
                    Qry.Open();
                    tempblob.CreateOutStream(OutStr);
                    tempblob.CreateInStream(instr);
                    CopyStream(OutStr, instr);
                    txt := 'Output.xml';
                    Qry.SaveAsXml(OutStr);
                    DownloadFromStream(instr, 'Run the query', 'application/xml', 'test', txt);
                end;
            }
        }
    }

    var
        myInt: Integer;
}