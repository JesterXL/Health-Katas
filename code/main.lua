display.setStatusBar( display.HiddenStatusBar )


local function mainSetup()
	local function setupGlobals()
		--require "utils.GameLoop"
		--_G.gameLoop = GameLoop:new()
		--gameLoop:start()

		_G.mainGroup = display.newGroup()
		mainGroup.classType = "mainGroup"
		_G.stage = display.getCurrentStage()

		--_G._ = require "utils.underscore"
	end

	local function testMainView()
		require "views.MainView"
		local mainView = MainView:new()
	end

	setupGlobals()

	testMainView()
end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, mainSetup)

