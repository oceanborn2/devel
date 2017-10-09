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
    LogPanel: TPanel;
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

    procedure ClearChrono(EnableChrono: boolean);
    procedure ChronoTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearLogMnuClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure SaveLogMnuClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure StayOnTopMnuClick(Sender: TObject);
    procedure CurrentTimeTimer(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure TourBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  chronoStart: double;
  chronoStop: double;


implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.ClearChrono(EnableChrono: boolean);
begin
  chronoStart := Time;
  chronoStop := chronoStart;
  ChronoLabel.Caption := '00:00:00';
  ChronoTimer.Enabled := EnableChrono;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Width := ResetBtn.Width + StartBtn.Width + StopBtn.Width + TourBtn.Width +
    Expand.Width + 2;
  // Height:=48;
  ClearChrono(False);
  LogMemo.Clear;
  CurrentTimeLabel.Caption := ''; //TimeToStr(Time);
end;

procedure TMainForm.CurrentTimeTimer(Sender: TObject);
begin
  CurrentTimeLabel.Caption := TimeToStr(Time);
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

// Chrono management
procedure TMainForm.ChronoTimerTimer(Sender: TObject);
begin
  if ChronoTimer.Enabled = True then
  begin
    ChronoLabel.Caption := TimeToStr(Time - ChronoStart);
  end;
end;

procedure TMainForm.ResetBtnClick(Sender: TObject);
begin
  ClearChrono(True);
end;




procedure TMainForm.StartBtnClick(Sender: TObject);
begin
  ClearChrono(True);
  StatusBar1.Caption := 'Started';
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
begin
  ClearChrono(False);
  StatusBar1.Caption := 'Stopped';
end;

procedure TMainForm.TourBtnClick(Sender: TObject);
var
  TourTime: double;
begin
  TourTime := Time;
  LogMemo.Append(TimeToStr(TourTime) + ' => ' + TimeToStr(tourTime - chronoStop));
end;

procedure TMainForm.ClearLogMnuClick(Sender: TObject);
begin
  LogMemo.Clear;
end;

procedure TMainForm.SaveLogMnuClick(Sender: TObject);
begin

end;


// StatusBar1.Caption := 'Started';
// ChronoTimer.Enabled := True;
// ChronoStart := Time;
// ChronoStop := 0;

end.
