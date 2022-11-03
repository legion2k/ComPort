unit uLog;

interface

uses
  System.Rtti,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Menus,
  FMX.Controls.Presentation;

type
  TfmLog = class(TFrame)
    RectBackground: TRectangle;
    LogList: TScrollBox;
    PopupMenu: TPopupMenu;
    MenuItem_Copy: TMenuItem;
    MenuItem_Sep: TMenuItem;
    MenuItem_Clear: TMenuItem;
    procedure MenuItem_CopyClick(Sender: TObject);
    procedure MenuItem_ClearClick(Sender: TObject);
  private
    background: Boolean;
    procedure App_OnException(Sender: TObject; E: Exception);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddToLog(const Mes, Info: string; const Data: TValue; Color: TAlphaColor);
    procedure ViewChange();
    procedure AddTimeChange();
    procedure Clear();
  end;

implementation
uses
uMain,
FMX.Platform, FMX.Clipboard;

{$R *.fmx}

{ TfrmLog }

constructor TfmLog.Create(AOwner: TComponent);
begin
  inherited;
  Application.OnException := App_OnException;
  background := not False;
end;

procedure TfmLog.App_OnException(Sender: TObject; E: Exception);
begin
  AddToLog('Ошибка', e.Message, nil, TAlphaColors.Red);
end;

procedure TfmLog.AddToLog(const Mes, Info: string; const Data: TValue; Color: TAlphaColor);
var dt: string;
  itm: TLabel;
begin
  LogList.BeginUpdate;
  try
    if LogList.Content.ChildrenCount>1200 then begin
      while LogList.Content.ChildrenCount>1000 do
        LogList.Content.RemoveObject( LogList.Content.Children[0] );
    end;
    //----------------
    DateTimeToString(dt, 'hh:nn:ss:.zzz', Now);
    itm := TLabel.Create(nil);
    itm.BeginUpdate;
    itm.HitTest := True;
    itm.StylesData['EXDATA'] := Data;
    itm.AutoSize := True;
    itm.Margins.Top := 5;
    itm.Margins.Bottom := 5;
    if fMain.AddTime.IsChecked then begin
      itm.Margins.Left := 145;
      itm.StyleLookup := 'LogStyle'
    end else begin
      itm.Margins.Left := 60;
      itm.StyleLookup := 'LogLiteStyle';
    end;
    //itm.StyleLookup := 'LogLabelStyle';
    itm.Text := Mes;
    itm.WordWrap := True;
    itm.StyledSettings := itm.StyledSettings - [TStyledSetting.FontColor];
    itm.TextSettings.FontColor := Color;
    itm.StylesData['info.text'] := Info + ' :';
    itm.StylesData['info.Color'] := Color;
    itm.StylesData['time.text'] := dt;
    itm.StylesData['alt_background.visible'] := background;
    itm.Align := TAlignLayout.Top;
    //itm.Position.Y := Single.MaxValue;
    itm.Position.Y := -(1+LogList.Content.ChildrenCount);
    itm.PopupMenu := PopupMenu;
    itm.EndUpdate;
    LogList.AddObject(itm);
    itm.RecalcSize;
    //ScrollBox.ScrollBy(0, -Single.MaxValue)
    background := not background;
  finally
    LogList.EndUpdate;
  end;
  //ScrollBox.RealignContent;
end;

procedure TfmLog.ViewChange;
var
  buf: AnsiString;
  itm: TFmxObject;
begin
  if LogList.Content.ChildrenCount=0 then exit;
  LogList.BeginUpdate;
  try
    for itm in LogList.Content.Children do
      with itm as TLabel do begin
        if StylesData['EXDATA'].TryAsType<AnsiString>(buf, False) then begin
          BeginUpdate;
          Text := fMain.DataToText(buf);
          //NeedStyleLookup;
          //ApplyStyleLookup;
          EndUpdate;
        end;
      end;
  finally
    LogList.EndUpdate;
  end;
  //ScrollBox.RecalcSize;
  LogList.RealignContent;
end;

procedure TfmLog.AddTimeChange;
var
  itm: TFmxObject;
begin
  if LogList.Content.ChildrenCount=0 then exit;
  LogList.BeginUpdate;
  try
    for itm in LogList.Content.Children do
      with itm as TLabel do begin
        BeginUpdate;
        if fMain.AddTime.IsChecked then begin
          Margins.Left := 145;
          StyleLookup := 'LogStyle'
        end else begin
          Margins.Left := 60;
          StyleLookup := 'LogLiteStyle';
        end;
        NeedStyleLookup;
        //ApplyStyleLookup;
        EndUpdate;
      end;
  finally
    //ScrollBox.ApplyStyleLookup;
    LogList.EndUpdate;
  end;
  //ScrollBox.RecalcSize;
  LogList.RealignContent;
end;

procedure TfmLog.Clear;
begin
  LogList.BeginUpdate;
  LogList.Content.DeleteChildren;
  LogList.RealignContent;
  LogList.EndUpdate;
end;

procedure TfmLog.MenuItem_CopyClick(Sender: TObject);
var o: TFmxObject;
  s,sp: string;
  ClipboardService: IFMXExtendedClipboardService;
begin
  if LogList.Content.ChildrenCount=0 then Exit;
  LogList.BeginUpdate;
  try
    s := '';
    sp := '';
    for o in LogList.Content.Children do
      if o is TLabel then
        with o as TLabel do begin
          s := format('%s%s%s',[Text, sp, s]);
          sp := #10;
        end;
    if s<>'' then
      if TPlatformServices.Current.SupportsPlatformService(IFMXExtendedClipboardService, ClipboardService) then
        ClipboardService.SetText(s);
  finally
    LogList.EndUpdate;
  end;
end;

procedure TfmLog.MenuItem_ClearClick(Sender: TObject);
begin
  Clear;
end;

end.
