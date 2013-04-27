require "robotlegs.Mediator"
MyProgressViewMediator = {}

function MyProgressViewMediator:new()

	local mediator = Mediator:new()

	function mediator:onRegister()
		print("MyProgressViewMediator::onRegister")
		local view = self.viewInstance
		view:setLevels(gProgressModel.levels)
	end

	function mediator:onRemove()
		print("MyProgressViewMediator::onRemove")
		local view = self.viewInstance
		view:setLevels(nil)
		self.viewInstance = nil
	end

	return mediator

end

return MyProgressViewMediator