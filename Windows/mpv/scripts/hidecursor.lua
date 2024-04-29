function handle_move(prop, m)
	if mp.get_property_bool("fullscreen") then
		local w, h = mp.get_osd_size()
		if m.y < (h * 0.30) then
			mp.set_property("cursor-autohide", "always")
		else
			mp.set_property("cursor-autohide", 1000)
		end
	end
end
mp.observe_property("mouse-pos", "native", handle_move)