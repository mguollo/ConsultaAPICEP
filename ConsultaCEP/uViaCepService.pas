unit uViaCepService;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Xml.XMLDoc, Xml.XMLIntf,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  uIViaCepService, uAddress;

type
  TViaCepService = class(TInterfacedObject, IViaCepService)
  private
    FHttp: TNetHTTPClient;
  public
    function ParseAddressFromJSON(const AJSON: string): TAddress;
    function ParseAddressesFromJSONArray(const AJSON: string): TArray<TAddress>;
    function ParseAddressFromXML(const AXML: string): TAddress;
    function ParseAddressesFromXML(const AXML: string): TArray<TAddress>;
    constructor Create;
    destructor Destroy; override;
    function GetByCep(const ACep: string; AFormat: TResponseFormat): TAddress;
    function GetByAddress(const AUF, ACity, AAddress: string; AFormat: TResponseFormat): TArray<TAddress>;
  end;

implementation

uses
  System.NetEncoding, System.Variants, System.Generics.Collections;

{ TViaCepService }

constructor TViaCepService.Create;
begin
  inherited;
  FHttp := TNetHTTPClient.Create(nil);
  FHttp.ConnectionTimeout := 5000;
  FHttp.ResponseTimeout := 5000;
end;

destructor TViaCepService.Destroy;
begin
  FHttp.Free;
  inherited;
end;

function TViaCepService.GetByCep(const ACep: string; AFormat: TResponseFormat): TAddress;
var
  URL, Resp: string;
  Response: IHTTPResponse;
begin
  if AFormat = rfJSON then
    URL := Format('https://viacep.com.br/ws/%s/json/', [ACep])
  else
    URL := Format('https://viacep.com.br/ws/%s/xml/', [ACep]);

  Response := FHttp.Get(URL);
  Resp := Response.ContentAsString;

  if Response.StatusCode <> 200 then
    raise Exception.CreateFmt('Erro HTTP: %d - %s', [Response.StatusCode, Response.StatusText]);

  if AFormat = rfJSON then
    Result := ParseAddressFromJSON(Resp)
  else
    Result := ParseAddressFromXML(Resp);
end;

function TViaCepService.GetByAddress(const AUF, ACity, AAddress: string; AFormat: TResponseFormat): TArray<TAddress>;
var
  URL, Resp: string;
  Response: IHTTPResponse;
begin
  if AFormat = rfJSON then
    URL := Format('https://viacep.com.br/ws/%s/%s/%s/json/', [AUF, TNetEncoding.URL.Encode(ACity), TNetEncoding.URL.Encode(AAddress)])
  else
    URL := Format('https://viacep.com.br/ws/%s/%s/%s/xml/', [AUF, TNetEncoding.URL.Encode(ACity), TNetEncoding.URL.Encode(AAddress)]);

  Response := FHttp.Get(URL);
  Resp := Response.ContentAsString;

  if Response.StatusCode <> 200 then
    raise Exception.CreateFmt('Erro HTTP: %d - %s', [Response.StatusCode, Response.StatusText]);

  if AFormat = rfJSON then
    Result := ParseAddressesFromJSONArray(Resp)
  else
    Result := ParseAddressesFromXML(Resp);
end;

function TViaCepService.ParseAddressFromJSON(const AJSON: string): TAddress;
var
  JSONObj: TJSONObject;
begin
  Result := nil;
  JSONObj := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  try
    if (JSONObj = nil) or (JSONObj.GetValue('erro') <> nil) then Exit;

    Result := TAddress.Create;
    Result.Cep := JSONObj.GetValue<string>('cep');
    Result.Logradouro := JSONObj.GetValue<string>('logradouro');
    Result.Complemento := JSONObj.GetValue<string>('complemento');
    Result.Bairro := JSONObj.GetValue<string>('bairro');
    Result.Localidade := JSONObj.GetValue<string>('localidade');
    Result.UF := JSONObj.GetValue<string>('uf');
  finally
    JSONObj.Free;
  end;
end;

function TViaCepService.ParseAddressesFromJSONArray(const AJSON: string): TArray<TAddress>;
var
  Arr: TJSONArray;
  i: Integer;
  Item: TJSONObject;
  Temp: TAddress;
begin
  SetLength(Result, 0);
  Arr := TJSONObject.ParseJSONValue(AJSON) as TJSONArray;
  if Arr = nil then Exit;
  try
    SetLength(Result, Arr.Count);
    for i := 0 to Arr.Count - 1 do
    begin
      Item := Arr.Items[i] as TJSONObject;
      Temp := TAddress.Create;
      Temp.Cep := Item.GetValue<string>('cep');
      Temp.Logradouro := Item.GetValue<string>('logradouro');
      Temp.Complemento := Item.GetValue<string>('complemento');
      Temp.Bairro := Item.GetValue<string>('bairro');
      Temp.Localidade := Item.GetValue<string>('localidade');
      Temp.UF := Item.GetValue<string>('uf');
      Result[i] := Temp;
    end;
  finally
    Arr.Free;
  end;
end;

function TViaCepService.ParseAddressFromXML(const AXML: string): TAddress;
var
  XMLDoc: IXMLDocument;
  Node: IXMLNode;
begin
  Result := nil;
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.LoadFromXML(AXML);
  XMLDoc.Active := True;

  Node := XMLDoc.DocumentElement;
  if (Node = nil) or (Node.NodeName = 'erro') then Exit;

  Result := TAddress.Create;
  Result.Cep := VarToStr(Node.ChildValues['cep']);
  Result.Logradouro := VarToStr(Node.ChildValues['logradouro']);
  Result.Complemento := VarToStr(Node.ChildValues['complemento']);
  Result.Bairro := VarToStr(Node.ChildValues['bairro']);
  Result.Localidade := VarToStr(Node.ChildValues['localidade']);
  Result.UF := VarToStr(Node.ChildValues['uf']);
end;

function TViaCepService.ParseAddressesFromXML(const AXML: string): TArray<TAddress>;
var
  XMLDoc: IXMLDocument;
  i: Integer;
  Node: IXMLNode;
  Temp: TAddress;
begin
  SetLength(Result, 0);
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.LoadFromXML(AXML);
  XMLDoc.Active := True;

  if (XMLDoc.DocumentElement = nil) or (XMLDoc.DocumentElement.ChildNodes.Count = 0) then Exit;

  SetLength(Result, XMLDoc.DocumentElement.ChildNodes.Count);
  for i := 0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
  begin
    Node := XMLDoc.DocumentElement.ChildNodes[i];
    Temp := TAddress.Create;
    Temp.Cep := VarToStr(Node.ChildValues['cep']);
    Temp.Logradouro := VarToStr(Node.ChildValues['logradouro']);
    Temp.Complemento := VarToStr(Node.ChildValues['complemento']);
    Temp.Bairro := VarToStr(Node.ChildValues['bairro']);
    Temp.Localidade := VarToStr(Node.ChildValues['localidade']);
    Temp.UF := VarToStr(Node.ChildValues['uf']);
    Result[i] := Temp;
  end;
end;

end.
