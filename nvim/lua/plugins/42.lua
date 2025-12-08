return {
  {
    "42Paris/42header",
    lazy = false,
    config = function()
      vim.keymap.set("n", "<F1>", "<cmd>Stdheader<CR>", { desc = "Add 42 Header" })
    end,
  },
}
