local lspconfig = require("lspconfig")
local nvlsp = require("nvchad.configs.lspconfig")

-- Carrega configurações padrão do NvChad
nvlsp.defaults()

-------------------------------------------------------------------------
-- 1. Servidores Simples (Bash, Markdown, HTML, CSS)
-------------------------------------------------------------------------
local servers = { "html", "cssls", "bashls", "marksman" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-------------------------------------------------------------------------
-- 2. Lua (Configuração Específica)
-------------------------------------------------------------------------
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  },
}

-------------------------------------------------------------------------
-- 3. GODOT (GDScript) - A PARTE CRUCIAL
-------------------------------------------------------------------------
lspconfig.gdscript.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  name = "godot",
  -- Comando para conectar na porta TCP 6005 (Godot 4)
  cmd = { "nc", "127.0.0.1", "6005" },
  -- Só ativa se encontrar o arquivo project.godot
  root_dir = lspconfig.util.root_pattern("project.godot", ".git"),
  flags = { debounce_text_changes = 150 }
}
