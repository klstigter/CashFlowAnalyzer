pageextension 57201 MyExtension extends "Review G/L Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Show All")
        {
            action("runMyAction")
            {
                ApplicationArea = All;
                Caption = 'My Action';
                Image = Process;
                trigger OnAction()
                var
                    Qry: Query "GetVatentry_GLentry";
                    OutStr: OutStream;
                    instr: InStream;
                    txt: Text;
                    tempblob: Codeunit "Temp Blob";
                begin
                    rec.TestField("Reviewed Identifier");
                    Qry.SetFilter(IdentifierFilter, format(rec."Reviewed Identifier"));
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