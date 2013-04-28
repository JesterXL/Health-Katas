-- key: 	description	, value: 	The longest journeys start with a single step.
-- 2013-04-28 16:51:00.117 Corona Simulator[12670:707] key: 	_id	, value: 	5161f10d0fe8297cf4000004
-- 2013-04-28 16:51:00.117 Corona Simulator[12670:707] key: 	game_id	, value: 	5161effb0fe8291990000003
-- 2013-04-28 16:51:00.118 Corona Simulator[12670:707] key: 	updated_at	, value: 	2013-04-07T22:19:57+00:00
-- 2013-04-28 16:51:00.118 Corona Simulator[12670:707] key: 	name	, value: 	First Step
-- 2013-04-28 16:51:00.118 Corona Simulator[12670:707] key: 	image_url_original	, value: 	https://api.coronalabs.com/images/original/missing.png
-- 2013-04-28 16:51:00.118 Corona Simulator[12670:707] key: 	image_url_small	, value: 	https://api.coronalabs.com/images/small/missing.png
-- 2013-04-28 16:51:00.119 Corona Simulator[12670:707] key: 	points	, value: 	10
-- 2013-04-28 16:51:00.119 Corona Simulator[12670:707] key: 	progress_based	, value: 	false
-- 2013-04-28 16:51:00.119 Corona Simulator[12670:707] key: 	created_at	, value: 	2013-04-07T22:19:57+00:00

AchievementVO = {}

function AchievementVO:new()

	local vo = {}

	vo.description = nil
	vo.id = nil
	vo.gameID = nil
	vo.updatedAt = nil -- date
	vo.name = nil
	vo.imageURLOriginal = nil
	vo.imageURLSmall = nil
	vo.points = nil -- number
	vo.progressBased = false -- boolean
	vo.createdAt = nil -- date

	return vo

end

return AchievementVO