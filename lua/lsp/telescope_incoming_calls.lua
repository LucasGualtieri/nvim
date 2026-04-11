-- Incoming calls via Telescope; auto-jumps with vim.lsp.util.show_document when there is exactly one call site.
-- Deduplicates call sites: jdtls (and others) may repeat the same range in fromRanges.

local api = vim.api
local lsp = vim.lsp

local conf = require('telescope.config').values
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local utils = require('telescope.utils')

local M = {}

---@param call_hierarchy_items lsp.CallHierarchyItem[]?
---@return lsp.CallHierarchyItem?
local function pick_call_hierarchy_item(call_hierarchy_items)
	if not call_hierarchy_items or vim.tbl_isempty(call_hierarchy_items) then
		return nil
	end
	if #call_hierarchy_items == 1 then
		return call_hierarchy_items[1]
	end
	local items = {}
	for i, item in pairs(call_hierarchy_items) do
		local entry = item.detail or item.name
		table.insert(items, string.format('%d. %s', i, entry))
	end
	local choice = vim.fn.inputlist(items)
	if choice < 1 or choice > #items then
		return nil
	end
	return call_hierarchy_items[choice]
end

--- Stable key for one physical call-site range (jdtls often emits duplicates).
---@param uri string
---@param rng lsp.Range
---@return string
local function range_key(uri, rng)
	return string.format(
		'%s:%d:%d:%d:%d',
		uri,
		rng.start.line,
		rng.start.character,
		rng['end'].line,
		rng['end'].character
	)
end

---@param uri string
---@param rng lsp.Range
---@param ch_item lsp.CallHierarchyItem
---@param seen table<string, boolean>
---@param locations table[]
---@return string?, lsp.Range? first_uri, first_range (only meaningful when #locations will be 1)
local function push_location_if_new(uri, rng, ch_item, seen, locations)
	local key = range_key(uri, rng)
	if seen[key] then
		return nil, nil
	end
	seen[key] = true
	table.insert(locations, {
		filename = vim.uri_to_fname(uri),
		text = ch_item.name,
		lnum = rng.start.line + 1,
		col = rng.start.character + 1,
		_uri = uri,
		_range = rng,
	})
	return uri, rng
end

---@param opts table? Telescope-style opts (bufnr, entry_maker, etc.)
function M.incoming_calls(opts)
	opts = vim.tbl_extend('force', { bufnr = api.nvim_get_current_buf() }, opts or {})
	local bufnr = vim._resolve_bufnr(opts.bufnr)

	local function client_position_params()
		local win = api.nvim_get_current_win()
		return function(client)
			return lsp.util.make_position_params(win, client.offset_encoding)
		end
	end

	lsp.buf_request(bufnr, 'textDocument/prepareCallHierarchy', client_position_params(), function(err, result, _ctx)
		if err then
			utils.notify('lsp.incoming_calls', { msg = err.message, level = 'ERROR' })
			return
		end

		local hierarchy_item = pick_call_hierarchy_item(result)
		if not hierarchy_item then
			return
		end

		lsp.buf_request(bufnr, 'callHierarchy/incomingCalls', { item = hierarchy_item }, function(err2, result2, ctx2)
			if err2 then
				utils.notify('lsp.incoming_calls', { msg = err2.message, level = 'ERROR' })
				return
			end

			if not result2 or vim.tbl_isempty(result2) then
				vim.notify('No incoming calls', vim.log.levels.INFO)
				return
			end

			local locations = {}
			local seen = {}
			local first_uri, first_range ---@type string?, lsp.Range?

			for _, ch_call in pairs(result2) do
				local ch_item = ch_call.from
				for _, rng in pairs(ch_call.fromRanges) do
					local uri = ch_item.uri
					local u, r = push_location_if_new(uri, rng, ch_item, seen, locations)
					if u and r and not first_uri then
						first_uri, first_range = u, r
					end
				end
			end

			if #locations == 0 then
				vim.notify('No incoming calls', vim.log.levels.INFO)
				return
			end

			-- Strip internal fields before Telescope / quickfix display
			for _, loc in ipairs(locations) do
				loc._uri = nil
				loc._range = nil
			end

			if #locations == 1 and first_uri and first_range then
				local client = assert(lsp.get_client_by_id(ctx2.client_id))
				local location = { uri = first_uri, range = first_range }
				lsp.util.show_document(location, client.offset_encoding, { focus = true })
				return
			end

			pickers
				.new(opts, {
					prompt_title = 'LSP Incoming Calls',
					finder = finders.new_table({
						results = locations,
						entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
					}),
					previewer = conf.qflist_previewer(opts),
					sorter = conf.generic_sorter(opts),
					push_cursor_on_edit = true,
					push_tagstack_on_edit = true,
				})
				:find()
		end)
	end)
end

---@param pos lsp.Position
---@param range lsp.Range
---@return boolean
local function position_in_range(pos, range)
	local s, e_ = range.start, range['end']
	if pos.line < s.line or (pos.line == s.line and pos.character < s.character) then
		return false
	end
	if pos.line > e_.line or (pos.line == e_.line and pos.character > e_.character) then
		return false
	end
	return true
end

---@param bufnr integer
---@param location lsp.Location|lsp.LocationLink
---@param cursor_lsp lsp.Position
---@return boolean
local function cursor_on_definition_location(bufnr, location, cursor_lsp)
	local uri = location.uri or location.targetUri
	if vim.uri_from_bufnr(bufnr) ~= uri then
		return false
	end
	local range = location.range or location.targetSelectionRange or location.targetRange
	if not range then
		return false
	end
	return position_in_range(cursor_lsp, range)
end

--- If the cursor is on a definition/declaration in this buffer, open incoming calls; otherwise go to definition (Telescope).
---@param bufnr integer?
function M.definition_or_incoming_calls(bufnr)
	bufnr = vim._resolve_bufnr(bufnr or 0)
	local win = api.nvim_get_current_win()
	local cur = api.nvim_win_get_cursor(win)
	local row, byte_col = cur[1] - 1, cur[2]

	local function params_for_definition()
		return function(client)
			return lsp.util.make_position_params(win, client.offset_encoding)
		end
	end

	local has_hierarchy = false
	for _, c in ipairs(lsp.get_clients({ bufnr = bufnr })) do
		if c:supports_method('textDocument/prepareCallHierarchy', { bufnr = bufnr }) then
			has_hierarchy = true
			break
		end
	end

	local function go_definitions()
		require('telescope.builtin').lsp_definitions({ bufnr = bufnr, winnr = win })
	end

	if not has_hierarchy then
		go_definitions()
		return
	end

	lsp.buf_request_all(bufnr, 'textDocument/definition', params_for_definition(), function(results)
		local on_definition = false
		for client_id, resp in pairs(results) do
			local client = lsp.get_client_by_id(client_id)
			if client and not resp.err and resp.result ~= nil then
				local list = resp.result
				if not vim.islist(list) then
					list = { list }
				end
				local enc = client.offset_encoding
				local char = lsp.util.character_offset(bufnr, row, byte_col, enc)
				local cursor_lsp = { line = row, character = char }
				for _, loc in ipairs(list) do
					if cursor_on_definition_location(bufnr, loc, cursor_lsp) then
						on_definition = true
						break
					end
				end
			end
			if on_definition then
				break
			end
		end

		if on_definition then
			M.incoming_calls({ bufnr = bufnr })
		else
			go_definitions()
		end
	end)
end

return M
