LevelVO = {}

function LevelVO:new(name, description, katas)

	local vo = {}
	vo.name = name
	vo.description = description
	vo.katas = katas

	return vo

end

return LevelVO