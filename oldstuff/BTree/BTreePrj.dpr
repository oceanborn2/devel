program BTreePrj;

uses
  Forms,
  BTrees in 'BTrees.pas' {Form1},
  Btree in 'Btree.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
