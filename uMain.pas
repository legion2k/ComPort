unit uMain;

interface

uses
  uComPort, System.Rtti,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus, FMX.ListBox, FMX.Edit,
  FMX.ComboEdit, FMX.Layouts, FMX.EditBox, FMX.SpinBox, FMX.Objects, FMX.TreeView, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  System.ImageList, FMX.ImgList, System.Actions, FMX.ActnList, uLog;

type
  TfMain = class(TForm)
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    ToolBar: TToolBar;
    Panel1: TPanel;
    LayoutPort: TLayout;
    Label1: TLabel;
    Port: TComboEdit;
    LayoutSpeed: TLayout;
    Label2: TLabel;
    Speed: TComboEdit;
    LayoutDataBits: TLayout;
    Label3: TLabel;
    DataBits: TComboBox;
    LayoutParity: TLayout;
    Label4: TLabel;
    Parity: TComboBox;
    Parity_None: TListBoxItem;
    Parity_Yes: TListBoxItem;
    Parity_No: TListBoxItem;
    Parity_Mark: TListBoxItem;
    Parity_Space: TListBoxItem;
    LayoutStopBits: TLayout;
    Label5: TLabel;
    StopBits: TComboBox;
    Layout6: TLayout;
    Label6: TLabel;
    LineBreake: TComboBox;
    LineBreake_AsIs: TListBoxItem;
    LineBreake_Timer: TListBoxItem;
    LayoutTimer: TLayout;
    Label7: TLabel;
    StyleBook: TStyleBook;
    Timeout: TSpinBox;
    LayoutCD: TLayout;
    Label8: TLabel;
    CD: TRectangle;
    LayoutCTS: TLayout;
    Label9: TLabel;
    CTS: TRectangle;
    LayoutDSR: TLayout;
    Label10: TLabel;
    DSR: TRectangle;
    LayoutRI: TLayout;
    Label11: TLabel;
    RI: TRectangle;
    signalsOut: TGridLayout;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Layout14: TLayout;
    Label14: TLabel;
    View: TComboBox;
    AddTime: TCheckBox;
    View_ASCII: TListBoxItem;
    View_Hex: TListBoxItem;
    View_Dec: TListBoxItem;
    View_Bin: TListBoxItem;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    Layout15: TLayout;
    EditSend: TEdit;
    AddSend: TComboBox;
    BtnSend: TButton;
    Macroses: TButton;
    Macros5: TButton;
    Macros2: TButton;
    Macros4: TButton;
    Macros3: TButton;
    Macros1: TButton;
    Macros10: TButton;
    Macros9: TButton;
    Macros8: TButton;
    Macros7: TButton;
    Macros6: TButton;
    DTR: TCheckBox;
    RTS: TCheckBox;
    BtnRefresh: TSpeedButton;
    BtnOpen: TSpeedButton;
    BtnClose: TSpeedButton;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    LineBreaker: TTimer;
    ImageList: TImageList;
    Actions: TActionList;
    Act_PortOpen: TAction;
    Act_PortClose: TAction;
    Act_PortRefresh: TAction;
    Act_Exit: TAction;
    Act_FileOpen: TAction;
    Act_FileSave: TAction;
    Line1: TLine;
    Line2: TLine;
    SpeedButton1: TSpeedButton;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    Macros18: TButton;
    Macros19: TButton;
    Macros17: TButton;
    Macros16: TButton;
    Macros15: TButton;
    Macros14: TButton;
    Macros13: TButton;
    Macros12: TButton;
    Macros11: TButton;
    Macros20: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    fmLog: TfmLog;
    procedure FormCreate(Sender: TObject);
    procedure MacrosesClick(Sender: TObject);
    procedure MacrosClick(Sender: TObject);
    procedure LineBreakeChange(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure AddTimeChange(Sender: TObject);
    procedure ViewChange(Sender: TObject);
    procedure MacrosDblClick(Sender: TObject);
    procedure DTRChange(Sender: TObject);
    procedure RTSChange(Sender: TObject);
    procedure LineBreakerTimer(Sender: TObject);
    procedure TimeoutChange(Sender: TObject);
    procedure Act_PortOpenExecute(Sender: TObject);
    procedure Act_PortCloseExecute(Sender: TObject);
    procedure Act_PortRefreshExecute(Sender: TObject);
    procedure Act_ExitExecute(Sender: TObject);
    procedure Act_FileOpenExecute(Sender: TObject);
    procedure Act_FileSaveExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure fmLogScrollBoxDblClick(Sender: TObject);
  private
    { Private declarations }
    ComPort: TComPort;
    MuteError: Boolean;
    TimeBuf: TBufStr;
    procedure OnComPortChangeState(Sender: TComPort; State: Boolean);
    procedure OnComPortDataRx(Sender: TComPort; Data: TBufStr);
    procedure OnComPortDataTx(Sender: TComPort; Data: TBufStr);
    procedure OnComPortError(Sender: TComPort; Error: String);
    procedure OnComPortChangeCTS(Sender: TComPort; State: Boolean);
    procedure OnComPortChangeDSR(Sender: TComPort; State: Boolean);
    procedure OnComPortChangeRLSD(Sender: TComPort; State: Boolean);
    procedure OnComPortChangeRI(Sender: TComPort; State: Boolean);
    //
    //procedure AddToLog(Mes, Detail: string; const Data: TValue; Color: TAlphaColor);
    //
    procedure LogItemResize(Item: TListBoxItem);
  public
    function DataToText(const AData: TBufStr): string;
    procedure SendToPort(AData: string; Add: Byte);
  end;

var fMain: TfMain;

implementation
uses  FMX.Styles, uMacros, FMX.Styles.Objects, System.Generics.Collections, System.RegularExpressions, System.IniFiles, System.IOUtils;

{$R *.fmx}

procedure TfMain.FormCreate(Sender: TObject);
begin
  TStyleManager.TrySetStyleFromResource('win10style');// чтоб было одинакого на всех win
  ComPort := TComPort.Create;
  ComPort.OnPortState := OnComPortChangeState;
  ComPort.OnPortError := OnComPortError;
  ComPort.OnPortТx    := OnComPortDataTx;
  ComPort.OnPortRx    := OnComPortDataRx;
  ComPort.OnPortCTS   := OnComPortChangeCTS;
  ComPort.OnPortDSR   := OnComPortChangeDSR;
  ComPort.OnPortRLSD  := OnComPortChangeRLSD;
  ComPort.OnPortRI    := OnComPortChangeRI;
  Act_PortRefresh.Execute;
  //Log.Clear;
  MuteError := False;
  TimeBuf := '';
  // - - -
end;

procedure TfMain.FormShow(Sender: TObject);
var ini: TIniFile;
  c: TComponent;
begin
  ini := TIniFile.Create( System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetHomePath, 'ComPort.ini'));
  try
    Height := ini.ReadInteger('0', 'h', Height);
    Width := ini.ReadInteger('0', 'w', Width);
    Left := ini.ReadInteger('0', 'x', Left);
    Top := ini.ReadInteger('0', 'y', Top);
    if ini.ReadBool('0', 'max', False) then WindowState := TWindowState.wsMaximized;
    //
    EditSend.Text := ini.ReadString ('-', 'e', EditSend.Text);
    AddSend.ItemIndex := ini.ReadInteger('-', 'c', AddSend.ItemIndex);
    Speed.Text := ini.ReadString('-', 'sp', Speed.Text);
    DataBits.ItemIndex := ini.ReadInteger('-', 'db', DataBits.ItemIndex);
    Parity.ItemIndex := ini.ReadInteger('-', 'pr', Parity.ItemIndex);
    StopBits.ItemIndex := ini.ReadInteger('-', 'sb', StopBits.ItemIndex);
    DTR.IsChecked := ini.ReadBool('-', 'dtr', DTR.IsChecked);
    RTS.IsChecked := ini.ReadBool('-', 'rts', RTS.IsChecked);
    View.ItemIndex := ini.ReadInteger('-', 'v', View.ItemIndex);
    AddTime.IsChecked := ini.ReadBool('-', 't', AddTime.IsChecked);
    LineBreake.ItemIndex := ini.ReadInteger('-', 'lb', LineBreake.ItemIndex);
    Timeout.Value := ini.ReadInteger('-', 'tm',  Round(Timeout.Value));
    //
    for var i := 1 to 20 do begin
      c := fMacroses.FindComponent('Edit'+i.ToString);
      (c as TEdit).Text := ini.ReadString ('e', i.ToString, (c as TEdit).Text);
      c := fMacroses.FindComponent('ComboBox'+i.ToString);
      (c as TComboBox).ItemIndex := ini.ReadInteger('c', i.ToString, (c as TComboBox).ItemIndex);
      c := fMacroses.FindComponent('SpinBox'+i.ToString);
      (c as TSpinBox).Value := ini.ReadInteger('s', i.ToString, Round((c as TSpinBox).Value));
      c := fMacroses.FindComponent('CheckBox'+i.ToString);
      (c as TCheckBox).IsChecked := ini.ReadBool('h', i.ToString, (c as TCheckBox).IsChecked);
    end;
  finally
    FreeAndNil(ini);
  end;
end;

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var ini: TIniFile;
begin
  FreeAndNil(ComPort);//если переместить на destroy - ошибка - не может отработать метод OnComPortError;
  ini := TIniFile.Create( System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetHomePath, 'ComPort.ini'));
  //ini := TIniFile.Create( 'ComPort.ini');
  try
    ini.WriteBool   ('0', 'max', WindowState=TWindowState.wsMaximized);
    if WindowState<>TWindowState.wsMaximized then begin
      ini.WriteInteger('0', 'h', Height);
      ini.WriteInteger('0', 'w', Width);
      ini.WriteInteger('0', 'x', Left);
      ini.WriteInteger('0', 'y', Top);
    end;
    //
    ini.WriteString ('-', 'e',   EditSend.Text);
    ini.WriteInteger('-', 'c',   AddSend.ItemIndex);
    ini.WriteString ('-', 'sp',  Speed.Text);
    ini.WriteInteger('-', 'db',  DataBits.ItemIndex);
    ini.WriteInteger('-', 'pr',  Parity.ItemIndex);
    ini.WriteInteger('-', 'sb',  StopBits.ItemIndex);
    ini.WriteBool   ('-', 'dtr', DTR.IsChecked);
    ini.WriteBool   ('-', 'rts', RTS.IsChecked);
    ini.WriteInteger('-', 'v',   View.ItemIndex);
    ini.WriteBool   ('-', 't',   AddTime.IsChecked);
    ini.WriteInteger('-', 'lb',  LineBreake.ItemIndex);
    ini.WriteInteger('-', 'tm',  Round(Timeout.Value));
    //
    for var i := 1 to 10 do begin
      ini.WriteString ('e', i.ToString, (fMacroses.FindComponent('Edit'+i.ToString) as TEdit).Text);
      ini.WriteInteger('c', i.ToString, Round((fMacroses.FindComponent('ComboBox'+i.ToString) as TComboBox).ItemIndex));
      ini.WriteInteger('s', i.ToString, Round((fMacroses.FindComponent('SpinBox'+i.ToString) as TSpinBox).Value));
      ini.WriteBool   ('h', i.ToString, (fMacroses.FindComponent('CheckBox'+i.ToString) as TCheckBox).IsChecked);
    end;
  finally
    FreeAndNil(ini);
  end;
end;

procedure TfMain.Act_ExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfMain.Act_FileOpenExecute(Sender: TObject);
var ini: TIniFile;
begin
  if not OpenDlg.Execute then exit;
  ini := TIniFile.Create(OpenDlg.FileName);
  try
    for var i := 1 to 10 do begin
      (fMacroses.FindComponent('Edit'+i.ToString) as TEdit).Text := ini.ReadString('e', i.ToString, '');
      (fMacroses.FindComponent('ComboBox'+i.ToString) as TComboBox).ItemIndex := ini.ReadInteger('c', i.ToString, 0);
      (fMacroses.FindComponent('SpinBox'+i.ToString) as TSpinBox).Value := ini.ReadInteger('s', i.ToString, 1000);
      (fMacroses.FindComponent('CheckBox'+i.ToString) as TCheckBox).IsChecked := ini.ReadBool('h', i.ToString, False);
    end;
  finally
    FreeAndNil(ini);
  end;
end;

procedure TfMain.Act_FileSaveExecute(Sender: TObject);
var ini: TIniFile;
begin
  if not SaveDlg.Execute then exit;
  ini := TIniFile.Create(SaveDlg.FileName);
  try
    for var i := 1 to 10 do begin
      ini.WriteString ('e', i.ToString, (fMacroses.FindComponent('Edit'+i.ToString) as TEdit).Text);
      ini.WriteInteger('c', i.ToString, Round((fMacroses.FindComponent('ComboBox'+i.ToString) as TComboBox).ItemIndex));
      ini.WriteInteger('s', i.ToString, Round((fMacroses.FindComponent('SpinBox'+i.ToString) as TSpinBox).Value));
      ini.WriteBool   ('h', i.ToString, (fMacroses.FindComponent('CheckBox'+i.ToString) as TCheckBox).IsChecked);
    end;
  finally
    FreeAndNil(ini);
  end;
end;

procedure TfMain.MacrosesClick(Sender: TObject);
begin
  fMacroses.ShowModal;
end;

procedure TfMain.Act_PortRefreshExecute(Sender: TObject);
begin
  Port.Clear;
  GetComPortsList(Port.Items);
  Port.ItemIndex := 0;
end;

procedure TfMain.Act_PortOpenExecute(Sender: TObject);
var e: Integer;
  spd: DWORD;
begin
//  Speed.Text.ToInteger,
  Val(Speed.Text, spd, e);
  if e<>0 then begin
    spd := 9600;
    Speed.Text := spd.ToString;
  end;
  ComPort.OpenPort(Port.Text, spd, DataBits.Selected.Tag, Parity.Selected.Tag, StopBits.Selected.Tag)
end;

procedure TfMain.Act_PortCloseExecute(Sender: TObject);
begin
  ComPort.ClosePort;
end;

procedure TfMain.OnComPortChangeState(Sender: TComPort; State: Boolean);
var i: Integer;
  b: TComponent;
begin
  Act_PortRefresh.Enabled := not State;
  Act_PortOpen.Enabled := not State;
  Act_PortClose.Enabled := State;
  LayoutPort.Enabled := not State;
  LayoutSpeed.Enabled := not State;
  LayoutDataBits.Enabled := not State;
  LayoutParity.Enabled := not State;
  LayoutStopBits.Enabled := not State;

  if State then begin
    BtnRefresh.Opacity := 0.3;
    BtnOpen.Opacity := 0.3;
    BtnClose.Opacity:= 1;
    ComPort.LineDTR := DTR.IsChecked;
    ComPort.LineRTS := RTS.IsChecked;
    CD.Fill.Color := TAlphaColors.White;
    CTS.Fill.Color := TAlphaColors.White;
    DSR.Fill.Color := TAlphaColors.White;
    RI.Fill.Color := TAlphaColors.White;
    for i:=1 to 10 do begin
      b := fMacroses.FindComponent('CheckBox'+i.ToString);
      (b as TCheckBox).OnChange := fMacroses.CheckBoxChange;
      fMacroses.CheckBoxChange(b);
    end;
    fmLog.AddToLog(format('Открыт порт «%s»', [Sender.ComPort]),'Инфо', tvalue.Empty, TAlphaColors.Blue);
  end else begin
    BtnRefresh.Opacity := 1;
    BtnOpen.Opacity := 1;
    BtnClose.Opacity:= 0.3;
    CD.Fill.Color := $FFE0E0E0;
    CTS.Fill.Color := $FFE0E0E0;
    DSR.Fill.Color := $FFE0E0E0;
    RI.Fill.Color := $FFE0E0E0;
    for i:=1 to 10 do begin
      b := fMacroses.FindComponent('CheckBox'+i.ToString);
      (b as TCheckBox).OnChange := fMacroses.CheckBoxChangeLite;
      b := fMacroses.FindComponent('Timer'+i.ToString);
      (b as TTimer).Enabled := False
    end;
    fmLog.AddToLog(format('Закрыт порт «%s»', [Sender.ComPort]),'Инфо', tvalue.Empty, TAlphaColors.Blue);
    LineBreaker.Enabled := False;
  end;
end;

procedure TfMain.DTRChange(Sender: TObject);
begin
  MuteError := not False;
  ComPort.LineDTR := DTR.IsChecked;
  MuteError := False;
end;

procedure TfMain.fmLogScrollBoxDblClick(Sender: TObject);
begin
  fmLog.Clear;
end;

procedure TfMain.RTSChange(Sender: TObject);
begin
  MuteError := not False;
  ComPort.LineRTS := RTS.IsChecked;
  MuteError := False;
end;

procedure TfMain.OnComPortChangeCTS(Sender: TComPort; State: Boolean);
begin
  if State then CTS.Fill.Color := TAlphaColors.Lime
  else          CTS.Fill.Color := TAlphaColors.White
end;

procedure TfMain.OnComPortChangeDSR(Sender: TComPort; State: Boolean);
begin
  if State then DSR.Fill.Color := TAlphaColors.Lime
  else          DSR.Fill.Color := TAlphaColors.White
end;

procedure TfMain.OnComPortChangeRI(Sender: TComPort; State: Boolean);
begin
  if State then RI.Fill.Color := TAlphaColors.Lime
  else          RI.Fill.Color := TAlphaColors.White
end;

procedure TfMain.OnComPortChangeRLSD(Sender: TComPort; State: Boolean);
begin
  if State then CD.Fill.Color := TAlphaColors.Lime
  else          CD.Fill.Color := TAlphaColors.White
end;

procedure TfMain.ViewChange(Sender: TObject);
begin
  fmLog.ViewChange;
end;

procedure TfMain.AddTimeChange(Sender: TObject);
begin
  fmLog.AddTimeChange;
end;

procedure TfMain.LogItemResize(Item: TListBoxItem);
begin
  var h := Item.StylesData['text.Height'];
  if not h.IsEmpty then
    Item.Height := h.AsExtended + Item.StylesData['text.Position.Y'].AsExtended + Item.StylesData['text.Margins.Bottom'].AsExtended;
end;

procedure TfMain.OnComPortError(Sender: TComPort; Error: String);
begin
  if not MuteError then
    fmLog.AddToLog(Error, 'Ошибка', TValue.Empty, TAlphaColors.Red);
end;

procedure TfMain.OnComPortDataTx(Sender: TComPort; Data: TBufStr);
begin
  fmLog.AddToLog(DataToText(Data), 'Tx', TValue.From<TBufStr>(Data), TAlphaColors.Blueviolet)
end;

procedure TfMain.OnComPortDataRx(Sender: TComPort; Data: TBufStr);
begin
  if LineBreake.Selected = LineBreake_AsIs then begin
    TimeBuf := Data;
    LineBreakerTimer(nil);
  end else begin
    LineBreaker.Enabled := False;
    TimeBuf := TimeBuf + Data;
    LineBreaker.Enabled := True;
  end;
end;
procedure TfMain.LineBreakerTimer(Sender: TObject);
begin
  LineBreaker.Enabled := False;
  fmLog.AddToLog(DataToText(TimeBuf), 'Rx', TValue.From<TBufStr>(TimeBuf), TAlphaColors.Green);
  TimeBuf := '';
end;

procedure TfMain.LineBreakeChange(Sender: TObject);
begin
  if LayoutTimer.Enabled and (TimeBuf<>'') and ComPort.Connected then
    LineBreakerTimer(nil);
  //LayoutTimer.Enabled := LineBreake.Selected=LineBreake_Timer;
end;

procedure TfMain.TimeoutChange(Sender: TObject);
begin
  LineBreaker.Interval := Round(Timeout.Value);
end;

function TfMain.DataToText(const AData: TBufStr): string;
var
  i: Integer;
  aBytes : TArray<Byte> absolute AData;
begin
//  if Length(Data)>1024 then
//    SetLength(Data,1024);
  if View.Selected=View_ASCII then begin
    Result := UnicodeString(AData);
//  end else if View.Selected=View_OEM then begin
//    Result := Data;
  end else begin
    var space := '';
    var l := length(AData)-1;
    Result := '';
    if View.Selected=View_Hex then begin
      for i:=0 to l do begin
        //Result :=  Format('%s%s$%0x',[Result, Space, aBytes[i]]);
        Result :=  Format('%s%s$%s',[Result, Space, aBytes[i].ToHexString(2)]);
        space := ' ';
      end;
    end else if View.Selected=View_Dec then begin
      for i:=0 to l do begin
        Result :=  Format('%s%s%u',[Result, Space, aBytes[i]]);
        space := ' ';
      end;
    end else if View.Selected=View_Bin then begin
      for i:=0 to l do begin
        Result :=  Format('%s%sb%d%d%d%d%d%d%d%d',[Result, Space,
          NativeInt((aBytes[i] and 128)>0), NativeInt((aBytes[i] and 64)>0),
          NativeInt((aBytes[i] and 32)>0), NativeInt((aBytes[i] and 16)>0),
          NativeInt((aBytes[i] and 8)>0), NativeInt((aBytes[i] and 4)>0),
          NativeInt((aBytes[i] and 2)>0), NativeInt((aBytes[i] and 1)>0)]);
        space := ' ';
      end;
    end;
  end;
end;

procedure TfMain.BtnSendClick(Sender: TObject);
begin
  SendToPort(EditSend.Text, AddSend.ItemIndex);
end;

//procedure TfMain.Button1Click(Sender: TObject);
//begin
//  for var i := 0 to 30 do
//    fmLog.AddToLog(i.ToString,'asd', nil, TAlphaColors.Black);
//end;
//
//procedure TfMain.Button2Click(Sender: TObject);
//begin
//  Caption := fmLog.LogList.Content.ChildrenCount.ToString;
//  if fmLog.LogList.Content.Children<>nil then
//    Button2.Text := fmLog.LogList.Content.Children.Count.ToString;
//
//  var i := 0;
////  for var o in fmLog.LogList.Content.Children do begin
////    fmLog.LogList.Content.RemoveObject( o );
////    inc(i);
////    if i>10 then
////      Break
////  end;
//  //for i:=10 downto 0 do begin
//  for i:=0 to 10 do begin
//    fmLog.LogList.Content.RemoveObject( fmLog.LogList.Content.Children[0] );
//  end;
//end;

//Function CRC16(Data: AnsiString): word;
// const Polinominal=$A001;
// var i,j,cnt: Integer;
//begin
// Result := $FFFF; cnt := length(Data) + 1;
//  i := 1;
//  while i < cnt do
//  begin
//    Result := (Result and $FF00) or (Lo(Result) xor ord(Data[i]));
//    for j := 1 to 8 do
//    begin
//      if (Result and $0001) <> 0 then Result := (Result shr 1) xor Polinominal
//      else Result := Result shr 1;
//    end;
//    inc(i);
//  end;
//end;

Function CRC16Mb(SData: TBufStr): AnsiString;
const
  Polinominal = $A001;
var
  i, j, cnt: Integer;
  crc: UInt16;
  aData: TArray<Byte> absolute SData;
  aCRC: Array[0..1] of AnsiChar absolute crc;
begin
  crc := $FFFF;
  cnt := length(SData)-1;
  for i:=0 to cnt do begin
    crc := (crc and $FF00)or(Lo(crc) xor aData[i]);
    for j := 1 to 8 do begin
      if (crc and $0001)<>0 then
        crc := (crc shr 1) xor Polinominal
      else
        crc := crc shr 1;
    end;
  end;
  //младший потом старший
  Result := aCRC[0] + aCRC[1];
end;
Function CRC16(SData: AnsiString): AnsiString;
var i,j,cnt: Integer;
  crc: UInt16;
  aData: TArray<Byte> absolute SData;
  aCRC: Array[0..1] of AnsiChar absolute crc;
begin
  crc := 0;
  cnt := length(SData)-1;
  for i:=0 to cnt do begin
    crc := crc xor ((aData[i] shl 8)and $FFFF);
    for j:=1 to 8 do
      if (crc and $8000)<>0 then
        crc := ((crc shl 1)and $FFFF) xor $1021
      else
        crc := ((crc shl 1)and $FFFF)
  end;
  Result := aCRC[1] + aCRC[0];
end;


//function  WordToBytes(val: UInt16): TBufStr;
//begin //младший потом старший
//  Result := TBufChar(val and $ff) + TBufChar((val shr 8) and $ff);
//end;

type
  Win1251String = type AnsiString(1251);

procedure TfMain.SendToPort(AData: string; Add: Byte);
var buf: TBufStr;
  reFullWrap, reMinWrap, reNoneHex, reHex, reDoubleWrpSmbl: TRegEx;
  m: TMatchCollection;
  m2,m3: TMatch;
  dig: string;
  i: Integer;
begin
  // ищет строку, начинающуюся с нечетного количества '[' из заканчивающуюся на ']'
  reFullWrap := TRegEx.Create('(?<!\[)(\[{2})*\[(?!\[).*?\]');
  // в найденной строке(после reFullWrap), ищет, непосредственно, строку '[ кикие-то символы ]'
  reMinWrap := TRegEx.Create('\[(?!\[).*?]');
  // в найденной строке(после reMinWrap), удаляет все симолы не относящиеся к HEX
  reNoneHex := TRegEx.Create('(?i)[^abcdef\d]');
  // в полученной строке(после reNoneHex), производит группировка символов парно, а если у последнего символа нет пары, то он идет один
  reHex := TRegEx.Create('(?i)[abcdef\d]{2}|[abcdef\d]');
  // заменяет в итоговом
  reDoubleWrpSmbl := TRegEx.Create('\[\[');
  //---------
  // ищет все строки, начинающуюся с нечетного количества '[' из заканчивающуюся на ']'
  m := reFullWrap.Matches(AData);
  for i:=m.Count-1 downto 0 do begin
    // в найденной строке, ищем, непосредственно, подстроку '[кикие-то символы]'
    m2 := reMinWrap.Match(m[i].Value);
    dig := '';
    // в найденной подстроку, удаляет все симолы не относящиеся к HEX и группируем симолы Hex
    for m3 in reHex.Matches(reNoneHex.Replace(m2.Value, '')) do
      //преодразовываем в код
      dig := dig + TBufChar(StrToUInt('$'+m3.Value));
    // формируем новую подстраку
    dig := Copy(m[i].Value, 1, m2.Index-1) + dig;
    // формируем строку
    AData := Copy(AData, 1, m[i].Index-1) + dig + Copy(AData, m[i].Index+m[i].Length, length(AData)-(m[i].Index+m[i].Length)+1 );
  end;
  AData := reDoubleWrpSmbl.Replace(AData,'[');
  buf := Win1251String(AData);
  //------------------
  case Add of
    //0: //pass
    1: buf := buf + CRC16(buf);
    2: buf := buf + CRC16Mb(buf);
    3: buf := buf + #$A;
    4: buf := buf + #$D + #$A;
    5: buf := buf + #$D;
  //else pass
  end;
  ComPort.WriteToPort(buf);
end;

procedure TfMain.MacrosClick(Sender: TObject);
begin
  if Sender is TButton then begin
    var b := (Sender as TButton);
    var bb := fMacroses.FindComponent('Button' + b.Tag.ToString) as TButton;
    fMacroses.ButtonClick(bb);
  end;
end;

procedure TfMain.MacrosDblClick(Sender: TObject);
begin
  if Sender is TButton then begin
    var b := (Sender as TButton);
    var t := fMacroses.FindComponent('CheckBox' + b.Tag.ToString) as TCheckBox;
    if t.Enabled then
      t.IsChecked := not t.IsChecked;
  end;
end;

end.
