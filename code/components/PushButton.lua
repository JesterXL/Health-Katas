require "components.AutoSizeText"
PushButton = {}

function PushButton:new()

	local button = display.newGroup()

	function button:init()
		local background =  display.newImage("images/button-push.png")
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background

		local field = AutoSizeText:new()
		field:setTextColor(255, 255, 255)
		field:setFontSize(28)
		self:insert(field)
		self.field = field

		self:addEventListener("touch", self)
	end

	function button:setLabel(text)
		local field = self.field
		local background = self.background
		field:setText(text)
		field.x = background.x + background.width / 2 - field.width / 2
		field.y = background.y + background.height / 2 - field.height / 2
		field.y = field.y - 4
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