require('XpSystem/ISUI/ISCharacterScreen')

local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10

local function getZodiacSign()
    if not getPlayer():getModData().Zodiac then
        local zodiacSigns = {
            {sign = "Aries", weight = 25},       -- 19 apr — 13 may
            {sign = "Taurus", weight = 37},      -- 14 may — 19 jun
            {sign = "Gemini", weight = 31},      -- 20 jun — 20 jul
            {sign = "Cancer", weight = 20},      -- 21 jul — 9 aug
            {sign = "Leo", weight = 37},         -- 10 aug — 15 sep
            {sign = "Virgo", weight = 45},       -- 16 sep — 30 oct
            {sign = "Libra", weight = 23},       -- 31 oct — 22 nov
            {sign = "Scorpio", weight = 7},      -- 23 nov — 29 nov
            {sign = "Ophiuchus", weight = 18},   -- 30 nov — 17 dec
            {sign = "Sagittarius", weight = 32}, -- 18 dec — 19 jan
            {sign = "Capricorn", weight = 28},   -- 20 jan — 15 feb
            {sign = "Aquarius", weight = 24},    -- 16 feb — 11 mar
            {sign = "Pisces", weight = 37},      -- 12 mar — 18 apr
            {sign = "Cetus", weight = 1}         -- 28 mar
        }
        
        local randomValue = ZombRand(365) + 1
        
        local currentWeight = 0
        for _, zodiac in ipairs(zodiacSigns) do
            currentWeight = currentWeight + zodiac.weight
            if randomValue <= currentWeight then
                getPlayer():getModData().Zodiac = zodiac.sign
                break
            end
        end
    end

    return getPlayer():getModData().Zodiac
end

local originalRender = ISCharacterScreen.render
function ISCharacterScreen:render()
    originalRender(self)

    local y = UI_BORDER_SPACING
    y = y + FONT_HGT_MEDIUM;
    y = y + UI_BORDER_SPACING * 2;

    local x = self.xOffset -- after Weight title
    x = x + UI_BORDER_SPACING -- spacing

    local weightStr = tostring(round(self.char:getNutrition():getWeight(), 0))
    x = x + getTextManager():MeasureStringX(UIFont.Small, weightStr) -- after weight value

    if self.char:getNutrition():isIncWeight() or self.char:getNutrition():isIncWeightLot() or
        self.char:getNutrition():isDecWeight() then
        local nutritionWidth = getTextManager():MeasureStringX(UIFont.Small, weightStr) + 13;
        local xAfterIcon
        if self.char:getNutrition():isIncWeight() and not self.char:getNutrition():isIncWeightLot() then
            xAfterIcon = self.xOffset + nutritionWidth + self.weightIncTexture:getWidth()
        end
        if self.char:getNutrition():isIncWeightLot() then
            xAfterIcon = self.xOffset + nutritionWidth + self.weightIncLotTexture:getWidth()
        end
        if self.char:getNutrition():isDecWeight() then
            xAfterIcon = self.xOffset + nutritionWidth + self.weightDecTexture:getWidth()
        end

        x = Math.max(x, xAfterIcon or 0)
    end

    x = x + UI_BORDER_SPACING * 2 -- after weight value and double spacings

    -- It's our place

    local title = getText("UI_Zodiac_Title")
    local sign = getZodiacSign()
    local signText = getText("UI_Zodiac_" .. sign)
    local hoverText = title .. ": " .. signText;
    local iconTexture = getTexture("media/ui/" .. string.lower(sign) .. ".png");

    self.zodiacIcon = ISXuiSkin.build(self.xuiSkin, "S_NeedsAStyle", ISImage, x, y, 32, 32, iconTexture);
    self.zodiacIcon.mouseovertext = hoverText;
    self.zodiacIcon:initialise();
    self.zodiacIcon:instantiate();
    self:addChild(self.zodiacIcon);
end
