KataVO = {}

function KataVO:new(name, question, info, success, alreadyASuccess)

	local vo = {}
	vo.name = name
	vo.question = question
	vo.info = info
	vo.success = success
	vo.alreadyASuccess = alreadyASuccess
	vo.complete = false

	return vo

end

return KataVO