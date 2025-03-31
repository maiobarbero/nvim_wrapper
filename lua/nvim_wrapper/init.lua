local Wrapper = {}

function Wrapper.wrap_word(char)
	local word = vim.fn.expand("<cword>")

	local row = vim.fn.line(".") - 1 -- 0-indexed
	local cursor_col = vim.fn.col(".") - 1 -- 0-indexed

	local line = vim.api.nvim_get_current_line()

	local word_start = line:sub(1, cursor_col + 1):match(".*()%w+$")
	if not word_start then
		word_start = cursor_col
	end
	word_start = word_start - 1 -- Convert to 0-indexed

	local word_end = word_start + #word

	local wrapped = char .. word .. char

	if char == "(" then
		wrapped = "(" .. word .. ")"
	elseif char == "[" then
		wrapped = "[" .. word .. "]"
	elseif char == "{" then
		wrapped = "{" .. word .. "}"
	end

	vim.api.nvim_buf_set_text(0, row, word_start, row, word_end, { wrapped })
end

function Wrapper.setup()
	vim.keymap.set("n", "<leader>w'", function()
		require("nvim_wrapper").wrap_word("'")
	end, { noremap = true, silent = true, desc = "[W]rap word with single quotes" })

	vim.keymap.set("n", '<leader>w"', function()
		require("nvim_wrapper").wrap_word('"')
	end, { noremap = true, silent = true, desc = "[W]rap word with double quotes" })

	vim.keymap.set("n", "<leader>w(", function()
		require("nvim_wrapper").wrap_word("(")
	end, { noremap = true, silent = true, desc = "[W]rap word with parenthesis" })

	vim.keymap.set("n", "<leader>w[", function()
		require("nvim_wrapper").wrap_word("[")
	end, { noremap = true, silent = true, desc = "[W]rap word with square brackets" })

	vim.keymap.set("n", "<leader>w{", function()
		require("nvim_wrapper").wrap_word("{")
	end, { noremap = true, silent = true, desc = "[W]rap word with curly brackets" })

end

return Wrapper
