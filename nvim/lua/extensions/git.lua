local Input = require("nui.input") -- Function to log output directly to a file

function logOutput(output, filename)
	local log_file = io.open(filename, "a") -- Open log file for appending
	if log_file then
		log_file:write(output) -- Write the output directly
		log_file:write("\n") -- Optionally add a newline after the log for better separation
		log_file:close()
	else
		print("Failed to open log file.")
	end
end

local function runCommandSeparate(command)
	local stdout_temp = os.tmpname() -- Temporary file for stdout
	local stderr_temp = os.tmpname() -- Temporary file for stderr

	-- Execute the command with stdout and stderr redirected to temporary files
	local full_command = string.format("%s >%s 2>%s", command, stdout_temp, stderr_temp)
	local success = os.execute(full_command)

	if not success then
		return "", "failed to run command"
	end

	-- Read the output from stdout
	local stdout_file = io.open(stdout_temp, "r")

	if not stdout_file then
		return "", "failed to open stdout file"
	end

	local output = stdout_file:read("*all")
	stdout_file:close()

	os.remove(stdout_temp) -- Clean up the temporary file

	-- Read the output from stderr
	local stderr_file = io.open(stderr_temp, "r")

	if not stderr_file then
		return "", "failed to open stderr file"
	end

	local err = stderr_file:read("*all")
	stderr_file:close()
	os.remove(stderr_temp) -- Clean up the temporary file

	return output, err
end

-- Function to run a command and capture its output, error and exit status
local function runCommand(command)
	local handle, errmsg = io.popen(command .. " 2>&1", "r") -- Captures both stdout and stderr
	if not handle then
		return false, "failed to run command", 1, ""
	end

	print(errmsg)
	local output = handle:read("*a") -- Read the entire output as a single string
	local success, exit_type, exit_code = handle:close()
	return success, exit_type, exit_code, output
end

local commitMessageInput = Input({
	position = "50%",
	size = {
		width = 80,
		height = 30,
	},
	border = {
		style = "single",
		text = {
			top = "Commit Message",
			top_align = "center",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal,FloatBorder:Normal",
	},
}, {
	prompt = "> ",
	on_close = function()
		print("Input Closed!")
	end,
	on_submit = function(value)
		-- Print current directory

		-- Stage all changes
		-- Create a acommit with the message
		os.execute("git add .")

		-- TODO: refactor success out and just put all errors in stdout_output
		local output, err = runCommandSeparate('git commit -m "' .. value .. '"')

		print("Output: " .. output)
		print("Error: " .. err)
		print(type(err))

		local clean_string = err:gsub("\n", "\n")
		print(clean_string)

		-- print(exit_type)
		-- print(exit_code)
		-- print(stdout_output)
		-- print(stderr_output)
		--
		-- if success then
		--   print 'Commit successful!'
		-- else
		--   print 'Commit failed!'
		--   print(exit_type)
		--   print(exit_code)
		-- end
	end,
})

local M = {}

M.setup = function()
	vim.keymap.set("n", "<leader>cc", function()
		commitMessageInput:mount()
	end, { desc = "Toggle commit popup" })
end

return M
