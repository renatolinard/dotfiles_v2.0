# Neovim Plugin Explanations

This file provides a brief explanation of the Neovim plugins found in
`/home/renatolinard/.config/nvim/lua/plugins` and their configured keymaps.

* **autocompletion.lua**: Configures autocompletion using `blink.cmp` and
`LuaSnip`. It provides intelligent code completion suggestions as you type and
supports snippet expansion.
    * **Keymaps**: This plugin uses the `default` keymap preset. Important
    keymaps in insert mode include:
        * `<C-y>`: Accept the selected completion.
        * `<C-e>`: Hide the completion menu.
        * `<C-space>`: Manually trigger completion or show documentation.
        * `<Tab>` / `<S-Tab>`: Navigate through snippet expansion points.
        * `<C-n>` / `<C-p>`: Select next/previous item in the completion menu.

* **autoformat.lua**: Sets up automatic code formatting using `conform.nvim`. It automatically formats code on save.
    * **Keymaps**:
        * `<leader>f` (Normal Mode): Manually trigger formatting for the current buffer.

* **autopairs.lua**: Implements `nvim-autopairs`, which automatically inserts closing pairs for brackets, parentheses, and quotes. It has no user-defined keymaps and works automatically in insert mode.

* **kanagawa.lua**: Sets the `kanagawa-paper` colorscheme. It has no keymaps.

* **lsp.lua**: Configures the Language Server Protocol (LSP) client using `nvim-lspconfig` for features like go-to-definition, find-references, and diagnostics.
    * **Keymaps (Normal Mode)**: These keymaps are active when an LSP server is attached to a buffer.
        * `grn`: Rename the variable under the cursor.
        * `gra`: Show available code actions.
        * `grr`: Find references for the word under the cursor.
        * `gri`: Go to the implementation of the word under the cursor.
        * `grd`: Go to the definition of the word under the cursor.
        * `grD`: Go to the declaration of the word under the cursor.
        * `gO`: List all symbols in the current document.
        * `gW`: List all symbols in the entire workspace/project.
        * `grt`: Go to the type definition of the word under thecursor.
        * `<leader>th`: Toggle inlay hints.

* **noice.lua**: Implements `noice.nvim` to improve the UI for messages, cmdline and popups. It has no user-defined keymaps.

* **oil.lua**: A file explorer that replaces netrw. It has no user-defined keymaps in the configuration, but you can use standard vim motions. Press `g?` in an oil buffer to see the default mappings.

* **statusline.lua**: Configures a custom statusline using `mini.statusline`. It has no keymaps.

* **telescope.lua**: Sets up `telescope.nvim`, a fuzzy finder for files, buffers, LSP definitions, and more.
    * **Keymaps (Normal Mode)**:
        * `<leader>sh`: Search help tags.
        * `<leader>sk`: Search keymaps.
        * `<leader>sf`: Search for files.
        * `<leader>ss`: Select a Telescope picker.
        * `<leader>sw`: Search for the word currently under the cursor.
        * `<leader>sg`: Grep (search) for a string in your project.
        * `<leader>sd`: Search diagnostics.
        * `<leader>sr`: Resume the last Telescope search.
        * `<leader>s.`: Search recent files.
        * `<leader><leader>`: Search existing buffers.
        * `<leader>/`: Fuzzily search in the current buffer.
        * `<leader>s/`: Grep in open files.
        * `<leader>sn`: Search your Neovim configuration files.

* **treesitter.lua**: Configures `nvim-treesitter` for syntax highlighting, indentation, and code navigation. It has no user-defined keymaps in this configuration.
