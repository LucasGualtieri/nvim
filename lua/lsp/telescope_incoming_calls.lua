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

--- Stable key for one physical call site (start only; end may differ across duplicate ranges).
---@param uri string
---@param rng lsp.Range
---@return string
local function range_key(uri, rng)
	return string.format('%s:%d:%d', uri, rng.start.line, rng.start.character)
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

---@param item vim.quickfix.entry
---@return string
local function qf_item_dedupe_key(item)
	return string.format('%s\0%d\0%d', item.filename, item.lnum or 0, item.col or 0)
end

---@param items vim.quickfix.entry[]
---@param opts table
---@return vim.quickfix.entry[]
local function filter_file_ignore_patterns(items, opts)
	local file_ignore_patterns = vim.F.if_nil(opts.file_ignore_patterns, conf.file_ignore_patterns)
	file_ignore_patterns = file_ignore_patterns or {}
	if vim.tbl_isempty(file_ignore_patterns) then
		return items
	end
	return vim.tbl_filter(function(item)
		for _, patt in ipairs(file_ignore_patterns) do
			if string.match(item.filename, patt) then
				return false
			end
		end
		return true
	end, items)
end

---@param bufnr integer
---@return boolean
local function check_definition_capability(bufnr)
	for _, client in pairs(lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method('textDocument/definition', { bufnr = bufnr }) then
			return true
		end
	end
	if #lsp.get_clients({ bufnr = bufnr }) == 0 then
		utils.notify('builtin.lsp_*', { msg = 'no client attached', level = 'INFO' })
	else
		utils.notify('builtin.lsp_*', { msg = 'server does not support textDocument/definition', level = 'INFO' })
	end
	return false
end

--- Like telescope.builtin.lsp_definitions, but dedupes identical targets (e.g. multiple LSP clients or duplicate results).
---@param opts table? telescope.builtin.list_or_jump.opts
local function lsp_definitions_deduped(opts)
	opts = opts or {}
	opts.bufnr = vim._resolve_bufnr(opts.bufnr or 0)
	if not check_definition_capability(opts.bufnr) then
		return
	end
	opts.reuse_win = vim.F.if_nil(opts.reuse_win, false)
	opts.winnr = opts.winnr or api.nvim_get_current_win()
	opts.curr_filepath = api.nvim_buf_get_name(opts.bufnr)

	local params = function(client)
		return lsp.util.make_position_params(opts.winnr, client.offset_encoding)
	end

	lsp.buf_request_all(opts.bufnr, 'textDocument/definition', params, function(results_per_client)
		local items = {}
		local seen = {}
		local first_item_encoding ---@type string?
		local errors = {}

		for client_id, result_or_error in pairs(results_per_client) do
			local err, result = result_or_error.err, result_or_error.result
			if err then
				errors[client_id] = err
			elseif result ~= nil then
				local locations = {}
				if not vim.islist(result) then
					vim.list_extend(locations, { result })
				else
					vim.list_extend(locations, result)
				end
				local offset_encoding = lsp.get_client_by_id(client_id).offset_encoding
				for _, item in ipairs(lsp.util.locations_to_items(locations, offset_encoding)) do
					local key = qf_item_dedupe_key(item)
					if not seen[key] then
						seen[key] = true
						table.insert(items, item)
						if not first_item_encoding then
							first_item_encoding = offset_encoding
						end
					end
				end
			end
		end

		for _, err in pairs(errors) do
			utils.notify('builtin.lsp_definitions', { msg = 'textDocument/definition : ' .. err.message, level = 'ERROR' })
		end

		items = filter_file_ignore_patterns(items, opts)

		if vim.tbl_isempty(items) then
			utils.notify('builtin.lsp_definitions', {
				msg = 'No LSP Definitions found',
				level = 'INFO',
			})
			return
		end

		if #items == 1 and opts.jump_type ~= 'never' then
			local item = items[1]
			if opts.curr_filepath ~= item.filename or not opts.reuse_win then
				local cmd
				if opts.jump_type == 'tab' then
					cmd = 'tabedit'
				elseif opts.jump_type == 'split' then
					cmd = 'new'
				elseif opts.jump_type == 'vsplit' then
					cmd = 'vnew'
				elseif opts.jump_type == 'tab drop' then
					cmd = 'tab drop'
				end
				if cmd then
					vim.cmd(string.format('%s %s', cmd, item.filename))
				end
			end
			lsp.util.show_document(item.user_data, first_item_encoding, { reuse_win = opts.reuse_win })
		else
			pickers
				.new(opts, {
					prompt_title = 'LSP Definitions',
					finder = finders.new_table({
						results = items,
						entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
					}),
					previewer = conf.qflist_previewer(opts),
					sorter = conf.generic_sorter(opts),
					push_cursor_on_edit = true,
					push_tagstack_on_edit = true,
				})
				:find()
		end
	end)
end

---@param opts table? Telescope-style opts (bufnr, entry_maker, etc.)
function M.incoming_calls(opts)
	opts = vim.tbl_extend('force', { bufnr = api.nvim_get_current_buf() }, opts or {})
	local bufnr = vim._resolve_bufnr(opts.bufnr)
	local win = api.nvim_get_current_win()

	local function position_params(client)
		return lsp.util.make_position_params(win, client.offset_encoding)
	end

	lsp.buf_request_all(bufnr, 'textDocument/prepareCallHierarchy', position_params, function(prep_results)
		local all_items = {}
		for _, resp in pairs(prep_results) do
			if not resp.err and resp.result then
				vim.list_extend(all_items, resp.result)
			end
		end

		local hierarchy_item = pick_call_hierarchy_item(all_items)
		if not hierarchy_item then
			return
		end

		lsp.buf_request_all(bufnr, 'callHierarchy/incomingCalls', { item = hierarchy_item }, function(call_results)
			local locations = {}
			local seen = {}
			local first_uri, first_range ---@type string?, lsp.Range?
			local first_client_id ---@type integer?

			for client_id, resp in pairs(call_results) do
				if not resp.err and resp.result and not vim.tbl_isempty(resp.result) then
					for _, ch_call in pairs(resp.result) do
						local ch_item = ch_call.from
						for _, rng in pairs(ch_call.fromRanges) do
							local uri = ch_item.uri
							local u, r = push_location_if_new(uri, rng, ch_item, seen, locations)
							if u and r and not first_uri then
								first_uri, first_range = u, r
								first_client_id = client_id
							end
						end
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

			if #locations == 1 and first_uri and first_range and first_client_id then
				local client = assert(lsp.get_client_by_id(first_client_id))
				lsp.util.show_document({ uri = first_uri, range = first_range }, client.offset_encoding, { focus = true })
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
		lsp_definitions_deduped({ bufnr = bufnr, winnr = win })
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
