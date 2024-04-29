mp.observe_property("chapter", "native", function(_, n)
	local title = mp.get_property_native("chapter-list/"..tostring(n).."/title")
	if title == nil or string.find(title, "://") ~= nil then return end
	mp.commandv("show-text", string.format("Chapter: (%d) %s", n+1, title))
end)