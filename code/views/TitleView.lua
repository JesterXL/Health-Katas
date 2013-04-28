require "utils.Layout"

TitleView = {}

function TitleView:new(layoutWidth, layoutHeight)
	local view = display.newGroup()
	view.COLOR_TEXT = {86, 86, 86, 255}
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight

	function view:init()
		--display.newText("string", x, y, font, size)
		local field = display.newText("Simple eating tips to be a healthier person.", 0, 0, native.systemFont, 28)
		--local field = native.newTextBox(0, 0, TEXT_WIDTH, 120)
		-- field.hasBackground = false
		-- field.isEditable = false
		field:setReferencePoint(display.TopLeftReferencePoint)
		self.field = field
		self:insert(field)
		field:setTextColor(unpack(self.COLOR_TEXT))
		field.align = "center"

		local titleField = display.newText("Health Katas", 0, 0, TEXT_WIDTH, 36, native.systemFontBold, 36)
		titleField:setReferencePoint(display.TopLeftReferencePoint)
		self.titleField = titleField
		self:insert(titleField)
		titleField:setTextColor(unpack(self.COLOR_TEXT))

		local button = PushButton:new()
		button:setLabel("Start")
		self.button = button
		self:insert(button)
		button:addEventListener("onPushButtonTouched", self)

		Layout.centerX(self.layoutWidth, titleField)
		Layout.centerX(self.layoutWidth, field)
		Layout.centerX(self.layoutWidth, button)

		titleField.y = 16
		field.y = titleField.y + titleField.height + 16
		button.y = field.y + field.height + 32		
	end

	function view:onPushButtonTouched(e)
		self:dispatchEvent({name="onTitleViewStartTouched"})
	end

	view:init()

	return view
end

return TitleView