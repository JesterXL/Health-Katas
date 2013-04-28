require "views.SingleKataView"

local widget = require( "widget" )
MyProgressView = {}

function MyProgressView:new(startX, startY, layoutWidth, layoutHeight)
	local view = display.newGroup()
	view.classType = "MyProgressView"
	view.startX = startX
	view.startY = startY
	view.x = startX
	view.y = startY
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight

	view.tableView = tableView
	view.katasHash = nil
	view.levelsHash = nil
	view.singleKataView = nil


	function view:init()
		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	-- Listen for tableView events
	function view:tableViewListener( event )
	    local phase = event.phase

	    print("tableViewListener:", event.phase)
	end

	-- Handle row rendering
	function view:onRowRender( event )
		print("onRowRender")
	    local phase = event.phase
	    local row = event.row
	    local key = tostring(row.index)
	    local kata = self.katasHash[key]
	    local textForRow
	    local completeText
	    if kata then
	    	textForRow = kata.name
	    	if kata.complete then
	    		completeText = "Complete!"
	    	elseif kata.started then
	    		completeText = "Started"
	    	else
	    		completeText = ""
	    	end
	    else
	    	local level = self.levelsHash[key]
	    	if level then
	    		textForRow = level.name
	    	else
	    		print("key:", key)
	    		error("Nothing found for index:", key)
	    	end
	    end

	    local rowTitle = display.newText(row, textForRow, 0, 0, native.systemFont, 18)
	    rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
	    rowTitle.x = rowTitle.x + 16
	    rowTitle.y = row.contentHeight * 0.5
	    rowTitle:setTextColor( 0, 0, 0 )

	    local completeField
	   	if completeText == "" or completeText == nil then
	   		return true
	   	end

	   	completeField = display.newText(row, completeText, 0, 0, native.systemFontBold, 18)
	   	if completeText == "Complete!" then
	   		completeField:setTextColor(0, 255, 0)
	   	else
	   		completeField:setTextColor(255, 120, 0)
	   	end
	   	completeField.x = row.contentWidth - (completeField.contentWidth + 16)
	   	completeField.y = rowTitle.y
	end

	-- Handle row's becoming visible on screen
	function view:onRowUpdate( event )
	    local row = event.row

	    print( "Row:", row.index, " is now visible" )
	end

	-- Handle touches on the row
	function view:onRowTouch( event )
	    local phase = event.phase

	    if phase == "tap" or phase == "release" then
	       	local index = event.target.index
	       	local key = tostring(index)
	   		local kata = self.katasHash[key]
	   		if kata then
	   			self:showSingleKata(kata)
	   		end
	   		return true
	    end
	end

	function view:limitReached(event)
		print("limitReached")
	end

	function view:direction(event)
		print("direction")
	end


	function view:setLevels(levels)

		self.levelsHash = {}
		self.katasHash = {}
		local levelsHash = self.levelsHash
		local katasHash = self.katasHash

		if self.tableView then
			self.tableView:removeSelf()
			self.tableView = nil
		end

		if levels == nil or #levels < 1 then
			return false
		end

		local tableView = widget.newTableView
		{
		    top = 0,
		    width = self.layoutWidth, 
		    height = self.layoutHeight - self.startY,
		    listener = function(e)
		    end,
		    onRowRender = function(e)self:onRowRender(e)end,
		    onRowTouch = function(e)self:onRowTouch(e)end,
		    onRowUpdate = function(e)self:onRowUpdate(e)end
		}
		self:insert(tableView)
		self.tableView = tableView

		

		local isCategory = false
	    local rowHeight = 80
	    local rowColor = { 
					        default = { 255, 255, 255 },
					    }
	    local lineColor = { 220, 220, 220 }

		local l
		local counterIndex = 1
		for l = 1, #levels do
			
			local level = levels[l]
			levelsHash[tostring(counterIndex)] = level
			counterIndex = counterIndex + 1
			tableView:insertRow
			{
				isCategory = true,
				rowHeight = 60,
				rowColor = 
		        { 
		            default = { 150, 160, 180, 200 },
		        },
				lineColor = lineColor
			}

			local katas = level.katas
			local k
			local updatedCounter = false
			for k = 1, #katas do
				local kata = katas[k]
				katasHash[tostring(counterIndex)] = kata
				counterIndex = counterIndex + 1
			    tableView:insertRow
				{
					isCategory = false,
					rowHeight = rowHeight,
					rowColor = rowColor,
					lineColor = lineColor,
					kata = kata
				}
				
			end
		end
	end

	function view:destroySingleKataView()
		if self.singleKataView then
			self.singleKataView:destroy()
			self.singleKataView = nil
		end
	end

	function view:showSingleKata(kata)
		self:destroySingleKataView()

		if kata then
			self.singleKataView = SingleKataView:new(self.layoutWidth, self.layoutHeight)
			self:insert(self.singleKataView)
			self.singleKataView:setKata(kata)
			self.singleKataView:addEventListener("onCloseSingleKataView", self)
		end
	end

	function view:onCloseSingleKataView(event)
		self:destroySingleKataView()
	end


	function view:destroy()

		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed", target=self})

		if self.tableView then
			self.tableView:removeSelf()
			self.tableView = nil
		end

		self:destroySingleKataView()

		self:removeSelf()
	end

	view:init()

	return view
end

return MyProgressView