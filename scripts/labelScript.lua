function onLoad()
	local objectXML = {
		{tag="Panel", attributes={position="0 -250 0", rotation="180 180 0"}, children={
			{tag="Text", value=self.getName(), attributes={id="Name", fontSize=100, fontStyle="Bold", color="#000000", outline="#FFFFFF", outlineSize="5 -5"}}
		}}
	}
	self.UI.setXmlTable(objectXML)
end



function onUpdate()
	self.UI.setValue("Name", self.getName())
end