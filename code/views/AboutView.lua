require "components.AutoSizeText"
require "services.LoadTextService"
local widget = require "widget"

AboutView = {}

function AboutView:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.BASE_PATH 				= "images/about/"
	view.URL_COMPANY			= "http://webappsolution.com"
	view.URL_BLOG 				= "http://jessewarden.com"
	view.URL_GOOGLEPLUS			= "https://plus.google.com/109537902154361720350"
	view.URL_TWITTER_WASI		= "http://twitter.com/webappsolution"
	view.URL_TWITTER 			= "http://twitter.com/jesterxl"
	view.layoutWidth 			= layoutWidth
	view.layoutHeight			= layoutHeight
	view.COLOR_TEXT 			= {86, 86, 86, 255}

	view.scrollView 			= nil
	view.whatTitleField			= nil
	view.whatField= nil
	view.whyTitleField = nil
	view.whyField = nil
	view.whoTitleField = nil
	view.buttonCompany = nil
	view.buttonBlog = nil
	view.buttonGooglePlus = nil
	view.buttonTwitterWASI = nil
	view.buttonTwitter = nil

	view.sizeRect = nil
	
	

	function view:init()

		local MARGIN			= 32
		local startY 			= MARGIN
		local SIZE_TEXT_TITLE 		= 31
		local SIZE_TEXT 			= 21
		local textWidth 		= layoutWidth - (MARGIN * 2)

		local scrollView = widget.newScrollView
		{
		    top = 0,
		    left = 0,
		    width = self.layoutWidth,
		    height = self.layoutHeight - self.y,
		    scrollWidth = self.layoutWidth,
		    scrollHeight = self.layoutHeight,
		    maskFile = "/images/about/about-scroll-mask.png"
		}
		self.scrollView = scrollView
		self:insert(scrollView)

		self.whatTitleField 		= self:getField("What", MARGIN, startY, textWidth, 0, SIZE_TEXT_TITLE, true)
		startY = self.whatTitleField.y + self.whatTitleField.height + (MARGIN / 2)
		self.whatField 			= self:getField({path = "assets/text/about-what.txt"}, MARGIN, startY, textWidth, 0, SIZE_TEXT)	

		startY = self.whatField.y + self.whatField.height + MARGIN
		self.whyTitleField 		= self:getField("Why", MARGIN, startY, textWidth, 0, SIZE_TEXT_TITLE, true)

		startY = self.whyTitleField.y + self.whyTitleField.height + (MARGIN / 2)
		self.whyField 			= self:getField({path="assets/text/about-why.txt"}, MARGIN, startY, textWidth, 0, SIZE_TEXT)
		
		startY = self.whyField.y + self.whyField.height + MARGIN

		self.whoTitleField 		= self:getField("Who", MARGIN, startY, textWidth, 0, SIZE_TEXT_TITLE, true)
		startY = self.whoTitleField.y + self.whoTitleField.height + (MARGIN / 2)

		local tweenDelay				= 700
		local tweenIncrement 			= 100
		

		self.buttonCompany 		= self:getImageButton(self.BASE_PATH .. "about-companyblog.png", "company", MARGIN, startY, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement
		startY					= startY + 86

		self.buttonBlog 		= self:getImageButton(self.BASE_PATH .. "about-blog.png", "blog", MARGIN, startY, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement
		startY					= startY + 86

		self.buttonGooglePlus 	= self:getImageButton(self.BASE_PATH .. "about-googleplus.png", "googleplus", MARGIN, startY, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement
		startY					= startY + 86

		self.buttonTwitterWASI 	= self:getImageButton(self.BASE_PATH .. "about-twitterwebapp.png", "twitterwasi", MARGIN, startY, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement
		startY					= startY + 86

		self.buttonTwitter 		= self:getImageButton(self.BASE_PATH .. "about-twitterjesterxl.png", "twitter", MARGIN, startY, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement
		startY					= startY + 86

		local sizeRect 			= display.newRect(0, 0, self.layoutWidth, 60)
		sizeRect:setReferencePoint(display.TopLeftReferencePoint)
		sizeRect:setFillColor(255, 0, 0, 0)
		sizeRect.y = startY
		self.scrollView:insert(sizeRect)
		self.sizeRect = sizeRect
		
	end

	function view:getField(text, x, y, width, height, fontSize, isBold)
		if isBold == nil then
			isBold = false
		end

		local platform = system.getInfo("platformName")

		local initialText
		if type(text) == "string" then
			initialText = text
		else
			initialText = LoadTextService:new():loadTextFile(text.path)
		end

		field = AutoSizeText:new()
		field:setFontSize(fontSize)
		field:setText(initialText)
		field:setBold(isBold)
		field:setTextColor(unpack(view.COLOR_TEXT))
		field:setSize(width, height)
		field:setAutoSize(true)
		self.scrollView:insert(field)
		field.x = x
		field.y = y
		return field
	end

	function view:getImageButton(imageURL, name, targetX, targetY, tweenDelay)
		local image = display.newImage(imageURL, true)
		image:setReferencePoint(display.TopLeftReferencePoint)
		self.scrollView:insert(image)
		function image:touch(event)
			if event.phase == "began" then
				view:onImageButtonTouched(self)
				return true
			end
		end
		image:addEventListener("touch", image)
		image.name = name
		image.x = targetX
		--image.alpha = 0
		--image.y = targetY - 40
		--image.tween = transition.to(image, {time=300, delay=tweenDelay, alpha=1, y=targetY, transition=easing.outExpo})
		image.y = targetY
		return image
	end

	function view:onImageButtonTouched(button)
		if button.name == "blog" then
			system.openURL(self.URL_BLOG)
			return true
		elseif button.name == "company" then
			system.openURL(self.URL_COMPANY)
			return true
		elseif button.name == "twitter" then
			system.openURL(self.URL_TWITTER)
			return true
		elseif button.name == "twitterwasi" then
			system.openURL(self.URL_TWITTER_WASI)
			return true
		elseif button.name == "googleplus" then
			system.openURL(self.URL_GOOGLEPLUS)
			return true
		end
	end

	function view:removeIt(name)
		local obj = self[name]
		if obj == nil then
			error("Cannot find object for name:" .. name)
		end
		self.scrollView:remove(obj)
		obj:removeSelf()
		self[name] = nil
	end

	function view:destroy()
		self:removeIt("sizeRect")
		self:removeIt("buttonTwitter")
		self:removeIt("buttonTwitterWASI")
		self:removeIt("buttonGooglePlus")
		self:removeIt("buttonBlog")
		self:removeIt("buttonCompany")
		self:removeIt("whoTitleField")
		self:removeIt("whyField")
		self:removeIt("whyTitleField")
		self:removeIt("whatField")
		self:removeIt("whatTitleField")
		self.scrollView:removeSelf()
		self.scrollView = nil
	end

	view:init()

	return view
end

return AboutView