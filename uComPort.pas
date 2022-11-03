unit uComPort;

interface
uses System.Classes, System.SyncObjs, Winapi.Windows, Winapi.Messages;

procedure GetComPortsList(const List: TStrings);

type
  TBufStr = AnsiString;
  PBufStr = ^TBufStr;
  TBufChar = AnsiChar;
  PBufChar = ^TBufChar;

  TComPort = class;

  TEventPort             = procedure(Sender: TComPort) of object;
  TEventPortDate         = procedure(Sender: TComPort; Data: TBufStr) of object;
  TEventPortError        = procedure(Sender: TComPort; Error: String) of object;
  TEventPortChangedState = procedure(Sender: TComPort; State: Boolean) of object;

  TComPort = class
  private type
    _TPortAction = class(TThread)
    private
      Event: TEvent;
      hMsg: HWND;
      Pause: Boolean;
      hPort : THandle;
      procedure Execute; override;
    protected
      OVERLAPPED: TOverlapped;
      procedure TerminatedSet; override;
      procedure Proccess(); virtual; abstract;
      procedure SendMes(wmMes: UINT; wParam: WPARAM; lParam: LPARAM);
    public
      constructor Create(hMes: HWND); virtual;
      destructor Destroy; override;
      procedure StartProc(hComPort: THandle);
      procedure StopProc();
    end;
    _TPortRead = class(_TPortAction)
    protected
      procedure Proccess(); override;
    end;
    _TPortWrite = class(_TPortAction)
    private
      buf: TBufStr;
      evnt: TEvent;
    protected
      procedure Proccess(); override;
      procedure TerminatedSet; override;
    public
      function WriteToPort(const Data: TBufStr): Boolean;
      constructor Create(hMes: HWND); override;
      destructor Destroy; override;
    end;
  private
    hPort : THandle;
    sPort : AnsiString;
    //
    _LineRTS: Boolean;
    _LineDTR: Boolean;
    EvOnPortTx:     TEventPortDate;
    EvOnPortRx:     TEventPortDate;
    EvOnPortError:  TEventPortError;
    EvOnChangeCTS:  TEventPortChangedState;
    EvOnChangeDSR:  TEventPortChangedState;
    EvOnChangeRLSD: TEventPortChangedState;
    EvOnChangeRI:   TEventPortChangedState;
    EvOnPortState:  TEventPortChangedState; // OnPortState(true)- открыт // OnPortState(false)- закрыт
    //
    hMsg: HWND;
    Rx: _TPortRead;
    Tx: _TPortWrite;
    //
    function _ClearCommError_(var lpError: DWORD; var lpState: TComStat): Boolean;
    function _EscapeCommFunction_(dwFunc: DWORD): Boolean;
    function _GetCommState_(var lpDCB: TDCB): Boolean;
    function _SetCommState_(const lpDCB: TDCB): Boolean;
    function _GetCommTimeouts_(var lpCommTimeouts: TCommTimeouts): Boolean;
    function _SetCommTimeouts_(const lpCommTimeouts: TCommTimeouts): Boolean;
    function _PurgeComm_(dwFlags: DWORD): Boolean;
    function _GetCommModemStatus_(var lpModemStat: DWORD): Boolean;
    //
    procedure _ErrorCode_(ErrorIndex: byte; ResultOfGetLastError: DWORD=0);
    //
    function _GetLineCTS(): Boolean;
    function _GetLineDSR(): Boolean;
    function _GetLineRLSD(): Boolean;
    function _GetLineRI(): Boolean;
    //
    procedure _SetLineDTR(State: Boolean);
    procedure _SetLineRTS(State: Boolean);
    //
    function _CheckConnection(): Boolean;
    //
    procedure MsgDispatcher(var Msg: TMessage);
    //
  public
    constructor Create();
    destructor Destroy; override;
    property ComPort: AnsiString read sPort;
    function OpenPort(const AComPort:AnsiString; BaudRate:DWORD=CBR_9600; ByteSize:Byte=8; Parity:Byte=NOPARITY; StopBits:Byte=ONESTOPBIT): Boolean;
    function ClosePort: Boolean;
    function Connected: Boolean;
    procedure RefreshStateOfLines; // ответ см. OnChangedLines
    function WriteToPort(const Data: TBufStr): Boolean;
    //
    property LineCTS:  Boolean read _GetLineCTS;
    property LineDSR:  Boolean read _GetLineDSR;
    property LineRLSD: Boolean read _GetLineRLSD;
    property LineRI:   Boolean read _GetLineRI;
    //
    property LineDTR:  Boolean read _LineDTR write _SetLineDTR;
    property LineRTS:  Boolean read _LineRTS write _SetLineRTS;
    //
    property OnPortState: TEventPortChangedState read EvOnPortState write EvOnPortState;
    property OnPortТx:    TEventPortDate read EvOnPortTx write EvOnPortTx;
    property OnPortRx:    TEventPortDate read EvOnPortRx write EvOnPortRx;
    property OnPortCTS:   TEventPortChangedState read EvOnChangeCTS write EvOnChangeCTS;
    property OnPortDSR:   TEventPortChangedState read EvOnChangeDSR write EvOnChangeDSR;
    property OnPortRLSD:  TEventPortChangedState read EvOnChangeRLSD write EvOnChangeRLSD;
    property OnPortRI:    TEventPortChangedState read EvOnChangeRI write EvOnChangeRI;
    property OnPortError: TEventPortError read EvOnPortError write EvOnPortError;
    //
  end;


implementation
uses System.SysUtils, System.Win.Registry;

const
  wm_Error       = wm_User;
  wm_ErrorStr    = wm_Error + 1;
  wm_PortRx      = wm_ErrorStr + 1;
  wm_PortSignals = wm_PortRx + 1;
  wm_ClosePort   = wm_PortSignals + 1;

//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
procedure GetComPortsList(const List: TStrings);
var reg: TRegIniFile;
  lst: TStrings;
  s: string;
  i: Integer;
  h: THandle;
begin
  List.Clear;
  try
    reg := TRegIniFile.Create(KEY_READ);
    lst := TStringList.Create();
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then begin
        reg.ReadSection('', lst);
        for s in lst do
          List.Add(reg.ReadString('', s, s));
      end else
        raise Exception.Create('notFind');
    finally
      FreeAndNil(reg);
      FreeAndNil(lst);
    end;
  except
    // ошибка чтения реестра или небостаточный уровень доступа
    // пробуем открыть порты с 1 по ComPortMax для проверки на существование
    for i := 1 to 15 do
    begin
      s := format('\\.\COM%d', [i]);
      h := CreateFileA(LPCSTR(AnsiString(s)), GENERIC_READ, 0, nil, OPEN_EXISTING, 0, 0);
      if (h <> INVALID_HANDLE_VALUE) and (h <> 0) then
      begin
        List.Add(s);
        CloseHandle(h);
      end;
    end;
  end;

end;
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------

{ TComPort }

constructor TComPort.Create;
begin
  inherited Create;
  hPort          := INVALID_HANDLE_VALUE;
  sPort          := '';
  //
  EvOnPortTx     := nil;
  EvOnPortRx     := nil;
  EvOnPortError  := nil;
  EvOnChangeCTS  := nil;
  EvOnChangeDSR  := nil;
  EvOnChangeRLSD := nil;
  EvOnChangeRI   := nil;
  EvOnPortState  := nil;
  _LineRTS       := False;
  _LineDTR       := False;

  //
  hMsg := AllocateHWnd(MsgDispatcher);
  //
  Rx := _TPortRead.Create(hMsg);
  Tx := _TPortWrite.Create(hMsg);
end;

destructor TComPort.Destroy;
begin
  if Connected then
    ClosePort;
  //
  Rx.Terminate;
  Tx.Terminate;
  Rx := nil;
  Tx := nil;
  //
  DeallocateHWnd(hMsg);
  //
  inherited;
end;

procedure TComPort.MsgDispatcher(var Msg: TMessage);
var pStr: ^String;
  pBuf: ^TBufStr;
begin
  case Msg.Msg of
    wm_Error:
      _ErrorCode_(Msg.LParam, Msg.WParam);
    wm_ErrorStr:
      begin
        if Assigned(EvOnPortError) then
        begin
          pStr := Pointer(Msg.LParam);
          EvOnPortError(Self, pStr^);
        end;
      end;
    wm_PortRx:
      begin
        if Assigned(EvOnPortRx) then
        begin
          pBuf := Pointer(Msg.LParam);
          EvOnPortRx(Self, pBuf^);
        end;
      end;
    wm_PortSignals:
      begin
        if Assigned(EvOnChangeCTS) then
          EvOnChangeCTS(Self, (Msg.WParam and MS_CTS_ON)=MS_CTS_ON);
        if Assigned(EvOnChangeDSR) then
          EvOnChangeDSR(Self, (Msg.WParam and MS_DSR_ON)=MS_DSR_ON);
        if Assigned(EvOnChangeRLSD) then
          EvOnChangeRLSD(Self, (Msg.WParam and MS_RLSD_ON)=MS_RLSD_ON);
        if Assigned(EvOnChangeRI) then
          EvOnChangeRI(Self, (Msg.WParam and MS_RING_ON)=MS_RING_ON);
      end;
    wm_ClosePort:
      ClosePort;
  end;
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function TComPort.OpenPort(const AComPort: AnsiString; BaudRate: DWORD; ByteSize, Parity, StopBits: Byte): Boolean;
var e:   DWORD;
  DCB:   TDCB;
  TmOut: TCommTimeouts;
begin
  Result := (hPort=0) or (hPort=INVALID_HANDLE_VALUE);
  if not Result then begin
    _ErrorCode_(2, 0);
    Exit;
  end;
  sPort := AComPort;//нужно для сообщения об ошибке
  hPort := CreateFileA(PAnsiChar('\\.\' + AComPort), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  // Port_Hndl := CreateFile(PWideChar(pwc), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  Result :=  (hPort<>0) and (hPort<>INVALID_HANDLE_VALUE);
  if not Result then begin// если ошибка порта !!!!
    e := GetLastError;
    case e of
      ERROR_FILE_NOT_FOUND: _ErrorCode_(8, 0);
      ERROR_ACCESS_DENIED:  _ErrorCode_(9, 0);
    else
      _ErrorCode_(0, e);
    end;
    sPort := '';
  end else begin // порт открыт !!!!
    SetCommMask(hPort, EV_CTS or EV_DSR or EV_RLSD or EV_RING or EV_BREAK or EV_ERR or EV_RXCHAR);
    _GetCommState_(DCB);
    DCB.BaudRate := BaudRate;
    DCB.ByteSize := ByteSize;
    DCB.Parity := Parity;
    DCB.StopBits := StopBits;
    DCB.Flags := $0001 or $0002 or $0010 or $1000; // 4113 = $1011
    // |        |        |        |
    // |        |        |        RTS_CONTROL_ENABLE- разрешает "вручную" управлять (EscapeCommFunction) модемной линией RTS.
    // |        |        DTR_CONTROL_ENABLE - разрешает "вручную" управлять (EscapeCommFunction) модемной линией DTR.С остальными значениями не приходилось сталкиваться.
    // |      	"1" - есть контроль четности по принципу значения поля Parity(см.далее), "0" - нет контроля четности (фактически при передаче не добавляется бит четности).
    // Включает двоичный режим обмена. Другого и не поддерживается, поэтому всегда = "1".
    _SetCommState_(DCB);
    //
    TmOut.ReadIntervalTimeout := INFINITE;
    TmOut.ReadTotalTimeoutMultiplier := 0;
    TmOut.ReadTotalTimeoutConstant := 0;
    TmOut.WriteTotalTimeoutMultiplier := 0;
    TmOut.WriteTotalTimeoutConstant := 0;
    _SetCommTimeouts_(TmOut);
    //
//    LineRTS := False;
//    LineDTR := False;
    //
    Rx.StartProc(hPort);
    Tx.StartProc(hPort);
    //
    if Assigned(EvOnPortState) then
      EvOnPortState(Self, True);
    RefreshStateOfLines;
  end;
end;

procedure TComPort.RefreshStateOfLines;
var lpModemStat: DWORD;
begin
  if not _GetCommModemStatus_(lpModemStat) then begin
    _ErrorCode_(0, GetLastError);
    Exit;
  end;
  if Assigned(EvOnChangeCTS) then
    EvOnChangeCTS(Self, (lpModemStat and MS_CTS_ON)=MS_CTS_ON);
  if Assigned(EvOnChangeDSR) then
    EvOnChangeDSR(Self, (lpModemStat and MS_DSR_ON)=MS_DSR_ON);
  if Assigned(EvOnChangeRLSD) then
    EvOnChangeRLSD(Self, (lpModemStat and MS_RLSD_ON)=MS_RLSD_ON);
  if Assigned(EvOnChangeRI) then
    EvOnChangeRI(Self, (lpModemStat and MS_RING_ON)=MS_RING_ON);
end;

function TComPort.WriteToPort(const Data: TBufStr): Boolean;
var ok: Boolean;
begin
  if Assigned(OnPortТx) then
    OnPortТx(Self, Data);
  TThread.Synchronize(Tx, procedure begin
      ok := Tx.WriteToPort(Data);
  end);
  Result := ok;
  //if ok then
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function TComPort.ClosePort: Boolean;
begin
  Result := (hPort<>0) and (hPort<>INVALID_HANDLE_VALUE);
  if not Result then Exit;
  Rx.StopProc;
  Tx.StopProc;
  Result := CloseHandle(hPort);
  hPort := INVALID_HANDLE_VALUE;
  if Assigned(EvOnPortState) then
    EvOnPortState(Self, False);
  sPort := '';
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function TComPort.Connected: Boolean;
var lpState: TComStat;
  lpError: DWORD;
begin
  Result := (hPort<>0) and (hPort<>INVALID_HANDLE_VALUE);
  if not Result then exit;
  Result := _ClearCommError_(lpError, lpState);
  if not Result then
    if (GetLastError in [ERROR_INVALID_HANDLE, ERROR_ACCESS_DENIED]) then
      ClosePort;
end;

function TComPort._CheckConnection: Boolean;
begin
  Result := (hPort<>0) and (hPort<>INVALID_HANDLE_VALUE);
  if not Result then
    _ErrorCode_(1)
end;

//------------------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------------------------------------
function TComPort._GetLineCTS: Boolean;
var lpModemStat: DWORD;
begin
  if _GetCommModemStatus_(lpModemStat) then
    Result := (lpModemStat and MS_CTS_ON)=MS_CTS_ON
  else begin
    _ErrorCode_(0, GetLastError);
    Result := False;
  end;
end;
function TComPort._GetLineDSR: Boolean;
var lpModemStat: DWORD;
begin
  if _GetCommModemStatus_(lpModemStat) then
    Result := (lpModemStat and MS_DSR_ON)=MS_DSR_ON
  else begin
    _ErrorCode_(0, GetLastError);
    Result := False;
  end;
end;
function TComPort._GetLineRI: Boolean;
var lpModemStat: DWORD;
begin
  if _GetCommModemStatus_(lpModemStat) then
    Result := (lpModemStat and MS_RING_ON)=MS_RING_ON
  else begin
    _ErrorCode_(0, GetLastError);
    Result := False;
  end;
end;
function TComPort._GetLineRLSD: Boolean;
var lpModemStat: DWORD;
begin
  if _GetCommModemStatus_(lpModemStat) then
    Result := (lpModemStat and MS_RLSD_ON)=MS_RLSD_ON
  else begin
    _ErrorCode_(0, GetLastError);
    Result := False;
  end;
end;
//------------------------------------------------------------------------------------------------------------------------------------------
procedure TComPort._SetLineDTR(State: Boolean);
begin
  _LineDTR := State;
  if _LineDTR then _EscapeCommFunction_(SETDTR)
  else          _EscapeCommFunction_(CLRDTR);
end;
procedure TComPort._SetLineRTS(State: Boolean);
begin
  _LineRTS := State;
  if _LineRTS then _EscapeCommFunction_(SETRTS)
  else          _EscapeCommFunction_(CLRRTS);
end;
//------------------------------------------------------------------------------------------------------------------------------------------
function TComPort._ClearCommError_(var lpError: DWORD; var lpState: TComStat): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := ClearCommError(hPort, lpError, @lpState);
end;
function TComPort._EscapeCommFunction_(dwFunc: DWORD): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := EscapeCommFunction(hPort, dwFunc);
end;
function TComPort._GetCommModemStatus_(var lpModemStat: DWORD): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
   Result := GetCommModemStatus(hPort, lpModemStat);
end;
function TComPort._GetCommState_(var lpDCB: TDCB): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := GetCommState(hPort, lpDCB);
end;
function TComPort._GetCommTimeouts_(var lpCommTimeouts: TCommTimeouts): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := GetCommTimeouts(hPort, lpCommTimeouts);
end;
function TComPort._PurgeComm_(dwFlags: DWORD): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := PurgeComm(hPort, dwFlags);
end;
function TComPort._SetCommState_(const lpDCB: TDCB): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := SetCommState(hPort, lpDCB);
end;
function TComPort._SetCommTimeouts_(const lpCommTimeouts: TCommTimeouts): Boolean;
begin
  Result := _CheckConnection;
  if not Result then exit;
  Result := SetCommTimeouts(hPort, lpCommTimeouts);
end;
//------------------------------------------------------------------------------------------------------------------------------------------
procedure TComPort._ErrorCode_(ErrorIndex: byte; ResultOfGetLastError: DWORD);
var mes: string;
begin
  if not Assigned(EvOnPortError) then Exit;
  case ErrorIndex of
    00: if ResultOfGetLastError <> NO_ERROR then
          mes := Format('Ошибка порта «%s»: %s (%d)', [sPort, SysErrorMessage(ResultOfGetLastError), ResultOfGetLastError])
        else
          mes := 'Неопознанная ошибка';
    01: mes := 'Порт не был открыт';
    02: mes := Format('Уже открыт порт «%s»', [sPort]);
    03: mes := 'Обнаруженно состояние разрыва';
    04: mes := 'Ошибка обрамления';
    05: mes := 'Переполнение аппаратного буфера';
    06: mes := 'Переполнение очереди приемника';
    07: mes := 'Ошибка четности приемника';
    08: mes := Format('Порт «%s» не найден', [sPort]);
    09: mes := Format('Порт «%s» занят', [sPort]);
    10: mes := Format('Ошибка чтение порта «%s»: %s (%d)', [sPort, SysErrorMessage(ResultOfGetLastError), ResultOfGetLastError]);
    11: mes := Format('Ошибка записи порта «%s»: %s (%d)', [sPort, SysErrorMessage(ResultOfGetLastError), ResultOfGetLastError]);
    //12: mes := 'Test';
  else
      mes := 'Неожиданная ошибка';
  end;
  EvOnPortError(Self, mes);
end;

//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------

{ TComPort._TPortAction }

constructor TComPort._TPortAction.Create;
begin
  inherited Create(False);
  FreeOnTerminate := true;
  pause := True;
  hMsg := hMes;
  Event := TEvent.Create(nil, True, True, '');
end;

destructor TComPort._TPortAction.Destroy;
begin
  FreeAndNil(Event);
  inherited;
end;

procedure TComPort._TPortAction.Execute;
begin
  //
  OVERLAPPED.Internal := 0;
  OVERLAPPED.InternalHigh := 0;
  OVERLAPPED.Offset := 0;
  OVERLAPPED.OffsetHigh := 0;
  OVERLAPPED.hEvent := CreateEvent(nil, True, False, nil);
  //
  while not Terminated do begin
    Event.ResetEvent;
    Event.WaitFor();
    if not Terminated and not Pause then
      try
        Proccess;
      except on e: Exception do begin
        SendMes(wm_ErrorStr, 0, NativeInt(@e.Message));
      end; end;
  end;
  //
  CloseHandle(OVERLAPPED.hEvent);
end;

procedure TComPort._TPortAction.StartProc;
begin
  Synchronize(self, procedure begin
    hPort := hComPort;
    Pause := False;
    Event.SetEvent;
  end);
end;

procedure TComPort._TPortAction.StopProc;
begin
  Synchronize(self, procedure begin
    hPort := INVALID_HANDLE_VALUE;
    Pause := True;
    //Event.SetEvent;
  end);
end;

procedure TComPort._TPortAction.TerminatedSet;
begin
  inherited;
  Event.SetEvent;
end;

procedure TComPort._TPortAction.SendMes(wmMes: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  SendMessage(hMsg, wmMes, wParam, lParam);
end;
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------

{ TComPort._TPortWrite }

constructor TComPort._TPortWrite.Create(hMes: HWND);
begin
  inherited;
  evnt := TEvent.Create(nil, True, False, '');
  evnt.ResetEvent;
end;

destructor TComPort._TPortWrite.Destroy;
begin
  FreeAndNil(evnt);
  inherited;
end;

function TComPort._TPortWrite.WriteToPort(const Data: TBufStr): Boolean;
begin
  Result := (hPort<>0) and (hPort<>INVALID_HANDLE_VALUE);
  if Result then begin
    buf := Data;
    Event.SetEvent;
    evnt.SetEvent;
  end else
    SendMes(wm_Error, 0, 1)
end;

procedure TComPort._TPortWrite.TerminatedSet;
begin
  evnt.SetEvent;
  inherited;
end;

procedure TComPort._TPortWrite.Proccess;
var {pStr: ^string;
  pBuf: ^TBufStr;}
  LengthWrited: DWORD;
begin
  evnt.WaitFor;
  evnt.ResetEvent;
  if not Terminated and not Pause then
    if not WriteFile(hPort, PBufChar(buf)^, length(buf), LengthWrited, @OVERLAPPED)then begin
      LengthWrited := GetLastError;
      if LengthWrited <> ERROR_IO_PENDING then
        SendMes(wm_Error, LengthWrited, 0);
    end;
end;
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------

{ TComPort._TPortRead }

procedure TComPort._TPortRead.Proccess;
var lpState: TComStat;
  lpError: DWORD;
  function CheckCnnct(): Boolean;
  begin
    Result := (hPort<>0) and (hPort<>INVALID_HANDLE_VALUE);
    if not Result then exit;
    Result := ClearCommError(hPort, lpError, @lpState);
    if not Result then
      if GetLastError in [ERROR_INVALID_HANDLE, ERROR_ACCESS_DENIED] then
        SendMes(wm_ClosePort,0,0);
  end;
const lenBuff = $1000;
var lpEvtMask: DWORD;
  Buf: TBufStr;
  Buff: array[1..lenBuff] of TBufChar;
  wait: DWORD;
begin
  while not Terminated and not Pause and CheckCnnct do begin
    lpEvtMask := EV_CTS or EV_DSR or EV_RLSD or EV_RING or EV_BREAK or EV_ERR or EV_RXCHAR;
    if not WaitCommEvent(hPort, lpEvtMask, @OVERLAPPED) then
      lpError := GetLastError
    else
      lpError := ERROR_BAD_UNIT;
    if lpError <> ERROR_IO_PENDING then begin
      SendMes(wm_Error, lpError, 0);
      //sleep(100);
    end else begin
      wait := WaitForSingleObject(OVERLAPPED.hEvent, INFINITE);
      if wait = WAIT_FAILED then begin
        if Terminated or Pause then
          Break;
        SendMes(wm_Error, GetLastError, 0);
      end else begin
        // EV_BREAK or EV_ERR or EV_RXCHAR
        if (lpEvtMask and (EV_BREAK or EV_ERR or EV_RXCHAR)) <> 0 then begin
          if not ClearCommError(hPort, lpError, @lpState) then begin
            lpError := GetLastError;
            if not(lpError in [ERROR_INVALID_HANDLE, ERROR_ACCESS_DENIED]) then
              SendMes(wm_Error, lpError, 0);
          end else begin
            // Ошибка или сброс
            if (lpEvtMask and (EV_BREAK or EV_ERR)) <> 0 then begin
              if (lpError and CE_BREAK) = CE_BREAK then
                SendMes(wm_Error, 0, 3);
              if (lpError and CE_FRAME) = CE_FRAME then
                SendMes(wm_Error, 0, 4);
              if (lpError and CE_OVERRUN) = CE_OVERRUN then
                SendMes(wm_Error, 0, 5);
              if (lpError and CE_RXOVER) = CE_RXOVER then
                SendMes(wm_Error, 0, 6);
              if (lpError and CE_RXPARITY) = CE_RXPARITY then
                SendMes(wm_Error, 0, 7);
            end;
            // Данные пришли
            if (lpEvtMask and EV_RXCHAR) <> 0 then begin
              if lpState.cbInQue > 0 then begin//если буфер не пустой
                lpError := 0;
                if not ReadFile(hPort, Buff, {length(Buff)}lenBuff, lpError, @OVERLAPPED) then begin
                  lpError := GetLastError;
                  if lpError<>INVALID_HANDLE_VALUE then
                    SendMes(wm_Error, lpError, 0);
                end else begin
                  Buf := TBufStr(Buff);
                  SetLength(Buf, lpError);
                  SendMes(wm_PortRx, 0, NativeInt(@Buf));
                end;
              end;
            end;
          end;
        end;
        // EV_CTS or EV_DSR or EV_RLSD or EV_RING
        if (lpEvtMask and (EV_CTS or EV_DSR or EV_RLSD or EV_RING)) <> 0 then begin
          if not GetCommModemStatus(hPort, lpError) then begin
            lpError := GetLastError;
            if lpError <> ERROR_INVALID_HANDLE then
              SendMes(wm_Error, lpError, 0);
          end else
            SendMes(wm_PortSignals, lpError, lpError);
        end;
      end;
    end;
  end;
  lpState := lpState;
end;

end.
