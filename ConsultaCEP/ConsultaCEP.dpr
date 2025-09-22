program ConsultaCEP;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {FrmMain},
  uAddress in 'uAddress.pas',
  uIViaCepService in 'uIViaCepService.pas',
  uViaCepService in 'uViaCepService.pas',
  uAddressRepository in 'uAddressRepository.pas',
  uCepHelper in 'uCepHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
