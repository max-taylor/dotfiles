local icons = require("icons")
local colors = require("colors")

local wifi = sbar.add("item", {
  position = "right",
  icon = {
    font = {
      style = "Regular",
      size = 19.0,
    }
  },
  label = { drawing = false },
  update_freq = 30,
})

local function wifi_update()
  sbar.exec("ipconfig getsummary en0", function(wifi_info)
    local ssid = wifi_info:match("SSID%s*:%s*([^\n]*)")

    if not ssid or ssid == "" then
      wifi:set({
        icon = icons.wifi.disconnected,
      })
    else
      wifi:set({
        icon = icons.wifi.connected,
      })
    end
  end)
end

wifi:subscribe({"routine", "system_woke"}, wifi_update)
wifi_update()
