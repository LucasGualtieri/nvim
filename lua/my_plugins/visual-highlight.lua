local M = {}

local namespace = vim.api.nvim_create_namespace("visual-highlight")

local default_config = {

	highlight = {
		-- fg = "#ff0000",
		bg = "#00ff00",
		bold = true,
		italic = false,
		underline = false,
		strikethrough = false,
		reverse = false,
	},

	-- enable_in_visual = true,
	-- enable_in_line = true,
	-- enable_in_block = true,
}

local function normalize_pos(pos1, pos2)

	local l1, c1 = pos1[2], pos1[3]
	local l2, c2 = pos2[2], pos2[3]

	if l1 < l2 or (l1 == l2 and c1 <= c2) then
		return pos1, pos2
	else
		return pos2, pos1
	end
end

local function get_visual_selection()

	-- Ambos retornam uma tabela: {bufnr, line, col, off} # Lua is 1 based
	local pos1 = vim.fn.getpos("v")
	local pos2 = vim.fn.getpos(".")

	local start_pos, end_pos = normalize_pos(pos1, pos2)

	local start_line = start_pos[2]
	local start_col = start_pos[3]
	local end_line = end_pos[2]
	local end_col = end_pos[3]

	-- Obtem linhas do buffer (inclusive)
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	if #lines ~= 1 then return "" end

	return string.sub(lines[1], start_col, end_col)
end

local function Highlight()

	local pattern = get_visual_selection()

	if string.len(pattern) == 0 then return end

	local linesUp = 40
	local linesDown = 40

	local currentLine = vim.fn.line(".") - linesUp

	if currentLine < 0 then
		currentLine = 0
	end

	local lines = vim.api.nvim_buf_get_lines(0, currentLine, currentLine + linesDown, false)

	for i, line in ipairs(lines) do

		local lineIndex = currentLine + i - 1
		local index = 0

		while true do

			local matchIndex = string.find(line, pattern, index + 1)

			if matchIndex == nil then break end

			index = matchIndex - 1

			vim.api.nvim_buf_set_extmark(0, namespace, lineIndex, index, {
				end_col = index + string.len(pattern),
				hl_group = "LucasHighlight",
			})

			index = index + 1
		end
	end
end

function M.setup(user_config)

	-- Merge user config with defaults
	default_config = vim.tbl_deep_extend("force", default_config, user_config or {})

	vim.api.nvim_set_hl(0, "LucasHighlight", default_config.highlight)

	vim.api.nvim_create_autocmd({"ModeChanged", "CursorMoved", "CursorMovedI"}, {

		-- group = group,

		callback = function()
			local mode = vim.fn.mode()
			if mode:match("[vV]") then
				vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
				Highlight()
			else
				-- Clear highlights when leaving visual mode
				vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
			end
		end
	})
end

return M
