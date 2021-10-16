objects = {
	'25e956',
	'cefa94'
}



function onLoad()
	for i=1, #objects, 1 do
		obj = getObjectFromGUID(objects[i])
		if obj ~= nil then
			obj.interactable = false
			obj.tooltip = false
        end
    end
end



function onPlayerChangeColor(player_color)
	xml = UI.getXmlTable()
	for idx,item in ipairs(xml) do
		if (item.attributes.id == player_color) then
			table.remove(xml, idx)
			break
		end
    end
	UI.setXmlTable(xml)
end