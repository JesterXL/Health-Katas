require "robotlegs.Mediator"
MainViewMediator = {}

function MainViewMediator:new()

	local mediator = Mediator:new()

	function mediator:onRegister()
		
	end

	function mediator:onRemove()

	end

	return mediator

end


return MainViewMediator