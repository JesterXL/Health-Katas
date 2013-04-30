ToolbarView = {}

function ToolbarView:new()

	local view = display.newGroup()
	view.lastSelected = nil

	function view:init()
		local background = display.newImage("images/bg-toolbar.png", 0, 0, true)
		background:setReferencePoint(display.TopLeftReferencePoint)
		self.background = background
		self:insert(background)
		function background:touch(e)
			return true
		end
		function background:tap(e)
			return true
		end
		background:addEventListener("touch", background)
		background:addEventListener("tap", background)

		local buttonDailyKata = self:getButton("images/button-center.png", "images/icon-fork-knife.png", "Daily Kata")
		self.buttonDailyKata = buttonDailyKata
		buttonDailyKata.x = self.width / 2 - buttonDailyKata.width / 2
		buttonDailyKata.y = -20

		local buttonMyProgress = self:getButton(nil, "images/icon-progress.png", "My Progress")
		self.buttonMyProgress = buttonMyProgress

		local buttonMotivations = self:getButton(nil, "images/icon-motivation.png", "Motivations")
		self.buttonMotivations = buttonMotivations
		buttonMotivations.x = buttonMyProgress.x + buttonMyProgress.width
		buttonMotivations.isVisible = false

		local buttonWorldProgress = self:getButton(nil, "images/icon-graph.png", "World Progress")
		self.buttonWorldProgress = buttonWorldProgress
		buttonWorldProgress.x = buttonDailyKata.x + buttonDailyKata.width
		buttonWorldProgress.isVisible = false

		local buttonAbout = self:getButton(nil, "images/icon-jxl.png", "About")
		self.buttonAbout = buttonAbout
		buttonAbout.x = buttonWorldProgress.x + buttonWorldProgress.width

		buttonDailyKata:toFront()

		self:setSelected(buttonDailyKata)
	end

	function view:setSelected(button)
		if self.lastSelected then
			self.lastSelected:setSelected(false)
		end
		self.lastSelected = button
		button:setSelected(true)
	end

	function view:getButton(backgroundImage, iconImage, label)
		local button = display.newGroup()
		self:insert(button)
		function button:touch(e)
			if e.phase == "ended" then
				view:onButtonPressed(self, label)
			end
			return true
		end
		button:addEventListener("touch", button)

		local backgroundRect
		if backgroundImage == nil then
			backgroundRect = display.newRect(0, 0, 130, self.background.height)
			backgroundRect:setFillColor(255, 0, 0, 0)
		else
			backgroundRect = display.newImage(backgroundImage)
		end
		backgroundRect:setReferencePoint(display.TopLeftReferencePoint)
		button:insert(backgroundRect)
		button.backgroundRect = backgroundRect

		local buttonSelected = display.newImage("images/button-toolbar-selected.png")
		buttonSelected:setReferencePoint(display.TopLeftReferencePoint)
		button:insert(buttonSelected)
		button.buttonSelected = buttonSelected
		buttonSelected.width = backgroundRect.width
		buttonSelected.height = backgroundRect.height
		buttonSelected.isVisible = false

		local icon = display.newImage(iconImage)
		icon:setReferencePoint(display.TopLeftReferencePoint)
		button:insert(icon)
		button.icon = icon

		local field = display.newText(label, 0, 0, native.systemFont, 18)
		field:setReferencePoint(display.TopLeftReferencePoint)
		button:insert(field)
		button.field = field

		icon.x = backgroundRect.x + backgroundRect.width / 2 - icon.width / 2
		field.x = backgroundRect.x + backgroundRect.width / 2 - field.width / 2

		icon.y = backgroundRect.x + backgroundRect.height / 2 - ( (icon.height / 2) + (field.height / 2) )
		field.y = icon.y + icon.height + 0

		function button:setSelected(show)
			self.buttonSelected.isVisible = show
		end
		
		return button
	end

	function view:onButtonPressed(button, label)
		self:setSelected(button)
		self:dispatchEvent({name="onToolbarButtonPressed", label=label})
	end


	view:init()


	return view

end


return ToolbarView