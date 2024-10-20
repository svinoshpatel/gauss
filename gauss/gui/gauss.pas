unit gauss;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StringGrid4: TStringGrid;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  Matrix = Array[1..5, 1..5] of Real;
  Vector = Array[1..5] of Real;

procedure gss(A: Matrix; B: Vector; n: Integer; Var X: Vector; StringGrid4: TStringGrid);
var
  i, j, k: Integer;
  R: Real;
begin
  if n = 1 then
    if abs(A[1, 1]) < 1e-7 then
    begin
      ShowMessage('The system is singular');
      halt
    end else
    begin
      X[1] := B[1] / A[1, 1];
      exit
    end;

  for i := 1 to n - 1 do
  begin
    k := i;
    R := abs(A[i, i]);
    for j := 1 + 1 to n do
      if abs(A[j, i]) >= R then
      begin
        k := j;
        R := abs(A[j, i])
      end;
    if R <= 1e-7 then
    begin
      ShowMessage('The system is singular');
      halt
    end;
    if k <> i then
    begin
      R := B[k];
      B[k] := B[i];
      B[i] := R;
      for j := i to n do
      begin
        R := A[k, j];
        A[k, j] := A[i, j];
        A[i, j] := R
      end;
    end;
    R := A[i, i];
    B[i] := B[i] / R;
    for j := 1 to n do
      A[i, j] := A[i, j] / R;
    for k := i + 1 to n do
    begin
      R := A[k, i];
      B[k] := B[k] - R * B[i];
      A[k, i] := 0;
      for j := i + 1 to n do
        A[k, j] := A[k, j] - R * A[i, j];
    end;
  end;

  if abs(A[n, n]) <= 1e-7 then
  begin
    ShowMessage('The system is singular');
    halt
  end;

  for i := 1 to n do
    for j := 1 to n do
    begin
      StringGrid4.Cells[j - 1, i - 1] := FloatToStr(A[i, j]);
    end;

  X[n] := B[n] / A[n, n];
  for i := n - 1 downto 1 do
  begin
    R := B[i];
    for j := i + 1 to n do
    R := R - A[i, j] * X[j];
    X[i] := R
  end
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  A : Matrix;
  B, x : Vector;
  i, j, n : Integer;
begin
  n := StrToInt(Edit1.text);
  for i := 1 to n do
    for j := 1 to n do
    begin
      a[i, j] := StrToFloat(StringGrid1.Cells[j - 1, i - 1]);
      b[j] := StrToFloat(StringGrid2.Cells[0, j - 1]);
    end;
  // SLAR
  gss(A, B, n, x, StringGrid4);
  for i := 1 to n do
    begin
      StringGrid3.Cells[0, i - 1] := FloatToStr(x[i]);
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.Button3Click(Sender: TObject);
var n : Integer;
begin
  n := StrToInt(Edit1.text);
  StringGrid1.ColCount := n;
  StringGrid1.RowCount := n;
  StringGrid2.RowCount := n;
  StringGrid3.RowCount := n;
  StringGrid4.RowCount := n;
  StringGrid4.ColCount := n;
end;

end.
