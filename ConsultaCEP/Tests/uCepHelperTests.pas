unit uCepHelperTests;

interface

uses
  TestFramework, uCepHelper;

type
  TestTCepHelper = class(TTestCase)
  published
    procedure TestLimparMascara;
    procedure TestCepValido;
  end;

implementation

procedure TestTCepHelper.TestLimparMascara;
begin
  CheckEquals('01001000', TCepHelper.LimparMascara('01001-000'));
  CheckEquals('12345678', TCepHelper.LimparMascara('12345-678'));
  CheckEquals('87654321', TCepHelper.LimparMascara('87654_321'));
end;

procedure TestTCepHelper.TestCepValido;
begin
  CheckTrue(TCepHelper.CepValido('01001-000'));
  CheckTrue(TCepHelper.CepValido('12345678'));

  CheckFalse(TCepHelper.CepValido('1234'));
  CheckFalse(TCepHelper.CepValido('abcdefgh'));
  CheckFalse(TCepHelper.CepValido('12345-67'));
  CheckFalse(TCepHelper.CepValido('12345-6789'));
end;

initialization
  RegisterTest(TestTCepHelper.Suite);

end.
