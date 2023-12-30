require('lualine').setup({
    options = {
        globalstatus = true,
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
    }
})

-- TODO: maybe move it to separate file
require("fidget").setup({
    progress = {
        display = {
            progress_icon = {
                pattern = "moon"
            },
        }
    },
})
