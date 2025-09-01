-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  -- Dependências diretas para garantir a ordem
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/nvim-cmp",
  },
  -- 'config' é o ideal, mas vamos usar 'init' para garantir que a configuração
  -- aconteça depois que TUDO estiver carregado.
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- O 'on_attach' é a forma mais segura de definir keymaps
    local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    end

    -- Itera sobre os servidores que o Mason instalou e os configura
    for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
        lspconfig[server].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end
  end
}
