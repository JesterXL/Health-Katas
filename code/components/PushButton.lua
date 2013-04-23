PushButton = {}

function PushButton:new()

	local button = display.newGroup()

	function button:init()
		local background =  display.newImage("images/button-push.png")
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background

		local field = display.newText("Default", 0, 0, native.systemFont, 21)
		field:setTextColor(255, 255, 255)
		field:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(field)
		self.field = field

		self:setLabel("Default")

		self:addEventListener("touch", self)
	end

	function button:setLabel(text)
		local field = self.field
		local background = self.background
		field.text = text
		field.x = background.x + background.width / 2 - field.width / 2
		field.y = background.y + background.height / 2 - field.height / 2
	end

	function button:touch(event)
		if event.phase == "ended" then
			self:dispatchEvent({name="onPushButtonTouched", target=self})
			return true
		end
	end

	button:init()

	return button

end

return PushButton