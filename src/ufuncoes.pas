unit uFuncoes;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Windows;

    function  BuscarUsuario: String;
    function  FileTimeToDTime(FTime: TFileTime): TDateTime;

implementation

function BuscarUsuario: String;
var
    I: DWord;
    Usuario: string;
begin
    I       := 255;
    SetLength(Usuario, I);
    GetUserName(PChar(Usuario), I);
    Usuario := String(PChar(Usuario));
    Result  := Usuario;
end;

function FileTimeToDTime(FTime: TFileTime): TDateTime;
var
    LocalFTime : TFileTime;
    STime      : TSystemTime;
begin
    FileTimeToLocalFileTime(FTime, LocalFTime);
    FileTimeToSystemTime(LocalFTime, STime);
    Result := SystemTimeToDateTime(STime);
end;

end.

