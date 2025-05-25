return {
    {
        "kikito/middleclass",
        enabled = false,
        -- config = function()
        -- 	-- Adding the plugin directory to the package path
        -- 	local package_path_str = table.concat({
        -- 		"/Users/maxtaylor/.local/share/nvim/lazy/?.lua",
        -- 		"/Users/maxtaylor/.local/share/nvim/lazy/?/init.lua",
        -- 		"/opt/homebrew/share/lua/5.1/?.lua",
        -- 		"/opt/homebrew/share/lua/5.1/?/init.lua",
        -- 		"/usr/local/share/lua/5.1/?.lua",
        -- 		"/usr/local/share/lua/5.1/?/init.lua",
        -- 		"/usr/local/lib/lua/5.1/?.so",
        -- 		"/opt/homebrew/lib/lua/5.1/?.so",
        -- 		"./?.lua",
        -- 	}, ";")
        --
        -- 	package.path = package.path .. ";" .. package_path_str
        --
        -- 	print("Package path: " .. package.path)
        -- 	-- Now require middleclass
        -- 	local middleclass = require("middleclass")
        -- 	print("Middleclass loaded")
        -- end,
    },
    {
        dir = "~/Documents/Code/Neovim/plugin/",
        name = "task-manager",
        dependencies = { "MunifTanjim/nui.nvim", "rxi/json.lua", "kikito/middleclass" },
        enabled = false,
        config = function()
            print("Setting up task-manager")
            -- require("middleclass")
            -- print("Middleclass loaded")
            require("task-manager").setup()
        end,
    },
}
