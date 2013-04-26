require "components.PushButton"
require "utils.StateMachine"
require "utils.Layout"

KataView = {}

function KataView:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.classType = "KataView"

	view.field = nil
	view.yesButton = nil
	view.noButton = nil
	view.titleField = nil
	view.button = nil
	view.motivationLinkField = nil

	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight

	view.fsm = nil
	view.vo = nil
	view.COLOR_TEXT = {86, 86, 86, 255}

	function view:init()

		local MARGIN = 16
		local TEXT_WIDTH = self.layoutWidth - (MARGIN * 2)

		local debugRect = display.newRect(0, 0, self.layoutWidth, self.layoutHeight)
		debugRect:setFillColor(0, 0, 0, 0)
		debugRect:setStrokeColor(255, 0, 0)
		debugRect.strokeWidth = 4
		self:insert(debugRect)
		self.debugRect = debugRect

		local field = display.newText("Generic Field.", 0, 0, native.systemFont, 21)
		--local field = native.newTextBox(0, 0, TEXT_WIDTH, 120)
		-- field.hasBackground = false
		-- field.isEditable = false
		field:setReferencePoint(display.TopLeftReferencePoint)
		self.field = field
		self:insert(field)
		field:setTextColor(unpack(self.COLOR_TEXT))
		field.align = "center"

		local yesButton = display.newImage("images/button-yes.png")
		yesButton.classType = "YesButton"
		yesButton:setReferencePoint(display.TopLeftReferencePoint)
		self.yesButton = yesButton
		self:insert(yesButton)
		function yesButton:touch(e)
			if e.phase == "ended" then
				view:onYesButtonTouched()
				return true
			end
		end
		yesButton:addEventListener("touch", yesButton)

		local noButton = display.newImage("images/button-no.png")
		noButton.classType = "NoButton"
		noButton:setReferencePoint(display.TopLeftReferencePoint)
		self.noButton = noButton
		self:insert(noButton)
		function noButton:touch(e)
			if e.phase == "ended" then
				view:onNoButtonTouched()
				return true
			end
		end
		noButton:addEventListener("touch", noButton)

		local titleField = display.newText("string", 0, 0, TEXT_WIDTH, 28, native.systemFont, 28)
		titleField:setReferencePoint(display.TopLeftReferencePoint)
		self.titleField = titleField
		self:insert(titleField)
		titleField.isVisible = false
		titleField:setTextColor(unpack(self.COLOR_TEXT))

		local infoField = display.newText("string", 0, 0, TEXT_WIDTH, 200, native.systemFont, 21)
		infoField:setReferencePoint(display.TopLeftReferencePoint)
		self.infoField = infoField
		self:insert(infoField)
		infoField.isVisible = false
		infoField:setTextColor(unpack(self.COLOR_TEXT))

		local motivationLinkField = display.newText("string", 0, 0, TEXT_WIDTH, 21, native.systemFont, 21)
		motivationLinkField:setReferencePoint(display.TopLeftReferencePoint)
		self.motivationLinkField = motivationLinkField
		self:insert(motivationLinkField)
		motivationLinkField.isVisible = false
		motivationLinkField.text = "I need motivation..."
		motivationLinkField:setTextColor(0, 0, 255)
		function motivationLinkField:touch(e)
			if e.phase == "ended" then
				view:onShowMotivation()
				return true
			end
		end
		motivationLinkField:addEventListener("touch", motivationLinkField)

		local button = PushButton:new()
		self.button = button
		self:insert(button)
		button.isVisible = false
		button:addEventListener("onPushButtonTouched", self)

		local fsm = StateMachine:new()
		fsm:addState("question", {from="*"})
		fsm:addState("main", {from="*"})
		fsm:addState("already", {from="*"})
		fsm:addState("motivation", {from="*"})
		fsm:addState("complete", {from="*"})
		fsm:setInitialState("question")
		fsm:addEventListener("onStateMachineStateChanged", self)
		self.fsm = fsm

		self:redraw()

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:setKata(vo)
		local fsm = self.fsm
		self.vo = vo
		if self.vo then
			if self.vo.complete == true and fsm.state ~= "complete" then
				fsm:changeStateToAtNextTick("complete")
				return true
			elseif self.vo.started == true and fsm.state ~= "main" then
				fsm:changeStateToAtNextTick("main")
				return true
			elseif fsm.state ~= "question" then
				fsm:changeStateToAtNextTick("question")
				return true
			end
		end

		self:redraw()
	end

	function view:onStateMachineStateChanged(event)
		--print("KataView::onStateMachineStateChanged")
		self:redraw()
	end

	function view:redraw()
		--print("KataView::redraw")

		self.field.isVisible = false
		self.yesButton.isVisible = false
		self.noButton.isVisible = false
		self.titleField.isVisible = false
		self.infoField.isVisible = false
		self.motivationLinkField.isVisible = false
		self.button.isVisible = false

		if self.vo == nil then
			return false
		end

		local state = self.fsm.state
		if state == "question" then
			self:redrawQuestion()
		elseif state == "main" then
			self:redrawMain()
		elseif state == "already" then
			self:redrawAlready()
		elseif state == "motivation" then
			--self:redrawMotivation()
		elseif state == "complete" then
			self:redrawComplete()
		end

	end

	function view:redrawQuestion()
		self.field.isVisible 		= true
		self.yesButton.isVisible 	= true
		self.noButton.isVisible 	= true

		self.field.text 			= self.vo.question
		Layout.center(self.layoutWidth, self.layoutHeight, self.field)
		Layout.centerX(self.layoutWidth, self.yesButton, self.noButton)
		self.yesButton.y = self.field.y + self.field.height + 16
		self.noButton.y = self.yesButton.y
	end

	function view:redrawMain()
		local field = self.field
		local titleField = self.titleField
		local motivationLinkField = self.motivationLinkField
		local button = self.button
		local vo = self.vo

		field.isVisible 		= true
		titleField.isVisible	= true
		motivationLinkField.isVisible = true
		button.isVisible = true
		

		field.text = vo.info
		titleField.text = vo.name
		button:setLabel("I Did It!")

		Layout.centerX(self.layoutWidth, titleField)
		Layout.centerX(self.layoutWidth, field)
		Layout.centerX(self.layoutWidth, motivationLinkField)
		Layout.centerX(self.layoutWidth, button)

		local MARGIN = 16
		titleField.x = MARGIN
		titleField.y = MARGIN
		field.x = MARGIN
		field.y = titleField.y + titleField.height + MARGIN
		motivationLinkField.y = field.y + field.height + MARGIN
		button.y = motivationLinkField.y + motivationLinkField.height + MARGIN
	end

	function view:redrawComplete()
		local field = self.field
		local titleField = self.titleField
		local button = self.button
		local vo = self.vo

		field.isVisible 		= true
		titleField.isVisible	= true
		button.isVisible = true
		

		field.text = vo.success
		titleField.text = vo.name
		button:setLabel("Next Kata")

		Layout.centerX(self.layoutWidth, titleField)
		Layout.centerX(self.layoutWidth, field)
		Layout.centerX(self.layoutWidth, button)

		local MARGIN = 16
		titleField.x = MARGIN
		titleField.y = MARGIN
		field.x = MARGIN
		field.y = titleField.y + titleField.height + MARGIN
		button.y = field.y + field.height + MARGIN
	end

	function view:redrawAlready()
		local field = self.field
		local button = self.button
		local vo = self.vo

		field.isVisible 		= true
		button.isVisible = true

		field.text = vo.alreadyASuccess
		button:setLabel("Next Kata")
		
		Layout.centerX(self.layoutWidth, button)

		local MARGIN = 16
		field.x = MARGIN
		field.y = MARGIN
		button.y = field.y + field.height + MARGIN
	end

	function view:onYesButtonTouched()
		self.fsm:changeState("main")
		self:dispatchEvent({name="onStartedKata"})
	end

	function view:onNoButtonTouched()
		self.fsm:changeState("already")
		self:dispatchEvent({name="onAlreadySuccessful"})
	end

	function view:onPushButtonTouched()
		local state = self.fsm.state
		if state == "main" then
			self.fsm:changeState("complete")
			self:dispatchEvent({name="onKataComplete"})
		elseif state == "complete" or state == "already" then
			self:dispatchEvent({name="onKataCompleteConfirmed"})
		end
	end

	function view:onShowMotivation()
		--self.fsm:changeState("motivation")
		media.playVideo("videos/test.mp4", true, self)
		--native.newVideo(self.x, self.y, self.layoutWidth, self.layoutHeight)
	end

	function view:completion(e)

	end

	function view:destroy()
		
		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed"})

		self.yesButton:removeEventListener("touch", self.yesButton)
		self.noButton:removeEventListener("touch", self.noButton)
		self.motivationLinkField:removeEventListener("touch", self.motivationLinkField)

		self.button:removeEventListener("onPushButtonTouched", self)

		self.field:removeSelf()
		self.yesButton:removeSelf()
		self.noButton:removeSelf()
		self.titleField:removeSelf()
		self.button:removeSelf()
		self.motivationLinkField:removeSelf()

		self.fsm:removeEventListener("onStateMachineStateChanged", self)
		self.fsm = nil
		self.vo = nil
	end

	view:init()

	return view

end

return KataView


