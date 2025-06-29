local jdtls = require("jdtls")
local home = os.getenv("HOME")
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if not root_dir then
	return
end

local workspace_folder = home .. "/.local/share/jdtls/workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", vim.fn.glob(home .. "/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration", home .. "/.local/share/jdtls/config_linux", -- change to config_mac or config_win as needed
		"-data", workspace_folder,
	},

	root_dir = root_dir,
	capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities()),

	on_attach = function(client, bufnr)
		-- Use your existing on_attach logic from the main config
		vim.lsp.inlay_hint.enable(false)
		vim.keymap.set("n", "<leader>ih", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }))
		end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
	end,
}

-- Start or attach to the workspace
jdtls.start_or_attach(config)
