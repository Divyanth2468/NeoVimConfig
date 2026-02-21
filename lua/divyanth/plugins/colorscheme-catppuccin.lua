return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,

        styles = {
          comments = { "italic" },
          keywords = { "italic" },
        },

        integrations = {
          treesitter = true,
          telescope = true,
          cmp = true,
          gitsigns = true,
          which_key = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
