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

	local function testMainView()
		require "views.MainView"
		local mainView = MainView:new()

		--require "components.PushButton"
		--local button = PushButton:new()
		--button.x = 300
		--button.y = 300
	end

	local function testKataView()
		require "vo.KataVO"
		local vo = KataVO:new()
		

		require "views.KataView"
		local view = KataView:new(stage.width, 300)
		view:setKata(vo)
	end


	setupGlobals()

	--testMainView()
	testKataView()
end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, mainSetup)

