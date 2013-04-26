require "models.ProgressModel"

StartupCommand = {}

function StartupCommand:new()

	local command = {}

	function command:execute()
		print("StartupCommand::execute")
		local progressModel = ProgressModel:new()
		progressModel:loadState()
		_G.gProgressModel = progressModel
	end

	return command

end

return StartupCommand