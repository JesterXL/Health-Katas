require "components.PushButton"
require "utils.StateMachine"
require "utils.Layout"
require "components.AutoSizeText"

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

	
	view.MARGIN		= 16
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight

	view.fsm = nil
	view.vo = nil
	view.COLOR_TEXT = {86, 86, 86, 255}
	view.SIZE_TITLE_TEXT = 36
	view.SIZE_TEXT = 28

	function view:init()

		local MARGIN = view.MARGIN
		local TEXT_WIDTH = self.layoutWidth - (MARGIN * 2)

		local debugRect = display.newRect(0, 0, self.layoutWidth, self.layoutHeight)
		debugRect:setFillColor(0, 0, 0, 0)
		debugRect:setStrokeColor(255, 0, 0)
		debugRect.strokeWidth = 4
		self:insert(debugRect)
		self.debugRect = debugRect

		--local field = display.newText("Generic Field.", 0, 0, native.systemFont, 21)
		local field = AutoSizeText:new()
		field:setText("Generic Field")
		field:setFontSize(self.SIZE_TEXT)
		--local field = native.newTextBox(0, 0, TEXT_WIDTH, 120)
		-- field.hasBackground = false
		-- field.isEditable = false
		self.field = field
		self:insert(field)
		field:setTextColor(unpack(self.COLOR_TEXT))

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

		local titleField = AutoSizeText:new()
		titleField:setText("string")
		titleField:setSize(TEXT_WIDTH, 0)
		titleField:setAutoSize(false)
		titleField:setFontSize(self.SIZE_TITLE_TEXT)
		titleField:setBold(true)
		self.titleField = titleField
		self:insert(titleField)
		titleField.isVisible = false
		titleField:setTextColor(unpack(self.COLOR_TEXT))

		local infoField = display.newText("string", 0, 0, TEXT_WIDTH, 200, native.systemFont, self.SIZE_TEXT)
		infoField:setReferencePoint(display.TopLeftReferencePoint)
		self.infoField = infoField
		self:insert(infoField)
		infoField.isVisible = false
		infoField:setTextColor(unpack(self.COLOR_TEXT))

		--local motivationLinkField = display.newText("string", 0, 0, TEXT_WIDTH, 21, native.systemFont, self.SIZE_TEXT)
		local motivationLinkField = AutoSizeText:new()
		motivationLinkField:setFontSize(self.SIZE_TEXT)
		self.motivationLinkField = motivationLinkField
		self:insert(motivationLinkField)
		motivationLinkField.isVisible = false
		motivationLinkField:setText("I need motivation...")
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
		local field = self.field
		field.isVisible 		= true
		self.yesButton.isVisible 	= true
		self.noButton.isVisible 	= true

		local MARGIN = view.MARGIN
		local MARGIN2 = MARGIN * 2

		field:setAutoSize(true)
		field:setSize(self.layoutWidth - MARGIN2, 0)
		field:setText(self.vo.question)

		field.y = MARGIN
		Layout.centerX(self.layoutWidth, field)
		Layout.centerX(self.layoutWidth, self.yesButton, self.noButton)
		self.yesButton.y = field.y + field.height + MARGIN2
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
		
		local MARGIN = view.MARGIN
		local MARGIN2 = MARGIN * 2
		field:setSize(self.layoutWidth - MARGIN2, 0)
		field:setAutoSize(true)
		field:setText(vo.info)
		titleField:setText(vo.name)
		button:setLabel("I Did It!")

		Layout.centerX(self.layoutWidth, titleField)
		Layout.centerX(self.layoutWidth, field)
		Layout.centerX(self.layoutWidth, motivationLinkField)
		Layout.centerX(self.layoutWidth, button)

		
		titleField.x = MARGIN
		titleField.y = MARGIN
		field.x = MARGIN
		field.y = titleField.y + titleField.height + MARGIN
		motivationLinkField.y = field.y + field.height + (MARGIN * 2)
		button.y = motivationLinkField.y + motivationLinkField.height + (MARGIN * 2)
	end

	function view:redrawComplete()
		local field = self.field
		local titleField = self.titleField
		local button = self.button
		local vo = self.vo

		field.isVisible 		= true
		titleField.isVisible	= true
		button.isVisible = true
		

		field:setText(vo.success)
		titleField:setText(vo.name)
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

		field:setText(vo.alreadyASuccess)
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
		print("KataView::destroy")

		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed", target=self})

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

		self:removeSelf()
	end

	view:init()

	return view

end

return KataView


