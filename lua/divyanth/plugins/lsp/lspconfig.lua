return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    local lspconfig = vim.lsp.config
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local keymap = vim.keymap

    ------------------------------------------------------------------
    -- LSP ATTACH (ALL BUFFER-LOCAL LOGIC LIVES HERE)
    ------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local buf = ev.buf
        local opts = { buffer = buf, silent = true }

        -- Keymaps
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        keymap.set("n", "K", vim.lsp.buf.hover, opts)
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

        ------------------------------------------------------------------
        -- FORMAT + IMPORTS ON SAVE (BUFFER-LOCAL, RACE-FREE)
        ------------------------------------------------------------------
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = buf,
          callback = function()
            local ft = vim.bo[buf].filetype

            -- -------------------- GO --------------------
            if ft == "go" then
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }

              -- organize imports (SYNC)
              local result = vim.lsp.buf_request_sync(buf, "textDocument/codeAction", params, 1000)

              if result then
                for _, res in pairs(result) do
                  for _, action in pairs(res.result or {}) do
                    if action.edit then
                      vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                    elseif action.command then
                      vim.lsp.buf.execute_command(action.command)
                    end
                  end
                end
              end

              -- format (gopls → goimports)
              vim.lsp.buf.format({
                async = false,
                filter = function(client)
                  return client.name == "gopls"
                end,
              })
            end

            -- -------------------- LUA --------------------
            if ft == "lua" then
              vim.lsp.buf.format({
                async = false,
                filter = function(client)
                  return client.name == "lua_ls"
                end,
              })
            end
          end,
        })
      end,
    })

    ------------------------------------------------------------------
    -- DIAGNOSTICS (MODERN, NON-DEPRECATED)
    ------------------------------------------------------------------
    vim.diagnostic.config({
      update_in_insert = false,
      float = { border = "rounded" },
      virtual_text = {
        prefix = "●",
        spacing = 2,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    ------------------------------------------------------------------
    -- LSP SERVERS (NEOVIM 0.11 STYLE)
    ------------------------------------------------------------------

    -- Lua
    lspconfig.lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    }

    -- Go
    lspconfig.gopls = {
      capabilities = capabilities,
      settings = {
        gopls = {
          staticcheck = true,
          gofumpt = false,
          usePlaceholders = true,
          completeUnimported = true,
        },
      },
    }
  end,
}
