local Wrapper = {}

function Wrapper.wrap_word(char)
	local line = vim.api.nvim_get_current_line()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row = cursor_pos[1] - 1
    local col = cursor_pos[2]
    local start_idx = col

    while start_idx > 0 and line:sub(start_idx, start_idx):match("[%w_]") do
        start_idx = start_idx - 1
    end

    local end_idx = col
    while end_idx <= #line and line:sub(end_idx + 1, end_idx + 1):match("[%w_]") do
        end_idx = end_idx + 1
    end

    local word = line:sub(start_idx + 1, end_idx)

	local wrapped

	if char == "(" then
		wrapped = "(" .. word .. ")"
	elseif char == "[" then
		wrapped = "[" .. word .. "]"
	elseif char == "{" then
		wrapped = "{" .. word .. "}"
    else
        wrapped = char .. word .. char
	end

	vim.api.nvim_buf_set_text(0, row, start_idx, row, end_idx, { wrapped })
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
