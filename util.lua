function NewGuid()
	return love.data.encode("string", "hex", love.data.hash("md5", love.timer.getTime()))
end