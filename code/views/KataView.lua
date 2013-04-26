require "components.PushButton"
require "utils.StateMachine"

KataView = {}

function KataView:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
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
	end

	function view:setKata(vo)
		self.vo = vo
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

		local state = self.fsm.state
		if state == "question" then
			self:redrawQuestion()
		elseif state == "main" then
			self:redrawMain()
		elseif state == "already" then
			self:redrawAlready()
		elseif state == "motivation" then
			self:redrawMotivation()
		elseif state == "complete" then
			self:redrawComplete()
		end

	end

	function view:redrawQuestion()
		self.field.isVisible 		= true
		self.yesButton.isVisible 	= true
		self.noButton.isVisible 	= true

		self.field.text 			= self.vo.question
		self:center(self.field)
		self:centerX(self.yesButton, self.noButton)
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

		self:centerX(titleField)
		self:centerX(field)
		self:centerX(motivationLinkField)
		self:centerX(button)

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

		self:centerX(titleField)
		self:centerX(field)
		self:centerX(button)

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
		
		self:centerX(button)

		local MARGIN = 16
		field.x = MARGIN
		field.y = MARGIN
		button.y = field.y + field.height + MARGIN
	end

	function view:center(obj)
		obj.x = layoutWidth / 2 - obj.width / 2
		obj.y = layoutHeight / 2 - obj.height / 2
	end

	function view:centerX(...)
		if #arg == 1 then
			arg[1].x = self.layoutWidth / 2 - arg[1].width / 2
		else
			local w = self.layoutWidth
			local inc = w / (#arg + 1)
			for i,v in ipairs(arg) do
				w = w - v.width
				local obj = arg[i]
				obj.x = inc - (obj.width / 2)
				inc = inc + inc
			end
		end
	end

	function view:centerY(...)
		if #arg == 1 then
			arg[1].y = self.layoutHeight / 2 - arg[1].height / 2
		else
			local h = self.layoutHeight
			local inc = h / (#arg + 1)

			for i,v in ipairs(arg) do
				local obj = arg[i]
				obj.y = inc - (obj.height / 2)
				inc = inc + inc
			end
		end
	end

	function view:centerAll(...)
		self:centerX(arg)
		self:centerY(arg)
	end

	function view:onYesButtonTouched()
		self.fsm:changeState("main")
	end

	function view:onNoButtonTouched()
		self.fsm:changeState("already")
	end

	function view:onPushButtonTouched()
		local state = self.fsm.state
		if state == "main" then
			self.fsm:changeState("complete")
		elseif state == "complete" or state == "already" then
			self:dispatchEvent({name="onKataCompleteConfirmed"})
		end
	end

	view:init()

	return view

end

return KataView


