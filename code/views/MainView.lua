require "views.ToolbarView"
require "components.BackButton"

MainView = {}

function MainView:new()

	local view = display.newGroup()

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
	end

	function view:onBackButtonPressed(e)

	end

	function view:onToolbarButtonPressed(e)
		local label = e.label

	end


	view:init()

	return view

end


return MainView