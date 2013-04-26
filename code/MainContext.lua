require "robotlegs.Context"

MainContext = {}

function MainContext:new()

	local context = Context:new()

	function context:startup()

		self:mapCommand("onApplicationStartup", 
						"commands.StartupCommand")
		
		-- self:mapMediator("views.MainView", 
		-- 					"mediators.MainViewMediator")

		self:mapMediator("views.KataView", 
							"mediators.KataViewMediator")
		
		Runtime:dispatchEvent({name="onApplicationStartup"})
	end

	return context

end

return MainContext