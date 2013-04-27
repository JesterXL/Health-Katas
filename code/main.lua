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
	end


	setupGlobals()

	--testMainView()
	--testKataView()
	--testLayout()

	testEverything()

end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, mainSetup)

