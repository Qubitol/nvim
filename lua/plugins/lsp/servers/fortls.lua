local util = require("lspconfig.util")

return {
    cmd = {
        "fortls",
        "--incremental_sync",
        "--hover_signature",
        "--hover_language=fortran",
        "--use_signature_help",
        "--enable_code_actions",
    },
    settings = {},
    root_dir = util.path.dirname,
}
