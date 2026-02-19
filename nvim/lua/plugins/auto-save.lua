return {
  {
    "Pocco81/auto-save.nvim",
    enabled = true,
    opts = {
      execution_message = {
        message = function()
          return ""
        end,
      },
      trigger_events = { "InsertLeave" },
      write_all_buffers = true,
      debounce_delay = 200,
    },
  },
}
