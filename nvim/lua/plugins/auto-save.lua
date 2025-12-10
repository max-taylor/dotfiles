return {
  {
    "Pocco81/auto-save.nvim",
    enabled = false,
    opts = {
      execution_message = {
        message = function()
          return "" -- Disable the message
        end,
      },
      trigger_events = { "InsertLeave" },
      write_all_buffers = true,
      debounce_delay = 600,
    },
  },
}
