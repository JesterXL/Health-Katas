AutoSizeText = {}

function AutoSizeText:new()

	local view = display.newGroup()
	view._text = nil
	view._rgba = {255, 255, 255, 255}
	view._fontSize = 18

	function view:init()
		print("init")
		self:setText("")
	end

	function view:getText()
		return self._text
	end

	function view:setText(str)
		if self._text == str then
			return true
		end

		self._text = str
		if self.field then
			self.field:removeSelf()
			self.field = nil
		end

		local field = display.newText(str, 0, 0, native.systemFont, self._fontSize)
		field:setReferencePoint(display.TopLeftReferencePoint)
		field:setTextColor(unpack(self._rgba))
		self.field = field
		self:insert(field)
	end

	function view:setTextColor(r, g, b, alpha)
		if alpha == nil then
			alpha = 255
		end
		self._rgba = {r, g, b, alpha}
		self.field:setTextColor(r, g, b, alpha)
	end

	function view:setFontSize(size)
		self._fontSize = size
		self.field.size = size
	end


	view:init()

	return view

end

return AutoSizeText