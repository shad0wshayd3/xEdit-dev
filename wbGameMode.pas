unit wbGameMode;

interface

uses
  Classes,
  Generics.Collections,
  IniFiles,
  IOUtils,
  Registry,
  ShlObj,
  SysUtils,
  Windows;

type
  TwbGameType = (gmTES3, gmTES4, gmFO3, gmFNV, gmTES5, gmFO4, gmFO4VR, gmSSE, gmSSEVR, gmFO76);
  TStringArray = array of string;

  TwbGameMode = class
    public
      class procedure InitList;
      class procedure Register;

      type TwbGameModeClass = class of TwbGameMode;
      class var List: TList<TwbGameModeClass>;

      function GetToolName(): string;                                                                       virtual; abstract;
      function GetGameName(): string;                                                                       virtual; abstract;
      function GetGameType(): TwbGameType;                                                                  virtual; abstract;
      function GetGameTypeString(): string;                                                                 virtual; final;
      function GetGamePath(): string;                                                                       virtual; abstract;
      function GetDataFolderName(): string;                                                                 virtual; abstract;
      function GetDataPath(): string;                                                                       virtual; abstract;
      function GetMasterName(): string;                                                                     virtual; abstract;
      function GetExecutableName(): string;                                                                 virtual; abstract;
      function GetAppDataPath(): string;                                                                    virtual; abstract;
      function GetPluginsPath(): string;                                                                    virtual; abstract;
      function GetMyGamesPath(): string;                                                                    virtual; abstract;
      function GetIniFiles(): TStringArray;                                                                 virtual; abstract;
      function GetIniSetting(const a_section, a_ident: string; const a_default: string = ''): string;       virtual; abstract;
      function TryGetIniSetting(const a_section, a_ident: string; const a_default: string = ''): string;    virtual; final;

    protected
      class function GetRegKeys(const a_path: string; const a_HKEY: cardinal = HKEY_LOCAL_MACHINE): TStringList;
      class function GetRegValue(const a_path, a_key: string; const a_HKEY: cardinal = HKEY_LOCAL_MACHINE): string;
      class function GetMSStorePath(const a_packageName: string): string;
      class function GetMSStoreLanguage(): string;
      class function GetCSIDLShellFolder(const a_CSIDLFolder: integer): string;
      class function GetLocalAppDataPath(): string;
      class function GetMyDocumentsPath(): string;

      var GamePath: string;
      var DataPath: string;
      var AppDataPath: string;
      var PluginsFilePath: string;
      var MyGamesPath: string;
      var IsMSStore: boolean;
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

  function TwbGameMode.GetGameTypeString: string;
  begin
    case GetGameType of
      gmTES3  : Result := 'gmTES3';
      gmTES4  : Result := 'gmTES4';
      gmFO3   : Result := 'gmFO3';
      gmFNV   : Result := 'gmFNV';
      gmTES5  : Result := 'gmTES5';
      gmFO4   : Result := 'gmFO4';
      gmFO4VR : Result := 'gmFO4VR';
      gmSSE   : Result := 'gmSSE';
      gmSSEVR : Result := 'gmSSEVR';
      gmFO76  : Result := 'gmFO76';
    end;
  end;
  
  function TwbGameMode.TryGetIniSetting;
  var
    fileName, filePath: string;
  begin
    Result := a_default;
    for fileName in GetIniFiles do begin
      filePath := TPath.Combine(GetMyGamesPath, fileName);
      with TMemIniFile.Create(filePath) do try
        if ValueExists(a_section, a_ident) then begin
          Result := ReadString(a_section, a_ident, a_default);
          exit;
        end;
      finally
        Free;
      end;
    end;
  end;
end.
