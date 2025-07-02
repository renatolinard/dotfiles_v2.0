# Neovim Keymaps (COLA)

Este documento lista os mapeamentos de teclas configurados no seu Neovim, organizados para facilitar a memorização e evitar conflitos. O `<Leader>` está configurado para a tecla `[espaço]`.

## Mapeamentos Globais

| Tecla             | Descrição                               |
| :---------------- | :-------------------------------------- |
| `<C-d>`           | Rola a página para baixo, centralizando o cursor |
| `<C-u>`           | Rola a página para cima, centralizando o cursor |
| `J` (Normal)      | Junta a linha atual com a próxima, mantendo o cursor |
| `J` (Visual)      | Move a linha selecionada para baixo     |
| `K` (Visual)      | Move a linha selecionada para cima       |
| `n`               | Próximo resultado da busca, centralizando a tela |
| `N`               | Resultado anterior da busca, centralizando a tela |
| `<C-a>` (Insert)  | Equivalente a `<Esc>` (sair do modo de inserção) |
| `<Leader>o`       | Abre o explorador de arquivos Oil       |
| `<Leader>tc`      | Alterna a coluna de 80 caracteres       |
| `<Leader>e`       | Limpa o destaque da busca               |
| `<Leader>i`       | Entra no modo de inserção               |
| `<Leader>80`      | Vai para a coluna 80                    |

## Mapeamentos FZF-Lua (`<Leader>f`)

| Tecla             | Descrição                               |
| :---------------- | :-------------------------------------- |
| `<Leader>ff`      | Encontrar arquivos no diretório do projeto |
| `<Leader>fg`      | Encontrar por grep no diretório do projeto |
| `<Leader>fc`      | Encontrar na configuração do Neovim     |
| `<Leader>fh`      | Encontrar ajuda (helptags)              |
| `<Leader>fk`      | Encontrar keymaps                        |
| `<Leader>fb`      | Encontrar buffers existentes             |
| `<Leader>fw`      | Encontrar a palavra sob o cursor         |
| `<Leader>fW`      | Encontrar a PALAVRA sob o cursor         |
| `<Leader>fd`      | Encontrar diagnósticos do documento      |
| `<Leader>fr`      | Retomar a última busca do fzf-lua        |
| `<Leader>fo`      | Encontrar arquivos antigos               |
| `<Leader>f/`      | Grep ao vivo no buffer atual             |

## Mapeamentos LSP (Language Server Protocol)

Estes mapeamentos são específicos do buffer e só funcionam quando um Language Server está ativo.

| Tecla             | Descrição                               |
| :---------------- | :-------------------------------------- |
| `gd`              | Ir para a definição                      |
| `gD`              | Ir para a declaração                     |
| `gi`              | Ir para a implementação                  |
| `gr`              | Ir para as referências                   |
| `<Leader>lh`      | Mostrar informações de hover             |
| `<Leader>lr`      | Renomear símbolo                         |
| `<Leader>la`      | Mostrar ações de código                  |
| `[d`              | Ir para o diagnóstico anterior           |
| `]d`              | Ir para o diagnóstico seguinte           |
| `<Leader>ds`      | Mostrar lista de diagnósticos            |
| `<Leader>lf`      | Formatar documento                       |
| `<Leader>fs`      | Buscar símbolo no workspace              |
| `gt`              | Ir para a definição de tipo              |
| `gR`              | Mostrar referências LSP (via Trouble.nvim) |

## Mapeamentos Trouble.nvim (`<Leader>d`)

| Tecla             | Descrição                               |
| :---------------- | :-------------------------------------- |
| `<Leader>dd`      | Alternar diagnósticos do documento       |
| `<Leader>dw`      | Alternar diagnósticos do workspace       |
| `<Leader>dl`      | Alternar lista de localização            |
| `<Leader>dq`      | Alternar lista de quickfix               |