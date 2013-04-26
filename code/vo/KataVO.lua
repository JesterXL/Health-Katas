KataVO = {}

function KataVO:new()

	local vo = {}
	vo.name = "Default Name"
	vo.question = "Default question?"
	vo.info = "Default info."
	vo.success = "Default success."
	vo.alreadyASuccess = "Default already a success."
	vo.complete = false

	return vo

end

return KataVO