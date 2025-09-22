program CepTests;

uses
  Forms,
  TestFramework,
  GUITestRunner,
  uCepHelperTests in 'uCepHelperTests.pas',
  uViaCepParserTests in 'uViaCepParserTests.pas',
  uAddressTests in 'uAddressTests.pas',  
  uViaCepServiceTests in 'uViaCepServiceTests.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
