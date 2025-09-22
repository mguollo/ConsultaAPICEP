unit uIViaCepService;

interface

uses
  uAddress, System.SysUtils;

type
  TResponseFormat = (rfJSON, rfXML);

  IViaCepService = interface
    ['{B7B9A2F8-4D7E-4C4B-9FBB-5E9B8A7C1A85}']
    function GetByCep(const ACep: string; AFormat: TResponseFormat): TAddress;
    function GetByAddress(const AUF, ACity, AAddress: string; AFormat: TResponseFormat): TArray<TAddress>;
  end;

implementation

end.
