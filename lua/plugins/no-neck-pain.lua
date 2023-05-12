local status_ok, no_neck_pain = pcall(require, "no-neck-pain")
if not status_ok then
	return
end

no_neck_pain.setup({
    -- Width
    width = 140,

    -- Only left buffer
    buffers = {
        left = {
            enabled = true,
        },
        right = {
            enabled = false,
        },
        scratchPad = {
            -- Enable scratchpad
            enabled = true,

            -- File name, filetype is `norg`
            fileName = "notes",

            -- By default, files are saved at the same location as the current Neovim session.
            location = nil,
        },
    },

    mappings = {
        -- Enable mappings
        enabled = true,

        -- Toggle the plugin
        toggle = "<Leader>tn",

        -- Increase the width
        widthUp = "<Leader>n=",

        -- Decrease the width
        widthDown = "<Leader>n-",

        -- Toggle scratchpad feature
        scratchPad = "<Leader>ns",
    },

    integrations = {
        undotree = {
            -- The position of the tree.
            position = "left",
        },
    },
})
