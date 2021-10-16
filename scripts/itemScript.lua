saveFlag = false
objectXML = {}



function onLoad(saved_data)
	if (saveFlag and saved_data ~= "") then objectXML = JSON.decode(saved_data)
	else renderDefaultUI() end
	
	self.UI.setXmlTable(objectXML)
	self.addContextMenuItem("Edit", editMode)
end



function onSave()
	return JSON.encode(objectXML)
end



function onDestroy()
	local xml = UI.getXmlTable()
	for idx,item in ipairs(xml) do
		if (item.attributes.class == self.getGUID()) then table.remove(xml, idx) end
    end
	
	UI.setXmlTable(xml)
end



function renderDefaultUI()
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
				{tag="Panel", attributes={class="textInput"}, children={
					{tag="Text", attributes={text="Unnamed Item", placeholder="Enter name...", lineType="MultiLineNewLine", alignment="MiddleLeft", resizeTextForBestFit="true", color="#FFFFFF", width="77.5%", height="30%", rectAlignment="UpperRight"}},
					{tag="Text", attributes={text="No description.", placeholder="Enter description...", fontStyle="Italic", lineType="MultiLineNewLine", alignment="UpperLeft", resizeTextForBestFit="true",  width="100%", height="12.5%", rectAlignment="MiddleCenter", offsetXY="0 27.5"}},
					{tag="Text", attributes={placeholder="Enter SFX (optional)...", lineType="MultiLineNewLine", alignment="UpperLeft", resizeTextForBestFit=true, resizeTextMaxSize=20, color="#FFFFFF", width="100%", height="52%", rectAlignment="LowerCenter"}}
				}},
				{tag="Panel", attributes={class="imageSelection"}, children={
					{tag="Image", attributes={image="D6", width="20%", height="30%", preserveAspect=true, rectAlignment="UpperLeft"}}
				}}
			}
		}
	}
end



function editMode(player_color)
	local uiXML = self.UI.getXmlTable()
	local uiDefault = {
		tag="Defaults",
		children={
			{tag="Panel", attributes={class="main", width=468.75, height=312.5, rectAlignment="UpperCenter", offsetXY="0 -50", color="#EBEBEB"}}
		}
	}
	uiXML[1] = uiDefault
	local i = 1
	for _,type in ipairs(uiXML[2].children) do
		if (type.attributes.class == "textInput") then
			for _,item in ipairs(type.children) do
				item.attributes.id = player_color .. ":" .. i
				i = i + 1
				if (item.attributes.offsetXY) then
					local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
					item.attributes.offsetXY = (x*1.25) .. " " .. (y*1.25)
				end
				item.tag = "InputField"
				item.attributes.onEndEdit = self.getGUID() .. "/registerInputField()"
			end
			
		elseif (type.attributes.class == "imageSelection") then
			for _,item in ipairs(type.children) do
				item.attributes.id = player_color .. ":" .. i
				i = i + 1
				if (item.attributes.offsetXY) then
					local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
					item.attributes.offsetXY = (x*1.25) .. " " .. (y*1.25)
				end
				item.attributes.color = "#FFFFFF50"
				local dropdown =  {tag="Dropdown", attributes={onValueChanged=self.getGUID() .. "/registerImage()", id=item.attributes.id, width=75, height=30, rectAlignment="MiddleCenter", color="#FFFFFF", fontSize=16, fontStyle="Bold"}, children={
					{tag="Option", value="D4"},
					{tag="Option", value="D6"},
					{tag="Option", value="D8"},
					{tag="Option", value="D10"},
					{tag="Option", value="D12"},
					{tag="Option", value="SFX"}
				}}
				local iconIdx = {["D4"]=1, ["D6"]=2, ["D8"]=3, ["D10"]=4, ["D12"]=5, ["SFX"]=6}
				local j = iconIdx[item.attributes.image]
				dropdown.children[j].attributes = {selected=true}
				item.children = {dropdown}
			end
		end
	end
	
	local uiTopBar = {
		tag="Panel", attributes={height=35, rectAlignment="UpperCenter", color="#80808040"},
		children={
			{tag="Image", attributes={
				width=25,
				preserveAspect=true,
				image="configIcon",
				rectAlignment="MiddleLeft",
				offsetXY= "10 0"
			}},
			{tag="Text", attributes={
				width=40,
				rectAlignment="MiddleLeft",
				offsetXY="40 0",
				text="Edit",
				fontStyle="Bold",
				resizeTextForBestFit="true"
			}},
			{tag="Button", attributes={onClick=self.getGUID() .. "/exitUI(" .. player_color .. ")",
				width=25,
				height=25,
				rectAlignment="UpperRight",
				offsetXY="-5 -5",
				text="X",
				fontStyle="Bold",
				textColor="#990000",
				colors="#FFFFFF|#1C97FF|#8B8B8B|#C8C8C8"
			}}
		}
	}
	local uiBottomBar = {
		tag="Panel", attributes={height=60, rectAlignment="LowerCenter", color="#80808040"},
		children={
			{tag="Button", attributes={onClick=self.getGUID() .. "/submitUI(" .. player_color .. ")",
				width=200,
				height=40,
				rectAlignment="MiddleCenter",
				text="Submit",
				fontStyle="Bold",
				textColor="#000000",
				colors="#FFFFFF|#1C97FF|#8B8B8B|#C8C8C8"
			}}
		}
	}
	table.insert(uiXML, {tag="Panel", children={uiTopBar, uiBottomBar}})
	
	local xml = UI.getXmlTable()
	for idx,item in ipairs(xml) do
		if (item.attributes.id == player_color) then
			table.remove(xml, idx)
			break
		end
    end
	table.insert(xml, {tag="Panel",
		attributes={data={}, id=player_color, class=self.getGUID(), visibility=player_color, returnToOriginalPositionWhenReleased=false, allowDragging=true,
			width=500,
			height=440,
			color="#EBEBEB",
			outline="#000000"
		}, children=uiXML})
	
	UI.setXmlTable(xml)
end



function registerInputField(_, value, id)
	UI.setAttribute(id, "text", value)
end



function registerImage(_, value, id)
	UI.setAttribute(id, "image", value)
end



function exitUI(_, id)
	local xml = UI.getXmlTable()
	for idx,item in ipairs(xml) do
		if item.attributes.id == id then
			table.remove(xml, idx)
			break
        end
    end
	
	UI.setXmlTable(xml)
end



function submitUI(_, id)
	local xml = UI.getXmlTable()
	for idx,item in ipairs(xml) do
		if item.attributes.id == id then
			uiXML = item.children
			table.remove(xml, idx)
			break
        end
    end
	
	for _,type in ipairs(uiXML[2].children) do
		if (type.attributes.class == "textInput") then
			for _,item in ipairs(type.children) do
				item.attributes.id = nil
				if (item.attributes.offsetXY) then
					local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
					item.attributes.offsetXY = (x/1.25) .. " " .. (y/1.25)
				end
				item.tag = "Text"
				item.attributes.onEndEdit = nil
			end
			
		elseif (type.attributes.class == "imageSelection") then
			for _,item in ipairs(type.children) do
				item.attributes.id = nil
				if (item.attributes.offsetXY) then
					local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
					item.attributes.offsetXY = (x/1.25) .. " " .. (y/1.25)
				end
				item.attributes.color = "#FFFFFF"
				item.children = nil
			end
		end
	end
	objectXML[2] = uiXML[2]
	
	self.UI.setXmlTable(objectXML)
	UI.setXmlTable(xml)
	
	local saved_data = JSON.encode(objectXML)
	self.script_state = saved_data
end