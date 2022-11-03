unit SendFile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.ListBox, FMX.Layouts, FMX.EditBox, FMX.SpinBox;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    Edit1: TEdit;
    EditButton1: TEditButton;
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Layout3: TLayout;
    Label3: TLabel;
    SpinBox1: TSpinBox;
    ButtonSend: TButton;
    ButtonClose: TButton;
    GridLayout1: TGridLayout;
    procedure EditButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses uMain;

procedure TForm1.EditButton1Click(Sender: TObject);
begin
  if not OpenDialog.Execute then Exit;
end;

end.
