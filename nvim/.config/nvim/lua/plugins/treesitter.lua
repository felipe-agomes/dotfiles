-- Engine de parsing para highlight de sintaxe avançado e indentação.
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  version = false,
  build = ":TSUpdate",
  priority = 1000,
  opts = {
          highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
          },
  },
  config = function(_, opts)
      local ts = require("nvim-treesitter")

      ts.setup(opts)

      ts.install({
          "json", "java", "lua", "sql", "yaml",
          "csv", "xml", "javascript", "typescript", "bash"
      })
  end,
}
