local M = {}

M.generic_tags = {
    -- Knowledge / state
    "bug",
    "idea",
    "question",
    "decision",
    "finding",
    "result",
    "blocker",
    "workaround",

    -- Interaction
    "request",
    "delegated",
    "feedback",
    "discussion",
    "meeting",
    "supervision",
    "review",

    -- Engineering activity
    "investigation",
    "debugging",
    "design",
    "implementation",
    "refactor",
    "optimization",
    "profiling",
    "benchmark",
    "validation",
    "testing",
    "setup",
    "configuration",
    "documentation",
    "reading",

    -- Outputs
    "paper",
    "presentation",

    -- Computing concepts
    "performance",
    "hpc",
    "cpu",
    "gpu",
    "simd",
    "simt",
    "numa",

    -- Technologies / vendors
    "nvidia",
    "amd",
    "intel",
    "cuda",
    "rocm",
    "cpp",
    "python",
    "fortran",
}

M.namespaces = {
    mention = "@",
    project = "p/",
}

M.mappings = {
    alternate_link = "<leader>ml",
    generic_tags = "<leader>mt",
    project_tag = "<leader>mp",
    mention = "<leader>mm",
    insert_generic_tags = "<C-g>t",
    insert_mention = "<C-g>m",
    insert_project_tag = "<C-g>p",
    tag_find = "<leader>ft",
    mentions = "<leader>fm",
    projects = "<leader>fp",
}

M.ui = {
    preview_flip_columns = 140,
    picker_height = 0.85,
    picker_width = 1,
}

return M
