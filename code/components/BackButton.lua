BackButton = {}

function BackButton:new()

	local button = display.newGroup()

	function button:init()
		local background = display.newImage("images/button-back.png")
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background
		background.xScale = 2
		background.yScale = 2

		local field = display.newText("Back", 0, 0, native.systemFont, 24)
		field:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(field)
		self.field = field
		field:setTextColor(0, 0, 0)
		field.x = 32
		field.y = 8

		self:addEventListener("touch", self)
	end

	function button:touch(event)
		if event.phase == "ended" then
			self:dispatchEvent({name="onBackButtonPressed"})
			return true
		end
	end

	button:init()

	return button

end


return BackButton