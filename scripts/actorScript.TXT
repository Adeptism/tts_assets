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
	local item = {tag="Panel", children={
		{tag="Panel", attributes={active=false}, children={
			{tag="Image", attributes={image="D6", width="30%", height="80%", preserveAspect=true, rectAlignment="MiddleLeft"}},
			{tag="Text", attributes={text="Trait", placeholder="Enter trait...", lineType="MultiLineNewLine", alignment="MiddleLeft", resizeTextForBestFit=true, resizeTextMaxSize=25, color="#FFFFFF", width="65%", height="80%", rectAlignment="MiddleRight"}}
		}},
		{tag="Panel", attributes={active=false}, children={
			{tag="Button", attributes={width=35, height=35, rectAlignment="MiddleCenter", text="+", resizeTextForBestFit="true", colors="#FFFFFF|#1C97FF|#8B8B8B|#C8C8C8"}}
		}},
		{tag="Panel", attributes={active=false}, children={
			{tag="Button", attributes={width=25, height=25, rectAlignment="UpperRight", offsetXY="5 0", text="X", fontStyle="Bold", textColor="#990000", colors="#FFFFFF|#1C97FF|#8B8B8B|#C8C8C8"}}
		}}
	}}
	
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
					{tag="Text", attributes={text="Unnamed Actor", placeholder="Enter name...", lineType="MultiLineNewLine", alignment="MiddleLeft", resizeTextForBestFit="true", color="#FFFFFF", width="100%", height="20%", rectAlignment="UpperLeft", offsetXY="0 -40"}},
					{tag="Text", attributes={text="No description.", placeholder="Enter description...", fontStyle="Italic", lineType="MultiLineNewLine", alignment="UpperLeft", resizeTextForBestFit="true",  width="100%", height="12.5%", rectAlignment="MiddleCenter", offsetXY="0 15"}},
				}},
				{tag="Panel", attributes={class="imageSeriesSelection"}, children={
					{tag="HorizontalLayout", attributes={width="50%", height="15%", rectAlignment="UpperLeft"}, children={
						{tag="Image", attributes={image="D6", color="#FFFFFF"}},
						{tag="Image", attributes={image="D6", color="#FFFFFF"}},
						{tag="Image", attributes={image="D6", color="#FFFFFF00"}},
						{tag="Image", attributes={image="D6", color="#FFFFFF00"}},
						{tag="Image", attributes={image="D6", color="#FFFFFF00"}}
					}}
				}},
				{tag="Panel", attributes={class="itemSelection"}, children={
					{tag="VerticalLayout", attributes={width="100%", height="48%", rectAlignment="LowerCenter"}, children={
						{tag="HorizontalLayout", attributes={spacing=7.5}, children={
							item, item, item
						}},
						{tag="HorizontalLayout", attributes={spacing=7.5}, children={
							item, item, item
						}}
					}}
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
			{tag="Panel", attributes={class="main", width=562.5, height=375, rectAlignment="UpperCenter", offsetXY="0 -50", color="#EBEBEB"}}
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
					item.attributes.offsetXY = (x*1.5) .. " " .. (y*1.5)
				end
				item.tag = "InputField"
				item.attributes.onEndEdit = self.getGUID() .. "/registerInputField()"
			end
		elseif (type.attributes.class == "imageSeriesSelection") then
			local j = 1
			for _,item in ipairs(type.children[1].children) do
				item.attributes.id = player_color .. "imageSeries:" .. j
				j = j + 1
				if (item.attributes.offsetXY) then
					local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
					item.attributes.offsetXY = (x*1.5) .. " " .. (y*1.5)
				end
			end
			local dropdown = {tag="Panel", children={
				{tag="Dropdown", attributes={onValueChanged=self.getGUID() .. "/registerImageSeries()", id=player_color .. "imageSeries:", width=50, height=30, rectAlignment="UpperRight", offsetXY="-75 0", color="#FFFFFF", fontSize=16, fontStyle="Bold"}, children={
					{tag="Option", value="2"},
					{tag="Option", value="3"},
					{tag="Option", value="4"},
					{tag="Option", value="5"}
				}},
				{tag="Dropdown", attributes={onValueChanged=self.getGUID() .. "/registerImageSeries()", id=player_color .. "imageSeries:", width=70, height=30, rectAlignment="UpperRight", color="#FFFFFF", fontSize=16, fontStyle="Bold"}, children={
					{tag="Option", value="D4"},
					{tag="Option", value="D6"},
					{tag="Option", value="D8"},
					{tag="Option", value="D10"},
					{tag="Option", value="D12"}
				}}
			}}
			local x = -1
			for _,icon in ipairs(type.children[1].children) do
				if (icon.attributes.color == "#FFFFFF") then x = x + 1 end
			end
			local iconIdx = {["D4"]=1, ["D6"]=2, ["D8"]=3, ["D10"]=4, ["D12"]=5, ["SFX"]=6}
			local y = iconIdx[type.children[1].children[1].attributes.image]
			dropdown.children[1].children[x].attributes = {selected=true}
			dropdown.children[2].children[y].attributes = {selected=true}
			table.insert(type.children, dropdown)
			
		elseif (type.attributes.class == "itemSelection") then
			type.attributes.active = true
			local j = 1
			for _,row in ipairs(type.children[1].children) do
				row.attributes.spacing = row.attributes.spacing*1.5
				for _,column in ipairs(row.children) do
					column.children[1].attributes.id = player_color .. ":" .. i
					i = i + 1
					
					if (column.children[1].attributes.active:lower() == "false") then column.children[2].attributes.active = true end
					column.children[2].attributes.id = column.children[1].attributes.id .. "_insert"
					column.children[2].children[1].attributes.onClick=self.getGUID() .. "/registerItem(" .. column.children[1].attributes.id .. ")"
					
					if (column.children[1].attributes.active:lower() == "true") then column.children[3].attributes.active = true end
					column.children[3].attributes.id = column.children[1].attributes.id .. "_delete"
					column.children[3].children[1].attributes.onClick=self.getGUID() .. "/unregisterItem(" .. column.children[1].attributes.id .. ")"
					
					for _,item in ipairs(column.children[1].children) do
						item.attributes.id = player_color .. "item:" .. j
						j = j + 1
						if (item.attributes.offsetXY) then
							local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
							item.attributes.offsetXY = (x*1.5) .. " " .. (y*1.5)
						end
						
						if (item.tag == "Text") then
							item.tag = "InputField"
							item.attributes.onEndEdit = self.getGUID() .. "/registerInputField()"
							
						elseif (item.tag == "Image") then
							item.attributes.color = "#FFFFFF50"
							local dropdown =  {tag="Dropdown", attributes={onValueChanged=self.getGUID() .. "/registerImage()", id=item.attributes.id, width=60, height=30, rectAlignment="MiddleCenter", color="#FFFFFF", fontSize=12, fontStyle="Bold"}, children={
								{tag="Option", value="D4"},
								{tag="Option", value="D6"},
								{tag="Option", value="D8"},
								{tag="Option", value="D10"},
								{tag="Option", value="D12"}
							}}
							local iconIdx = {["D4"]=1, ["D6"]=2, ["D8"]=3, ["D10"]=4, ["D12"]=5, ["SFX"]=6}
							local k = iconIdx[item.attributes.image]
							dropdown.children[k].attributes = {selected=true}
							item.children = {dropdown}
						end
					end
				end
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
			width=593.75,
			height=502.5,
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



function registerImageSeries(_, value, id)
	if (tonumber(value) ~= nil) then
		for i=1,5 do
			if (i <= tonumber(value)) then UI.setAttribute(id .. i, "color", "#FFFFFF")
			else UI.setAttribute(id .. i, "color", "#FFFFFF00") end
		end
	else
		for i=1,5 do UI.setAttribute(id .. i, "image", value) end
	end
end



function registerItem(_, id)
	UI.setAttribute(id, "active", true)
	UI.setAttribute(id .. "_insert", "active", false)
	UI.setAttribute(id .. "_delete", "active", true)
end



function unregisterItem(_, id)
	UI.setAttribute(id, "active", false)
	UI.setAttribute(id .. "_insert", "active", true)
	UI.setAttribute(id .. "_delete", "active", false)
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
					item.attributes.offsetXY = (x/1.5) .. " " .. (y/1.5)
				end
				item.tag = "Text"
				item.attributes.onEndEdit = nil
			end
			
		elseif (type.attributes.class == "imageSeriesSelection") then
			for _,item in ipairs(type.children[1].children) do
				item.attributes.id = nil
			end
			type.children[#type.children] = nil
			
		elseif (type.attributes.class == "itemSelection") then
			for _,row in ipairs(type.children[1].children) do
				row.attributes.spacing = row.attributes.spacing/1.5
				for _,column in ipairs(row.children) do
				
					column.children[2].attributes.active = false
					column.children[2].attributes.id = nil
					column.children[2].children[1].attributes.onClick = nil
					
					column.children[3].attributes.active = false
					column.children[3].attributes.id = nil
					column.children[3].children[1].attributes.onClick = nil
					
					for _,item in ipairs(column.children[1].children) do
						item.attributes.id = nil
						if (item.attributes.offsetXY) then
							local x,_,y = item.attributes.offsetXY:match("(%S+)(%s)(%S+)")
							item.attributes.offsetXY = (x/1.5) .. " " .. (y/1.5)
						end
						
						if (item.tag == "InputField") then
							item.tag = "Text"
							item.attributes.onEndEdit = nil
							
						elseif (item.tag == "Image") then
							item.attributes.color = "#FFFFFF"
							item.children = nil
						end
					end
				end
			end
		end
	end
	objectXML[2] = uiXML[2]
	
	self.UI.setXmlTable(objectXML)
	UI.setXmlTable(xml)
	
	local saved_data = JSON.encode(objectXML)
	self.script_state = saved_data
end