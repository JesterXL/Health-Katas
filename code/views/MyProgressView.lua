local widget = require( "widget" )
MyProgressView = {}

function MyProgressView:new(startX, startY, layoutWidth, layoutHeight)
	local view = display.newGroup()
	view.startX = startX
	view.startY = startY
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight

	view.tableView = tableView


	function view:init()
		-- Create a tableView
		local tableView = widget.newTableView
		{
		    top = startY,
		    width = view.layoutWidth, 
		    height = view.layoutHeight - startY,
		    listener = view,
		    onRowRender = view,
		    onRowTouch = view,
		    onRowUpdate = view
		}
		self:insert(tableView)
		self.tableView = tableView

		-- Create 100 rows
		local i
		for i = 1, 100 do
		    local isCategory = false
		    local rowHeight = 40
		    local rowColor = 
		    { 
		        default = { 255, 255, 255 },
		    }
		    local lineColor = { 220, 220, 220 }

		    -- Make some rows categories
		    if i == 25 or i == 50 or i == 75 then
		        isCategory = true
		        rowHeight = 24
		        rowColor = 
		        { 
		            default = { 150, 160, 180, 200 },
		        }
		    end

		    -- Insert the row into the tableView
		    tableView:insertRow
		    {
		        isCategory = isCategory,
		        rowHeight = rowHeight,
		        rowColor = rowColor,
		        lineColor = lineColor,
		    }
		end 
	end

	-- Listen for tableView events
	function view:tableViewListener( event )
	    local phase = event.phase

	    print("tableViewListener:", event.phase)
	end

	-- Handle row rendering
	function view:onRowRender( event )
	    local phase = event.phase
	    local row = event.row

	    local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
	    rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
	    rowTitle.y = row.contentHeight * 0.5
	    rowTitle:setTextColor( 0, 0, 0 )
	end

	-- Handle row's becoming visible on screen
	function view:onRowUpdate( event )
	    local row = event.row

	    print( "Row:", row.index, " is now visible" )
	end

	-- Handle touches on the row
	function view:onRowTouch( event )
	    local phase = event.phase

	    if "press" == phase then
	        print( "Touched row:", event.target.index )
	    end
	end

	function view:destroy()
		self.tableView:removeSelf()
		self.tableView = nil

		self:removeSelf()
	end

	view:init()

	return view
end

return MyProgressView