-- ~/.config/nvim/lua/plugins/mason.lua
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      -- Lista de servidores para garantir que estejam instalados
      ensure_installed = { "lua_ls", "tsserver" }
    })
  end,
}
