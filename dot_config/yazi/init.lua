function Linemode:size_and_btime()
	local time = math.floor(self._file.cha.btime or 0)
	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", os.date("%b %d %H:%M", time))
end
