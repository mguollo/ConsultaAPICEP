unit uAddressTests;

interface

uses
  TestFramework, uAddress;

type
  TestTAddress = class(TTestCase)
  published
    procedure TestPropriedades;
  end;

implementation

procedure TestTAddress.TestPropriedades;
var
  Addr: TAddress;
begin
  Addr := TAddress.Create;
  try
    Addr.Cep := '01001-000';
    Addr.Logradouro := 'Praça da Sé';
    Addr.Complemento := 'lado ímpar';
    Addr.Bairro := 'Sé';
    Addr.Localidade := 'São Paulo';
    Addr.UF := 'SP';

    CheckEquals('01001-000', Addr.Cep);
    CheckEquals('Praça da Sé', Addr.Logradouro);
    CheckEquals('lado ímpar', Addr.Complemento);
    CheckEquals('Sé', Addr.Bairro);
    CheckEquals('São Paulo', Addr.Localidade);
    CheckEquals('SP', Addr.UF);
  finally
    Addr.Free;
  end;
end;

initialization
  RegisterTest(TestTAddress.Suite);

end.
