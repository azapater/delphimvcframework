// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2020 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// Collaborators on this file:
// Jo�o Ant�nio Duarte (https://github.com/joaoduarte19)
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
// *************************************************************************** }

unit MVCFramework.RESTClient.Intf;

{$I dmvcframework.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  MVCFramework.Serializer.Intf,
  MVCFramework.Serializer.Commons,
  REST.Types,
  Data.DB,
  System.TypInfo;

type
  IMVCRESTResponse = interface;

  IMVCRESTClient = interface
    ['{592BC90F-B825-4B3B-84A7-6CA3927BAD69}']

    function BaseURL: string; overload;
    function BaseURL(const aBaseURL: string): IMVCRESTClient; overload;
    function RaiseExceptionOn500: Boolean; overload;
    function RaiseExceptionOn500(const aRaiseExceptionOn500: Boolean): IMVCRESTClient; overload;

    function ProxyServer: string; overload;
    function ProxyServer(const aProxyServer: string): IMVCRESTClient; overload;
    function ProxyPort: Integer; overload;
    function ProxyPort(const aProxyPort: Integer): IMVCRESTClient; overload;
    function ProxyUsername: string; overload;
    function ProxyUsername(const aProxyUsername: string): IMVCRESTClient; overload;
    function ProxyPassword: string; overload;
    function ProxyPassword(const aProxyPassword: string): IMVCRESTClient; overload;

    function UserAgent: string; overload;
    function UserAgent(const aUserAgent: string): IMVCRESTClient; overload;

    function ClearAllParams: IMVCRESTClient;

    /// <summary>
    /// Get request timeout.
    /// </summary>
    function Timeout: Integer; overload;
    /// <summary>
    /// Set request timeout.
    /// </summary>
    function Timeout(const aTimeout: Integer): IMVCRESTClient; overload;

    /// <summary>
    /// Add basic authorization header. Authorization = Basic <Username:Password>
    /// </summary>
    function SetBasicAuthorization(const aUsername, aPassword: string): IMVCRESTClient;

    /// <summary>
    /// Add bearer authorization header. Authorization = Bearer <Token>
    /// </summary>
    function SetBearerAuthorization(const aToken: string): IMVCRESTClient;

    /// <summary>
    /// Add a header.
    /// </summary>
    /// <param name="aName">
    /// Header name
    /// </param>
    /// <param name="aValue">
    /// Header value
    /// </param>
    /// <param name="aDoNotEncode">
    /// Indicates whether the value of this header should be used as is (True), or encoded by the component (False)
    /// </param>
    function AddHeader(const aName, aValue: string; const aDoNotEncode: Boolean = False): IMVCRESTClient; overload;

    /// <summary>
    /// Clears all headers.
    /// </summary>
    function ClearHeaders: IMVCRESTClient;

    /// <summary>
    /// Add a cookie header.
    /// </summary>
    function AddCookie(const aName, aValue: string): IMVCRESTClient;
    /// <summary>
    /// Clear all cookie headers.
    /// </summary>
    function ClearCookies: IMVCRESTClient;

    /// <summary>
    /// Add a URL segment parameter. The parameters of your url path may be enclosed in braces or in
    /// parentheses starting with a money sign. <c>/api/{param1}/($param2)</c>
    /// </summary>
    /// <param name="aName">
    /// Parameter name
    /// </param>
    /// <param name="aValue">
    /// Parameter value
    /// </param>
    function AddPathParam(const aName, aValue: string): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: Integer): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: Int64): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: TGUID): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: TDateTime): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: TDate): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: TTime): IMVCRESTClient; overload;
    function AddPathParam(const aName: string; aValue: Double): IMVCRESTClient; overload;
    function ClearPathParams: IMVCRESTClient;

    /// <summary>
    /// Add a QueryString parameter. <c>/api/person?para1=value&amp;param2=value</c>
    /// </summary>
    function AddQueryStringParam(const aName, aValue: string): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: Integer): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: Int64): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: TGUID): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: TDateTime): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: TDate): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: TTime): IMVCRESTClient; overload;
    function AddQueryStringParam(const aName: string; aValue: Double): IMVCRESTClient; overload;
    function ClearQueryParams: IMVCRESTClient;

    function Accept: string; overload;
    function Accept(const aAccept: string): IMVCRESTClient; overload;
    function AcceptCharset: string; overload;
    function AcceptCharset(const aAcceptCharset: string): IMVCRESTClient; overload;
    function AcceptEncoding: string; overload;
    function AcceptEncoding(const aAcceptEncoding: string): IMVCRESTClient; overload;
    function HandleRedirects: Boolean; overload;
    function HandleRedirects(const aHandleRedirects: Boolean): IMVCRESTClient; overload;

    /// <summary>
    /// Get the current resource path.
    /// </summary>
    function Resource: string; overload;
    /// <summary>
    /// Set the current resource path.
    /// </summary>
    function Resource(const aResource: string): IMVCRESTClient; overload;
    /// <summary>
    /// Add a body to the requisition.
    /// </summary>
    /// <param name="aBody">
    /// Body in string format.
    /// </param>
    /// <param name="aContentType">
    /// Body content type.
    /// </param>

    function URLAlreadyEncoded: string; overload;
    function URLAlreadyEncoded(const aURLAlreadyEncoded: Boolean): IMVCRESTClient; overload;

    function AddBody(const aBody: string; const aDoNotEncode: Boolean = False;
      const aContentType: TRESTContentType = TRESTContentType.ctNone): IMVCRESTClient; overload;
    /// <summary>
    /// Add a body to the requisition
    /// </summary>
    /// <param name="aBodyStream">
    /// Body in Stream format
    /// </param>
    /// <param name="aContentType">
    /// Body content type
    /// </param>
    /// <param name="aOwnsStream">
    /// If OwnsStream is true, Stream will be destroyed by IMVCRESTClient.
    /// </param>
    function AddBody(aBodyStream: TStream; const aContentType: TRESTContentType = TRESTContentType.ctNone;
      const aOwnsStream: Boolean = True): IMVCRESTClient; overload;
    /// <summary>
    /// Add a body to the requisition
    /// </summary>
    /// <param name="aBodyObject">
    /// Body in Object format. The object will be serialized to a JSON string.
    /// </param>
    /// <param name="aOwnsObject">
    /// If OwnsObject is true, BodyObject will be destroyed by IMVCRESTClient.
    /// </param>
    function AddBody(aBodyObject: TObject; const aOwnsObject: Boolean = True): IMVCRESTClient; overload;
    function ClearBody: IMVCRESTClient;

    /// <summary>
    /// Adds a file as the request body. Several files can be added in the same request. In this case the request
    /// will be of the multipart/form-data type
    /// </summary>
    /// <param name="aName">
    /// Field name
    /// </param>
    /// <param name="aFileName">
    /// File path
    /// </param>
    /// <param name="aContentType">
    /// File content type
    /// </param>
    function AddFile(const aName, aFileName: string;
      const aContentType: TRESTContentType = TRESTContentType.ctNone): IMVCRESTClient; overload;
    function AddFile(const aFileName: string;
      const aContentType: TRESTContentType = TRESTContentType.ctNone): IMVCRESTClient; overload;
    function ClearFiles: IMVCRESTClient;

    /// <summary>
    /// Executes the next request asynchronously.
    /// </summary>
    /// <param name="aCompletionHandler">
    /// An anonymous method that will be run after the execution completed.
    /// </param>
    /// <param name="aSynchronized">
    /// Specifies if aCompletioHandler will be run in the main thread's (True) or execution thread's (False) context.
    /// </param>
    /// <param name="aCompletionHandlerWithError">
    /// An anonymous method that will be run if an exception is raised during execution.
    /// </param>
    function Async(aCompletionHandler: TProc<IMVCRESTResponse>; const aSynchronized: Boolean = True;
      aCompletionHandlerWithError: TProc<Exception> = nil): IMVCRESTClient;

    /// <summary>
    /// Execute a Get request.
    /// </summary>
    function Get: IMVCRESTResponse; overload;
    function Get(const aResource: string): IMVCRESTResponse; overload;

    /// <summary>
    /// Execute a Post request.
    /// </summary>
    function Post: IMVCRESTResponse; overload;
    function Post(const aResource: string; const aBody: string = ''): IMVCRESTResponse; overload;
    function Post(const aResource: string; aBody: TObject; const aOwnsBody: Boolean = True): IMVCRESTResponse; overload;

    /// <summary>
    /// Execute a Patch request.
    /// </summary>
    function Patch: IMVCRESTResponse; overload;
    function Patch(const aResource: string; const aBody: string = ''): IMVCRESTResponse; overload;
    function Patch(const aResource: string; aBody: TObject; const aOwnsBody: Boolean = True): IMVCRESTResponse;
      overload;

    /// <summary>
    /// Execute a Put request.
    /// </summary>
    function Put: IMVCRESTResponse; overload;
    function Put(const aResource: string; const aBody: string = ''): IMVCRESTResponse; overload;
    function Put(const aResource: string; aBody: TObject; const aOwnsBody: Boolean = True): IMVCRESTResponse; overload;

    /// <summary>
    /// Execute a Delete request.
    /// </summary>
    function Delete: IMVCRESTResponse; overload;
    function Delete(const aResource: string): IMVCRESTResponse; overload;

    /// <summary>
    /// Serialize the current dataset record and execute a POST request.
    /// </summary>
    function DataSetInsert(const aResource: string; aDataSet: TDataSet; const aIgnoredFields: TMVCIgnoredList = [];
      const aNameCase: TMVCNameCase = ncAsIs): IMVCRESTResponse;
    /// <summary>
    /// Serialize the current dataset record and execute a PUT request.
    /// </summary>
    function DataSetUpdate(const aResource: string; aDataSet: TDataSet; const aIgnoredFields: TMVCIgnoredList = [];
      const aNameCase: TMVCNameCase = ncAsIs): IMVCRESTResponse;
    /// <summary>
    /// Delete the current dataset record by executing a delete request.
    /// </summary>
    function DataSetDelete(const aResource: string): IMVCRESTResponse;

    /// <summary>
    /// Register a custom serializer to the RESTClient serializer.
    /// </summary>
    function RegisterTypeSerializer(const aTypeInfo: PTypeInfo; aInstance: IMVCTypeSerializer): IMVCRESTClient;
  end;

  IMVCRESTResponse = interface
    ['{BF611B46-CCD1-47C7-8D8B-82EA0518896B}']

    function Success: Boolean;
    function StatusCode: Integer;
    function StatusText: string;
    function ErrorMessage: string;
    function Headers: TStrings;
    function HeaderByName(const aName: string): string;
    function Server: string;
    function FullRequestURI: string;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentLength: Integer;
    function Content: string;
    function RawBytes: TBytes;
    procedure SaveContentToStream(aStream: TStream);
    procedure SaveContentToFile(const aFileName: string);
  end;

implementation

end.
