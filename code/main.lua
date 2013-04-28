display.setStatusBar( display.HiddenStatusBar )


local function mainSetup()
	local function setupGlobals()
		require "utils.GameLoop"
		_G.gameLoop = GameLoop:new()
		gameLoop:start()

		_G.mainGroup = display.newGroup()
		mainGroup.classType = "mainGroup"
		_G.stage = display.getCurrentStage()

		--_G._ = require "utils.underscore"
	end

	function showProps(o)
		print("-- showProps --")
		print("o: ", o)
		for key,value in pairs(o) do
			print("key: ", key, ", value: ", value);
		end
		print("-- end showProps --")
	end

	local function testMainView()
		require "views.MainView"
		local mainView = MainView:new()

		--require "components.PushButton"
		--local button = PushButton:new()
		--button.x = 300
		--button.y = 300
	end

	local function testKataView()

		require "views.MainView"
		local mainView = MainView:new()

		require "vo.KataVO"
		local vo = KataVO:new()
		

		require "views.KataView"
		local bounds = mainView:getContentBounds()
		local view = KataView:new(bounds.width, bounds.height)
		view.x = bounds.x
		view.y = bounds.y
		view:setKata(vo)
	end

	local function testLayout()
		require "utils.Layout"
		local rect = display.newRect(0, 0, 60, 60)
		rect:setFillColor(255, 0, 0)
		rect:setReferencePoint(display.TopLeftReferencePoint)

		local box2 = display.newRect(0, 0, 100, 100)
		box2:setFillColor(0, 0, 255)
		box2:setReferencePoint(display.TopLeftReferencePoint)

		-- Layout.centerX(stage.width, rect)
		-- Layout.centerY(stage.height, rect)
		--Layout.center(stage.width, stage.height, rect)

		--Layout.centerX(stage.width, rect, box2)
		-- Layout.centerY(stage.height, rect, box2)
		--Layout.centerAll(stage.width, stage.height, rect, box2)
	end


	local function testEverything()
		require "views.MainView"
		local mainView = MainView:new()

		require "MainContext"
		local context = MainContext:new()
		context:startup()

		local service = ProgressService:new()
		service:delete()
	end

	local function testWhackTextMeasurement()
		local center = function(o)
			o.x = stage.width / 2 - o.width / 2
		end

		local field = display.newText("my test textfield that I want to center", 0, 0, native.systemFont, 21)
		field:setReferencePoint(display.TopLeftReferencePoint)
		print(field.width, field.contentWidth, stage.width)
		center(field)
		field.text = "cow"
		field.x = 0
		field = display.newText("cow", 0, 0, native.systemFont, 21)
		field:setReferencePoint(display.TopLeftReferencePoint)
		print(field.width, field.contentWidth)
		field.x = 0


		local first = display.newText("More text that is quite long, and yet not so much more than a side breaker.", 0, 0, stage.width, 0, native.systemFont, 21)
		print("first:", first.height, first.height)
	end

	local function testMagicTextField()
		require "utils.Layout"
		require "components.AutoSizeText"
		local field = AutoSizeText:new()
		field:setText("Sup")
		field:setTextColor(255, 0, 0)
		field:setFontSize(36)
		Layout.centerX(stage.width, field)
		field:setText("Dude, a much longer block of text, it's just crazy.")
		Layout.centerX(stage.width, field)



	end

	local function testSetter()
		
		local main = {}
		
		local mt = {}
		local p = print
		
		function mt:__index(index, key)
			print(tostring(index), tostring(key))
			return "sup"
		end

		function mt:__newIndex(index, value)
			p("index:", index, ", value:", value)
			rawset(index, 3)
		end

		setmetatable(mt, mt)
		print("ready")
		--main["text"] = "cow"
		--main.text = "cow"
		print("main.text:", mt.text)


	end

	local function testMeta()
		t={1,2,3}  -- basetable
		mt={} -- metatable
		mt.__index=function(t,k)
		    print("__index event from "..tostring(t).." key "..k)
		    return "currently unavailable"
		end
		mt.__newindex=function(t,k,v)
		    print("__newindex event from "..tostring(t).." key: "..k.." value: "..v)
		    if type(k)=="string" then
		        rawset(t,k,v:reverse())
		    else
		        rawset(t,k,v)
		    end
		end
		mt.__call=function(t,...)
		    print("call to table "..tostring(t).." with arguments: ".. ...)
		    print("All elements of the table:")
		    for k,v in pairs(t) do print(k,v) end
		end
		setmetatable(t,mt)

		t[4]="foo" -- this will run the __newindex method
		print(t[5]) -- this will run the __index method
	end



	setupGlobals()

	--testMainView()
	--testKataView()
	--testLayout()

	testEverything()

	--testWhackTextMeasurement()
	--testMagicTextField()
	--testSetter()
	--testMeta()


end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, mainSetup)

