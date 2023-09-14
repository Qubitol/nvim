local status_ok, no_neck_pain = pcall(require, "no-neck-pain")
if not status_ok then
	return
end

local utils = require("core.utils")
local mappings = require("core.mappings")

no_neck_pain.setup({
    -- Width
    width = 140,

    buffers = {
        setNames = false,

        -- Only left buffer
        left = {
            enabled = true,
        },
        right = {
            enabled = false,
        },

        scratchPad = {
            -- Enable scratchpad
            enabled = false,

            -- File name, filetype is `norg`
            fileName = "notes",

            -- By default, files are saved at the same location as the current Neovim session.
            location = nil,
        },

        bo = {
            filetype = "norg",
        },

        wo = {
            number = true,
            relativenumber = true,
            cursorline = true
        }
    },

    mappings = {
        enabled = false,
    },

    integrations = {
        undotree = {
            -- The position of the tree.
            position = "left",
        },
    },
})

utils.load_mappings(mappings.plugins["no-neck-pain"])
