-- ✦ markdownlint: always use the global config in the home folder
return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters = {
				["markdownlint-cli2"] = {
					args = { "--config", vim.fn.expand("~/.markdownlint-cli2.yaml"), "--" },
				},
			},
		},
	},
}
