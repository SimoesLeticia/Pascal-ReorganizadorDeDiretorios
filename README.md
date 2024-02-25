# Pascal - Reorganizador De Diretórios

O objetivo deste aplicativo em Pascal é oferecer uma solução eficiente para reorganizar arquivos em um diretório específico. A reorganização será realizada criando uma nova estrutura de pastas com base na data de criação e na extensão dos arquivos presentes.

## Funcionalidades Principais
- **Análise de Arquivos:** O aplicativo escaneia o diretório especificado, identificando todos os arquivos presentes.
- **Criação de Estrutura de Pastas:** Com base na data de criação e extensão dos arquivos, o programa cria uma nova estrutura de pastas para armazená-los de forma organizada.
- **Realocação de Arquivos:** Cada arquivo é copiado para a pasta correspondente à sua data de criação e extensão, mantendo a hierarquia estabelecida.
- **Tratamento de Duplicatas:** Em casos de arquivos duplicados (que possuam o mesmo nome, data de criação e extensão), todas as cópias são mantidas na nova estrutura de pastas.
- **Relatório de Processamento:** Após a conclusão da reorganização, é gerado um arquivo log detalhado, indicando quais arquivos foram movidos e para qual pasta. Este arquivo pode ser encontrado na raiz do projeto com o nome `LOG.log`.

## Detalhes Adicionais
- **Novo Diretório de Destino:** O usuário pode especificar o local onde deseja que os arquivos reorganizados sejam armazenados.
- **Flexibilidade de Configuração:** A opção ***Ignorar arquivos dentro de subdiretórios*** permite que o aplicativo considere apenas os arquivos na raiz do diretório de origem. Isto é, arquivos dentro de subpastas não serão copiados.
  
## Benefícios
### Organização Eficiente
A reestruturação dos arquivos em pastas categorizadas por data e extensão simplifica a localização e o gerenciamento.
### Economia de Tempo
Automatizando o processo de reorganização, o aplicativo poupa tempo e esforço.
### Redução de Erros
Minimizando a intervenção humana, o risco de erros durante o processo é significativamente reduzido.

## Nota
- O aplicativo acompanha um diretório amostra com 13 arquivos de diferentes extensões, ideal para testar e entender seu funcionamento. O executável também está disponível para execução sem a necessidade de compilação.

```
# Caminho para o diretório amostra:
> ./ReorganizadorDeArquivos/samples/DiretorioAmostra
```

## Pré-requisitos
Desenvolvido na versão 2.2.6 da IDE Lazarus, sem dependências adicionais.

## Telas
<img src="https://raw.githubusercontent.com/SimoesLeticia/Pascal-ReorganizadorDeDiretorios/main/assets/tela_sobre.png" width="50%"><img src="https://raw.githubusercontent.com/SimoesLeticia/Pascal-ReorganizadorDeDiretorios/main/assets/tela_reorganizador.png" width="50%">

## Contribuições
Contribuições são sempre bem-vindas! Se você tem sugestões de melhorias, encontrou algum bug ou simplesmente quer dizer "olá 👋🏽", sinta-se à vontade para abrir uma issue ou enviar um pull request.
