return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "MaximilianLloyd/ascii.nvim", "MunifTanjim/nui.nvim" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local ascii = require("ascii")

        -- dashboard.section.header.opts.hl = "AlphaHeader"
        -- dashboard.section.header.val = ascii.art.text.neovim.delta_corps_priest1
        -- dashboard.section.header.val = ascii.art.text.neovim.bloody
        dashboard.section.header.val = ascii.art.text.neovim.sharp
        dashboard.section.buttons.val = {}
        -- dashboard.section.buttons.val = { type = "text", val = "hey" }

        -- dashboard.section.footer.val = ascii.art.text.slogons.robust

        -- dashboard.section.footer.val = ascii.art.misc.skulls.threeskulls_big_v1

        dashboard.section.footer.val = ascii.art.misc.krakens.krakedking

        alpha.setup(dashboard.config)
        -- require("alpha").setup(require("alpha.themes.dashboard").config)
        -- local startify = require("alpha.themes.startify")
        -- -- available: devicons, mini, default is mini
        -- -- if provider not loaded and enabled is true, it will try to use another provider
        -- startify.file_icons.provider = "devicons"
        -- require("alpha").setup(startify.config)
    end,
}
