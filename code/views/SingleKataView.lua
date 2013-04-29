require "components.AutoSizeText"
require "utils.Layout"
require "components.PushButton"

SingleKataView = {}

function SingleKataView:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.MARGIN		= 16
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight
	view.vo = nil
	view.COLOR_TEXT = {86, 86, 86, 255}
	view.SIZE_TITLE_TEXT = 36
	view.SIZE_TEXT = 28

	view.background = nil
	view.field = nil
	view.titleField = nil
	view.closeButton = nil

	function view:init()
		local MARGIN = view.MARGIN
		local TEXT_WIDTH = self.layoutWidth - (MARGIN * 2)

		local background = display.newRect(self, 0, 0, layoutWidth, layoutHeight)
		self.background = background
		background:setFillColor(255, 255, 255)
		function background:touch(e)
			return true
		end
		function background:tap(e)
			return true
		end
		background:addEventListener("touch", background)
		background:addEventListener("tap", background)

		local field = AutoSizeText:new()
		field:setText("Loading...")
		field:setFontSize(self.SIZE_TEXT)
		field:setAutoSize(true)
		self.field = field
		self:insert(field)
		field:setTextColor(unpack(self.COLOR_TEXT))

		local titleField = AutoSizeText:new()
		titleField:setText(" ")
		titleField:setSize(TEXT_WIDTH, 0)
		titleField:setAutoSize(false)
		titleField:setFontSize(self.SIZE_TITLE_TEXT)
		titleField:setBold(true)
		self.titleField = titleField
		self:insert(titleField)
		titleField:setTextColor(unpack(self.COLOR_TEXT))

		local closeButton = PushButton:new()
		self.closeButton = closeButton
		self:insert(closeButton)
		closeButton:setLabel("Close")
		closeButton:addEventListener("onPushButtonTouched", self)
	end

	function view:setKata(vo)
		self.vo = vo
		self:redraw()
	end

	function view:redraw()
		local field = self.field
		local titleField = self.titleField
		local vo = self.vo
		
		local MARGIN = view.MARGIN
		local MARGIN2 = MARGIN * 2
		field:setSize(self.layoutWidth - MARGIN2, 0)
		field:setText(vo.info)
		titleField:setText(vo.name)

		Layout.centerX(self.layoutWidth, titleField)
		Layout.centerX(self.layoutWidth, field)

		titleField.x = MARGIN
		titleField.y = MARGIN
		field.x = MARGIN
		field.y = titleField.y + titleField.height + MARGIN

		local closeButton = self.closeButton
		closeButton.x = (self.layoutWidth / 2) - (closeButton.width / 2)
		closeButton.y = field.y + field.height + MARGIN
	end

	function view:onPushButtonTouched(event)
		self:dispatchEvent({name="onCloseSingleKataView"})
		return true
	end

	function view:destroy()
		self.closeButton:removeSelf()
		self.closeButton = nil
		self.background:removeSelf()
		self.background = nil
		self.titleField:removeSelf()
		self.titleField = nil
		self.field:removeSelf()
		self.field = nil
		self.vo = nil
		self:removeSelf()
	end

	view:init()

	return view

end


return SingleKataView