local M = {}
-- custom_areas
M.custom_areas_diagnostic = function()
	local result = {}
	local seve = vim.diagnostic.severity
	local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
	local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
	local info = #vim.diagnostic.get(0, { severity = seve.INFO })
	local hint = #vim.diagnostic.get(0, { severity = seve.HINT })
	local icons = require("util.stuffs.icons").diagnostics
	local colors = {
		error = require("util.stuffs.colors").get_hl("DiagnosticError").fg,
		warn = require("util.stuffs.colors").get_hl("DiagnosticWarn").fg,
		info = require("util.stuffs.colors").get_hl("DiagnosticInfo").fg,
		hint = require("util.stuffs.colors").get_hl("DiagnosticHint").fg,
	}

	if error ~= 0 then
		table.insert(result, { text = string.format("%s%d ", icons.Error, error), fg = colors.error })
	end

	if warning ~= 0 then
		table.insert(result, { text = string.format("%s%d ", icons.Warn, warning), fg = colors.warn })
	end

	if info ~= 0 then
		table.insert(result, { text = string.format("%s%d ", icons.Info, info), fg = colors.info })
	end

	if hint ~= 0 then
		table.insert(result, { text = string.format("%s%d ", icons.Hint, hint), fg = colors.hint })
	end

	return result
end

return M
