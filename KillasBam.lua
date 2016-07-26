SLASH_KILLASBAM1, SLASH_KILLASBAM2, SLASH_KILLASBAM3 = "/killasbam", "/kb", "/bam"
SlashCmdList["KILLASBAM"] = function(message)
	DEFAULT_CHAT_FRAME:AddMessage("--KillasBam records--")
	if not KillasBamRecord then 
		DEFAULT_CHAT_FRAME:AddMessage("no records :(")
	else
		for title,value in pairsByKeys(KillasBamRecord) do
			DEFAULT_CHAT_FRAME:AddMessage(title..": "..value);
		end
	end
end

function pairsByKeys (t, f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
	return iter
end

local backdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 32,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
	insets = {left = 5, right = 5, top = 5, bottom = 5},
}

KbHook_ChatFrame_OnEvent = ChatFrame_OnEvent
function ChatFrame_OnEvent(event)
	KbHook_ChatFrame_OnEvent(event);
end

KillasBam = CreateFrame("Frame",nil,UIParent)
KillasBam:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
KillasBam:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
KillasBam:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
KillasBam:RegisterEvent("PLAYER_ENTERING_WORLD");

function KillasBam:PlaySound()
	PlaySoundFile("Interface\\AddOns\\KillasBam\\bam.ogg")
end

KillasBam:SetScript("OnEvent", function ()
	if not KillasBamSettings then
		KillasBamSettings = "EMOTE"
		KillasBam.outputemote:SetChecked(true)
		KillasBamRecord = {}
	else
  	    KillasBam:Hide()
	end

	if not KillasBamCrit then
		KillasBamCrit = false
	elseif KillasBamCrit == true then
		KillasBam.Crit:SetChecked(true)
	end

	if KillasBamSettings == "SELF" then
		KillasBam.outputself:SetChecked(true)
	elseif KillasBamSettings == "EMOTE" then
		KillasBam.outputemote:SetChecked(true)
	elseif KillasBamSettings == "SAY" then
		KillasBam.outputsay:SetChecked(true)
	elseif KillasBamSettings == "YELL" then
		KillasBam.outputyell:SetChecked(true)
	elseif KillasBamSettings == "GROUP" then
		KillasBam.outputgroup:SetChecked(true)
	elseif KillasBamSettings == "RAID" then
		KillasBam.outputraid:SetChecked(true)
	end

	if event == "PLAYER_ENTERING_WORLD" then
		if GetLocale() == "deDE" then
			KillasBam.spell = "(.+) trifft (.+) kritisch: (%d+) .+%."
			KillasBam.weapon = "Ihr trefft (.+) kritisch für (%d+) .+%."
			KillasBam.heal   = "Kritische Heilung: (.+) heilt (.+) um (%d+) .+%."
		else
			KillasBam.spell = "Your (.+) crits (.+) for (%d+)"
			KillasBam.weapon = "You crit (.+) for (%d+)"
			KillasBam.heal = "Your (.+) critically heals (.+) for (%d+)%."
		end
		return
	end

	for spell, mob, damage in string.gfind(arg1, KillasBam.spell) do
	    local damage = tonumber(damage)
		local bam = false
		if not KillasBamRecord[spell] or KillasBamRecord[spell] < damage then
			KillasBamRecord[spell] = damage
			bam = true
		end
		if bam == true or KillasBamCrit == true then
			if KillasBamSettings == "SELF" or ( KillasBamCrit == true and bam ~= true ) then
				DEFAULT_CHAT_FRAME:AddMessage("Bam! " .. spell .. " crit for " .. damage .. "!")
			else
				SendChatMessage("Bam! " .. spell .. " crit for " .. damage .. "!", KillasBamSettings)
			end
			KillasBam:PlaySound()
		end
	end
  
    for heal, player, damage in string.gfind(arg1, KillasBam.heal) do
		local damage = tonumber(damage)
		local bam = false
		if not KillasBamRecord[heal] or KillasBamRecord[heal] < damage then
			KillasBamRecord[heal] = damage
			bam = true
		end
		if bam == true or KillasBamCrit == true then
			if KillasBamSettings == "SELF" or ( KillasBamCrit == true and bam ~= true ) then
				DEFAULT_CHAT_FRAME:AddMessage("Bam! " .. heal .. " crit for " .. damage .. "!")
			else
				SendChatMessage("Bam! " .. heal .. " crit for " .. damage .. "!", KillasBamSettings)
			end
			KillasBam:PlaySound()
		end
	end

	for mob, damage in string.gfind(arg1, KillasBam.weapon) do
		local damage = tonumber(damage)
		local bam = false
		if not KillasBamRecord["auto"] or KillasBamRecord["auto"] < damage then
			KillasBamRecord["auto"] = damage
			bam = true
		end
		if bam == true or KillasBamCrit == true then
			if KillasBamSettings == "SELF" or ( KillasBamCrit == true and bam ~= true ) then
				DEFAULT_CHAT_FRAME:AddMessage("Bam! Autohit crit for " .. damage .. "!")
			else
				SendChatMessage("Bam! Autohit crit for " .. damage .. "!", KillasBamSettings)
			end
			KillasBam:PlaySound()
		end
	end
end)

KillasBam:SetFrameStrata("DIALOG")
KillasBam:SetWidth(410)
KillasBam:SetHeight(300) --350
KillasBam:SetBackdrop(backdrop)
KillasBam:SetBackdropColor(0,0,0,1);
KillasBam:SetPoint("CENTER",0,0)
KillasBam:SetMovable(true)
KillasBam:EnableMouse(true)
KillasBam:SetScript("OnMouseDown",function()
    KillasBam:StartMoving()
end)
KillasBam:SetScript("OnMouseUp",function()
    KillasBam:StopMovingOrSizing()
end)

KillasBam.title = CreateFrame("Frame", nil, KillasBam)
KillasBam.title:SetPoint("TOP", 0, -5);
KillasBam.title:SetWidth(400);
KillasBam.title:SetHeight(100);
KillasBam.title.tex = KillasBam.title:CreateTexture("LOW");
KillasBam.title.tex:SetAllPoints();
KillasBam.title.tex:SetTexture("Interface\\AddOns\\KillasBam\\img\\bg");

KillasBam.title.text = KillasBam.title:CreateFontString("Status", "LOW", "GameFontNormal")
KillasBam.title.text:SetFontObject(GameFontWhite)
KillasBam.title.text:SetFont("Fonts\\MORPHEUS.TTF", 26, "OUTLINE")
KillasBam.title.text:SetPoint("TOP", 0, -20)
KillasBam.title.text:SetText("KillasBam")

KillasBam.title.dtext = KillasBam.title:CreateFontString("Status", "LOW", "GameFontNormal")
KillasBam.title.dtext:SetFontObject(GameFontWhite)
KillasBam.title.dtext:SetFont("Fonts\\MORPHEUS.TTF", 10, "OUTLINE")
KillasBam.title.dtext:SetPoint("BOTTOM", 0, 30)
KillasBam.title.dtext:SetTextColor(1,1,1,.75)
KillasBam.title.dtext:SetText("Version 0.2 - WoW PATCH 1.12.1")

KillasBam.closeButton = CreateFrame("Button", nil, KillasBam.title, "UIPanelCloseButton")
KillasBam.closeButton:SetWidth(30)
KillasBam.closeButton:SetHeight(30) -- width, height
KillasBam.closeButton:SetPoint("TOPRIGHT", 0,0)
KillasBam.closeButton:SetScript("OnClick", function()
    if KillasBam:IsShown() then
		KillasBam:Hide()
    end
end)

KillasBam.accountSettings = KillasBam:CreateFontString("Status", "LOW", "GameFontNormal")
KillasBam.accountSettings:SetFontObject(GameFontWhite)
KillasBam.accountSettings:SetFont("Fonts\\FRIZQT__.TTF", 12)
KillasBam.accountSettings:SetPoint("TOPLEFT", 30, -110)
KillasBam.accountSettings:SetTextColor(1,1,1,1)
KillasBam.accountSettings:SetText("options")

KillasBam.Crit = CreateFrame("CheckButton", "CritAllwaysBam", KillasBam, "UICheckButtonTemplate")
KillasBam.Crit:ClearAllPoints()
KillasBam.Crit:SetPoint("TOPLEFT", 140, -105)
KillasBam.Crit:SetHeight(24)
KillasBam.Crit:SetWidth(24)
CritAllwaysBamText:SetText("every crit bam")
CritAllwaysBamText:SetFont("Fonts\\FRIZQT__.TTF", 12)
CritAllwaysBamText:SetTextColor(1,1,1)
CritAllwaysBamText:ClearAllPoints()
CritAllwaysBamText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.Crit:SetScript("OnClick", function ()
	if KillasBamCrit == false then
		KillasBamCrit = true
		KillasBam.Crit:SetChecked(true)
	else
		KillasBamCrit = false
		KillasBam.Crit:SetChecked(false)
	end
end)

KillasBam.accountSettings = KillasBam:CreateFontString("Status", "LOW", "GameFontNormal")
KillasBam.accountSettings:SetFontObject(GameFontWhite)
KillasBam.accountSettings:SetFont("Fonts\\FRIZQT__.TTF", 10)
KillasBam.accountSettings:SetPoint("TOPLEFT", 165, -125)
KillasBam.accountSettings:SetTextColor(1,1,1,1)
KillasBam.accountSettings:SetText("(output always as self)")

KillasBam.accountSettings = KillasBam:CreateFontString("Status", "LOW", "GameFontNormal")
KillasBam.accountSettings:SetFontObject(GameFontWhite)
KillasBam.accountSettings:SetFont("Fonts\\FRIZQT__.TTF", 12)
KillasBam.accountSettings:SetPoint("TOPLEFT", 30, -150)
KillasBam.accountSettings:SetTextColor(1,1,1,1)
KillasBam.accountSettings:SetText("output set to")

KillasBam.outputself = CreateFrame("CheckButton", "outputself", KillasBam, "UICheckButtonTemplate")
KillasBam.outputself:ClearAllPoints()
KillasBam.outputself:SetPoint("TOPLEFT", 140, -145)
KillasBam.outputself:SetHeight(24)
KillasBam.outputself:SetWidth(24)
outputselfText:SetText("self")
outputselfText:SetFont("Fonts\\FRIZQT__.TTF", 12)
outputselfText:SetTextColor(1,1,1)
outputselfText:ClearAllPoints()
outputselfText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.outputself:SetScript("OnClick", function ()
	if KillasBamSettings ~= "SELF" then      
		KillasBamSettings = "SELF"
    end
    KillasBam.outputself:SetChecked(true)
    KillasBam.outputemote:SetChecked(false)
    KillasBam.outputsay:SetChecked(false)
    KillasBam.outputyell:SetChecked(false)
	KillasBam.outputgroup:SetChecked(false)
	KillasBam.outputraid:SetChecked(false)
end)

KillasBam.outputemote = CreateFrame("CheckButton", "outputemote", KillasBam, "UICheckButtonTemplate")
KillasBam.outputemote:ClearAllPoints()
KillasBam.outputemote:SetPoint("TOPLEFT", 210, -145)
KillasBam.outputemote:SetHeight(24)
KillasBam.outputemote:SetWidth(24)
outputemoteText:SetText("emote")
outputemoteText:SetFont("Fonts\\FRIZQT__.TTF", 12)
outputemoteText:SetTextColor(1,1,1)
outputemoteText:ClearAllPoints()
outputemoteText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.outputemote:SetScript("OnClick", function ()
	if KillasBamSettings ~= "EMOTE" then      
		KillasBamSettings = "EMOTE"
	end
	KillasBam.outputself:SetChecked(false)
	KillasBam.outputemote:SetChecked(true)
	KillasBam.outputsay:SetChecked(false)
	KillasBam.outputyell:SetChecked(false)
	KillasBam.outputgroup:SetChecked(false)
	KillasBam.outputraid:SetChecked(false)
end)

KillasBam.outputsay = CreateFrame("CheckButton", "outputsay", KillasBam, "UICheckButtonTemplate")
KillasBam.outputsay:ClearAllPoints()
KillasBam.outputsay:SetPoint("TOPLEFT", 300, -145)
KillasBam.outputsay:SetHeight(24)
KillasBam.outputsay:SetWidth(24)
outputsayText:SetText("say")
outputsayText:SetFont("Fonts\\FRIZQT__.TTF", 12)
outputsayText:SetTextColor(1,1,1)
outputsayText:ClearAllPoints()
outputsayText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.outputsay:SetScript("OnClick", function ()
	if KillasBamSettings ~= "SAY" then      
		KillasBamSettings = "SAY"
	end
	KillasBam.outputself:SetChecked(false)
	KillasBam.outputemote:SetChecked(false)
	KillasBam.outputsay:SetChecked(true)
	KillasBam.outputyell:SetChecked(false)
	KillasBam.outputgroup:SetChecked(false)
	KillasBam.outputraid:SetChecked(false)
end)

KillasBam.outputyell = CreateFrame("CheckButton", "outputyell", KillasBam, "UICheckButtonTemplate")
KillasBam.outputyell:ClearAllPoints()
KillasBam.outputyell:SetPoint("TOPLEFT", 140, -165)
KillasBam.outputyell:SetHeight(24)
KillasBam.outputyell:SetWidth(24)
outputyellText:SetText("yell")
outputyellText:SetFont("Fonts\\FRIZQT__.TTF", 12)
outputyellText:SetTextColor(1,1,1)
outputyellText:ClearAllPoints()
outputyellText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.outputyell:SetScript("OnClick", function ()
	if KillasBamSettings ~= "YELL" then      
		KillasBamSettings = "YELL"
	end
	KillasBam.outputself:SetChecked(false)
	KillasBam.outputemote:SetChecked(false)
	KillasBam.outputsay:SetChecked(false)
	KillasBam.outputyell:SetChecked(true)
	KillasBam.outputgroup:SetChecked(false)
	KillasBam.outputraid:SetChecked(false)
end)

KillasBam.outputgroup = CreateFrame("CheckButton", "outputgroup", KillasBam, "UICheckButtonTemplate")
KillasBam.outputgroup:ClearAllPoints()
KillasBam.outputgroup:SetPoint("TOPLEFT", 210, -165)
KillasBam.outputgroup:SetHeight(24)
KillasBam.outputgroup:SetWidth(24)
outputgroupText:SetText("group")
outputgroupText:SetFont("Fonts\\FRIZQT__.TTF", 12)
outputgroupText:SetTextColor(1,1,1)
outputgroupText:ClearAllPoints()
outputgroupText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.outputgroup:SetScript("OnClick", function ()
	if KillasBamSettings ~= "GROUP" then      
		KillasBamSettings = "GROUP"
	end
	KillasBam.outputself:SetChecked(false)
	KillasBam.outputemote:SetChecked(false)
	KillasBam.outputsay:SetChecked(false)
	KillasBam.outputyell:SetChecked(false)
	KillasBam.outputgroup:SetChecked(true)
	KillasBam.outputraid:SetChecked(false)
end)

KillasBam.outputraid = CreateFrame("CheckButton", "outputraid", KillasBam, "UICheckButtonTemplate")
KillasBam.outputraid:ClearAllPoints()
KillasBam.outputraid:SetPoint("TOPLEFT", 300, -165)
KillasBam.outputraid:SetHeight(24)
KillasBam.outputraid:SetWidth(24)
outputraidText:SetText("raid")
outputraidText:SetFont("Fonts\\FRIZQT__.TTF", 12)
outputraidText:SetTextColor(1,1,1)
outputraidText:ClearAllPoints()
outputraidText:SetPoint("LEFT", 25, 0, "RIGHT")
KillasBam.outputraid:SetScript("OnClick", function ()
	if KillasBamSettings ~= "RAID" then      
		KillasBamSettings = "RAID"
	end
	KillasBam.outputself:SetChecked(false)
	KillasBam.outputemote:SetChecked(false)
	KillasBam.outputsay:SetChecked(false)
	KillasBam.outputyell:SetChecked(false)
	KillasBam.outputgroup:SetChecked(false)
	KillasBam.outputraid:SetChecked(true)
end)

KillasBam.DeleteAll = CreateFrame("Button", nil, KillasBam, "UIPanelButtonTemplate")
KillasBam.DeleteAll:SetWidth(120)
KillasBam.DeleteAll:SetHeight(30) -- width, height
KillasBam.DeleteAll:SetPoint("TOPLEFT", 60, -220)
KillasBam.DeleteAll:SetText("delete records")
KillasBam.DeleteAll:SetScript("OnClick", function()
	KillasBamRecord = {}
end)

KillasBam.Close = CreateFrame("Button", nil, KillasBam, "UIPanelButtonTemplate")
KillasBam.Close:SetWidth(125)
KillasBam.Close:SetHeight(30) -- width, height
KillasBam.Close:SetPoint("TOPLEFT", 210, -220)
KillasBam.Close:SetText("close")
KillasBam.Close:SetScript("OnClick", function()
      KillasBam:Hide()
end)

KillasBam.bottom = CreateFrame("Frame", nil, KillasBam)
KillasBam.bottom:SetPoint("BOTTOM", 0, 5);
KillasBam.bottom:SetWidth(400);
KillasBam.bottom:SetHeight(50);
KillasBam.bottom.tex = KillasBam.bottom:CreateTexture("LOW");
KillasBam.bottom.tex:SetAllPoints();
KillasBam.bottom.tex:SetTexture("Interface\\AddOns\\KillasBam\\img\\bgb");

KillasBam.author = KillasBam.bottom:CreateFontString("Status", "LOW", "GameFontNormal")
KillasBam.author:SetFontObject(GameFontWhite)
KillasBam.author:SetFont("Fonts\\MORPHEUS.TTF", 10, "OUTLINE")
KillasBam.author:SetPoint("BOTTOM", 0, 8)
KillasBam.author:SetText("© 2016 Killas")
