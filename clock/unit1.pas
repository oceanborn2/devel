unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, Buttons, ComCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    ChronoLabel: TLabel;
    ClearLogMnu: TMenuItem;
    Expand: TSpeedButton;
    MainPanel: TPanel;
    LogMemo: TMemo;
    Panel1: TPanel;
    ResetBtn: TSpeedButton;
    SaveLogMnu: TMenuItem;
    StartBtn: TSpeedButton;
    StatusBar1: TStatusBar;
    StayOnTopMnu: TMenuItem;
    PopupMenu1: TPopupMenu;
    StopBtn: TSpeedButton;
    ChronoTimer: TTimer;
    ToolBar1: TToolBar;
    CurrentTimeLabel: TLabel;
    CurrentTime: TTimer;
    TourBtn: TSpeedButton;

    procedure ClearChrono;
    procedure ChronoTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearLogMnuClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure SaveLogMnuClick(Sender: TObject);
    procedure StayOnTopMnuClick(Sender: TObject);

    procedure CurrentTimeStartTimer(Sender: TObject);
    procedure CurrentTimeStopTimer(Sender: TObject);
    procedure CurrentTimeTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  chronoStart: integer;
  chronoStop: integer;


implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Width := ResetBtn.Width + StartBtn.Width + StopBtn.Width + TourBtn.Width +
    Expand.Width;
  // Height:=48;
  ClearChrono;
  LogMemo.Clear;
  CurrentTimeLabel.Caption := TimeToStr(Time);
end;

procedure TMainForm.ClearChrono;
begin
  chronoStart := 0;
  chronoStop := 0;
  ChronoLabel.Caption := '00:00:00';
end;

procedure TMainForm.ChronoTimerTimer(Sender: TObject);
begin

end;

procedure TMainForm.ClearLogMnuClick(Sender: TObject);
begin
  LogMemo.Clear;
end;

procedure TMainForm.ResetBtnClick(Sender: TObject);
begin
  ClearChrono;
end;

procedure TMainForm.SaveLogMnuClick(Sender: TObject);
begin

end;

procedure TMainForm.StayOnTopMnuClick(Sender: TObject);
begin
  if formStyle = TFormStyle.fsSystemStayOnTop then
  begin
    FormStyle := TFormStyle.fsNormal;
    StayOnTopMnu.Checked := False;
  end
  else
  begin
    FormStyle := TFormStyle.fsSystemStayOnTop;
    StayOnTopMnu.Checked := True;
  end;
end;

procedure TMainForm.CurrentTimeStartTimer(Sender: TObject);
begin
  StatusBar1.Caption := 'Started';
end;

procedure TMainForm.CurrentTimeStopTimer(Sender: TObject);
begin
  StatusBar1.Caption := 'Stopped';
  CurrentTimeLabel.Caption := '00:00:00';
end;

procedure TMainForm.CurrentTimeTimer(Sender: TObject);
begin
  CurrentTimeLabel.Caption := TimeToStr(Time);
end;

end.
