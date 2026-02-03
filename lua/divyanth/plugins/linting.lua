return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Go linting only
    lint.linters_by_ft = {
      go = { "golangcilint" },
    }

    -- Create an augroup so we don't duplicate autocmds
    local lint_augroup = vim.api.nvim_create_augroup("GoLint", { clear = true })

    -- Run linting
    local function try_lint()
      lint.try_lint()
    end

    -- Auto-lint on common events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = try_lint,
    })

    -- Manual trigger
    vim.keymap.set("n", "<leader>gl", try_lint, {
      desc = "Run Go linting (golangci-lint)",
    })
  end,
}
