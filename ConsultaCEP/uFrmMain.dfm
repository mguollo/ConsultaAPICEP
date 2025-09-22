object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Consulta CEP'
  ClientHeight = 355
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblCep: TLabel
    Left = 16
    Top = 12
    Width = 24
    Height = 15
    Caption = 'CEP:'
  end
  object lblLogradouro: TLabel
    Left = 16
    Top = 42
    Width = 65
    Height = 15
    Caption = 'Logradouro:'
  end
  object lblBairro: TLabel
    Left = 16
    Top = 72
    Width = 34
    Height = 15
    Caption = 'Bairro:'
  end
  object lblCidade: TLabel
    Left = 16
    Top = 102
    Width = 40
    Height = 15
    Caption = 'Cidade:'
  end
  object lblUF: TLabel
    Left = 320
    Top = 102
    Width = 17
    Height = 15
    Caption = 'UF:'
  end
  object medtCEP: TMaskEdit
    Left = 100
    Top = 11
    Width = 100
    Height = 23
    EditMask = '!99999\-999;1;_'
    MaxLength = 9
    TabOrder = 0
    Text = '     -   '
    OnKeyPress = medtCEPKeyPress
  end
  object btnConsultar: TButton
    Left = 583
    Top = 8
    Width = 163
    Height = 25
    Caption = 'Consultar CEP'
    TabOrder = 1
    OnClick = btnConsultarClick
  end
  object edtLogradouro: TEdit
    Left = 100
    Top = 40
    Width = 400
    Height = 23
    TabOrder = 2
  end
  object edtBairro: TEdit
    Left = 100
    Top = 70
    Width = 200
    Height = 23
    TabOrder = 3
  end
  object edtCidade: TEdit
    Left = 100
    Top = 100
    Width = 200
    Height = 23
    TabOrder = 4
  end
  object edtUF: TEdit
    Left = 350
    Top = 100
    Width = 50
    Height = 23
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 142
    Width = 737
    Height = 200
    DataSource = DataSource1
    TabOrder = 8
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cep'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'logradouro'
        Width = 239
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'complemento'
        Width = 64
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bairro'
        Width = 64
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'localidade'
        Width = 64
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'uf'
        Width = 64
        Visible = True
      end>
  end
  object rgMetodoPesquisa: TRadioGroup
    Left = 582
    Top = 95
    Width = 163
    Height = 41
    Caption = ' M'#233'todo de pesquisa '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Json'
      'XML')
    TabOrder = 7
  end
  object btnConsultarEndereco: TButton
    Left = 583
    Top = 39
    Width = 163
    Height = 25
    Caption = 'Consultar Endere'#231'o'
    TabOrder = 6
    OnClick = btnConsultarEnderecoClick
  end
  object btnLimparCampos: TButton
    Left = 582
    Top = 70
    Width = 163
    Height = 25
    Caption = 'Limpar Campos'
    TabOrder = 9
    OnClick = btnLimparCamposClick
  end
  object FDConnection1: TFDConnection
    ConnectionName = 'cep'
    Params.Strings = (
      'DriverID=SQLite'
      
        'Database=C:\Users\mguol\Downloads\teste delphi softplan\Consulta' +
        'CEP-Full\ConsultaCEP\addresses.db')
    LoginPrompt = False
    Left = 436
    Top = 106
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 412
    Top = 90
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM addresses')
    Left = 472
    Top = 104
    object FDQuery1id: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object FDQuery1cep: TWideStringField
      FieldName = 'cep'
      KeyFields = 'cep'
      Origin = 'cep'
      Transliterate = False
    end
    object FDQuery1logradouro: TWideStringField
      FieldName = 'logradouro'
      KeyFields = 'logradouro'
      Origin = 'logradouro'
      Size = 50
    end
    object FDQuery1complemento: TWideStringField
      FieldName = 'complemento'
      KeyFields = 'complemento'
      Origin = 'complemento'
      Size = 50
    end
    object FDQuery1bairro: TWideStringField
      FieldName = 'bairro'
      KeyFields = 'bairro'
      Origin = 'bairro'
      Size = 50
    end
    object FDQuery1localidade: TWideStringField
      FieldName = 'localidade'
      KeyFields = 'localidade'
      Origin = 'localidade'
      Size = 50
    end
    object FDQuery1uf: TWideStringField
      FieldName = 'uf'
      KeyFields = 'uf'
      Origin = 'uf'
      Size = 4
    end
  end
end
