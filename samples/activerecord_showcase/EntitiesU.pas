// *************************************************************************** }
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2023 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

unit EntitiesU;
{$RTTI EXPLICIT METHODS([vcPublic, vcPublished]) FIELDS([vcPrivate, vcProtected, vcPublic, vcPublished]) PROPERTIES([vcPublic, vcPublished])}

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  System.Generics.Collections,
  System.Classes,
  FireDAC.Stan.Param,
  MVCFramework.Nullables;

type

  TCustomEntity = class abstract(TMVCActiveRecord)
  protected
    procedure OnBeforeExecuteSQL(var SQL: string); override;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('articles')]
  TArticle = class(TCustomEntity)
  private
    [MVCTableField('ID', [foPrimaryKey, foAutoGenerated])]
    fID: NullableInt32;
    fCodice: NullableString;
    [MVCTableField('description')]
    fDescrizione: string;
    [MVCTableField('price')]
    fPrezzo: Currency;
  public
    constructor Create; override;
    destructor Destroy; override;
    property ID: NullableInt32 read fID write fID;
    property Code: NullableString read fCodice write fCodice;
    property Description: string read fDescrizione write fDescrizione;
    property Price: Currency read fPrezzo write fPrezzo;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('articles')]
  TArticleWithWriteOnlyFields = class(TCustomEntity)
  private
{$IFNDEF USE_SEQUENCES}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated, foReadOnly])]
{$ELSE}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated],
      'SEQ_ARTICLES_ID' { required for interbase } )]
{$ENDIF}
    fID: NullableInt32;
    [MVCTableField('description', [foWriteOnly])]
    fDescrizione: string;
    [MVCTableField('price', [foWriteOnly])]
    fPrice: Integer;
  public
    property ID: NullableInt32 read fID write fID;
    property Description: string read fDescrizione write fDescrizione;
    property Price: Integer read fPrice write fPrice;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('articles')]
  TArticleWithReadOnlyFields = class(TCustomEntity)
  private
    [MVCTableField('ID', [foPrimaryKey, foReadOnly])]
    fID: NullableInt32;
    fCodice: NullableString;
    [MVCTableField('description', [foReadOnly])]
    fDescrizione: string;
    [MVCTableField('price', [foReadOnly])]
    fPrezzo: Currency;
  public
    property ID: NullableInt32 read fID write fID;
    property Code: NullableString read fCodice write fCodice;
    property Description: string read fDescrizione write fDescrizione;
    property Price: Currency read fPrezzo write fPrezzo;
  end;

  TOrder = class;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers')]
  TCustomer = class(TCustomEntity)
  private
{$IFNDEF USE_SEQUENCES}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
{$ELSE}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated],
      'SEQ_CUSTOMERS_ID' { required for interbase } )]
{$ENDIF}
    fID: NullableInt64;
    [MVCTableField('code')]
    fCode: NullableString;
    [MVCTableField('description')]
    fCompanyName: NullableString;
    [MVCTableField('city')]
    fCity: string;
    [MVCTableField('rating')]
    fRating: NullableInt32;
    [MVCTableField('note')]
    fNote: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ToString: String; override;
    property ID: NullableInt64 read fID write fID;
    property Code: NullableString read fCode write fCode;
    property CompanyName: NullableString read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
    property Rating: NullableInt32 read fRating write fRating;
    property Note: string read fNote write fNote;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers')]
  TPartitionedCustomer = class(TCustomEntity)
  private
{$IFNDEF USE_SEQUENCES}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
{$ELSE}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated],
      'SEQ_CUSTOMERS_ID' { required for interbase } )]
{$ENDIF}
    fID: NullableInt64;
    [MVCTableField('code')]
    fCode: NullableString;
    [MVCTableField('description')]
    fCompanyName: NullableString;
    [MVCTableField('city')]
    fCity: string;
    [MVCTableField('note')]
    fNote: string;
  public
    function ToString: String; override;
    property ID: NullableInt64 read fID write fID;
    property Code: NullableString read fCode write fCode;
    property CompanyName: NullableString read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
    property Note: string read fNote write fNote;
  end;


  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers', 'ge(Rating,4)')]
  TGoodCustomer = class(TCustomer)
  end;

  [MVCTable('customers')]
  [MVCPartition('rating=(integer)1')]
  TCustomerWithRate1 = class(TPartitionedCustomer)
  end;


  [MVCTable('customers')]
  [MVCPartition('rating=(integer)2')]
  TCustomerWithRate2 = class(TPartitionedCustomer)
  end;



  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers', 'le(Rating,3)')]
  TBadCustomer = class(TGoodCustomer)
  end;


  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers')]
  TCustomerWithReadOnlyFields = class(TCustomEntity)
  private
{$IFNDEF USE_SEQUENCES}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
{$ELSE}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated],
      'SEQ_CUSTOMERS_ID' { required for interbase } )]
{$ENDIF}
    fID: Integer;
    [MVCTableField('code', [foReadOnly])]
    fCode: string;
    fFormattedCode: string;
    [MVCTableField('description')]
    fCompanyName: string;
    [MVCTableField('city')]
    fCity: string;
    procedure SetFormattedCode(const Value: string);
  public
    property ID: Integer read fID write fID;
    property Code: string read fCode write fCode;
    property FormattedCode: string read fFormattedCode write SetFormattedCode;
    property CompanyName: string read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('order_details')]
  TOrderDetail = class(TCustomEntity)
  private
{$IFNDEF USE_SEQUENCES}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
{$ELSE}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated],
      'SEQ_order_details_ID' { required for interbase } )]
{$ENDIF}
    fID: Integer;
    [MVCTableField('id_order')]
    fOrderID: Integer;
    [MVCTableField('id_article')]
    fArticleID: Integer;
    [MVCTableField('unit_price')]
    fPrice: Currency;
    [MVCTableField('discount')]
    fDiscount: Integer;
    [MVCTableField('quantity')]
    fQuantity: Integer;
    [MVCTableField('description')]
    fDescription: string;
    [MVCTableField('total')]
    fTotal: Currency;
  public
    constructor Create; override;
    destructor Destroy; override;
    property ID: Integer read fID write fID;
    property OrderID: Integer read fOrderID write fOrderID;
    property ArticleID: Integer read fArticleID write fArticleID;
    property Price: Currency read fPrice write fPrice;
    property Discount: Integer read fDiscount write fDiscount;
    property Quantity: Integer read fQuantity write fQuantity;
    property Description: string read fDescription write fDescription;
    property Total: Currency read fTotal write fTotal;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers_plain')]
  TCustomerPlain = class(TCustomEntity)
  private
    [MVCTableField('id', [foPrimaryKey])]
    fID: NullableInt64;
    [MVCTableField('code')]
    fCode: NullableString;
    [MVCTableField('description')]
    fCompanyName: NullableString;
    [MVCTableField('city')]
    fCity: string;
    [MVCTableField('rating')]
    fRating: NullableInt32;
    [MVCTableField('note')]
    fNote: string;
    [MVCTableField('creation_time')]
    FCreationTime: TTime;
    [MVCTableField('creation_date')]
    FCreationDate: TDate;
  public
    property ID: NullableInt64 read fID write fID;
    property Code: NullableString read fCode write fCode;
    property CompanyName: NullableString read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
    property Rating: NullableInt32 read fRating write fRating;
    property Note: string read fNote write fNote;
    property CreationTime: TTime read FCreationTime write FCreationTime;
    property CreationDate: TDate read FCreationDate write FCreationDate;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers with spaces')]
  TCustomerWithSpaces = class(TCustomEntity)
  private
    [MVCTableField('id with spaces', [foPrimaryKey])]
    fID: NullableInt64;
    [MVCTableField('code with spaces')]
    fCode: NullableString;
    [MVCTableField('description with spaces')]
    fCompanyName: NullableString;
    [MVCTableField('city with spaces')]
    fCity: string;
    [MVCTableField('rating with spaces')]
    fRating: NullableInt32;
    [MVCTableField('note with spaces')]
    fNote: string;
  public
    property ID: NullableInt64 read fID write fID;
    property Code: NullableString read fCode write fCode;
    property CompanyName: NullableString read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
    property Rating: NullableInt32 read fRating write fRating;
    property Note: string read fNote write fNote;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers_with_code')]
  TCustomerWithCode = class(TCustomEntity)
  private
    [MVCTableField('code', [foPrimaryKey])]
    fCode: NullableString;
    [MVCTableField('description')]
    fCompanyName: NullableString;
    [MVCTableField('city')]
    fCity: string;
    [MVCTableField('rating')]
    fRating: NullableInt32;
    [MVCTableField('note')]
    fNote: string;
  public
    property Code: NullableString read fCode write fCode;
    property CompanyName: NullableString read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
    property Rating: NullableInt32 read fRating write fRating;
    property Note: string read fNote write fNote;
  end;

  [MVCTable('customers_with_code')]
  TCustomerPlainWithClientPK = class(TCustomerWithCode)
  protected
    procedure OnBeforeInsert; override;
  end;


  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers_with_guid')]
  TCustomerWithGUID = class(TCustomEntity)
  private
    [MVCSerializeGuidWithoutBraces]
    [MVCTableField('idguid', [foPrimaryKey])]
    fGUID: NullableTGUID;
    [MVCTableField('code')]
    fCode: NullableString;
    [MVCTableField('description')]
    fCompanyName: NullableString;
    [MVCTableField('city')]
    fCity: string;
    [MVCTableField('rating')]
    fRating: NullableInt32;
    [MVCTableField('note')]
    fNote: string;
  public
    property GUID: NullableTGUID read fGUID write fGUID;
    property Code: NullableString read fCode write fCode;
    property CompanyName: NullableString read fCompanyName write fCompanyName;
    property City: string read fCity write fCity;
    property Rating: NullableInt32 read fRating write fRating;
    property Note: string read fNote write fNote;
  end;


  [MVCNameCase(ncLowerCase)]
  [MVCTable('orders')]
  TOrder = class(TCustomEntity)
  private
{$IFNDEF USE_SEQUENCES}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
{$ELSE}
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated],
      'SEQ_ORDERS_ID' { required for interbase } )]
{$ENDIF}
    fID: Integer;
    [MVCTableField('id_customer')]
    fCustomerID: Integer;
    [MVCTableField('order_date')]
    fOrderDate: TDate;
    [MVCTableField('total')]
    fTotal: Currency;
  public
    constructor Create; override;
    destructor Destroy; override;
    property ID: Integer read fID write fID;
    property CustomerID: Integer read fCustomerID write fCustomerID;
    property OrderDate: TDate read fOrderDate write fOrderDate;
    property Total: Currency read fTotal write fTotal;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers')]
  TCustomerEx = class(TCustomer)
  private
    fOrders: TObjectList<TOrder>;
    function GetOrders: TObjectList<TOrder>;
  protected
    procedure OnAfterLoad; override;
    procedure OnAfterInsert; override;
  public
    destructor Destroy; override;
    property Orders: TObjectList<TOrder> read GetOrders;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('customers')]
  TCustomerWithLogic = class(TCustomer)
  private
    fIsLocatedInRome: Boolean;
  protected
    procedure OnAfterLoad; override;
    procedure OnBeforeInsertOrUpdate; override;
    procedure OnValidation(const Action: TMVCEntityAction); override;
  public
    property IsLocatedInRome: Boolean read fIsLocatedInRome;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('nullables_test')]
  TNullablesTest = class(TCustomEntity)
  private
    [MVCTableField('f_int2', [foPrimaryKey])]
    ff_int2: NullableInt16;
    [MVCTableField('f_int4')]
    ff_int4: NullableInt32;
    [MVCTableField('f_int8')]
    ff_int8: NullableInt64;
    [MVCTableField('f_date')]
    ff_date: NullableTDate;
    [MVCTableField('f_time')]
    ff_time: NullableTTime;
    [MVCTableField('f_bool')]
    ff_bool: NullableBoolean;
    [MVCTableField('f_datetime')]
    ff_datetime: NullableTDateTime;
    [MVCTableField('f_float4')]
    ff_float4: NullableSingle;
    [MVCTableField('f_float8')]
    ff_float8: NullableDouble;
    [MVCTableField('f_string')]
    ff_string: NullableString;
    [MVCTableField('f_currency')]
    ff_currency: NullableCurrency;
    [MVCTableField('f_blob')]
    ff_blob: TStream;
  public
    constructor Create; override;
    destructor Destroy; override;
    // f_int2 int2 NULL,
    property f_int2: NullableInt16 read ff_int2 write ff_int2;
    // f_int4 int4 NULL,
    property f_int4: NullableInt32 read ff_int4 write ff_int4;
    // f_int8 int8 NULL,
    property f_int8: NullableInt64 read ff_int8 write ff_int8;
    // f_string varchar NULL,
    property f_string: NullableString read ff_string write ff_string;
    // f_bool bool NULL,
    property f_bool: NullableBoolean read ff_bool write ff_bool;
    // f_date date NULL,
    property f_date: NullableTDate read ff_date write ff_date;
    // f_time time NULL,
    property f_time: NullableTTime read ff_time write ff_time;
    // f_datetime timestamp NULL,
    property f_datetime: NullableTDateTime read ff_datetime write ff_datetime;
    // f_float4 float4 NULL,
    property f_float4: NullableSingle read ff_float4 write ff_float4;
    // f_float8 float8 NULL,
    property f_float8: NullableDouble read ff_float8 write ff_float8;
    // f_currency numeric(18,4) NULL
    property f_currency: NullableCurrency read ff_currency write ff_currency;
    // f_blob bytea NULL
    property f_blob: TStream read ff_blob write ff_blob;
  end;

  [MVCNameCase(ncLowerCase)]
  [MVCTable('complex_types')]
  TComplexTypes = class(TCustomEntity)
  private
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
    fID: Int64;
    [MVCTableField('json_field', [], '', 'json')]
    FJSON: String;
    [MVCTableField('jsonb_field', [], '', 'jsonb')]
    FJSONB: String;
    [MVCTableField('xml_field', [], '', 'xml')]
    fXML: String;
  public
    property ID: Int64 read fID write fID;
    property JSON: String read FJSON write FJSON;
    property JSONB: String read FJSONB write FJSONB;
    property XML: String read fXML write fXML;
  end;

  [MVCTable('customers')]
  [MVCEntityActions([eaRetrieve])] //only the "R" in CRUD
  TReadOnlyCustomer = class(TCustomer)

  end;

// person, employee, manager
  [MVCTable('people')]
  [MVCEntityActions([])]  //no CRUD operations allowed for this entity
  TAbstractPerson = class abstract(TMVCActiveRecord)
  private
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
    fID: NullableInt64;
    [MVCTableField('last_name')]
    fLastName: String;
    [MVCTableField('first_name')]
    fFirstName: String;
    [MVCTableField('dob')]
    fDob: NullableTDate;
    [MVCTableField('full_name')]
    fFullName: NullableString;
    [MVCTableField('is_male')]
    fIsMale: NullableBoolean;
    [MVCTableField('note')]
    fNote: NullableString;
    [MVCTableField('photo')]
    fPhoto: TStream;
    function GetFullName: NullableString;
  protected
    procedure OnBeforeInsertOrUpdate; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property ID: NullableInt64 read fID write fID;
    property LastName: String read fLastName write fLastName;
    property FirstName: String read fFirstName write fFirstName;
    property Dob: NullableTDate read fDob write fDob;
    property FullName: NullableString read GetFullName;
    property IsMale: NullableBoolean read fIsMale write fIsMale;
    property Note: NullableString read fNote write fNote;
    property Photo: TStream read fPhoto write fPhoto;
  end;

  [MVCTable('people')]
  [MVCPartition('person_type=(string)employee')]
  TEmployee = class(TAbstractPerson)
  private
    [MVCTableField('salary')]
    fSalary: Currency;
  public
    property Salary: Currency read fSalary write fSalary;
  end;

  [MVCTable('people')]
  [MVCPartition('person_type=(string)manager')]
  TManager = class(TEmployee)
  private
    [MVCTableField('annual_bonus')]
    fAnnualBonus: Currency;
  public
    property AnnualBonus: Currency read fAnnualBonus write fAnnualBonus;
  end;

  [MVCTable('people', 'in(person_type,["manager","employee"])')]
  [MVCEntityActions([eaRetrieve, eaDelete])]
  TPerson = class(TAbstractPerson)

  end;

implementation

uses
  System.SysUtils, Data.DB, MVCFramework.Logger, System.Rtti;

constructor TArticle.Create;
begin
  inherited Create;
end;

destructor TArticle.Destroy;
begin
  inherited;
end;

constructor TCustomer.Create;
begin
  inherited Create;
end;

destructor TCustomer.Destroy;
begin

  inherited;
end;

function TCustomer.ToString: String;
begin
  Result := '';
  if PKIsNull then
    Result := '<null>'
  else
    Result := fID.ValueOrDefault.ToString;
  Result := Format('[ID: %6s][CODE: %6s][CompanyName: %18s][City: %16s][Rating: %3d][Note: %s]',[
    Result, fCode.ValueOrDefault, fCompanyName.ValueOrDefault, fCity, fRating.ValueOrDefault, fNote]);
end;

constructor TOrderDetail.Create;
begin
  inherited Create;
end;

destructor TOrderDetail.Destroy;
begin
  inherited;
end;

constructor TOrder.Create;
begin
  inherited Create;
end;

destructor TOrder.Destroy;
begin
  inherited;
end;

{ TCustomerEx }

destructor TCustomerEx.Destroy;
begin
  fOrders.Free;
  inherited;
end;

function TCustomerEx.GetOrders: TObjectList<TOrder>;
begin
  if not Assigned(fOrders) then
  begin
    fOrders := TObjectList<TOrder>.Create(True);
  end;
  Result := fOrders;
end;

procedure TCustomerEx.OnAfterInsert;
begin
  inherited;
end;

procedure TCustomerEx.OnAfterLoad;
begin
  inherited;
  if Self.ID.HasValue then
  begin
    fOrders.Free;
    fOrders := TMVCActiveRecord.Where<TOrder>('id_customer = ?', [Self.ID]);
  end;
end;

{ TCustomerWithLogic }

procedure TCustomerWithLogic.OnAfterLoad;
begin
  inherited;
  fIsLocatedInRome := fCity = 'ROME';
end;

procedure TCustomerWithLogic.OnBeforeInsertOrUpdate;
begin
  inherited;
  fCompanyName := fCompanyName.ValueOrDefault.ToUpper;
  fCity := fCity.ToUpper;
end;

procedure TCustomerWithLogic.OnValidation(const Action: TMVCEntityAction);
begin
  inherited;
  if fCompanyName.ValueOrDefault.IsEmpty or fCity.Trim.IsEmpty or fCode.Value.Trim.IsEmpty then
    raise Exception.Create('CompanyName, City and Code are required');
end;

{ TCustomerWithReadOnlyFields }

procedure TCustomerWithReadOnlyFields.SetFormattedCode(const Value: string);
begin
  fFormattedCode := Value;
end;

{ TNullablesTest }

constructor TNullablesTest.Create;
begin
  inherited Create;
  ff_blob := TMemoryStream.Create;
end;

destructor TNullablesTest.Destroy;
begin
  ff_blob.Free;
  inherited;
end;

{ TCustomEntity }

procedure TCustomEntity.OnBeforeExecuteSQL(var SQL: string);
begin
  inherited;
  Log.Info(ClassName + ' | ' + SQL, 'sql_trace');
end;

{ TCustomerPlainWithClientPK }

procedure TCustomerPlainWithClientPK.OnBeforeInsert;
begin
  inherited;
  SetPK(TValue.From<NullableString>(TGUID.NewGuid.ToString.Replace('{', '').Replace('-',
    '').Replace('}', '').Substring(0, 20)));
end;

{ TPartitionedCustomer }

function TPartitionedCustomer.ToString: String;
begin
  Result := '';
  if PKIsNull then
    Result := '<null>';
  Result := Format('[ID: %6s][CODE: %6s][CompanyName: %18s][City: %16s][Note: %s]',[
    Result, fCode.ValueOrDefault, fCompanyName.ValueOrDefault, fCity, fNote]);
end;

constructor TAbstractPerson.Create;
begin
  inherited Create;
  fPhoto := TMemoryStream.Create;
end;

destructor TAbstractPerson.Destroy;
begin
  fPhoto.Free;
  inherited;
end;

function TAbstractPerson.GetFullName: NullableString;
begin
  Result := fFirstName + ' ' + fLastName;
end;

procedure TAbstractPerson.OnBeforeInsertOrUpdate;
begin
  inherited;
  fFullName := GetFullName;
end;

end.
