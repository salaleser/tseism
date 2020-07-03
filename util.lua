function NewGuid()
	return love.data.encode("string", "hex", love.data.hash("md5", love.timer.getTime()))
end

function Contains(list, value)
	for _,v in ipairs(list) do
		if v.code == value.code
		and v.category == value.category
		and v.contractor == value.contractor then
			return true
		end
	end

	return false
end