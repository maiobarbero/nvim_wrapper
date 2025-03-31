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

function Wrapper.wrap_visual(char)
	local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
	local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

    start_row = start_row - 1
    end_row = end_row - 1

    local selected_text
    if start_row == end_row then
        -- Single line selection
        local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
        selected_text = line:sub(start_col + 1, end_col + 1) 

        local wrapped = char .. selected_text .. char
        
        if char == "(" then
            wrapped = "(" .. selected_text .. ")"
        elseif char == "[" then
            wrapped = "[" .. selected_text .. "]"
        elseif char == "{" then
            wrapped = "{" .. selected_text .. "}"
        end
        
        vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, { wrapped })
    else
        -- Multi-line selection is more complex
        -- For simplicity, we'll just notify the user that it's not supported
        vim.notify("Multi-line selection wrapping is not supported yet", vim.log.levels.WARN)
    end
    
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

    -- Visual mode mappings
    vim.keymap.set("v", "<leader>w'", function()
        require("nvim_wrapper").wrap_visual("'")
    end, { noremap = true, silent = true, desc = "[W]rap selection with single quotes" })

    vim.keymap.set("v", '<leader>w"', function()
        require("nvim_wrapper").wrap_visual("\"")
    end, { noremap = true, silent = true, desc = "[W]rap selection with double quotes" })

    vim.keymap.set("v", "<leader>w(", function()
        require("nvim_wrapper").wrap_visual("(")
    end, { noremap = true, silent = true, desc = "[W]rap selection with parenthesis" })

    vim.keymap.set("v", "<leader>w[", function()
        require("nvim_wrapper").wrap_visual("[")
    end, { noremap = true, silent = true, desc = "[W]rap selection with square brackets" })

    vim.keymap.set("v", "<leader>w{", function()
        require("nvim_wrapper").wrap_visual("{")
    end, { noremap = true, silent = true, desc = "[W]rap selection with curly brackets" })
end

return Wrapper
