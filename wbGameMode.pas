unit wbGameMode;

interface

uses
  Classes,
  Generics.Collections,
  IOUtils,
  Registry,
  ShlObj,
  SysUtils,
  Windows;

type
  TwbGameModeClass = class of TwbGameMode;
  TwbGameMode = class
    public
      class procedure InitList;
      class procedure Register;

      class var List: TList<TwbGameModeClass>;

      function GetAppName(): string;          virtual; abstract;
      function GetGameName(): string;         virtual; abstract;
      function GetGamePath(): string;         virtual; abstract;
      function GetDataFolderName(): string;   virtual; abstract;
      function GetDataPath(): string;         virtual; abstract;
      function GetAppDataPath(): string;      virtual; abstract;
      function GetMyGamesPath(): string;      virtual; abstract;

    protected
      class function GetRegKeys(const a_path: string; const a_HKEY: cardinal = HKEY_LOCAL_MACHINE): TStringList;
      class function GetRegValue(const a_path: string; const a_key: string; const a_HKEY: cardinal = HKEY_LOCAL_MACHINE): string;
      class function GetMSStorePath(const a_packageName: string): string;
      class function GetMSStoreLanguage(): string;
      class function GetCSIDLShellFolder(const a_CSIDLFolder: integer): string;
      class function GetLocalAppDataPath(): string;
      class function GetMyDocumentsPath(): string;

      var GamePath: string;
      var DataPath: string;
      var AppDataPath: string;
      var MyGamesPath: string;

      var IsMicrosoftStore: boolean;
  end;

implementation
  function GetUserDefaultLocaleName(lpLocaleName: LPWSTR; cchLocaleName: integer): integer; stdcall; external kernel32 name 'GetUserDefaultLocaleName';

  class procedure TwbGameMode.InitList;
  begin
    List := TList<TwbGameModeClass>.Create;
  end;

  class procedure TwbGameMode.Register;
  begin
    List.Add(self);
  end;

  class function TwbGameMode.GetRegKeys;
  begin
    Result := TStringList.Create;
    with TRegistry.Create do try
      Access  := KEY_READ or KEY_WOW64_32KEY;
      RootKey := a_HKEY;

      if not OpenKey(a_path, False) then begin
        Access := KEY_READ or KEY_WOW64_64KEY;
        if not OpenKey(a_path, False) then exit;
      end;

      GetKeyNames(Result);
    finally
      Free;
    end;
  end;

  class function TwbGameMode.GetRegValue;
  begin
    Result := '';
    with TRegistry.Create do try
      Access  := KEY_READ or KEY_WOW64_32KEY;
      RootKey := a_HKEY;

      if not OpenKey(a_path, False) then begin
        Access := KEY_READ or KEY_WOW64_64KEY;
        if not OpenKey(a_path, False) then exit;
      end;

      Result := ReadString(a_key);
    finally
      Free;
    end;
  end;

  // https://github.com/wrye-bash/wrye-bash/wiki/%5Bdev%5D-Microsoft-Store-Games
  class function TwbGameMode.GetMSStorePath;
  var
    FullNameList, IndexList: TStringList;
    FullName, Index: string;
  begin
    Result := '';
    try
      FullNameList := GetRegKeys(
        TPath.Combine(
          'Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Families\',
          a_packageName),
        HKEY_CLASSES_ROOT);

      for FullName in FullNameList do begin
        try
          IndexList := GetRegKeys(
            TPath.Combine(
              'SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\StateRepository\Cache\Package\Index\PackageFullName\',
              FullName));

          for Index in IndexList do begin
            Result := GetRegValue(
              TPath.Combine(
                'SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\StateRepository\Cache\Package\Data\',
                Index),
              'MutableLocation');
            if (Result <> '') then exit;
          end;
        finally
          FreeAndNil(IndexList);
        end;
      end;
    finally
      FreeAndNil(FullNameList);
    end;
  end;

  class function TwbGameMode.GetMSStoreLanguage;
  var
    buf: array [0..84] of WideChar;
  begin
    Result := 'en';
    if (GetUserDefaultLocaleName(buf, 85) <> 0) then
      Result := buf;
  end;

  class function TwbGameMode.GetCSIDLShellFolder;
  begin
    SetLength(Result, MAX_PATH);
    SHGetSpecialFolderPath(0, PChar(Result), a_CSIDLFolder, True);
    SetLength(Result, StrLen(PChar(Result)));
    if (Result <> '') then
      Result := IncludeTrailingBackslash(Result);
  end;

  class function TwbGameMode.GetLocalAppDataPath;
  begin
    Result := GetCSIDLShellFolder(CSIDL_LOCAL_APPDATA);
  end;

  class function TwbGameMode.GetMyDocumentsPath;
  begin
    Result := GetCSIDLShellFolder(CSIDL_PERSONAL);
  end;
end.
