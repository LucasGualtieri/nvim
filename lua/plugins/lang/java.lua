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
	-- Hash-set for O(1) exclusion lookup instead of O(m) vim.tbl_contains per file
	local skip = {}
	for _, v in ipairs(excluded) do skip[v] = true end

	-- vim.fn.glob(..., true, true) returns a Lua list directly — no string-split needed
	local jars = {}
	for _, jar in ipairs(vim.fn.glob(pattern, true, true)) do
		local fname = vim.fn.fnamemodify(jar, ':t')
		if fname ~= '' and not skip[fname] then
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

			-- ── Bundles (computed once at plugin load) ───────────────
			local bundles = {}

			-- 1) java-debug-adapter (installed via Mason)
			local debug_jar = vim.fn.glob(
				mason_root .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true
			)
			local has_debug = debug_jar ~= ''
			if has_debug then
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
			local lombok_path = jdtls_root .. '/lombok.jar'
			local has_lombok = vim.uv.fs_stat(lombok_path) ~= nil

			-- ── Per-buffer setup function ────────────────────────────
			-- Called for every Java buffer so that root_dir and workspace_dir
			-- are evaluated fresh, enabling correct multi-project support.
			local function attach(bufnr)
				-- Resolve the project root for this specific buffer
				local root_dir = vim.fs.root(bufnr, { 'gradlew', 'mvnw', 'pom.xml', 'build.gradle', '.git' })

				-- Key the workspace off the full root path so two projects with the
				-- same directory basename (e.g. both named "backend") get distinct
				-- workspaces. The 8-char sha256 prefix is collision-free in practice.
				local workspace_dir
				if root_dir then
					local safe_name = vim.fn.fnamemodify(root_dir, ':t')
					local hash = vim.fn.sha256(root_dir):sub(1, 8)
					workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspaces/' .. safe_name .. '-' .. hash
				else
					local fpath = vim.api.nvim_buf_get_name(bufnr)
					workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspaces/_unnamed-' .. vim.fn.sha256(fpath):sub(1, 8)
				end

				local cmd = {
					'jdtls',
					'-data', workspace_dir,
					'--jvm-arg=-Xms512m',
					'--jvm-arg=-Xmx4g',
					'--jvm-arg=-XX:+UseG1GC',
					'--jvm-arg=-XX:+UseStringDeduplication',
				}
				if has_lombok then
					table.insert(cmd, '--jvm-arg=-javaagent:' .. lombok_path)
				end

				local config = {
					name = 'jdtls',

					flags = {
						debounce_text_changes = 50,
					},

					cmd = cmd,

					root_dir = root_dir,

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

				require('jdtls').start_or_attach(config)
			end

			-- ── Register autocmd for future Java buffers ─────────────
			-- When lazy.nvim loads this plugin (triggered by FileType java),
			-- the current buffer's FileType event has already fired. We register
			-- the autocmd for subsequent buffers and call attach() directly for
			-- the buffer that triggered this load.
			vim.api.nvim_create_autocmd('FileType', {
				pattern = 'java',
				group = vim.api.nvim_create_augroup('JdtlsAttach', { clear = true }),
				callback = function(args)
					attach(args.buf)
				end,
			})

			-- Handle the buffer that triggered plugin load
			attach(vim.api.nvim_get_current_buf())

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
					-- map('n', '<leader>co', function() require('jdtls').organize_imports() end, 'Organize imports')
					-- map('n', '<leader>cxv', function() require('jdtls').extract_variable() end, 'Extract variable')
					-- map('n', '<leader>cxc', function() require('jdtls').extract_constant() end, 'Extract constant')
					-- map({ 'n', 'v' }, '<leader>cxm', function() require('jdtls').extract_method() end, 'Extract method')

					-- Testing (requires java-test bundle)
					-- map('n', '<leader>ct', function() require('jdtls').test_nearest_method() end, 'Run nearest test')
					-- map('n', '<leader>cT', function() require('jdtls').test_class() end, 'Run test class')

					-- DAP — reuse the has_debug flag computed at load; no re-globbing needed
					if has_debug then
						-- Kill the 2s `setup_dap_main_class_configs` auto-provider. Big Gradle projects
						-- exceed its timeout and the picker closes empty ("Discovering main classes took too long").
						-- Main-class discovery stays available explicitly via <leader>cD below.
						local dap_ok, dap = pcall(require, 'dap')
						if dap_ok and dap.providers and dap.providers.configs then
							dap.providers.configs.jdtls = nil
						end

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
