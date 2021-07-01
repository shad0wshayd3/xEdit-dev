program BethGame;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  wbGameMode in 'wbGameMode.pas',
  wbGameModeTES3 in 'wbGameModeTES3.pas',
  wbGameModeTES5 in 'wbGameModeTES5.pas';

var
  iter: TwbGameMode.TwbGameModeClass;

begin
  try
    TwbGameMode.InitList;
    TwbGameModeTES3.Register;
    // TwbGameModeTES4.Register;
    // TwbGameModeTES5.Register;
    TwbGameModeSSE.Register;
    // TwbGameModeSSEVR.Register;
    // TwbGameModeEnderal.Register;
    TwbGameModeEnderalSE.Register;
    // TwbGameModeFO3.Register;
    // TwbGameModeFNV.Register;
    // TwbGameModeFO4.Register;
    // TwbGameModeFO4VR.Register;
    // TwbGameModeFO76.Register;
    // TwbGameModeFrontier.Register;

    Writeln('GameMode Count: ' + TwbGameMode.List.Count.ToString);
    Writeln;

    for iter in TwbGameMode.List do begin
      with iter.Create do try
        Writeln('ToolName     : ' + GetToolName);
        Writeln('GameName     : ' + GetGameName);
        Writeln('GameType     : ' + GetGameTypeString);
        Writeln('GamePath     : ' + GetGamePath);
        Writeln('DataPath     : ' + GetDataPath);
        Writeln('MasterFile   : ' + GetMasterName);
        Writeln('Executable   : ' + GetExecutableName);
        Writeln('AppDataPath  : ' + GetAppDataPath);
        Writeln('PluginsPath  : ' + GetPluginsPath);
        Writeln('MyGamesPath  : ' + GetMyGamesPath);

        // Test GetIniSetting
        Writeln('IniFile[0]   : ' + GetIniFiles[0]);
        case GetGameType of
          gmTES3: begin
            Writeln('string       : ' + GetIniSetting('General', 'Screen Shot Base Name'));
            Writeln('integer      : ' + GetIniSetting('General', 'Subtitles'));
            Writeln('float        : ' + GetIniSetting('General', 'PC Footstep Volume'));
          end;

          gmSSE, gmSSEVR: begin
            Writeln('string       : ' + GetIniSetting('General', 'sLanguage'));
            Writeln('integer      : ' + GetIniSetting('Papyrus', 'bEnableTrace'));
            Writeln('uinteger     : ' + GetIniSetting('Decals', 'uMaxSkinDecalPerActor'));
            Writeln('float        : ' + GetIniSetting('LightingShader', 'fDecalLODFadeStart'));
          end;
        end;

        Writeln;
      finally
        Free;
      end;
    end;

    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
