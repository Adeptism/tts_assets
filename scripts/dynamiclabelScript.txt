saveFlag = true
icons = {"D0", "D4", "D6", "D8", "D10", "D12"}
iconIndex = 1


function onLoad(saved_data)
	if (saveFlag and saved_data ~= "") then iconIndex = JSON.decode(saved_data) end

	local objectXML = {
		{
			tag="Defaults",
			children={
				{tag="Panel", attributes={class="main", width=250, height=250, rectAlignment="MiddleCenter", position="0 0 -10", rotation="180 180 0"}}
			}
		},
		{
			tag="Panel", attributes={position="0 -110 0", rotation="180 180 0"},
			children={
				{tag="Text", value=self.getName(), attributes={id="Name", fontSize=50, fontStyle="Bold", color="#000000", outline="#FFFFFF", outlineSize="5 -5"}}
			}
		},
		{
			tag="Panel", attributes={class="main"},
			children={
				{tag="Image", attributes={id="Icon", image=icons[iconIndex], width="50%", height="50%", preserveAspect=true, rectAlignment="MiddleCenter"}}
			}
		}
	}
	self.UI.setXmlTable(objectXML)

	self.addContextMenuItem("[43C66F][b]Raise[/b]", raiseType, true)
	self.addContextMenuItem("[E55B5B][b]Lower[/b]", lowerType, true)
end


function onUpdate()
	self.UI.setValue("Name", self.getName())
end


function onSave()
	return JSON.encode(iconIndex)
end



function raiseType()
	if (iconIndex + 1 > 6) then
		iconIndex = 6
	else
		iconIndex = iconIndex + 1
	end
	self.UI.setAttribute("Icon", "image", icons[iconIndex])
	
	local saved_data = JSON.encode(iconIndex)
	self.script_state = saved_data
end


function lowerType()
	if (iconIndex - 1 < 1) then
		iconIndex = 1
	else
		iconIndex = iconIndex - 1
	end
	self.UI.setAttribute("Icon", "image", icons[iconIndex])
	
	local saved_data = JSON.encode(iconIndex)
	self.script_state = saved_data
end