unit uViaCepServiceTests;

interface

uses
  TestFramework, uViaCepService, uAddress;

type
  TestTViaCepService = class(TTestCase)
  private
    Service: TViaCepService;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestParseAddressFromJSON;
    procedure TestParseAddressFromXML;
  end;

implementation

procedure TestTViaCepService.SetUp;
begin
  Service := TViaCepService.Create;
end;

procedure TestTViaCepService.TearDown;
begin
  Service.Free;
end;

procedure TestTViaCepService.TestParseAddressFromJSON;
var
  Addr: TAddress;
  JSON: string;
begin
  JSON := '{"cep":"01001-000","logradouro":"Praça da Sé","complemento":"lado ímpar","bairro":"Sé","localidade":"São Paulo","uf":"SP"}';
  Addr := Service.ParseAddressFromJSON(JSON);
  try
    CheckNotNull(Addr, 'Endereço não foi parseado');
    CheckEquals('01001-000', Addr.Cep);
    CheckEquals('SP', Addr.UF);
  finally
    Addr.Free;
  end;
end;

procedure TestTViaCepService.TestParseAddressFromXML;
var
  Addr: TAddress;
  XML: string;
begin
  XML := '<xmlcep><cep>01001-000</cep><logradouro>Praça da Sé</logradouro><complemento>lado ímpar</complemento><bairro>Sé</bairro><localidade>São Paulo</localidade><uf>SP</uf></xmlcep>';
  Addr := Service.ParseAddressFromXML(XML);
  try
    CheckNotNull(Addr, 'Endereço não foi parseado');
    CheckEquals('01001-000', Addr.Cep);
    CheckEquals('Praça da Sé', Addr.Logradouro);
    CheckEquals('Sé', Addr.Bairro);
  finally
    Addr.Free;
  end;
end;

initialization
  RegisterTest(TestTViaCepService.Suite);

end.
