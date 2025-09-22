unit uAddressRepository;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  uAddress;

type
  TAddressRepository = class
  private
    FConnection: TFDConnection;
    procedure EnsureTable;
  public
    constructor Create(AConn: TFDConnection);
    procedure Insert(AAddr: TAddress);
    procedure Update(AAddr: TAddress);
    //function GetAll: TFDQuery;
  end;

implementation

{ TAddressRepository }

constructor TAddressRepository.Create(AConn: TFDConnection);
begin
  FConnection := AConn;
  EnsureTable;
end;

procedure TAddressRepository.EnsureTable;
begin
  FConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS addresses ('+
    'id INTEGER PRIMARY KEY AUTOINCREMENT,'+
    'cep TEXT,'+
    'logradouro TEXT,'+
    'complemento TEXT,'+
    'bairro TEXT,'+
    'localidade TEXT,'+
    'uf TEXT)');
end;

procedure TAddressRepository.Insert(AAddr: TAddress);
begin
  FConnection.ExecSQL(
    'INSERT INTO addresses (cep, logradouro, complemento, bairro, localidade, uf) '+
    'VALUES (?,?,?,?,?,?)',
    [AAddr.Cep, AAddr.Logradouro, AAddr.Complemento,
     AAddr.Bairro, AAddr.Localidade, AAddr.UF]);
end;

procedure TAddressRepository.Update(AAddr: TAddress);
begin
  FConnection.ExecSQL(
    'UPDATE addresses ' +
    'SET logradouro = ?, complemento = ?, bairro = ?, localidade = ?, uf = ? ' +
    'WHERE cep = ?',
    [AAddr.Logradouro, AAddr.Complemento,
     AAddr.Bairro, AAddr.Localidade, AAddr.UF,
     AAddr.Cep]
  );
end;

//function TAddressRepository.GetAll: TFDQuery;
//begin
//  Result := TFDQuery.Create(nil);
//  Result.Connection := FConnection;
//  Result.SQL.Text := 'SELECT * FROM addresses';
//  Result.Open;
//end;

end.
