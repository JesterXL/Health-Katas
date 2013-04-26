Layout = {}

Layout.center = function(width, height, obj)
	obj.x = width / 2 - obj.width / 2
	obj.y = height / 2 - obj.height / 2
end

Layout.centerX = function(width, ...)
	if #arg == 1 then
		arg[1].x = width / 2 - arg[1].width / 2
	else
		local w = width
		local inc = w / (#arg + 1)
		for i,v in ipairs(arg) do
			w = w - v.width
			local obj = arg[i]
			obj.x = inc - (obj.width / 2)
			inc = inc + inc
		end
	end
end

Layout.centerY = function(height, ...)
	if #arg == 1 then
		arg[1].y = height / 2 - arg[1].height / 2
	else
		local h = height
		local inc = h / (#arg + 1)

		for i,v in ipairs(arg) do
			local obj = arg[i]
			obj.y = inc - (obj.height / 2)
			inc = inc + inc
		end
	end
end

Layout.centerAll = function(width, height, ...)
	Layout.centerX(width, unpack(arg))
	Layout.centerY(height, unpack(arg))
end

return Layout