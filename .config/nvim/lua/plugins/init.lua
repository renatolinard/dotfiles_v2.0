return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    {
      -- Main LSP Configuration
      "neovim/nvim-lspconfig",
      dependencies = {
        { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        {
          "j-hui/fidget.nvim",
          opts = {
            notification = {
              override_vim_notify = false,
            },
          },
        },
        "saghen/blink.cmp",
      },
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
          callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
              })
            end

            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              vim.keymap.set("n", "<leader>uh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
              end, { desc = "Toggle [U]i Inlay [H]ints" })
            end
          end,
        })

        local floating_border_style = "rounded"

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = floating_border_style,
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = floating_border_style,
        })

        vim.diagnostic.config({
          float = { border = floating_border_style },
        })

        local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config({ signs = { text = diagnostic_signs } })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, blink_capabilities)

        local servers = {

          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
                diagnostics = { disable = { "missing-fields" } },
              },
            },
          },
          -- Markdown
          marksman = {},
          -- TypeScript, JavaScript
          ts_ls = {},
          -- TOML
          taplo = {},
          -- PHP
          -- intelephense = {},
          phpactor = {},
          -- Bash/Shell
          shellcheck = {},
          bashls = {},
          -- Docker
          dockerls = {},
          docker_compose_language_service = {},
          -- Helm
          helm_ls = {},
          -- JSON
          yamlls = {
            filetypes = { "yaml" },
            on_attach = function(client, bufnr)
              local patterns = { "*/templates/*.yaml", "*/templates/*.tpl", "values.yaml", "Chart.yaml" }
              local fname = vim.fn.expand("%:p")
              for _, pattern in ipairs(patterns) do
                local lua_pattern = pattern:gsub("*", ".*"):gsub("/", "/.*")
                if fname:match(lua_pattern) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
              end
            end,
          },
          jsonls = {},

          -- PlatformIO
          clangd = {},
        }
        require("mason").setup()
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          "stylua", -- Used to format Lua code
          "prettierd", -- Used to format JavaScript/TypeScript code
        })

        require("mason-tool-installer").setup({
          ensure_installed = ensure_installed,
        })

        require("mason-lspconfig").setup({
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
              require("lspconfig")[server_name].setup(server)
            end,
          },
          ensure_installed = {},
          automatic_installation = true,
        })
      end,
    },
    -- LSP Plugins
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "mrcjkb/rustaceanvim",
      version = "^5", -- Recommended
      lazy = false, -- This plugin is already lazy
      config = function()
        vim.g.rustaceanvim = {
          tools = {
            float_win_config = {
              border = "rounded",
            },
          },
        }
      end,
    },
  },

  -- Oil.nvim for file browsing
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional dependency for icons
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
          border = "rounded",
        },
        win_options = {
          wrap = true,
          winblend = 0,
        },
      })
    end,
  },

  --Browser sync
  {
    "ray-x/web-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require("web-tools").setup({})
    end,
  },

  --hardtime
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },

  --cmp 
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })
    end,
  },

  -- treesitter
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- [CORREÇÃO] Se estiver rodando dentro do VS Code, cancela o carregamento.
      -- O VS Code já faz o highlight e isso evita os erros de compilação (gzip/tar).
      if vim.g.vscode then return end

      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "json",
          "css",
          "typescript",
          "bash",
          "gitignore",
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "elixir",
          "heex",
          "javascript",
          "html",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Enter>",
            node_incremental = "<Enter>",
            scope_incremental = false,
            node_decremental = "<Backspace>",
          },
        },
      })
    end,
  },
}
