require "robotlegs.Mediator"
KataViewMediator = {}

function KataViewMediator:new()

	local mediator = Mediator:new()

	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("onStartedKata", self)
		view:addEventListener("onAlreadySuccessful", self)
		view:addEventListener("onKataComplete", self)
		view:addEventListener("onKataCompleteConfirmed", self)

		Runtime:addEventListener("ProgressModel_currentKataChanged", self)

		view:setKata(gProgressModel.currentKata)
	end

	function mediator:onRemove()
		local view = self.viewInstance
		view:removeEventListener("onStartedKata", self)
		view:removeEventListener("onAlreadySuccessful", self)
		view:removeEventListener("onKataComplete", self)
		view:removeEventListener("onKataCompleteConfirmed", self)
		self.viewInstance:setKata(nil)
	end

	function mediator:onStartedKata()
		gProgressModel:startKata(self.viewInstance.vo)
	end

	function mediator:onAlreadySuccessful()
		gProgressModel:kataAlreadySuccessful(self.viewInstance.vo)
	end

	function mediator:onKataComplete()
		gProgressModel:kataCompleted(self.viewInstance.vo)
	end

	function mediator:onKataCompleteConfirmed()
		gProgressModel:nextKata()
	end

	function mediator:ProgressModel_currentKataChanged()
		self.viewInstance:setKata(gProgressModel.currentKata)
	end

	return mediator

end


return KataViewMediator