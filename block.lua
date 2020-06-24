function block_load(xx, yy, spp)

	table.insert(blocks, {
		id = #blocks + 1000000,
		x = xx,
		y = yy,
		w = 64,
		h = 64,
		color = {r = 1, g = 1, b = 1},
		sprite = spp or spr_blocks,
		visible = true
	})

end

function block_draw()
	-- Execute only if have instances
	if next(blocks) == nil then return nil end

	for i, v in ipairs(blocks) do
		if v.sprite ~= nil and v.visible then

			love.graphics.setColor(v.color.r, v.color.g, v.color.b)
			love.graphics.draw(v.sprite, v.x, v.y)
		end
    end
end