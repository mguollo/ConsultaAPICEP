unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.Phys.SQLite, FireDAC.DApt, FireDAC.Stan.Intf, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, uIViaCepService, uViaCepService,
  uCepHelper, uAddress, uAddressRepository, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.DBCtrls, Data.FMTBcd, Data.SqlExpr;

type
  TFrmMain = class(TForm)
    lblCep: TLabel;
    medtCEP: TMaskEdit;
    btnConsultar: TButton;
    lblLogradouro: TLabel;
    edtLogradouro: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    lblUF: TLabel;
    edtUF: TEdit;
    DBGrid1: TDBGrid;
    FDConnection1: TFDConnection;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    FDQuery1id: TFDAutoIncField;
    FDQuery1cep: TWideStringField;
    FDQuery1logradouro: TWideStringField;
    FDQuery1complemento: TWideStringField;
    FDQuery1bairro: TWideStringField;
    FDQuery1localidade: TWideStringField;
    FDQuery1uf: TWideStringField;
    rgMetodoPesquisa: TRadioGroup;
    btnConsultarEndereco: TButton;
    btnLimparCampos: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure medtCEPKeyPress(Sender: TObject; var Key: Char);
    procedure btnConsultarEnderecoClick(Sender: TObject);
    procedure btnLimparCamposClick(Sender: TObject);
  private
    FService: IViaCepService;
    FRepo: TAddressRepository;
    procedure CarregarGrid;
    function ValidarTemNaBase(const fsCep: string): boolean;
    procedure PesquisarEnderecoCompleto(const Estado, Cidade, Endereco: string);
  public
  end;

var
  FrmMain: TFrmMain;


implementation

uses
  System.UITypes;

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FService := TViaCepService.Create;

  FDConnection1.Params.Clear;
  FDConnection1.DriverName := 'SQLite';
  FDConnection1.Params.Database := 'addresses.db';
  FDConnection1.LoginPrompt := False;
  FDConnection1.Connected := True;

  FRepo := TAddressRepository.Create(FDConnection1);
  CarregarGrid;
end;

procedure TFrmMain.btnConsultarClick(Sender: TObject);
var
  Cep: string;
  Addr: TAddress;
  bCEPCadastrado,bAtualizarRegistro: boolean;
begin
  Cep := TCepHelper.LimparMascara(medtCEP.Text);
  if not TCepHelper.CepValido(Cep) then
  begin
    ShowMessage('Digite um CEP válido com 8 números.');
    Exit;
  end;

  bCEPCadastrado := ValidarTemNaBase(medtCEP.Text);
  bAtualizarRegistro := (bCEPCadastrado and (MessageDlg('Registro encontrado na base. Deseja atualizar o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes));
  if (not bCEPCadastrado) or bAtualizarRegistro then
  begin
    if rgMetodoPesquisa.ItemIndex = 0 then
      Addr := FService.GetByCep(Cep, rfJSON)
    else
      Addr := FService.GetByCep(Cep, rfXML);

    if Assigned(Addr) then
    begin
      edtLogradouro.Text := Addr.Logradouro;
      edtBairro.Text := Addr.Bairro;
      edtCidade.Text := Addr.Localidade;
      edtUF.Text := Addr.UF;

      if bAtualizarRegistro then
        FRepo.Update(Addr)
      else
        FRepo.Insert(Addr);
      Addr.Free;
      CarregarGrid;
    end
    else
      ShowMessage('CEP não encontrado.');
  end;
end;

procedure TFrmMain.medtCEPKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btnConsultar.Click;
  end;
end;

function TFrmMain.ValidarTemNaBase(const fsCep: string): boolean;
begin
  try
    FDQuery1.DisableControls;
    result := FDQuery1.Locate('cep', fsCep, []);
  finally
    FDQuery1.EnableControls;
  end;
end;

procedure TFrmMain.btnConsultarEnderecoClick(Sender: TObject);
var
  Estado, Cidade, Endereco: string;
begin
  Estado   := Trim(edtUF.Text);
  Cidade   := Trim(edtCidade.Text);
  Endereco := Trim(edtLogradouro.Text);

  if (Length(Estado) < 2) or (Length(Cidade) < 3) or (Length(Endereco) < 3) then
  begin
    ShowMessage('Informe Estado (2 letras), Cidade e Endereço com pelo menos 3 caracteres.');
    Exit;
  end;

  PesquisarEnderecoCompleto(Estado, Cidade, Endereco);
end;

procedure TFrmMain.btnLimparCamposClick(Sender: TObject);
begin
  edtUF.Clear;
  edtCidade.Clear;
  edtLogradouro.Clear;
  edtBairro.Clear;
  medtCEP.Clear;
end;

procedure TFrmMain.PesquisarEnderecoCompleto(const Estado, Cidade, Endereco: string);
var
  Q: TFDQuery;
  Enderecos: TArray<TAddress>;
  Addr: TAddress;
  bEncontrouEndereco: boolean;
  sCEP : string;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDConnection1;
    Q.SQL.Text :=
      'SELECT * FROM addresses WHERE uf = :uf AND localidade LIKE :cidade AND logradouro LIKE :endereco';
    Q.ParamByName('uf').AsString := Estado;
    Q.ParamByName('cidade').AsString := '%' + Cidade + '%';
    Q.ParamByName('endereco').AsString := '%' + Endereco + '%';
    Q.Open;

    bEncontrouEndereco := not Q.IsEmpty;

    if bEncontrouEndereco then
    begin
      edtLogradouro.Text := Q.FieldByName('logradouro').AsString;
      edtBairro.Text     := Q.FieldByName('bairro').AsString;
      edtCidade.Text     := Q.FieldByName('localidade').AsString;
      edtUF.Text         := Q.FieldByName('uf').AsString;

      if MessageDlg('Endereço já existe na base. Deseja atualizar dados?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end;
  finally
    Q.Free;
  end;

  // Consulta no WS ViaCEP
  Enderecos := FService.GetByAddress(Estado, Cidade, Endereco, rfJSON);

  if Length(Enderecos) = 0 then
  begin
    ShowMessage('Endereço não encontrado nem no banco nem no ViaCEP.');
    Exit;
  end;

  // Grava no banco todos os retornados
  for Addr in Enderecos do
  begin
    try
      if bEncontrouEndereco then
        FRepo.Update(Addr)
      else
        FRepo.Insert(Addr);

      sCEP := Addr.Cep;
    finally
      Addr.Free;
    end;
  end;

  CarregarGrid;
end;

procedure TFrmMain.CarregarGrid;
begin
  FDQuery1.Open('select * from addresses');
end;

end.
