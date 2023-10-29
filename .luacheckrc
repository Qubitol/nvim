stds.nvim = {
    read_globals = { "jit" }
}
std = "lua51+nvim"
read_globals = {
    vim = {
        fields = {
            g = {
                read_only = false,
                other_fields = true,
            },
            o = {
                read_only = false,
                other_fields = true,
            },
            wo = {
                read_only = false,
                other_fields = true,
            },
            bo = {
                read_only = false,
                other_fields = true,
            },
            b = {
                read_only = false,
                other_fields = true,
            },
            w = {
                read_only = false,
                other_fields = true,
            },
            opt = {
                read_only = false,
                other_fields = true,
            },
            opt_local = {
                read_only = false,
                other_fields = true,
            },
        },
    },
}
ignore = {}
max_comment_line_length = false
files[".luacheckrc"] = {
    ignore = true,
}
