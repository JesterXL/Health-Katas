ProgressService = {}

function ProgressService:new()

	local service = {}
	service.FILE_NAME = "progress.json"
	service.DIRECTORY = system.DocumentsDirectory

	function service:saveProgress(memento)
		-- create a file path for corona i/o
		local path = system.pathForFile(self.FILE_NAME, self.DIRECTORY)
		assert(path ~= nil, "path is nil")
		local json = require "json"
		-- will hold contents of file
		local contents = json.encode(memento)

		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "w" )
		--print("base: ", base, ", path: ", path, ", file: ", file)
		file:write(contents)
		io.close( file )	-- close the file after using it
		return true
	end

	function service:loadProgress()
		-- create a file path for corona i/o
		local path = system.pathForFile(self.FILE_NAME, self.DIRECTORY)
		assert(path ~= nil, "path is nil")
		-- will hold contents of file
		local contents

		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "r" )
		if file then
			contents = file:read( "*a" )
			io.close( file )	-- close the file after using it
			if contents == nil then return nil end
			local json = require "json"
			local memento = json.decode(contents)
			return memento
		else
			return nil
		end
	end

	function service:delete()
		local path = system.pathForFile(self.FILE_NAME, self.DIRECTORY)
		return os.remove(path)
	end

	return service
end

return ProgressService
