unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    TimeLabel: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimeLabelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Width:=100;
  Height:=48;

end;

procedure TMainForm.TimeLabelClick(Sender: TObject);
begin

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  TimeLabel.Caption:=TimeToStr(Time);
end;

end.

