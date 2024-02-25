unit ufrmPrincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
    StdCtrls, ComCtrls, EditBtn, Windows, DateUtils, FileUtil, ShellAPI, uFuncoes;

type

    { TfrmPrincipal }

    TfrmPrincipal = class(TForm)
        chk_IgnoraSubdiretorios: TCheckBox;
        dir_Destino: TDirectoryEdit;
        dir_Origem: TDirectoryEdit;
        Image1: TImage;
        img_Logo: TImage;
        lbl_BoasVindas: TLabel;
        lbl_Acessado: TLabel;
        lbl_DiretorioDestino: TLabel;
        lbl_DiretorioOrigem: TLabel;
        lbl_Menu: TLabel;
        lbl_SelecioneDiretorioDestino: TLabel;
        lbl_SelecioneDiretorioOrigem: TLabel;
        lbl_Sobre_01: TLabel;
        lbl_Sobre_02: TLabel;
        lbl_Sobre_3: TLabel;
        mem_Log: TMemo;
        pgc_Conteudo: TPageControl;
        pnl_Conteudo: TPanel;
        pnl_Botoes: TPanel;
        pnl_Logo: TPanel;
        pnl_Menu: TPanel;
        pnl_Central: TPanel;
        pnl_Processar: TPanel;
        pnl_Reorganizador: TPanel;
        pnl_Sair: TPanel;
        pnl_Sobre: TPanel;
        sbt_Iniciar: TSpeedButton;
        sbt_Linkedin1: TSpeedButton;
        sbt_Processar: TSpeedButton;
        sbt_Reorganizador: TSpeedButton;
        sbt_Sair: TSpeedButton;
        sbt_Sobre: TSpeedButton;
        shp_Dividor_01: TShape;
        shp_Dividor_02: TShape;
        shp_Dividor_03: TShape;
        sbt_Github: TSpeedButton;
        tbs_01_Sobre: TTabSheet;
        tbs_02_Reorganizador: TTabSheet;
        trv_DiretorioDestino: TTreeView;
        trv_DiretorioOrigem: TTreeView;
        procedure FormShow(Sender: TObject);
        procedure sbt_GithubClick(Sender: TObject);
        procedure sbt_Linkedin1Click(Sender: TObject);
        procedure sbt_ProcessarClick(Sender: TObject);
        procedure sbt_ProcessarMouseEnter(Sender: TObject);
        procedure sbt_ProcessarMouseLeave(Sender: TObject);
        procedure sbt_ReorganizadorClick(Sender: TObject);
        procedure sbt_SairClick(Sender: TObject);
        procedure sbt_SobreClick(Sender: TObject);
        procedure tbs_02_ReorganizadorShow(Sender: TObject);
    private
        procedure ListarArquivos(pDiretorio: String);
        procedure CriarDiretorio(pDataCriacao: TDateTime; pExtensao, pArquivo: String);
        procedure RealocarArquivo(pArquivo, pArquivoDestino: String);
        function  RenomearArquivo(pArquivo: String): String;
    public
        ContadorArquivos: Integer;
    end;

var
    frmPrincipal: TfrmPrincipal;

const
    Meses: array [1..12] of String = ('01 - JANEIRO',  '02 - FEVEREIRO', '03 - MARÇO',    '04 - ABRIL',
                                      '05 - MAIO',     '06 - JUNHO',     '07 - JULHO',    '08 - AGOSTO',
                                      '09 - SETEMBRO', '10 - OUTUBRO',   '11 - NOVEMBRO', '12 - DEZEMBRO');

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
    lbl_BoasVindas.Caption  := 'Boas-vindas, '+ BuscarUsuario + '.';
    lbl_Acessado.Caption    := 'Acessado em ' + FormatDateTime('dd/mm/yyyy hh:nn', Now);
    sbt_SobreClick(Sender);
end;

procedure TfrmPrincipal.sbt_GithubClick(Sender: TObject);
begin
    ShellExecute(Handle, 'OPEN', 'https://github.com/SimoesLeticia', NIL, NIL, SW_SHOW);
end;

procedure TfrmPrincipal.sbt_Linkedin1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'OPEN', 'https://www.linkedin.com/in/simoesLeticia', NIL, NIL, SW_SHOW);
end;

procedure TfrmPrincipal.sbt_ProcessarClick(Sender: TObject);
var
    TempoInicio : Cardinal;
    TempoFim    : Cardinal;
begin
    // Validações
    if (not DirectoryExists(dir_Origem.Text)) then
    begin
        Application.MessageBox('Diretório de origem não encontrado!', 'ERRO', MB_ICONEXCLAMATION);
        Exit;
    end;

    if (not DirectoryExists(dir_Destino.Text)) then
        ForceDirectories(dir_Destino.Text);

    if (Application.MessageBox('Deseja reorganizar os arquivos para o novo diretório de destino?', 'Atenção' , 3 + MB_ICONEXCLAMATION) <> IDYES) then
        Exit;

    // Processamento
    sbt_Processar.Enabled := False;
    sbt_Processar.Caption := 'Em processamento. Aguarde...';

    mem_Log.Enabled       := True;
    mem_Log.Lines.Clear;
    mem_log.Lines.Add('LOG DE PROCESSAMENTO:');
    Application.ProcessMessages;

    ContadorArquivos  := 0;
    TempoInicio := GetTickCount;

    try
        ListarArquivos(dir_Origem.Text);
    except
        on E: Exception do
        begin
            mem_Log.Lines.Add('ERRO: ' + e.Message);
            ShowMessage('Atenção! Ocorreu uma falha durante o processamento dos arquivos: ' + #13 + e.Message);
        end;
    end;

    TempoFim    := GetTickCount - TempoInicio;

    // Salvar LOG no diretório do projeto
    mem_Log.Lines.Add('');
    mem_Log.Lines.Add('Quantidade de Arquivos copiados: ' + IntToStr(ContadorArquivos));
    mem_Log.Lines.Add('Tempo Total de Execução: ' + FormatDateTime('hh:mm:ss', UnixToDateTime(TempoFim div 1000)));
    mem_Log.Lines.SaveToFile(ExtractFileDir(Application.ExeName) + '\LOG.log');

    //Abrir diretório destino
    if (Application.MessageBox(PChar('Processamento concluído com sucesso!' + #13 + 'Deseja abrir diretório de destino?'), 'Atenção' , 3 + MB_ICONEXCLAMATION) = IDYES) then
        shellexecute(handle, 'open', Pchar(dir_Destino.Text), nil, nil, SW_SHOWMAXIMIZED);

    sbt_Processar.Enabled := True;
    sbt_Processar.Caption := 'Iniciar processamento';
end;

procedure TfrmPrincipal.sbt_ProcessarMouseEnter(Sender: TObject);
begin
    sbt_Processar.Font.Color := clBlack;
end;

procedure TfrmPrincipal.sbt_ProcessarMouseLeave(Sender: TObject);
begin
    sbt_Processar.Font.Color := clWhite;
end;

procedure TfrmPrincipal.sbt_ReorganizadorClick(Sender: TObject);
begin
    pgc_Conteudo.ActivePage := tbs_02_Reorganizador;
end;

procedure TfrmPrincipal.sbt_SairClick(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TfrmPrincipal.sbt_SobreClick(Sender: TObject);
begin
    pgc_Conteudo.ActivePage := tbs_01_Sobre;
end;

procedure TfrmPrincipal.tbs_02_ReorganizadorShow(Sender: TObject);
begin
    if (Dir_Origem.Directory = '') then
        Dir_Origem.Directory := ExtractFileDir(Application.ExeName) + '\Samples\DiretorioAmostra';

    if (Dir_Destino.Directory = '') then
        Dir_Destino.Directory := ExtractFileDir(Application.ExeName)  + '\Samples\DiretorioDestino';
end;

procedure TfrmPrincipal.ListarArquivos(pDiretorio: String);
var
    Retorno     : Integer;
    Search      : TSearchRec;
    DataCriacao : TDateTime;
    Extensao    : String;
    Arquivo     : String;
begin
    Retorno := FindFirst(pDiretorio + '\*.*', faAnyFile or faArchive or faDirectory, Search);
    while Retorno = 0 do
    begin
        if (Trim(Search.Name) <> '.') and (Trim(Search.Name) <> '..') then
        begin
            if (Search.Attr and faDirectory > 0) and (not chk_IgnoraSubdiretorios.Checked) then
                ListarArquivos(pDiretorio + '\' + Search.Name)
            else
            begin
                DataCriacao := FileTimeToDTime(Search.FindData.ftCreationTime);
                Extensao    := ExtractFileExt(Search.Name);
                Arquivo     := pDiretorio + '\' + Search.Name;

                // Tratamento para ignorar subdiretórios
                if (FileExists(Arquivo)) then
                    CriarDiretorio(DataCriacao, UPPERCASE(Extensao), UPPERCASE(Arquivo));
            end;
        end;
        Retorno := FindNext(Search);
    end;
    SysUtils.FindClose(Search);
end;

procedure TfrmPrincipal.CriarDiretorio(pDataCriacao: TDateTime; pExtensao,
    pArquivo: String);
var
    ArquivoDestino : String;
    Diretorio      : String;
begin
    Diretorio      := dir_Destino.Text
                      + '\' + IntToStr(YearOf(pDataCriacao))
                      + '\' + Meses[MonthOf(pDataCriacao)]
                      + '\' + Copy(pExtensao, (Pos('.', pExtensao) + 1));
    ArquivoDestino := Diretorio + '\' + ExtractFileName(pArquivo);
    if (not DirectoryExists(Diretorio)) then
        ForceDirectories(Diretorio);
    RealocarArquivo(pArquivo, UPPERCASE(ArquivoDestino));
end;

procedure TfrmPrincipal.RealocarArquivo(pArquivo, pArquivoDestino: String);
var
    ArquivoRenomeado: String;
begin
    if FileExists(pArquivoDestino) then
    begin
        ArquivoRenomeado := RenomearArquivo(pArquivoDestino);
        RealocarArquivo(pArquivo, ArquivoRenomeado);
    end
    else
    begin
        try
            CopyFile(Pchar(pArquivo), Pchar(pArquivoDestino), False);
            mem_Log.Lines.Add('Copiado com Sucesso: ' + pArquivoDestino);
            Inc(ContadorArquivos);
        except
            mem_Log.Lines.Add('ERRO AO COPIAR: ' + pArquivoDestino);
        end;
    end;
end;

function TfrmPrincipal.RenomearArquivo(pArquivo: String): String;
var
    ArquivoDestino : String;
    NomeArquivo    : String;
    Diretorio      : String;
    Extensao       : String;
    PosExtensao    : Integer;
    Contador       : Integer;
begin
    ArquivoDestino := pArquivo;
    Contador       := 1;
    repeat
        NomeArquivo := ExtractFileName(pArquivo);
        Diretorio   := ExtractFileDir(pArquivo);
        Extensao    := ExtractFileExt(pArquivo);
        PosExtensao := Pos(Extensao, NomeArquivo);

        { Tratamento para arquivos duplicados, permanecem ambos os arquivos.
          Exemplo: O Arquivo Teste.txt será copiado para pasta destino com o nome: Teste_1.txt }
        ArquivoDestino := Diretorio
                          + '\' + Copy(NomeArquivo, 0, (PosExtensao - 1))
                          + '_' + IntToStr(Contador)
                          + Extensao;
        Inc(Contador);
    until (not FileExists(ArquivoDestino));

    Result := ArquivoDestino;
end;

end.

