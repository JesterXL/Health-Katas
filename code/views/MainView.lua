require "views.ToolbarView"
require "components.BackButton"
require "views.KataView"
require "utils.StateMachine"
require "views.TitleView"
require "views.MyProgressView"

MainView = {}

function MainView:new()

	local view = display.newGroup()
	view.kataView = nil
	view.titleView = nil
	view.myProgressView = nil

	view.fsm = nil

	function view:init()

		local background = display.newImage("images/bg-background.png", 0, 0, true)
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background

		local toolbar = ToolbarView:new()
		self:insert(toolbar)
		self.toolbar = toolbar
		toolbar:addEventListener("onToolbarButtonPressed", self)

		local header = display.newImage("images/bg-top-header.png", 0, 0, true)
		header:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(header)
		self.header = header

		local logo = display.newImage("images/icon-logo.png")
		logo:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(logo)
		self.logo = logo

		local backButton = BackButton:new()
		self:insert(backButton)
		self.backButton = backButton

		local buttonInfo = display.newImage("images/button-info.png")
		buttonInfo:setReferencePoint(display.TopLeftReferencePoint)
		function buttonInfo:touch(e)
			if e.phase == "ended" then
				view:dispatchEvent({name="onInfoButtonPressed"})
				return true
			end
		end
		buttonInfo:addEventListener("touch", buttonInfo)
		self:insert(buttonInfo)
		self.buttonInfo = buttonInfo

		logo.x = 20
		logo.y = 20
		toolbar.y = stage.height - toolbar.height + 20
		backButton.y = header.y + header.height / 2 - backButton.height / 2
		backButton.x = 8
		backButton:addEventListener("onBackButtonPressed", self)
		backButton.isVisible = false
		buttonInfo.x = self.width - buttonInfo.width * 4
		buttonInfo.y = header.y + header.height / 2 - buttonInfo.height / 2

		local bounds = self:getContentBounds()
		local debugRect = display.newRect(bounds.x, bounds.y, bounds.width, bounds.height)
		debugRect:setFillColor(0, 0, 0, 0)
		debugRect:setStrokeColor(255, 0, 0)
		debugRect.strokeWidth = 4
		self:insert(debugRect)
		self.debugRect = debugRect

		local fsm = StateMachine:new()
		fsm:addState("title", {from="*"})
		fsm:addState("kata", {from="*"})
		fsm:addState("progress", {from="*"})
		fsm:addState("motivations", {from="*"})
		fsm:addState("worldProgress", {from="*"})
		fsm:addState("about", {from="*"})
		fsm:setInitialState("title")
		fsm:addEventListener("onStateMachineStateChanged", self)
		self.fsm = fsm

		self:redraw()

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:onStateMachineStateChanged(event)
		self:redraw()
	end

	function view:redraw()
		if self.kataView then
			self.kataView:destroy()
			self.kataView = nil
		end

		if self.titleView then
			self.titleView.isVisible = false
		end

		if self.myProgressView then
			self.myProgressView:destroy()
			self.myProgressView = nil
		end

		local state = self.fsm.state
		if state == "title" then
			self:redrawTitle()
		elseif state == "kata" then
			self:redrawKata()
		elseif state == "progress" then
			self:redrawProgress()
		elseif state == "motivations" then
			self:redrawMotivations()
		elseif state == "worldProgress" then
			self:redrawWorldProgress()
		elseif state == "about" then
			self:redrawAbout()
		end
	end

	function view:getContentBounds()
		local bounds = {}
		bounds.x = self.header.x
		bounds.y = self.header.y + self.header.height
		bounds.width = self.header.width
		bounds.height = self.toolbar.y - bounds.y
		return bounds
	end

	function view:redrawTitle()
		if self.titleView == nil then
			local bounds = self:getContentBounds()
			self.titleView = TitleView:new(bounds.width, bounds.height)
			self:insert(self.titleView)
			self.titleView:addEventListener("onTitleViewStartTouched", self)
		end
		
		self.titleView.y = self.header.y + self.header.height
	end

	function view:redrawKata()
		if self.kataView == nil then
			local bounds = self:getContentBounds()
			self.kataView = KataView:new(bounds.width, bounds.height)
			self:insert(self.kataView)
		end

		self.kataView.y = self.header.y + self.header.height
	end

	function view:redrawProgress()
		if self.myProgressView == nil then
			local bounds = self:getContentBounds()
			self.myProgressView = MyProgressView:new(bounds.x, bounds.y, bounds.width, bounds.height)
			self:insert(self.myProgressView)
			self.myProgressView:toBack()
			self.background:toBack()
		end
	end

	function view:onBackButtonPressed(e)

	end

	function view:onToolbarButtonPressed(e)
		local label = e.label
		local fsm = self.fsm
		if label == "My Progress" then
			fsm:changeState("progress")
		elseif label == "Daily Kata" then
			fsm:changeState("kata")
		end

	end

	function view:onTitleViewStartTouched(e)
		self.fsm:changeState("kata")
	end


	view:init()

	return view

end


return MainView