-- For `plugins/markview.lua` users.
return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    keys = {
        { "<leader>mm", "<cmd>Markview toggle<cr>", ft = "markdown", desc = "Markview: toggle (buffer)" },
        { "<leader>mM", "<cmd>Markview Toggle<cr>", ft = "markdown", desc = "Markview: toggle (global)" },
        { "<leader>ms", "<cmd>Markview splitToggle<cr>", ft = "markdown", desc = "Markview: split view" },
        { "<leader>mh", "<cmd>Markview hybridToggle<cr>", ft = "markdown", desc = "Markview: hybrid mode" },
        { "<leader>ml", "<cmd>Markview linewiseToggle<cr>", ft = "markdown", desc = "Markview: linewise hybrid" },
    },

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
};
