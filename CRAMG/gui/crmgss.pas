unit crmgss;

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
    ComboBox1: TComboBox;
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

function sign(k : Integer) : Real;
begin
  if (k + 1) mod 2 = 0 then
    sign := 1
  else
    sign := -1;
end;

function det(system : Matrix; n : Integer) : Real;
var
  minor : Matrix;
  mi, mj, i, j, k : Integer;
  num, sum, a : Real;
begin
  mi := 0;
  mj := 0;
  sum := 0;

  if n = 1 then
    det := system[n, n];
  if n = 2 then
    det := system[1, 1] * system[2, 2] - system[1, 2] * system[2, 1];
  if n = 3 then
    det := system[1, 1] * system[2, 2] * system[3, 3]
         + system[1, 2] * system[2, 3] * system[3, 1]
         + system[1, 3] * system[2, 1] * system[3, 2]
         - system[1, 3] * system[2, 2] * system[3, 1]
         - system[1, 1] * system[2, 3] * system[3, 2]
         - system[1, 2] * system[2, 1] * system[3, 3];
  if n > 3 then
  begin
    for k := 1 to n do
    begin
      a := system[1, k];
      mi := 0;
      for i := 2 to n do
      begin
        mi := mi + 1;
        mj := 0;
        for j := 1 to n do
        begin
          if j <> k then
          begin
            mj := mj + 1;
            minor[mi, mj] := system[i, j];
          end
        end
      end;
      num := a * det(minor, n-1) * sign(k);
      sum := sum + num;
    end;
    det := sum;
  end;
end;

function sub(system : Matrix; ans : Vector; n : Integer; p : Integer) : Matrix;
var
  i, j : Integer;
begin
  for i := 1 to n do
    for j := 1 to n do
      if j = p then
        system[i, j] := ans[i];
  sub := system;
end;

function crm(system : Matrix; ans : Vector; n : Integer) : Vector;
var
  d : Real;
  p : Integer;
  sublist : Matrix;
begin
  d := det(system, n);
  if abs(d) < 1e-7 then
  begin
    ShowMessage('Determinant equals zero. No result can be found.');
    halt;
  end;
  for p := 1 to n do
  begin
    sublist := sub(system, ans, n, p);
    crm[p] := det(sublist, n) / d;
  end;
end;

procedure GAUSS(A: Matrix; B: Vector; n: Integer; Var X: Vector);
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
  i, j, n, m: Integer;
begin
  m := 0;
  n := StrToInt(Edit1.text);
  for i := 1 to n do
    for j := 1 to n do
    begin
      a[i, j] := StrToFloat(StringGrid1.Cells[j - 1, i - 1]);
      b[j] := StrToFloat(StringGrid2.Cells[0, j - 1]);
    end;

  case ComboBox1.ItemIndex of
    0: m := 0;
    1: m := 1;
  end;

  case m of
    0: x := crm(A, B, n);
    1: gauss(A, B, n, x);
  end;

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
end;

end.
