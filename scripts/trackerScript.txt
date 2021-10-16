saveFlag = false
icon = "D0"



function onLoad(saved_data)
	if (saveFlag and saved_data ~= "") then icon = JSON.decode(saved_data) end
	objectXML = {
		{
			tag="Defaults",
			children={
				{tag="Panel", attributes={class="main", width=375, height=250, rectAlignment="MiddleCenter", scale="0.5 1", position="0 0 -50", rotation="180 180 0"}}
			}
		},
		{
			tag="Panel", attributes={class="main"},
			children={
				{tag="Image", attributes={id="icon", image=icon, width="80%", height="80%", preserveAspect=true, rectAlignment="MiddleCenter"}},
				{tag="Button", attributes={onClick="registerButtonClick(dec)", text="◄", textColor="#FFFFFF", fontSize=60, width=100, height=100, rectAlignment="MiddleLeft", colors="#FFFFFF00|#1C97FF|#8B8B8B|#C8C8C8"}},
				{tag="Button", attributes={onClick="registerButtonClick(inc)", text="►", textColor="#FFFFFF", fontSize=60, width=100, height=100, rectAlignment="MiddleRight", colors="#FFFFFF00|#1C97FF|#8B8B8B|#C8C8C8"}}
			}
		}
	}
	
	self.UI.setXmlTable(objectXML)
end



function onSave()
	return JSON.encode(icon)
end



function registerButtonClick(_, value)
	local iconIdx = {["D0"]=0, ["D4"]=4, ["D6"]=6, ["D8"]=8, ["D10"]=10, ["D12"]=12}
	local i = iconIdx[self.UI.getAttribute("icon", "image")]
	if (value == "dec") then
		i = i - 2
		if (i < 4) then i = 0 end
	elseif (value == "inc") then
		i = i + 2
		if (i < 4) then i = 4
		elseif (i > 12) then i = 12 end
	end
	self.UI.setAttribute("icon", "image", "D" .. i)
	
	local saved_data = JSON.encode("D" .. i)
	self.script_state = saved_data
end