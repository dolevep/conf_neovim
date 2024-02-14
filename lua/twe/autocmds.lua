-- wut autocmd/
local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand


-- is this autocmd?
-- vim.api.nvim_create_autocmd('BufReadPost', {
-- 	group = vim.g.user.event,
-- 	callback = function(args)
-- 		local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
-- 		local not_commit = vim.b[args.buf].filetype ~= 'commit'
--
-- 		if valid_line and not_commit then
-- 			vim.cmd([[normal! g`"]])
-- 		end
-- 	end,
-- })


-- autocmd("BufWriteCmd", {
--   callback = function()
--     -- do stuff here like print!
--     print("whe~~~~~~~~~");
--   end
-- })
