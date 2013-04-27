LoadTextService = {}

function LoadTextService:new()
	local service = {}

	function service:loadTextFile(path)
		-- create a file path for corona i/o
		local path = system.pathForFile(path, system.ResourceDirectory)
		assert(path ~= nil, "path is nil")
		-- will hold contents of file
		local contents

		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "r" )
		if file then
			contents = file:read( "*a" )
			io.close( file )	-- close the file after using it
			if contents then
				return contents
			else
				error("ERROR: LoadTextService::loadTextFile, failed to load text file: " .. path)
				return ""
			end
		else
			error("ERROR: LoadTextService::loadTextFile, failed to open the file at: " .. path)
			return ""
		end
	end

	return service
end

return LoadTextService