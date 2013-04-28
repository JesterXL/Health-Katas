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
		if o == nil then
			return false
		end
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
		require "services.ProgressService"
		local service = ProgressService:new()
		service:delete()

		require "views.MainView"
		local mainView = MainView:new()

		require "MainContext"
		local context = MainContext:new()
		context:startup()

		
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

	local function testGameCenter()
		-- local gameNetwork = require "gameNetwork"
		-- local params =
		-- {
		--     accessKey = "f57d2de3972eeb7dc2aef35ce5a33b8156072a97",
		--     secretKey = "3b794f330fa434466d07b4209a9d8be9aea6ec20",
		-- }
		-- gameNetwork.init( "corona", params )
		-- gameNetwork.show( "leaderboards" )

		local cloud = require( "cloud" )
		local json = require ( "json" )

		-- forward declarations
		local chatRoom
		local friends
		local news
		local multiplayer

		-- also a forward declaration, will be assigned to the cloud.match object in the multiplayer listener
		local match

		-- the authentication listener
		local authListener = function( event )
			-- all events contain event.name, event.type, event.error, event.response.
			if event.type == "loggedIn" then
				--print( "User is logged in: ", cloud.isLoggedIn )
				-- get the user profile
				cloud.getProfile()
				-- get the chatrooms
				chatRoom.getAll()
				-- get all friends
				friends.getAll()
				-- get all news
				news.getAll()
				-- get the matches
				multiplayer.getAllMatches()
				--multiplayer.newMatch()
				multiplayer.findMatch( "SOME_MATCH_ID" )
			end
			
			if event.type == "getProfile" then
				--print( "The user profile: ", event.response )
			end

		end

		-- the leaderboards listener
		local leaderboardsListener = function( event )
			local leaderboards = json.decode( event.response )
			--print( "Leaderboard 1: ", leaderboards[ 1 ]._id )
			print("leaderboards")
			showProps(leaderboards[1])
		end

		-- the achievements listener
		local achievementsListener = function( event )
			local achievements = json.decode( event.response )
			--print( "Achievement 1: ", achievements[ 1 ]._id )
			print("achievementsListener")
			showProps(achievements[1])
		end

		-- the analytics listener
		local analyticsListener = function( event )
			local analytics = json.decode( event.response )
			--print ( event.response )
		end

		-- the chat room listener
		local chatRoomListener = function( event )
			local chatRoom = json.decode( event.response )
			--print( "Chatrooms: ", event.response )
		end

		-- the friends listener
		local friendsListener = function( event )
			local friends = json.decode( event.response )
			--print( "Friends: ", event.response )
		end

		local newsListener = function( event )
			local news = json.decode( event.response )
			--print( "Unread News: ", event.response )
		end

		local multiplayerListener = function( event )
			if event.type == "getAllMatches" then
				local gamesTable = json.decode( event.response )
				for i = 1, #gamesTable do
					--print ( gamesTable[ i ]._id )
				end
			end
			if event.type == "newMatch" then
				-- the match table is now available
				match = cloud.match
				--print( match.data._id )
			end
			if event.type == "findMatch" then
				-- the match table is now available
				match = cloud.match
				--print( match.data._id )
				--match:resign()
			end
		end


		-- set the debugEnabled variable
		cloud.debugEnabled = false

		-- init the main cloud object
		cloud.init( "f57d2de3972eeb7dc2aef35ce5a33b8156072a97", "3b794f330fa434466d07b4209a9d8be9aea6ec20", authListener )

		-- prepare the parameters for the login method
		local loginParams = {}
		loginParams.type = "user"
		loginParams.email = "anscamobile@jessewarden.com"
		loginParams.password = "mako00769"

		-- login to the cloud
		cloud.login( loginParams )

		-- localize the leaderboards object of the cloud
		local leaderboards = cloud.leaderboards

		-- set the leaderboards listener
		leaderboards.setListener( leaderboardsListener )

		-- get the leaderboards
		leaderboards.getAll()

		leaderboards.submitHighScore("5161f0920fe8297cf4000001", 10)

		-- localize the achievements object of the cloud
		local achievements = cloud.achievements

		-- set the achievements listener
		achievements.setListener( achievementsListener )

		-- get the achievements
		achievements.getAll()

		-- localize the analytics object of the cloud
		local analytics = cloud.analytics

		-- set the analytics listener
		analytics.setListener( analyticsListener )

		-- submit analytics event
		local aParams = {}
		aParams.event_type = "Session"
		aParams.message = "The user logged In"
		aParams.name = "logIn"

		-- send the event
		analytics.submitEvent( aParams )

		-- localize the chatRoom object of the cloud
		chatRoom = cloud.chatRoom

		-- set the chatRoom listener
		chatRoom.setListener( chatRoomListener )

		-- localize the friends object of the cloud
		friends = cloud.friends

		-- set the friends listener
		friends.setListener( friendsListener )

		-- localize the news object of the cloud
		news = cloud.news

		-- set the news listener
		news.setListener( newsListener )

		-- localize the multiplayer object
		multiplayer = cloud.multiplayer

		-- set the listener
		multiplayer.setListener( multiplayerListener )





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

	--testGameCenter()


end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, mainSetup)

