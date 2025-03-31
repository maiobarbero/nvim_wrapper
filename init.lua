local Wrapper = {}

function Wrapper.wrap_word(char)
	local word = vim.fn.expand("<cword>")

	local word_start = vim.fn.col("\\<") - 1
	local word_end = vim.fn.col("\\>")

	local wrapped = char .. word .. char

	if char == "(" then
		wrapped = "(" .. word .. ")"
	elseif char == "[" then
		wrapped = "[" .. word .. "]"
	elseif char == "{" then
		wrapped = "{" .. word .. "}"
	end

	vim.api.nvim_buf_set_text(0, vim.fn.line(".") - 1, word_start, vim.fn.line(".") - 1, word_end, { wrapped })
end

function Wrapper.setup()
	vim.keymap.set("n", "<leader>w'", function()
		require("nvim_wrapper").wrap_word("'")
	end, { noremap = true, silent = true, desc = "[W]rap word with single quotes" })

	vim.keymap.set("n", '<leader>w"', function()
		require("nvim_wrapper").wrap_word("\"")
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
