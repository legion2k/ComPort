unit uMacros;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.EditBox,
  FMX.SpinBox, FMX.StdCtrls, FMX.ScrollBox;

type
  TfMacroses = class(TForm)
    Panel1: TPanel;
    ButtonClose: TButton;
    ButtonReset: TButton;
    PresentedScrollBox1: TPresentedScrollBox;
    Layout1: TLayout;
    Edit1: TEdit;
    Button1: TButton;
    SpinBox1: TSpinBox;
    ComboBox1: TComboBox;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    Layout10: TLayout;
    Edit10: TEdit;
    Button10: TButton;
    SpinBox10: TSpinBox;
    ComboBox10: TComboBox;
    Timer10: TTimer;
    CheckBox10: TCheckBox;
    Layout2: TLayout;
    Edit2: TEdit;
    Button2: TButton;
    SpinBox2: TSpinBox;
    ComboBox2: TComboBox;
    Timer2: TTimer;
    CheckBox2: TCheckBox;
    Layout3: TLayout;
    Edit3: TEdit;
    Button3: TButton;
    SpinBox3: TSpinBox;
    ComboBox3: TComboBox;
    Timer3: TTimer;
    CheckBox3: TCheckBox;
    Layout4: TLayout;
    Edit4: TEdit;
    Button4: TButton;
    SpinBox4: TSpinBox;
    ComboBox4: TComboBox;
    Timer4: TTimer;
    CheckBox4: TCheckBox;
    Layout5: TLayout;
    Edit5: TEdit;
    Button5: TButton;
    SpinBox5: TSpinBox;
    ComboBox5: TComboBox;
    Timer5: TTimer;
    CheckBox5: TCheckBox;
    Layout6: TLayout;
    Edit6: TEdit;
    Button6: TButton;
    SpinBox6: TSpinBox;
    ComboBox6: TComboBox;
    Timer6: TTimer;
    CheckBox6: TCheckBox;
    Layout7: TLayout;
    Edit7: TEdit;
    Button7: TButton;
    SpinBox7: TSpinBox;
    ComboBox7: TComboBox;
    Timer7: TTimer;
    CheckBox7: TCheckBox;
    Layout8: TLayout;
    Edit8: TEdit;
    Button8: TButton;
    SpinBox8: TSpinBox;
    ComboBox8: TComboBox;
    Timer8: TTimer;
    CheckBox8: TCheckBox;
    Layout9: TLayout;
    Edit9: TEdit;
    Button9: TButton;
    SpinBox9: TSpinBox;
    ComboBox9: TComboBox;
    Timer9: TTimer;
    CheckBox9: TCheckBox;
    Layout11: TLayout;
    Edit11: TEdit;
    Button11: TButton;
    SpinBox11: TSpinBox;
    ComboBox11: TComboBox;
    Timer11: TTimer;
    CheckBox11: TCheckBox;
    Layout12: TLayout;
    Edit12: TEdit;
    Button12: TButton;
    SpinBox12: TSpinBox;
    ComboBox12: TComboBox;
    Timer12: TTimer;
    CheckBox12: TCheckBox;
    Layout13: TLayout;
    Edit13: TEdit;
    Button13: TButton;
    SpinBox13: TSpinBox;
    ComboBox13: TComboBox;
    Timer13: TTimer;
    CheckBox13: TCheckBox;
    Layout14: TLayout;
    Edit14: TEdit;
    Button14: TButton;
    SpinBox14: TSpinBox;
    ComboBox14: TComboBox;
    Timer14: TTimer;
    CheckBox14: TCheckBox;
    Layout15: TLayout;
    Edit15: TEdit;
    Button15: TButton;
    SpinBox15: TSpinBox;
    ComboBox15: TComboBox;
    Timer15: TTimer;
    CheckBox15: TCheckBox;
    Layout16: TLayout;
    Edit16: TEdit;
    Button16: TButton;
    SpinBox16: TSpinBox;
    ComboBox16: TComboBox;
    Timer16: TTimer;
    CheckBox16: TCheckBox;
    Layout17: TLayout;
    Edit17: TEdit;
    Button17: TButton;
    SpinBox17: TSpinBox;
    ComboBox17: TComboBox;
    Timer17: TTimer;
    CheckBox17: TCheckBox;
    Layout18: TLayout;
    Edit18: TEdit;
    Button18: TButton;
    SpinBox18: TSpinBox;
    ComboBox18: TComboBox;
    Timer18: TTimer;
    CheckBox18: TCheckBox;
    Layout19: TLayout;
    Edit19: TEdit;
    Button19: TButton;
    SpinBox19: TSpinBox;
    ComboBox19: TComboBox;
    Timer19: TTimer;
    CheckBox19: TCheckBox;
    Layout20: TLayout;
    Edit20: TEdit;
    Button20: TButton;
    SpinBox20: TSpinBox;
    ComboBox20: TComboBox;
    Timer20: TTimer;
    CheckBox20: TCheckBox;
    procedure TimerXTimer(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxChange(Sender: TObject);
    procedure SpinBoxChange(Sender: TObject);
    procedure CheckBoxChangeLite(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);
    procedure EditXChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMacroses: TfMacroses;

implementation

{$R *.fmx}

uses uMain, uComPort;


procedure TfMacroses.FormCreate(Sender: TObject);
var i: Integer;
begin
  for i:=1 to 20 do begin
    var cb := (FindComponent('ComboBox'+i.ToString) as TComboBox);
    cb.Items.Text := fMain.AddSend.Items.Text;
    cb.ItemIndex := 0;
    var e := (FindComponent('Edit'+i.ToString) as TEdit);
    e.hint := fMain.EditSend.hint;
  end;
end;

procedure TfMacroses.SpinBoxChange(Sender: TObject);
begin
  if Sender is TSpinBox then begin
    var s := (Sender as TSpinBox);
    var t := FindComponent('Timer'+ s.Tag.ToString);
    (t as TTimer).Interval := Round(s.Value);
  end;
end;

procedure TfMacroses.TimerXTimer(Sender: TObject);
begin
  ButtonClick( FindComponent('Button'+ (Sender as TTimer).Tag.ToString) )
end;

procedure TfMacroses.ButtonClick(Sender: TObject);
begin
  if Sender is TButton then begin
    var b := (Sender as TButton);
    var e := FindComponent('Edit'+ b.Tag.ToString);
    var c := FindComponent('ComboBox'+ b.Tag.ToString);
    fMain.SendToPort((e as TEdit).Text, (c as TComboBox).ItemIndex);
  end;
end;

procedure TfMacroses.CheckBoxChangeLite(Sender: TObject);
begin
  var c := (Sender as TCheckBox);
  var b := fMain.FindComponent('Macros' + c.Tag.ToString) as TButton;
  b.StylesData['FatLine.visible'] := c.IsChecked;
  b.NeedStyleLookup;
  b.ApplyStyleLookup;
end;

procedure TfMacroses.CheckBoxChange(Sender: TObject);
begin
  var c := (Sender as TCheckBox);
  var t := FindComponent('Timer' + c.Tag.ToString);
  (t as TTimer).Enabled := c.IsChecked;
  CheckBoxChangeLite(Sender);
end;

procedure TfMacroses.ButtonResetClick(Sender: TObject);
var i: Integer;
begin
  for i:=1 to 20 do begin
    (FindComponent('Edit'+i.ToString) as TEdit).Text := '';
    (FindComponent('ComboBox'+i.ToString) as TComboBox).ItemIndex := 0;
    (FindComponent('SpinBox'+i.ToString) as TSpinBox).Value := 1000;
    (FindComponent('CheckBox'+i.ToString) as TCheckBox).IsChecked := False;
  end;
end;

procedure TfMacroses.EditXChange(Sender: TObject);
var e: TEdit;
  s: string;
begin
  e := Sender as TEdit;
  s := e.Text;
  if s<>'' then
    s := format('%s'#10+
    '―――――――――――――――――――――――――――――――――――'#10,[s]);
  (fMain.FindComponent('Macros' + e.Tag.ToString) as TButton).Hint := format('%s'+
    'Исполльзуте [ и ] для вставки HEX.'#10+
    'Символы заключенные в [ ], не принадлежащие HEX, будут просто удалены.'#10+
    '[[ преобразуется в [ и игнорируется' ,[s]);
end;

end.
