KillasBam.minimapButton = CreateFrame('Button', "KillasBam_Minimap", Minimap)
KillasBam.minimapButton:RegisterEvent("PLAYER_ENTERING_WORLD");

KillasBam.minimapButton:SetScript("OnEvent", function(self, event, ...)
  KillasBam.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(KillasBamMinimapPosition)),(80*sin(KillasBamMinimapPosition))-52)
end)

if (KillasBamMinimapPosition == nil) then
  KillasBamMinimapPosition = 125
end

KillasBam.minimapButton:SetMovable(true)
KillasBam.minimapButton:EnableMouse(true)
KillasBam.minimapButton:RegisterForDrag('LeftButton')
KillasBam.minimapButton:SetScript("OnDragStop", function()
    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin-xpos/UIParent:GetScale()+70
    ypos = ypos/UIParent:GetScale()-ymin-70

    KillasBamMinimapPosition = math.deg(math.atan2(ypos,xpos))
    KillasBam.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(KillasBamMinimapPosition)),(80*sin(KillasBamMinimapPosition))-52)
  end)

KillasBam.minimapButton:SetFrameStrata('LOW')
KillasBam.minimapButton:SetWidth(31)
KillasBam.minimapButton:SetHeight(31)
KillasBam.minimapButton:SetFrameLevel(9)
KillasBam.minimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
KillasBam.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(KillasBamMinimapPosition)),(80*sin(KillasBamMinimapPosition))-52)
KillasBam.minimapButton:SetScript("OnClick", function()
    if ( arg1 == "LeftButton" ) then
      if (KillasBam:IsShown()) then
        KillasBam:Hide()
      else
        KillasBam:Show()
      end
    end
  end)

KillasBam.minimapButton.overlay = KillasBam.minimapButton:CreateTexture(nil, 'OVERLAY')
KillasBam.minimapButton.overlay:SetWidth(53)
KillasBam.minimapButton.overlay:SetHeight(53)
KillasBam.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
KillasBam.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)

KillasBam.minimapButton.icon = KillasBam.minimapButton:CreateTexture(nil, 'BACKGROUND')
KillasBam.minimapButton.icon:SetWidth(20)
KillasBam.minimapButton.icon:SetHeight(20)
KillasBam.minimapButton.icon:SetTexture('Interface\\AddOns\\KillasBam\\img\\logo')
KillasBam.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
KillasBam.minimapButton.icon:SetPoint('CENTER',1,1)
