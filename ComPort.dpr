program ComPort;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uComPort in 'uComPort.pas',
  uMacros in 'uMacros.pas' {fMacroses},
  SendFile in 'SendFile.pas' {Form1},
  uLog in 'uLog.pas' {fmLog: TFrame},
  uSetFont in 'uSetFont.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfMacroses, fMacroses);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
