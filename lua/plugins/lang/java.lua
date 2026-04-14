-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lang/java.lua — nvim-jdtls (manual setup)      ║
-- ║                                                          ║
-- ║  Replaces nvim-java with direct nvim-jdtls configuration ║
-- ║  Bundles: lombok, java-debug, java-test, spring-boot     ║
-- ╚══════════════════════════════════════════════════════════╝

--- Collect all .jar files matching a glob pattern into a table
---@param pattern string glob pattern
---@param excluded? string[] basenames to skip
---@return string[]
local function collect_jars(pattern, excluded)
	excluded = excluded or {}
	local jars = {}
	for _, jar in ipairs(vim.split(vim.fn.glob(pattern, true), '\n', { trimempty = true })) do
		local fname = vim.fn.fnamemodify(jar, ':t')
		if fname ~= '' and not vim.tbl_contains(excluded, fname) then
			table.insert(jars, jar)
		end
	end
	return jars
end

return {
	-- ── nvim-jdtls ────────────────────────────────────────────
	{
		'mfussenegger/nvim-jdtls',
		ft = 'java',
		dependencies = {
			'mason-org/mason.nvim',
			'mfussenegger/nvim-dap',
		},
		config = function()
			local mason_root = vim.fn.stdpath('data') .. '/mason/packages'
			local jdtls_root = mason_root .. '/jdtls'

			-- ── Bundles ─────────────────────────────────────────────
			local bundles = {}

			-- 1) java-debug-adapter (installed via Mason)
			local debug_jar = vim.fn.glob(
				mason_root .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true
			)
			if debug_jar ~= '' then
				table.insert(bundles, debug_jar)
			end

			-- 2) java-test (installed via Mason)
			vim.list_extend(bundles, collect_jars(
				mason_root .. '/java-test/extension/server/*.jar',
				{ 'com.microsoft.java.test.runner-jar-with-dependencies.jar', 'jacocoagent.jar' }
			))

			-- 3) spring-boot-tools (via spring-boot.nvim plugin)
			local spring_ok, spring_boot = pcall(require, 'spring_boot')
			if spring_ok and spring_boot.java_extensions then
				vim.list_extend(bundles, spring_boot.java_extensions())
			end

			-- ── Lombok ──────────────────────────────────────────────
			-- Mason's jdtls ships with lombok.jar at the root
			local lombok_path = jdtls_root .. '/lombok.jar'

			-- ── Workspace directory ─────────────────────────────────
			-- Each project gets its own eclipse workspace so index data persists
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
			local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspaces/' .. project_name

			-- ── JDTLS config ───────────────────────────────────────
			local config = {
				name = 'jdtls',

				flags = {
					debounce_text_changes = 50, -- ms; lower = sooner updates, more traffic/CPU
				},

				cmd = {
					'jdtls',                                              -- Mason puts this in PATH
					'-data', workspace_dir,                               -- Per-project workspace
					'--jvm-arg=-javaagent:' .. lombok_path,               -- Lombok annotation processing
				},

				root_dir = vim.fs.root(0, { 'gradlew', 'mvnw', 'pom.xml', 'build.gradle', '.git' }),

				settings = {
					java = {
						signatureHelp = { enabled = true },
						completion = {
							favoriteStaticMembers = {
								'org.hamcrest.MatcherAssert.assertThat',
								'org.hamcrest.Matchers.*',
								'org.hamcrest.CoreMatchers.*',
								'org.junit.jupiter.api.Assertions.*',
								'java.util.Objects.requireNonNull',
								'java.util.Objects.requireNonNullElse',
								'org.mockito.Mockito.*',
							},
						},
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
					},
				},

				init_options = {
					bundles = bundles,
				},
			}

			-- ── Start jdtls ─────────────────────────────────────────
			require('jdtls').start_or_attach(config)

			-- ── LspAttach keymaps for jdtls ────────────────────────
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('JavaKeymaps', { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client or client.name ~= 'jdtls' then return end

					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = 'Java: ' .. desc })
					end

					-- Refactoring
					map('n', '<leader>co', function() require('jdtls').organize_imports() end, 'Organize imports')
					map('n', '<leader>cxv', function() require('jdtls').extract_variable() end, 'Extract variable')
					map('n', '<leader>cxc', function() require('jdtls').extract_constant() end, 'Extract constant')
					map({ 'n', 'v' }, '<leader>cxm', function() require('jdtls').extract_method() end, 'Extract method')

					-- Testing (requires java-test bundle)
					map('n', '<leader>ct', function() require('jdtls').test_nearest_method() end, 'Run nearest test')
					map('n', '<leader>cT', function() require('jdtls').test_class() end, 'Run test class')

					-- DAP (requires java-debug bundle) — register Java DAP adapter
					if #collect_jars(mason_root .. '/java-debug-adapter/extension/server/*.jar') > 0 then
						map('n', '<leader>cD', function() require('jdtls.dap').setup_dap_main_class_configs() end, 'Refresh DAP configs')
					end
				end,
			})
		end,
	},

	-- ── spring-boot.nvim (Spring Boot language server) ────────
	{
		'JavaHello/spring-boot.nvim',
		ft = { 'java', 'yaml', 'jproperties' },
		dependencies = {
			'mfussenegger/nvim-jdtls',
		},
		opts = {},
	},
}
