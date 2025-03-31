local Wrapper 

function Wrapper.wrap_word(char)
	local word = vim.fn.expand("<cword>")

	local word_start = vim.fn.col("\\<") - 1
	local word_end = vim.fn.col("\\>")

    local wrapped = char .. word .. char

    local par = char == "("
    if par then
        wrapped = "(" .. wrapped .. ")"
    end

    local square = char == "["
    if square then
        wrapped = "[" .. wrapped .. "]"
    end

    local curly = char == "{"
    if curly then
        wrapped = "{" .. wrapped .. "}"
    end

	vim.api.nvim_buf_set_text(0, vim.fn.line(".") - 1, word_start, vim.fn.line(".") - 1, word_end, { wrapped })
end

function Wrapper.setup()
	vim.keymap.set("n", "s'", function()
		require("wrapper").wrap_word("'")
	end, { noremap = true, silent = true, desc = "[S]urround word with single quotes" })

	vim.keymap.set("n", "s\"", function()
		require("wrapper").wrap_word("'")
	end, { noremap = true, silent = true, desc = "[S]urround word with single quotes" })

	vim.keymap.set("n", "s(", function()
		require("wrapper").wrap_word("'")
	end, { noremap = true, silent = true, desc = "[S]urround word with parenthesis" })

    vim.keymap.set("n", "s[", function()
        require("wrapper").wrap_word("'")
    end, { noremap = true, silent = true, desc = "[S]urround word with square brackets" })

    vim.keymap.set("n", "s{", function()
        require("wrapper").wrap_word("'")
    end, { noremap = true, silent = true, desc = "[S]urround word with curly brackets" })
end

return Wrapper
