-- ~/.config/nvim/lua/plugins/lsp.lua (Versão Final "À Prova de Falhas")
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Adicione o cmp-nvim-lsp aqui para garantir que ele seja carregado a tempo
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Esta é a nossa "fonte da verdade". Todos os servidores que queremos são listados aqui.
            -- Usamos os nomes que o lspconfig espera (ex: "tsserver").
            local servers = {
                "lua_ls",
                "ts_ls",
                -- Adicione outros servidores aqui no futuro, como "pyright" para Python, etc.
            }

            -- 1. Configura o Mason
            require("mason").setup()

            -- 2. Configura a ponte Mason-LSPConfig
            require("mason-lspconfig").setup({
                -- Diz ao Mason para garantir que os servidores da nossa lista estejam instalados.
                ensure_installed = { "lua_ls", "ts_ls", "cssls", "html" }
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- 3. A função que será executada quando um LSP se anexar a um buffer
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end

            -- 4. Loop através da nossa lista de servidores e configura cada um com lspconfig
            for _, server_name in ipairs(servers) do
                lspconfig[server_name].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end

            -- Configurações específicas podem vir depois do loop, se necessário
            lspconfig.lua_ls.setup({
                settings = { Lua = { diagnostics = { globals = { "vim" } } } },
            })

            -- UI dos diagnósticos
            vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
        end,
    },
}
