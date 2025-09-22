unit uCepHelper;

interface

uses
  System.SysUtils, System.Character;

type
  TCepHelper = class
  public
    class function LimparMascara(const ACep: string): string;
    class function CepValido(const ACep: string): Boolean;
  end;

implementation

{ TCepHelper }

class function TCepHelper.LimparMascara(const ACep: string): string;
begin
  Result := StringReplace(ACep, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '_', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

class function TCepHelper.CepValido(const ACep: string): Boolean;
var
  Digitos: string;
  i: Integer;
begin
  Digitos := LimparMascara(ACep);
  if Length(Digitos) <> 8 then Exit(False);
  for i := 1 to Length(Digitos) do
    if not Digitos[i].IsDigit then Exit(False);
  Result := True;
end;

end.
