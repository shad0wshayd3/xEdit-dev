program BethGame;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  wbGameMode in 'wbGameMode.pas' {/ wbModeSkyrimSpecialEdition in 'wbModeSkyrimSpecialEdition.pas';},
  wbGameModeTES3 in 'wbGameModeTES3.pas',
  wbGameModeTES5 in 'wbGameModeTES5.pas';

var
  iter: TwbGameModeClass;

begin
  try
    TwbGameMode.InitList;
    TwbGameModeTES3.Register;
    // TwbGameModeTES4.Register;
    // TwbGameModeTES5.Register;
    TwbGameModeSSE.Register;
    // TwbGameModeTES5VR.Register;
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
        Writeln('AppName     : ' + GetAppName);
        Writeln('GameName    : ' + GetGameName);
        Writeln('GamePath    : ' + GetGamePath);
        Writeln('DataPath    : ' + GetDataPath);
        Writeln('AppDataPath : ' + GetAppDataPath);
        Writeln('MyGamesPath : ' + GetMyGamesPath);
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
