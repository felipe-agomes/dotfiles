---
name: Config Neovim
description: Use ao adicionar ou alterar plugins, keymaps, LSP, formatadores, linters ou configurações neste dotfiles do Neovim. Define a estrutura do projeto, o agrupamento de keymaps, a separação entre configuração geral e específica de linguagem e as convenções de simplicidade.
---

# Config Neovim

Este skill documenta o padrão deste repositório de configuração do Neovim.
Use-o antes de adicionar plugins, keymaps, suporte a linguagens, LSP,
formatadores, linters ou autocmds.

## Princípios

1. **Simplicidade primeiro.** Manter a configuração o mais próxima possível da
   recomendação oficial do plugin.
2. **Não duplicar funcionalidades.** Antes de adicionar um plugin, verificar se
   `snacks.nvim`, `fzf-lua`, `trouble.nvim`, `oil.nvim`, `conform.nvim` ou
   `nvim-lint` já cobrem o caso.
3. **Keymaps sempre agrupados.** Todo atalho deve pertencer a um grupo
   existente ou a um novo grupo semanticamente claro.
4. **Configuração genérica não se mistura com linguagem.** O que é global fica
   em `lua/config/`; o que é específico de linguagem fica em `ftplugin/` ou
   `lua/config/ftplugin-setup/`.
5. **Preferir `opts` e defaults.** Só usar `config` quando houver efeito
   colateral, keymap, autocmd ou chamada explícita de `setup`.
6. **Validar antes de concluir.** Carregar a config e testar o comportamento
   adicionado.

## Estrutura do projeto

```text
init.lua                         # bootstrap mínimo e leaders
lazy-lock.json                   # lockfile do lazy.nvim (versionado)
ftplugin/                        # entrada por filetype
  java.lua
  plsql.lua
  sql.lua
  text.lua
  yaml.lua
lua/config/
  init.lua                       # ordem de carregamento
  options.lua                    # opções globais do editor
  lazy.lua                       # bootstrap e setup do lazy.nvim
  lsp.lua                        # LSP genérico: keymaps, enable, settings comuns
  general-keymaps.lua            # keymaps globais sem plugin
  autocmd.lua                    # autocmds globais
  diagnostics.lua                # aparência dos diagnósticos e atalho manual
  ftplugin-setup/                # implementação de filetypes
    db-setup.lua
    txt-setup.lua
lua/plugins/                     # um arquivo por plugin ou grupo coeso
lua/utils/                       # módulos auxiliares (local M = {}; return M)
```

### Ordem de carregamento

`init.lua` define `mapleader` e `maplocalleader`, depois chama
`require("config")`. `lua/config/init.lua` carrega, nesta ordem:

```lua
require("config.options")
require("config.lazy")
require("config.lsp")
require("config.general-keymaps")
require("config.autocmd")
require("config.diagnostics")
```

Ao adicionar um novo módulo global, inclua-o nessa sequência.

## Convenções de código

- Lua com **tabs** para indentação.
- Aspas duplas.
- Vírgula final em tabelas.
- Arquivos em `snake_case`.
- Módulos auxiliares usam `local M = {}` e terminam com `return M`.
- Comentários em português, curtos e apenas quando a intenção não é óbvia.
- Evitar abstrações desnecessárias; preferir a forma recomendada pelo plugin.
- Não editar `lazy-lock.json` manualmente.

## Keymaps

### Leaders

```lua
vim.g.maplocalleader = "\\"
vim.g.mapleader = " "
```

### Grupos existentes

Os grupos são declarados em `lua/plugins/which-key.lua`:

| Prefixo          | Grupo                | Principais usos                          |
| ---------------- | -------------------- | ---------------------------------------- |
| `<leader><tab>`  | Tabs                 | grupos reservados                        |
| `<leader>b`      | Buffer               | `bd`, `bo`, `bl`, `br`                   |
| `<leader>c`      | Code                 | LSP: actions, referências, símbolos      |
| `<leader>d`      | Debug                | reservado para DAP                       |
| `<leader>f`      | File/Find            | `fb`, `fp`, `fc`, `fd`                   |
| `<leader>g`      | Git                  | `gg`, `gs`, `gr`, `gp`, `gb`             |
| `<leader>gt`     | Git Toggles          | `gtb`, `gtw`                             |
| `<leader>gh`     | Hunks                | navegação de hunks                       |
| `<leader>i`      | Inspect              | reservado                                |
| `<leader>q`      | Quit                 | reservado                                |
| `<leader>r`      | Remove               | `rc`, `rw`                               |
| `<leader>s`      | Search               | `sg`, `sw`, `sd`, `sr`, `st`             |
| `<leader>t`      | Toggles              | `tc`, `te`, `tz`, `tm`, `tw`, `tv`       |
| `<leader>u`      | UI                   | `uc`                                     |
| `<leader>w`      | Windows              | proxy para `<c-w>`                       |
| `<leader>x`      | Diagnostics/Quickfix | `xx`, `xd`, `xq`, `xl`                   |
| `<leader>y`      | Yank                 | `yf`, `yp`, `yP`                         |
| `<leader>\`      | Terminal             | `\1`, `\2`, `\3`, `\s`, `\n`, `\l`, `\v` |
| `[`              | Prev                 | `[B`, `]g`, `[[`                         |
| `]`              | Next                 | `]B`, `]g`, `]]`                         |
| `g`              | Goto                 | `grd`, `grr`, `gra`, `grn`               |

Atalhos globais que não são grupos:

- `<leader>e` — File Explorer (Snacks)
- `<leader>E` — File Explorer float (Oil)
- `<leader><space>` — Find files
- `<leader>?` — Keymaps do buffer

### Regras para novos keymaps

1. **Sempre usar um grupo existente quando fizer sentido.** Exemplos:
   - busca → `<leader>s...`
   - toggle → `<leader>t...`
   - git → `<leader>g...`
   - terminal → `<leader>\...`
   - LSP → `<leader>c...` ou `gr...`
2. **Só criar um grupo novo se nenhum existente representar o assunto.**
   Ao criar, adicionar a definição em `lua/plugins/which-key.lua` com
   `group = "Nome"`.
3. **Descrição no padrão `Grupo: Ação`.**
   Exemplos: `"Search: TODO/FIXME"`, `"Toggle: Render Markdown"`,
   `"Debug: Toggle breakpoint"`.
4. **Verificar conflitos antes.**
   ```sh
   rg -o '"<leader>[^"]*"' lua | sort -u
   ```
5. **Evitar colisões conhecidas.**
   `<leader>dp`, `<leader>dd`, `<leader>dP` e `<leader>dD` são buffer-local
   nos buffers SQL/PLSQL (`db-setup.lua`). Não usar esses prefixos globalmente.
6. **Usar `buffer = true`** para keymaps específicos de filetype/buffer.
7. **Usar `silent = true`** em ações LSP que não precisam ecoar mensagem.
8. **Usar `vim.keymap.set`**, não `nvim_set_keymap`.

### Onde declarar cada keymap

| Tipo de keymap                     | Local                                   |
| ---------------------------------- | --------------------------------------- |
| Global, sem dependência de plugin  | `lua/config/general-keymaps.lua`        |
| LSP genérico                       | `lua/config/lsp.lua`                    |
| Diagnósticos                       | `lua/config/diagnostics.lua`            |
| Plugin carregado sob demanda       | tabela `keys` do spec em `lua/plugins/` |
| Plugin que precisa de estado/setup | dentro do `config` do plugin            |
| Específico de linguagem/buffer     | `ftplugin/<lang>.lua` ou `ftplugin-setup/` |

### Exemplo de keymap de plugin

```lua
return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	keys = {
		{
			"<leader>tm",
			"<cmd>RenderMarkdown toggle<cr>",
			desc = "Toggle: Render Markdown",
		},
	},
}
```

### Exemplo de keymap buffer-local

```lua
vim.keymap.set("n", "grf", function()
	-- ...
end, { desc = "Format Buffer", buffer = true })
```

## Plugins

### Organização

- Um arquivo por plugin ou por grupo coeso (ex.: `themes.lua`).
- Nome do arquivo igual ao nome curto do plugin.
- Retornar diretamente a spec do lazy.nvim.
- Dependências declaradas em `dependencies`.
- Preferir `opts` para configuração simples.
- Usar `config(_, opts)` quando houver setup explícito, keymaps ou autocmds.
- Usar carregamento preguiçoso com `event`, `cmd`, `ft` ou `keys` quando possível.
- `lazy = false` apenas para plugins globais ou de prioridade alta.

### Estilo de spec

```lua
return {
	"autor/plugin",
	dependencies = { "autor/dependencia" },
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "<leader>xx", "<cmd>Comando<cr>", desc = "Grupo: Ação" },
	},
	config = function(_, opts)
		local plugin = require("plugin")
		plugin.setup(opts)

		vim.keymap.set("n", "<leader>xy", function()
			plugin.acao()
		end, { desc = "Grupo: Outra ação" })
	end,
}
```

### Versões e lockfile

- `lazy-lock.json` é versionado e garante reprodutibilidade.
- Não editar o lockfile manualmente.
- Usar `version = "*"` apenas quando o plugin recomenda (ex.: `nvim-surround`,
  `toggleterm`, `bufferline`, `mini.ai`).
- Atualizações são feitas com `:Lazy sync` / `:Lazy update`.

## Configuração geral vs. específica de linguagem

### Regra principal

`lua/config/lsp.lua` deve conter apenas o que é genérico:

- keymaps LSP (`gr*`, `<leader>c...`);
- lista de servidores habilitados com `vim.lsp.enable`;
- settings compartilhados entre linguagens.

Configurações específicas de uma linguagem **não** devem ficar em
`lua/config/lsp.lua`.

### Padrão para linguagens

Para suporte específico, usar:

```text
ftplugin/<lang>.lua
```

Se houver lógica maior, delegar para:

```text
lua/config/ftplugin-setup/<lang>-setup.lua
```

com o padrão:

```lua
local M = {}

function M.setup()
	vim.opt_local.shiftwidth = 4
	-- keymaps com buffer = true
end

return M
```

E no `ftplugin`:

```lua
require("config.ftplugin-setup.lang-setup").setup()
```

### Exemplos já existentes

- `ftplugin/java.lua` inicia o `jdtls` com workspace próprio.
- `ftplugin/sql.lua` e `ftplugin/plsql.lua` usam `db-setup.lua`.
- `ftplugin/text.lua` e `ftplugin/yaml.lua` usam `txt-setup.lua`.

### Estado atual do Python

A configuração do `basedpyright` está em `lua/config/lsp.lua`, mas isso é uma
exceção conhecida. Ao refatorar, mover os settings específicos para
`lua/config/ftplugin-setup/python-setup.lua` e criar `ftplugin/python.lua`,
mantendo `lua/config/lsp.lua` genérico.

Não criar uma segunda configuração concorrente: mover, não duplicar.

## Formatação, lint e Treesitter

Ao adicionar suporte a uma linguagem, verificar todos estes pontos:

1. **LSP** — `lua/config/lsp.lua` ou `ftplugin/<lang>.lua`.
2. **Parser** — adicionar em `ts.install(...)` no `nvim-treesitter.lua`.
3. **Highlight** — adicionar o filetype em `lua/config/autocmd.lua`.
4. **Formatter** — adicionar em `formatters_by_ft` no `conform.lua`.
5. **Linter** — adicionar em `linters_by_ft` no `nvim-lint.lua`.
6. **Ferramentas** — instalar via Mason (`:MasonInstall ...`).

O atalho `grf` é criado pelo `conform.nvim` para os filetypes configurados.
Alguns filetypes podem sobrescrever `grf` com comportamento próprio, como
`txt-setup.lua`.

## Diagnósticos

`lua/config/diagnostics.lua` define:

- `virtual_text` com prefixo `●`;
- `signs`, `underline` e `severity_sort`;
- float com borda arredondada;
- `gl` para abrir detalhes manualmente.

Não reintroduzir abertura automática via `CursorHold` sem pedido explícito.
O comportamento foi removido intencionalmente para evitar floats inesperados.

## Mason

- `mason.nvim` está instalado, mas não há `mason-lspconfig` nem
  `mason-tool-installer`.
- Ferramentas são instaladas manualmente com `:MasonInstall <pacote>`.
- Ao concluir uma tarefa que dependa de ferramenta externa, informar o comando
  de instalação.
- Não adicionar gerenciadores automáticos de ferramentas sem necessidade.

## Checklist: novo plugin

1. Verificar se algum plugin atual já resolve o problema.
2. Criar `lua/plugins/<nome>.lua`.
3. Preferir `opts` e defaults do plugin.
4. Declarar `dependencies`.
5. Adicionar lazy loading adequado (`event`, `cmd`, `ft`, `keys`).
6. Colocar keymaps no grupo correto e com `desc`.
7. Se criar grupo novo, registrar em `which-key.lua`.
8. Se depender de ferramenta externa, instalar via Mason.
9. Rodar `:Lazy sync`.
10. Validar carregamento e comportamento.

## Checklist: novo keymap

1. Identificar o grupo existente mais adequado.
2. Verificar conflitos com `rg -o '"<leader>[^"]*"' lua | sort -u`.
3. Usar `desc = "Grupo: Ação"`.
4. Declarar no local correto (plugin, geral, LSP, filetype).
5. Usar `buffer = true` quando for específico de buffer.
6. Se o prefixo for novo, adicionar em `which-key.lua`.

## Checklist: nova linguagem

1. Adicionar/instalar o LSP.
2. Configurar settings específicos em `ftplugin`/`ftplugin-setup`.
3. Adicionar parser em `nvim-treesitter.lua`.
4. Adicionar filetype em `autocmd.lua`.
5. Adicionar formatter em `conform.lua`.
6. Adicionar linter em `nvim-lint.lua`.
7. Instalar ferramentas com Mason.
8. Validar LSP, parser, formato e lint.

## Anti-padrões

- Colocar configuração específica de linguagem em `lua/config/lsp.lua`.
- Criar keymap sem `desc` ou fora de um grupo.
- Criar grupo novo sem registrar no `which-key.lua`.
- Duplicar funcionalidades já cobertas por Snacks, fzf-lua, trouble, oil,
  conform ou nvim-lint.
- Adicionar plugins pesados ou muitas customizações quando o default resolve.
- Editar `lazy-lock.json` manualmente.
- Reintroduzir `CursorHold` abrindo float de diagnóstico automaticamente.
- Usar `<leader>dp`, `<leader>dd`, `<leader>dP` ou `<leader>dD` globalmente.

## Validação

Carregar a configuração sem erros:

```sh
nvim --headless "+lua print('config OK')" +qa
```

Validar plugin/parser:

```sh
nvim --headless "+lua print(pcall(vim.treesitter.language.add, 'python'))" +qa
```

Dentro do Neovim:

- `:Lazy` — status dos plugins.
- `:Mason` — ferramentas instaladas.
- `:checkhealth` — saúde geral.
- `:lua =vim.lsp.get_clients()` — clientes LSP ativos.
- `:lua require("conform").format({ async = false })` — teste de formatação.
- `:lua require("lint").try_lint()` — teste de lint.

## Referências úteis no repositório

- `lua/plugins/which-key.lua` — grupos de keymaps.
- `lua/config/general-keymaps.lua` — keymaps globais.
- `lua/config/lsp.lua` — keymaps e habilitação LSP.
- `ftplugin/java.lua` — exemplo de LSP específico de linguagem.
- `lua/config/ftplugin-setup/` — implementações por filetype.
- `lua/plugins/conform.lua` — formatadores.
- `lua/plugins/nvim-lint.lua` — linters.
- `lua/plugins/nvim-treesitter.lua` — parsers.
- `lua/config/diagnostics.lua` — diagnósticos.
