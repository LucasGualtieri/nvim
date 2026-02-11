local jdtls = require('jdtls')

-- 1. Locate the Installation (matching the manual install we did)
local home = os.getenv('HOME')
local jdtls_path = home .. "/.local/share/jdtls"
local launcher_script = jdtls_path .. "/bin/jdtls"
local configuration = jdtls_path .. "/config_linux"

-- 2. Determine the Data Directory (Workspace)
-- This creates a unique workspace folder for every project to avoid data corruption
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/jdtls-workspace/' .. project_name

-- 3. Define Capabilities (connecting to your existing nvim-cmp setup)
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- 4. The Configuration Table
local config = {
	cmd = {
		-- We use the wrapper script (requires Python 3)
		launcher_script,

		-- Explicitly tell it where the configuration is
		"-configuration", configuration,

		-- Explicitly tell it where to store project data
		"-data", workspace_dir,
	},

	-- Find the root of the project (looking for git, maven, or gradle files)
	root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),

	-- Your specific settings
	settings = {
		java = {
			errors = { incompleteClasspath = { severity = "ignore" } },
			configuration = {
				-- Ensure it knows we are using Java 21
				runtimes = {
					{
						name = "JavaSE-21",
						path = "/usr/lib/jvm/java-21-openjdk-amd64",
						default = true,
					},
				}
			}
		}
	},

	-- Connect capabilities
	capabilities = capabilities,

	-- Function to run when the LSP attaches
	on_attach = function(client, bufnr)
		-- NOTE: Your existing Global LspAttach autocommand will run generic keymaps (gd, gr, etc.)
		-- We only need to add Java-specific keymaps here

		-- Organize Imports
		vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Java: Organize Imports" })

		-- Extract Variable
		vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { buffer = bufnr, desc = "Java: Extract Variable" })

		-- Extract Method
		vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { buffer = bufnr, desc = "Java: Extract Method" })
	end
}

-- 5. Start the Server
jdtls.start_or_attach(config)
