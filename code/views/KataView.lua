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

	function view:init()
		local debugRect = display.newRect(0, 0, self.layoutWidth, self.layoutHeight)
		debugRect:setFillColor(0, 0, 0, 0)
		debugRect:setStrokeColor(255, 0, 0)
		debugRect.strokeWidth = 4

		local field = display.newText("Generic Field.", 0, 0, native.systemFont, 21)
		field:setReferencePoint(display.TopLeftReferencePoint)
		self.field = field
		self:insert(field)

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

		local titleField = display.newText("string", 0, 0, native.systemFont, 28)
		titleField:setReferencePoint(display.TopLeftReferencePoint)
		self.titleField = titleField
		self:insert(titleField)
		titleField.isVisible = false

		local infoField = display.newText("string", 0, 0, native.systemFont, 21)
		infoField:setReferencePoint(display.TopLeftReferencePoint)
		self.infoField = infoField
		self:insert(infoField)
		infoField.isVisible = false

		local motivationLinkField = display.newText("string", 0, 0, native.systemFont, 21)
		motivationLinkField:setReferencePoint(display.TopLeftReferencePoint)
		self.motivationLinkField = motivationLinkField
		self:insert(motivationLinkField)
		motivationLinkField.isVisible = false
		motivationLinkField.text = "I need motivation..."

		local button = PushButton:new()
		self.button = button
		self:insert(button)
		button.isVisible = false

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
		titleField.y = MARGIN
		field.y = titleField.y + titleField.height + MARGIN
		motivationLinkField.y = field.y + field.height + MARGIN
		button.y = motivationLinkField.y + motivationLinkField.height + MARGIN


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

	view:init()

	return view

end

return KataView


