local DebugEnabled = false

local function DebugPrint(...)
    if DebugEnabled then
        print("[Kaitun Fisch]", ...)
    end
end



local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end

local function PressSpaceOnce()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

local function IsIntroScreenVisible()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return false
    end

    for _, obj in ipairs(playerGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local text = tostring(obj.Text):lower()

            if text:find("press any key", 1, true)
                or text:find("continue", 1, true) then
                return true
            end
        end
    end

    return false
end

local function GetClockTime()
    local clockTime = tonumber(Lighting.ClockTime)

    if not clockTime then
        return 12
    end

    return clockTime
end

local function IsNight()
    local clockTime = GetClockTime()

    return clockTime < 6 or clockTime >= 18
end

local function IsDay()
    return not IsNight()
end

local function GetDayNightState()
    local clockTime = GetClockTime()

    if IsNight() then
        return "Night", clockTime
    end

    return "Day", clockTime
end

local function WaitGameLoaded()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    while not LocalPlayer do
        task.wait(0.1)
        LocalPlayer = Players.LocalPlayer
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    while not playerGui do
        task.wait(0.2)
        playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    end

    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end

    task.wait(2)

    local introPressed = false
    local startTime = tick()

    while tick() - startTime < 30 do
        if IsIntroScreenVisible() and not introPressed then
            DebugPrint("Intro screen detected, pressing Space")
            PressSpaceOnce()
            introPressed = true
            task.wait(2)
        end

        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local backpack = LocalPlayer:FindFirstChild("Backpack")

        if leaderstats and backpack then
            DebugPrint("Game loaded")
            return true
        end

        task.wait(0.5)
    end

    DebugPrint("Game load wait timeout, continuing")
    return false
end

WaitGameLoaded()

warn("[Kaitun Fisch] Script passed WaitGameLoaded")

local TweenService = game:GetService("TweenService")

local function CreateKaitunSplashScreen()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

    if not playerGui then
        return
    end

    -- กัน GUI ซ้อนตอนรันซ้ำ
    local oldGui = playerGui:FindFirstChild("KaitunFischSplashGui")
    if oldGui then
        oldGui:Destroy()
    end

    local oldBlur = Lighting:FindFirstChild("KaitunFischSplashBlur")
    if oldBlur then
        oldBlur:Destroy()
    end

    -- เบลอหน้าจอ
    local blur = Instance.new("BlurEffect")
    blur.Name = "KaitunFischSplashBlur"
    blur.Size = 18
    blur.Enabled = true
    blur.Parent = Lighting

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KaitunFischSplashGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 360, 0, 390)
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 5
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Size = UDim2.new(1, 0, 0, 55)
    title.Font = Enum.Font.GothamBlack
    title.Text = "KAITUN FISCH"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.TextStrokeTransparency = 0.35
    title.TextScaled = true
    title.ZIndex = 6
    title.Parent = mainFrame

    local image = Instance.new("ImageLabel")
    image.Name = "Logo"
    image.AnchorPoint = Vector2.new(0.5, 0)
    image.Position = UDim2.new(0.5, 0, 0, 70)
    image.Size = UDim2.new(0, 220, 0, 220)
    image.BackgroundTransparency = 1

    -- ใช้ rbxthumb แทน rbxassetid เพื่อให้รูปจาก Creator Store แสดงง่ายกว่า
    image.Image = "rbxthumb://type=Asset&id=73738210298178&w=420&h=420"

    image.ScaleType = Enum.ScaleType.Fit
    image.ZIndex = 6
    image.Parent = mainFrame

    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 0, 0, 300)
    subtitle.Size = UDim2.new(1, 0, 0, 45)
    subtitle.Font = Enum.Font.GothamBold
    subtitle.Text = "Switch hub"
    subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    subtitle.TextStrokeTransparency = 0.45
    subtitle.TextScaled = true
    subtitle.ZIndex = 6
    subtitle.Parent = mainFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.AnchorPoint = Vector2.new(0.5, 1)
    closeButton.Position = UDim2.new(0.5, 0, 1, 0)
    closeButton.Size = UDim2.new(0, 170, 0, 38)
    closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    closeButton.BackgroundTransparency = 0.15
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "ปิดหน้าจอ"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.ZIndex = 7
    closeButton.Parent = mainFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeButton


    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.AnchorPoint = Vector2.new(1, 0)
    toggleButton.Position = UDim2.new(1, -15, 0, 15)
    toggleButton.Size = UDim2.new(0, 120, 0, 36)
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.BorderSizePixel = 0
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = "ซ่อนหน้า"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 14
    toggleButton.Visible = true
    toggleButton.Active = true
    toggleButton.ZIndex = 999
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton

    local splashVisible = true

    local function SetSplashVisible(state)
        splashVisible = state

        mainFrame.Visible = state
        blur.Enabled = state

        if state then
            toggleButton.Text = "ซ่อนหน้า"
        else
            toggleButton.Text = "เปิดหน้า"
        end
    end

    closeButton.MouseButton1Click:Connect(function()
        SetSplashVisible(false)
    end)

    toggleButton.MouseButton1Click:Connect(function()
        SetSplashVisible(not splashVisible)
    end)

    mainFrame.Size = UDim2.new(0, 300, 0, 340)

    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 360, 0, 390),
        }
    ):Play()

    DebugPrint("[Splash] Kaitun splash screen created")
end

CreateKaitunSplashScreen()

local DefaultConfig = {
    Debug = false,

    TargetRod = "Splitbranch Twig",

    Farm = {
        Enabled = true,
        Position = Vector3.new(3723, -1128, -1073),
        RotationY = 40,
    },

    Fishing = {
        AutoShake = true,
        AutoCast = true,
        AutoCastMode = "Perfect",
        AutoEquipRod = true,
        AutoFish = false,
        InstantReel = true,
        FreezePosition = true,
        InstantBobber = true,
        InstantBobberForce = -300,
        InstantBobberDuration = 0.15,

        PerfectCatchChance = 100,
        ReelSnapChance = 0,
        ReelTime = 0.1,
        WhiteBarSize = 1,
        AutoCastDelay = 0.5,
    },

    Sell = {
        Enabled = true,
        Delay = 120,

        Position = Vector3.new(2436, 132, -673),
        RotationY = 0,

        ReturnDelay = 1,
    },

    BuyRod = {
        Enabled = true,
        TargetRod = "Splitbranch Twig",
        MoneyRequired = 25000,

        Position = Vector3.new(2450, 155, -2365),
        RotationY = 0,
    },

    CarrotRod = {
        Enabled = true,
        TargetRod = "Carrot Rod",
        MoneyRequired = 75000,

        BuyPosition = Vector3.new(3722, -1127, -1061),
        BuyRotationY = 0,

        RequiredFish = {
            "Carrot Goldfish",
            "Carrot Pufferfish",
            "Carrot Eel",
            "Carrot Minnow",
            "Carrot Salmon",
            "Carrot Turtle",
            "Carrot Snapper",
            "Carrot Shark",
        },
    },

    CarrotRodFarm = {
        Position = Vector3.new(3723, -1128, -1073),
        RotationY = 40,

        SellAtFarm = false,
    },

    GreatRodOscar = {
        Enabled = true,
        TargetRod = "Great Rod of Oscar",

        LevelRequired = 250,
        MoneyRequired = 2500000,

        BuyPosition = Vector3.new(272, -386, 3406),
        BuyRotationY = 0,
    },

    LuminescentCavern = {
        Enabled = true,
        TargetRod = "Luminescent Oath",

        LevelRequired = 500,
        MoneyRequired = 1000000,

        BuyPosition = Vector3.new(-1132, -323, -4309),
        BuyRotationY = 0,

        RequiredFish = {
            "Bluelip Batfish",
            "Hawaiian Bobtail Squid",
            "Dinoflagellates",
            "Blue Ribbon Eel",
            "Kitefin Shark",
            "Atolla Jellyfish",
            "Electric Blue Seahorse",
            "Colossal Blue Dragon",
        },
    },

    CrimsonQuest = {
        Enabled = true,

        TargetFish = "Colossal Blue Dragon",
        TargetMutation = "Crimson",

        AcceptPosition = Vector3.new(-1019, -336, -4332),
        AcceptRotationY = 0,
        AcceptDialogArgs = { 3, 1 },

        SubmitPosition = Vector3.new(-1019, -336, -4332),
        SubmitRotationY = 0,

        SubmitPositionCheckDistance = 8,
        SubmitTeleportMaxTries = 10,
        SubmitTeleportRetryDelay = 0.4,

        RerollPosition = Vector3.new(453, 151, 209),
        RerollRotationY = 0,

        MinMoneyToReroll = 1000000,

        CheckDelay = 5,
        ActionDelay = 0.6,

      
        HoldBeforeRerollDelay = 5,

       
        RerollFireCount = 4,

      
        RerollFireDelay = 1,

        PreRerollDialogArgs = { 1, 1 },
        SubmitDialogArgs = { 1, 1 },
        RerollDialogArgs = { 6, 1 },

        RerollPositionCheckDistance = 8,
        RerollTeleportMaxTries = 8,
        RerollTeleportRetryDelay = 0.4,
        PreRerollDelay = 0.2,

        RequireFishEquippedBeforeReroll = true,

        EquipFishMaxTries = 10,
        EquipFishRetryDelay = 0.35,

        RerollAfterMoneyDecreaseDelay = 1,
        NoMoneyDecreaseRetryLimit = 5,
    },

    PostCrimsonFarm = {
        Enabled = true,

        TargetRod = "Luminescent Oath",
        TargetEnchant = "Blessed",

        Position = Vector3.new(-927, -365, -4843),
        RotationY = 0,

        CrabCage = {
            Enabled = true,

            TargetAmount = 50,
            BuyAmount = 50,

            PlaceDelay = 0.18,
            CheckDelay = 2,
            CollectDelay = 0.15,
            WaitAfterFullPlace = 300,

            PlaceCFrame = CFrame.new(
                -934.4000244140625, -370, -4852.39990234375,
                -0.7880113124847412, 0, -0.6156618595123291,
                0, 1, 0,
                0.6156618595123291, 0, -0.7880113124847412
            ),
        },
    },

    RuinousOath = {
        Enabled = true,

        TargetRod = "Ruinous Oath",

        LevelRequired = 750,
        MoneyRequired = 5000000,

        BuyPosition = Vector3.new(-1040, -330, -4895),
        BuyRotationY = 0,

        RequiredFish = {
            "Red Spotted Blenny",
            "Red Crabsquid",
            "Sea Raven",
            "Red Fangtooth",
            "Viperfish",
            "Japanese Dragon Eel",
            "Vampire Squid",
            "Colossal Ancient Dragon",
            "Lithodes Megacantha",
        },

        RequireShiny = true,
        RequireSparkling = true,

        CheckDelay = 5,
    },

    GreatRodFarm = {
        Position = Vector3.new(-1124, -342, -4144),
        RotationY = 0,
    },

    GreatRodSell = {
        Position = Vector3.new(-790, 125, -3100),
        RotationY = 0,
    },

    AuroraFarm = {
        Enabled = true,
        TargetWeather = "Aurora_Borealis",

        AuroraTotem = "Aurora Totem",
        SundialTotem = "Sundial Totem",

        CheckDelay = 10,
    },

    CrabCageFarm = {
        Enabled = true,

        ItemName = "Crab Cage",
        BuyAmount = 50,

        TargetAmount = 50,
        RefillBelow = 25,

        PlaceDelay = 0.18,
        CheckDelay = 2,
        CollectDelay = 0.15,

        WaitAfterFullPlace = 300,

        PlaceCFrame = CFrame.new(
            -1116.0999755859375, -345.1000061035156, -4142,
            -0.8571678996086121, 0, 0.5150383710861206,
            0, 1, 0,
            -0.5150383710861206, 0, -0.8571678996086121
        ),
    },

    Enchant = {
        Enabled = true,

        RequiredItem = "Enchant Relic",

        CarrotRod = {
            TargetRod = "Carrot Rod",
            EnchantsToKeep = {
                ["Clever"] = true,
            },
        },

        GreatRodOscar = {
            TargetRod = "Great Rod of Oscar",
            EnchantsToKeep = {
                ["Clever"] = true,
            },
        },

        LuminescentOath = {
            TargetRod = "Luminescent Oath",
            EnchantsToKeep = {
                ["Blessed"] = true,
            },
        },
    },
}

local ExternalConfig = getgenv().KaitunConfig

local function DeepMerge(target, source)
    if typeof(target) ~= "table" or typeof(source) ~= "table" then
        return target
    end

    for key, value in pairs(source) do
        if typeof(value) == "table" and typeof(target[key]) == "table" then
            DeepMerge(target[key], value)
        else
            target[key] = value
        end
    end

    return target
end

if ExternalConfig and typeof(ExternalConfig) == "table" then

    DeepMerge(DefaultConfig, ExternalConfig)

    if ExternalConfig.CrabCage and typeof(ExternalConfig.CrabCage) == "table" then
        if DefaultConfig.CrabCageFarm then
            DeepMerge(DefaultConfig.CrabCageFarm, ExternalConfig.CrabCage)
        end

        if DefaultConfig.PostCrimsonFarm
            and DefaultConfig.PostCrimsonFarm.CrabCage then

            DeepMerge(DefaultConfig.PostCrimsonFarm.CrabCage, ExternalConfig.CrabCage)
        end
    end


    if DefaultConfig.AuroraFarm then
        if DefaultConfig.AuroraFarm.Enable ~= nil
            and DefaultConfig.AuroraFarm.Enabled == nil then

            DefaultConfig.AuroraFarm.Enabled = DefaultConfig.AuroraFarm.Enable
        end
    end
end

getgenv().KaitunConfig = DefaultConfig

local Config = getgenv().KaitunConfig

if Config.Debug ~= nil then
    DebugEnabled = Config.Debug
end
local IsSellingNow = false
local IsEnchantingNow = false
local IsUsingTotemNow = false
local IsCrabCageNow = false
local IsCrimsonRerollNow = false
local IsFinalFarmActive = false
local LastTotemUseTime = 0

LastRodEquipAttempt = 0
LastRodEquipTarget = nil
RodEquipCooldown = 1.2

function HasLuminescentOath()
    return HasRod and HasRod("Luminescent Oath", true)
end

function HasRuinousOath()
    return HasRod and HasRod("Ruinous Oath", true)
end

function ShouldLockToLuminescentOath()
    if HasRuinousOath() then
        return false
    end

    return HasLuminescentOath()
end

local function IsAnySpecialActionRunning()
    return IsSellingNow
        or IsEnchantingNow
        or IsUsingTotemNow
        or IsCrabCageNow
        or IsCrimsonRerollNow
end

local RodCache = {}
local LastRodCacheUpdate = 0
local RodCacheDelay = 1.5

local function IsRodLikeName(name)
    local lower = tostring(name):lower()

    return lower:find("rod", 1, true)
        or lower:find("twig", 1, true)
        or lower:find("cavern", 1, true)
        or lower:find("oscar", 1, true)
        or lower:find("oath", 1, true)
        or lower:find("luminescent", 1, true)
        or lower:find("ruinous", 1, true)
end

local function RefreshRodCache(force)
    if not force and tick() - LastRodCacheUpdate < RodCacheDelay then
        return
    end

    LastRodCacheUpdate = tick()

    local found = {}

    local function scanTools(container)
        if not container then
            return
        end

        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and IsRodLikeName(item.Name) then
                found[item.Name] = true
            end
        end
    end

    scanTools(LocalPlayer:FindFirstChild("Backpack"))
    scanTools(LocalPlayer.Character)

    -- [PERF FIX] ตัด PlayerGui:GetDescendants() scan ออก
    -- rod จริงอยู่ใน Backpack/Character เสมอ GUI scan ไม่จำเป็น

    RodCache = found
end

function HasRod(rodName, forceRefresh)
    RefreshRodCache(forceRefresh == true)
    return RodCache[rodName] == true
end

GetOwnedRods = function(forceRefresh)
    RefreshRodCache(forceRefresh == true)
    return RodCache
end

function GetCurrentEquippedRod()
    local character = LocalPlayer.Character

    if not character then
        return nil
    end

    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") and IsRodLikeName(item.Name) then
            return item.Name
        end
    end

    return nil
end

local SettingsEditRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RE/Settings/Edit")

local function SetupAutoSellSettings()
    local args = {
        "autosell",
        {
            Unusual = true,
            Mythical = true,
            Special = true,
            Limited = true,
            Rare = true,
            Fragment = false,
            Gemstone = false,
            Trash = true,
            Common = true,
            Uncommon = true,
            Secret = true,
            Extinct = false,
            Legendary = true,
            Relic = false,
            Seed = false,
            Apex = false,
            ["Divine Secret"] = false,
            Exotic = false,
            Crates = false,
        },
    }

    pcall(function()
        SettingsEditRemote:FireServer(unpack(args))
    end)

    DebugPrint("Auto Sell setting sent")
end

SetupAutoSellSettings()

warn("[Kaitun Fisch] Script passed AutoSell setup")

local AutoShake = Config.Fishing.AutoShake

local function GetShakeButton()
    local shakeui = Players.LocalPlayer:FindFirstChild("PlayerGui")
        and Players.LocalPlayer.PlayerGui:FindFirstChild("shakeui")

    if not shakeui then
        return nil
    end

    local safezone = shakeui:FindFirstChild("safezone")
    if not safezone then
        return nil
    end

    local button = safezone:FindFirstChild("button")
    if not button then
        return nil
    end

    if not button.Visible then
        return nil
    end

    if button.AbsoluteSize.X <= 0 or button.AbsoluteSize.Y <= 0 then
        return nil
    end

    return button
end

local function ClickShakeButton(button)
    if not button then
        return
    end

    if not button.Visible then
        return
    end

    if button.AbsoluteSize.X <= 0 or button.AbsoluteSize.Y <= 0 then
        return
    end

    pcall(function()
        for _, connection in ipairs(getconnections(button.Activated)) do
            connection:Fire()
        end
    end)
end

local function GetFishSelectionButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local fishSelection = playerGui and playerGui:FindFirstChild("FishSelection")
    local list = fishSelection and fishSelection:FindFirstChild("List")
    local slot = list and list:FindFirstChild("1")
    local button = slot and slot:FindFirstChild("Button")

    if button and button.Visible and button.AbsoluteSize.X > 0 and button.AbsoluteSize.Y > 0 then
        return button
    end

    return nil
end

local function ClickGuiButton(button)
    if not button then
        return
    end

    if not button.Visible then
        return
    end

    pcall(function()
        for _, connection in ipairs(getconnections(button.Activated)) do
            connection:Fire()
        end
    end)
end

task.spawn(function()
    while task.wait(0.1) do
        if AutoShake
            and not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrimsonRerollNow then

            local button = GetShakeButton()
            if button then
                ClickShakeButton(button)
            end
        end
    end
end)

local FishSelectionDetectedAt = nil

task.spawn(function()
    while task.wait(0.25) do
        if HasRod("Splitbranch Twig")
            and not HasRod("Carrot Rod")
            and not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrimsonRerollNow then

            local button = GetFishSelectionButton()

            if button then
                if not FishSelectionDetectedAt then
                    FishSelectionDetectedAt = tick()
                end

                if tick() - FishSelectionDetectedAt >= 1 then
                    ClickGuiButton(button)
                    FishSelectionDetectedAt = nil
                end
            else
                FishSelectionDetectedAt = nil
            end
        else
            FishSelectionDetectedAt = nil
        end
    end
end)


local AutoCast = Config.Fishing.AutoCast
local AutoCastMode = Config.Fishing.AutoCastMode
local AutoCastDelay = Config.Fishing.AutoCastDelay
local InstantBobber = Config.Fishing.InstantBobber
local InstantBobberForce = Config.Fishing.InstantBobberForce
local InstantBobberDuration = Config.Fishing.InstantBobberDuration
local LastBobber = nil

local CastRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RF/FishingRod/Cast")

local ReelFinishedRemote = ReplicatedStorage
    :WaitForChild("events")
    :WaitForChild("reelfinished")



local function HasShakeUI()
    local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local shakeui = playerGui and playerGui:FindFirstChild("shakeui")
    if not shakeui or shakeui.Enabled == false then
        return false
    end

    local safezone = shakeui:FindFirstChild("safezone")
    local button = safezone and safezone:FindFirstChild("button")

    if button and button.Visible and button.AbsoluteSize.X > 0 and button.AbsoluteSize.Y > 0 then
        return true
    end

    return false
end

-- [PERF FIX] cache ref แทน GetDescendants poll ทุก 120ms
local _reelFishRef = nil

task.spawn(function()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 30)
    if not playerGui then return end

    local function checkObj(obj)
        if obj.Name == "fish" and obj.Parent and obj.Parent:FindFirstChild("playerbar") then
            _reelFishRef = obj
        end
    end

    for _, obj in ipairs(playerGui:GetDescendants()) do
        checkObj(obj)
    end

    playerGui.DescendantAdded:Connect(checkObj)
    playerGui.DescendantRemoving:Connect(function(obj)
        if obj == _reelFishRef then
            _reelFishRef = nil
        end
    end)
end)

local function HasReelGui()
    if _reelFishRef and _reelFishRef.Parent then
        return true
    end
    _reelFishRef = nil
    return false
end

local function FindMyBobber()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and IsRodLikeName(tool.Name) then
            local bobber = tool:FindFirstChild("bobber", true)
            if bobber and bobber:IsA("BasePart") then
                return bobber
            end
        end
    end

    return nil
end

local function ApplyInstantBobber(bobber)
    if not bobber or not bobber.Parent then
        return
    end

    task.spawn(function()
        local startTime = tick()

        while tick() - startTime < InstantBobberDuration do
            if not InstantBobber then
                break
            end

            if IsSellingNow or IsEnchantingNow or IsUsingTotemNow or IsCrabCageNow or IsCrimsonRerollNow then
                break
            end

            if not bobber or not bobber.Parent then
                break
            end

            bobber.AssemblyLinearVelocity = Vector3.new(0, InstantBobberForce, 0)
            bobber.AssemblyAngularVelocity = Vector3.zero

            task.wait()
        end

        DebugPrint("[Instant Bobber] Applied")
    end)
end

task.spawn(function()
    while task.wait(AutoCastDelay) do
        if IsSellingNow
            or IsEnchantingNow
            or IsUsingTotemNow
            or IsCrabCageNow
            or IsCrimsonRerollNow
            or not AutoCast then

            continue
        end

        pcall(function()
            local castPower = 100
            local perfectCast = true

            if AutoCastMode == "Random" then
                castPower = math.random(50, 100)
                perfectCast = false
            end

            CastRemote:InvokeServer(castPower, perfectCast)
        end)
    end
end)

task.spawn(function()
    while task.wait(0.08) do
        if InstantBobber
            and not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrabCageNow
            and not IsCrimsonRerollNow then

            local bobber = FindMyBobber()

            if bobber and bobber ~= LastBobber then
                LastBobber = bobber
                ApplyInstantBobber(bobber)
            end
        else
            LastBobber = nil
        end
    end
end)


local AutoEquipRod = Config.Fishing.AutoEquipRod

local RodEquipRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RF/Rod/Equip")

local function FindRodToolByName(rodName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character

    local function scan(container)
        if not container then
            return nil
        end

        local tool = container:FindFirstChild(rodName)
        if tool and tool:IsA("Tool") then
            return tool
        end

        return nil
    end

    return scan(character) or scan(backpack)
end

local RodPriority = {
    "Ruinous Oath",
    "Luminescent Oath",
    "Great Rod of Oscar",
    "Carrot Rod",
    "Splitbranch Twig",
    "Flimsy Rod",
}

local function GetBestRodToEquip()
    local ownedRods = GetOwnedRods(false)

    if ownedRods["Ruinous Oath"] then
        return "Ruinous Oath"
    end

    -- หลังมี Luminescent Oath ให้ล็อกเป็น Luminescent Oath เท่านั้น
    if ownedRods["Luminescent Oath"] then
        return "Luminescent Oath"
    end

    for _, rodName in ipairs(RodPriority) do
        if ownedRods[rodName] then
            return rodName
        end
    end

    return nil
end

local function FindAnyRodTool()
    local targetRod = GetBestRodToEquip()

    if targetRod then
        local specificRod = FindRodToolByName(targetRod)
        if specificRod then
            return specificRod
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character

    local function scan(container)
        if not container then
            return nil
        end

        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and IsRodLikeName(item.Name) then
                return item
            end
        end

        return nil
    end

    return scan(character) or scan(backpack)
end

local function EquipAnyRod()
    local character = LocalPlayer.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    local targetRod = GetBestRodToEquip()

    if not targetRod then
        return
    end

    local equippedRod = GetCurrentEquippedRod()

    if equippedRod == targetRod then
        return
    end

    DebugPrint(
        "[Equip Rod] Current =",
        tostring(equippedRod),
        "Target =",
        targetRod
    )

    humanoid:UnequipTools()

    task.wait(0.2)

    local rod = FindRodToolByName(targetRod)

    if not rod then
        DebugPrint("[Equip Rod] Remote equip:", targetRod)

        pcall(function()
            RodEquipRemote:InvokeServer(targetRod)
        end)

        task.wait(0.6)

        rod = FindRodToolByName(targetRod)
    end

    if rod then
        humanoid:EquipTool(rod)

        task.wait(0.2)

        local finalRod = GetCurrentEquippedRod()

        DebugPrint(
            "[Equip Rod] Equipped:",
            tostring(finalRod)
        )
    else
        DebugPrint("[Equip Rod] Rod not found:", targetRod)
    end
end


task.spawn(function()
    while task.wait(1.5) do
        if AutoEquipRod
            and not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrabCageNow
            and not IsCrimsonRerollNow then

            EquipAnyRod()
        end
    end
end)

local AutoFish = Config.Fishing.AutoFish
local InstantReel = Config.Fishing.InstantReel
local PerfectCatchChance = Config.Fishing.PerfectCatchChance
local ReelSnapChance = Config.Fishing.ReelSnapChance
local ReelTime = Config.Fishing.ReelTime
local WhiteBarSize = Config.Fishing.WhiteBarSize

local ReelControllerModule = nil

pcall(function()
    local client = ReplicatedStorage:WaitForChild("client", 10)
    local legacyControllers = client and client:WaitForChild("legacyControllers", 10)
    local reelController = legacyControllers and legacyControllers:WaitForChild("ReelController", 10)

    if reelController then
        ReelControllerModule = require(reelController)
    end
end)

if not ReelControllerModule then
    warn("[Kaitun Fisch] ReelControllerModule not found, AutoFish/InstantReel disabled")
    AutoFish = false
    InstantReel = false
end

ReelFeatureLastToggle = 0
local LastBarApply = 0
local CurrentReelStart = nil
local LastReelObject = nil
local LastProgress = nil
local LastActiveState = nil

local function IsValidReel(reel)
    return typeof(reel) == "table"
        and rawget(reel, "barSize") ~= nil
        and rawget(reel, "progress") ~= nil
        and rawget(reel, "fishmove") ~= nil
        and rawget(reel, "fishPosition") ~= nil
end

local function GetReelController()
    if not ReelControllerModule then
        return nil
    end

    local reel = rawget(ReelControllerModule, "ActiveReel")

    if IsValidReel(reel) then
        return reel
    end

    return nil
end

local function ApplyAutoFish()
    local reel = GetReelController()
    if not reel then
        return
    end

    if tick() - LastBarApply < 0.2 then
        return
    end

    LastBarApply = tick()

    reel.barSize = WhiteBarSize
    reel.minBarSize = WhiteBarSize
    reel.barPosition = 0.5
    reel.fishPosition = 0.5
    reel.perfect = true
    reel.onbar = true
end







local function RollChance(chance)
    return math.random(1, 100) <= chance
end

local function ApplyInstantReel()
    local reel = GetReelController()

    if not reel then
        CurrentReelStart = nil
        LastReelObject = nil
        LastProgress = nil
        LastActiveState = nil
        return
    end

    local progress = tonumber(reel.progress) or 0
    local active = reel.active

    local isNewRound = false

    if reel ~= LastReelObject then
        isNewRound = true
    elseif LastProgress and progress < LastProgress then
        isNewRound = true
    elseif LastActiveState == false and active == true then
        isNewRound = true
    end

    if isNewRound then
        LastReelObject = reel
        CurrentReelStart = tick()
        LastProgress = progress
        LastActiveState = active
        return
    end

    LastProgress = progress
    LastActiveState = active

    if not CurrentReelStart then
        CurrentReelStart = tick()
        return
    end

    if ReelTime > 0 and tick() - CurrentReelStart < ReelTime then
        return
    end

    local isSnap = RollChance(ReelSnapChance)
    local isPerfect = RollChance(PerfectCatchChance)

    if isSnap then
        reel.progress = 0
        reel.perfect = false
    else
        reel.progress = 100
        reel.targetProgress = 100
        reel.perfect = isPerfect
        reel.onbar = true
    end

    CurrentReelStart = nil
    LastReelObject = nil
    LastProgress = nil
    LastActiveState = nil
end

task.spawn(function()
    while task.wait(0.12) do
        if not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrimsonRerollNow
            and AutoFish then

            ApplyAutoFish()
        end

        if not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrimsonRerollNow
            and InstantReel then

            ApplyInstantReel()
        end

        if not AutoFish and not InstantReel then
            CurrentReelStart = nil
            LastReelObject = nil
            LastProgress = nil
            LastActiveState = nil
        end
    end
end)


local FreezePosition = Config.Fishing.FreezePosition
local FrozenCFrame = nil

local function TeleportToFarm()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    local farmCFrame =
        CFrame.new(Config.Farm.Position)
        * CFrame.Angles(0, math.rad(Config.Farm.RotationY), 0)

    root.CFrame = farmCFrame
    FrozenCFrame = farmCFrame

    DebugPrint("Teleport to farm:", Config.TargetRod)
end

task.spawn(function()
    task.wait(2)

    if not Config.Farm.Enabled then
        return
    end

    if not HasRod("Carrot Rod") then
        DebugPrint("Teleport farm for progression")
        TeleportToFarm()
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if FreezePosition
            and not IsSellingNow
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrimsonRerollNow then

            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root and FrozenCFrame then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                local distance = (root.Position - FrozenCFrame.Position).Magnitude

                if distance > 2 then
                    root.CFrame = FrozenCFrame
                elseif distance > 0.4 then
                    root.CFrame = root.CFrame:Lerp(FrozenCFrame, 0.08)
                end
            end
        end
    end
end)


AutoSpearFish = false
SpearDelay = 0.5

local SpearMinigameRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RE/SpearFishing/Minigame")

local CachedWaterPart = nil
local LastWaterPartSearch = 0
local CachedUIDList = {}
local LastUIDScan = 0

local function GetCurrentWaterPart()
    local character = Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local spearWater = workspace:FindFirstChild("Spearfishing Water")

    if not root or not spearWater then
        CachedWaterPart = nil
        return nil
    end

    if CachedWaterPart
        and CachedWaterPart.Parent
        and os.clock() - LastWaterPartSearch < 5 then
        return CachedWaterPart
    end

    LastWaterPartSearch = os.clock()

    local closestPart = nil
    local closestDistance = math.huge

    for _, waterPart in ipairs(spearWater:GetChildren()) do
        if waterPart:IsA("BasePart") then
            local distance = (root.Position - waterPart.Position).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPart = waterPart
            end
        end
    end

    CachedWaterPart = closestPart
    return closestPart
end

local function GetSpearFishUIDs()
    if os.clock() - LastUIDScan < 0.35 then
        return CachedUIDList
    end

    LastUIDScan = os.clock()
    CachedUIDList = {}

    local waterPart = GetCurrentWaterPart()
    if not waterPart then
        return CachedUIDList
    end

    local zoneFish = waterPart:FindFirstChild("ZoneFish")
    if not zoneFish then
        return CachedUIDList
    end

    for _, fishModel in ipairs(zoneFish:GetChildren()) do
        local uid = fishModel:GetAttribute("UID")

        if uid then
            table.insert(CachedUIDList, {
                UID = uid,
                Name = fishModel.Name,
                Path = fishModel:GetFullName()
            })
        end
    end

    return CachedUIDList
end

local function FireSpearFish(uid)
    if not uid then
        return
    end

    pcall(function()
        SpearMinigameRemote:FireServer(uid)
    end)

    task.wait(0.5)

    pcall(function()
        SpearMinigameRemote:FireServer(uid, true)
    end)
end



task.spawn(function()
    while task.wait(0.15) do
        if AutoSpearFish then
            local uidList = GetSpearFishUIDs()

            for _, fishData in ipairs(uidList) do
                if not AutoSpearFish then
                    break
                end

                FireSpearFish(fishData.UID)
                task.wait(SpearDelay)
            end
        else
            CachedUIDList = {}
            CachedWaterPart = nil
        end
    end
end)


AutoSell = true
SellDelay = 90

local SellRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("events")
    :WaitForChild("Sell")

local SellAllRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("events")
    :WaitForChild("SellAll")

local function GetMerchantArgs()
    local npcFolder = workspace:WaitForChild("world"):WaitForChild("npcs")

    for _, npc in ipairs(npcFolder:GetChildren()) do
        if string.find(string.lower(npc.Name), "merchant") then

            local idle = npc:FindFirstChild("description")
                and npc.description:FindFirstChild("idle")

            local uid = npc:GetAttribute("uid")
                or npc:GetAttribute("UID")
                or npc:GetAttribute("NpcId")
                or npc:GetAttribute("npc_id")

            if not uid then
                uid = string.lower(npc.Name)
                    :gsub("%s+", "_")
                    :gsub("merchant_", "merchant_")
            end

            return {
                {
                    voice = 12,
                    uid = uid,
                    npc = npc,
                    idle = idle
                }
            }
        end
    end

    warn("Merchant NPC not found")
    return nil
end

local function SellHand()
    pcall(function()
        SellRemote:InvokeServer(unpack(GetMerchantArgs()))
    end)
end

local function SellAll()
    pcall(function()
        SellAllRemote:InvokeServer(unpack(GetMerchantArgs()))
    end)
end

local function SetFishingState(state)
    AutoShake = state and Config.Fishing.AutoShake or false
    AutoCast = state and Config.Fishing.AutoCast or false
    AutoEquipRod = state and Config.Fishing.AutoEquipRod or false
    AutoFish = state and Config.Fishing.AutoFish or false
    InstantReel = state and Config.Fishing.InstantReel or false
    FreezePosition = state and Config.Fishing.FreezePosition or false

    if not state then
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if root then
            root.Anchored = false
        end
    end
end

local function TeleportToCFrame(position, rotationY)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    local targetCFrame =
        CFrame.new(position)
        * CFrame.Angles(0, math.rad(rotationY or 0), 0)

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = targetCFrame

    return targetCFrame
end

local function IsNearPosition(position, distance)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false, math.huge
    end

    local currentDistance = (root.Position - position).Magnitude

    return currentDistance <= distance, currentDistance
end

local function TeleportUntilNear(position, rotationY, distance, maxTries, retryDelay)
    distance = distance or 8
    maxTries = maxTries or 8
    retryDelay = retryDelay or 0.4

    local finalCFrame = nil

    for i = 1, maxTries do
        finalCFrame = TeleportToCFrame(position, rotationY)

        if finalCFrame then
            FrozenCFrame = finalCFrame
        end

        task.wait(retryDelay)

        local isNear, currentDistance = IsNearPosition(position, distance)

        DebugPrint(
            "[Teleport Check]",
            "Try:",
            i,
            "/",
            maxTries,
            "Distance:",
            currentDistance,
            "Near:",
            isNear
        )

        if isNear then
            return true, finalCFrame
        end
    end

    return false, finalCFrame
end

local function DoSellCycle()
    if IsSellingNow
        or IsEnchantingNow
        or IsUsingTotemNow
        or IsCrabCageNow
        or IsCrimsonRerollNow then

        return
    end

    IsSellingNow = true
    DebugPrint("Sell cycle started")

    SetFishingState(false)

    task.wait(0.3)

    local usingCarrotFarm =
        HasRod("Carrot Rod")
        and not HasRod("Great Rod of Oscar")

    if usingCarrotFarm and Config.CarrotRodFarm.SellAtFarm then
        DebugPrint("Selling directly at CarrotRodFarm")

        task.wait(0.5)
        SellAll()

        task.wait(0.5)

        local farmCFrame = TeleportToCFrame(
            Config.CarrotRodFarm.Position,
            Config.CarrotRodFarm.RotationY
        )

        if farmCFrame then
            FrozenCFrame = farmCFrame
        end
    else
        local sellPosition = Config.Sell.Position
        local sellRotation = Config.Sell.RotationY

        if HasRod("Great Rod of Oscar") then
            sellPosition = Config.GreatRodSell.Position
            sellRotation = Config.GreatRodSell.RotationY
        end

        local sellCFrame = TeleportToCFrame(
            sellPosition,
            sellRotation
        )

        task.wait(2)

        SellAll()

        task.wait(Config.Sell.ReturnDelay or 1)

        local returnPosition = Config.Farm.Position
        local returnRotation = Config.Farm.RotationY

        if HasRod("Great Rod of Oscar") then
            returnPosition = Config.GreatRodFarm.Position
            returnRotation = Config.GreatRodFarm.RotationY

        elseif HasRod("Carrot Rod") then
            returnPosition = Config.CarrotRodFarm.Position
            returnRotation = Config.CarrotRodFarm.RotationY
        end

        local farmCFrame = TeleportToCFrame(
            returnPosition,
            returnRotation
        )

        if farmCFrame then
            FrozenCFrame = farmCFrame
        end
    end

    task.wait(0.3)

    SetFishingState(true)

    IsSellingNow = false
    DebugPrint("Sell cycle finished")
end

task.spawn(function()
    while task.wait(1) do
        if Config.Sell.Enabled
            and not IsEnchantingNow
            and not IsUsingTotemNow
            and not IsCrabCageNow
            and not IsCrimsonRerollNow then

            task.wait(Config.Sell.Delay)

            if Config.Sell.Enabled
                and not IsEnchantingNow
                and not IsUsingTotemNow
                and not IsCrabCageNow
                and not IsCrimsonRerollNow then

                DoSellCycle()
            end
        end
    end
end)

local PurchaseRemote = ReplicatedStorage
    :WaitForChild("events")
    :WaitForChild("purchase")

local CrabCagePlaceRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RF/CrabCage/Place")

local CrabCageClaimRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RF/CrabCage/Claim")

local GetItemTool

local function BuyTotemIfMissing(totemName)
    if GetItemTool(totemName) then
        return true
    end

    if totemName ~= "Sundial Totem" and totemName ~= "Aurora Totem" then
        return false
    end

    if tick() - LastTotemUseTime < 5 then
        return false
    end

    pcall(function()
        PurchaseRemote:FireServer(totemName, "Item", nil, 1)
    end)

    task.wait(1)

    return GetItemTool(totemName) ~= nil
end

local BuyingRodNow = false

local function GetMoney()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    local money = leaderstats and leaderstats:FindFirstChild("C$")

    if money and typeof(money.Value) == "number" then
        return money.Value
    end

    return 0
end

local function GetLevel()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    local level = leaderstats and leaderstats:FindFirstChild("Level")

    if level and typeof(level.Value) == "number" then
        return level.Value
    end

    return 0
end

local function HasItem(itemName)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if character and character:FindFirstChild(itemName) then
        return true
    end

    if backpack and backpack:FindFirstChild(itemName) then
        return true
    end

    return false
end

function GetItemTool(itemName)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    return (character and character:FindFirstChild(itemName))
        or (backpack and backpack:FindFirstChild(itemName))
end

local CrabCageBusy = false
local LastCrabCageAction = 0
local LastCrabCageFullPlace = 0

local function GetCrabCageFolder()
    local active = workspace:FindFirstChild("active")

    if not active then
        DebugPrint("[Crab Cage Debug] workspace.active not found")
        return nil
    end

    local folder =
        active:FindFirstChild("crabcages")
        or active:FindFirstChild("CrabCages")
        or active:FindFirstChild("CrabCage")

    if not folder then
        DebugPrint("[Crab Cage Debug] crabcages folder not found")

        for _, child in ipairs(active:GetChildren()) do
            DebugPrint("[Crab Cage Debug] active child:", child.Name, child.ClassName)
        end

        return nil
    end

    DebugPrint("[Crab Cage Debug] Folder found:", folder:GetFullName(), "Count:", #folder:GetChildren())

    return folder
end

local function GetPlacedCrabCages()
    local folder = GetCrabCageFolder()
    if not folder then
        return {}
    end

    return folder:GetChildren()
end

local function CountPlacedCrabCages()
    return #GetPlacedCrabCages()
end

local function GetCrabCageTool()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    local function scan(container)
        if not container then
            return nil
        end

        return container:FindFirstChild("Crab Cages")
            or container:FindFirstChild("Crab Cage")
    end

    return scan(character) or scan(backpack)
end

local function BuyCrabCages()
    pcall(function()
        PurchaseRemote:FireServer(
            "Crab Cage",
            "Item",
            nil,
            Config.CrabCageFarm.BuyAmount
        )
    end)

    DebugPrint("[Crab Cage] Buy sent:", Config.CrabCageFarm.BuyAmount)
    task.wait(1)
end

local function EquipCrabCages()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return false
    end

    local tool = GetCrabCageTool()

    if not tool then
        BuyCrabCages()
        task.wait(0.5)
        tool = GetCrabCageTool()
    end

    if not tool then
        DebugPrint("[Crab Cage] Tool not found after buy")
        return false
    end

    humanoid:UnequipTools()
    task.wait(0.2)

    if tool.Parent ~= character then
        humanoid:EquipTool(tool)
        task.wait(0.35)
    end

    return true
end

local function UnequipAllTools()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:UnequipTools()
        task.wait(0.2)
    end
end

local function PlaceCrabCagesToTarget()
    if CountPlacedCrabCages() >= Config.CrabCageFarm.TargetAmount then
        return true
    end

    if not EquipCrabCages() then
        return false
    end

    local failCount = 0

    while CountPlacedCrabCages() < Config.CrabCageFarm.TargetAmount do
        if not Config.CrabCageFarm.Enabled then
            break
        end

        local before = CountPlacedCrabCages()

        pcall(function()
            CrabCagePlaceRemote:InvokeServer(
                Config.CrabCageFarm.PlaceCFrame,
                0
            )
        end)

        task.wait(Config.CrabCageFarm.PlaceDelay)

        local after = CountPlacedCrabCages()

        if after <= before then
            failCount += 1
        else
            failCount = 0
        end

        if failCount >= 10 then
            DebugPrint("[Crab Cage] Place failed too many times")
            break
        end
    end

    local finalCount = CountPlacedCrabCages()

    DebugPrint("[Crab Cage] Current placed:", finalCount)

    if finalCount >= Config.CrabCageFarm.TargetAmount then
        LastCrabCageFullPlace = tick()

        DebugPrint(
            "[Crab Cage] Full placed, waiting",
            Config.CrabCageFarm.WaitAfterFullPlace,
            "seconds before claim"
        )
    end

    return finalCount >= Config.CrabCageFarm.TargetAmount
end

local function TryClaimCrabCage(cage)
    if not cage or not cage.Parent then
        return false
    end

    local cageName = tostring(cage.Name)

    DebugPrint("[Crab Cage Debug] Try claim:", cageName)

    local success, result = pcall(function()
        return CrabCageClaimRemote:InvokeServer(cageName)
    end)

    DebugPrint(
        "[Crab Cage Debug] Claim result:",
        cageName,
        success,
        tostring(result)
    )

    if success then
        task.wait(Config.CrabCageFarm.CollectDelay or 0.15)

        local stillExists = cage.Parent ~= nil

        DebugPrint(
            "[Crab Cage Debug] After claim:",
            cageName,
            "Still exists:",
            stillExists
        )

        if not stillExists then
            DebugPrint("[Crab Cage] Claimed:", cageName)
            return true
        end
    end

    return false
end

local function ClaimAllReadyCrabCages()
    local cages = GetPlacedCrabCages()

    DebugPrint("[Crab Cage Debug] Total cages:", #cages)

    local claimed = 0

    for _, cage in ipairs(cages) do
        if cage and cage.Parent then
            local success = TryClaimCrabCage(cage)

            if success then
                claimed += 1
            end
        end
    end

    DebugPrint("[Crab Cage] Total claimed:", claimed)

    return claimed
end

local HasAllLuminescentFish
local HasBestiaryFish

local function ShouldStopCrabCageFarm()
    return HasBestiaryFish("Electric Blue Seahorse")
        and HasBestiaryFish("Dinoflagellates")
end

local function ShouldRunCrabCageFarm()
    if ShouldStopCrabCageFarm() then
        Config.CrabCageFarm.Enabled = false

        DebugPrint("[Crab Cage] Stop: target fish found")

        return false
    end

    if not Config.CrabCageFarm.Enabled then
        DebugPrint("[Crab Cage Debug] Blocked: Config disabled")
        return false
    end

    if IsSellingNow then
        DebugPrint("[Crab Cage Debug] Blocked: IsSellingNow")
        return false
    end

    if IsEnchantingNow then
        DebugPrint("[Crab Cage Debug] Blocked: IsEnchantingNow")
        return false
    end

    if IsUsingTotemNow then
        DebugPrint("[Crab Cage Debug] Blocked: IsUsingTotemNow")
        return false
    end

    if IsCrabCageNow then
        DebugPrint("[Crab Cage Debug] Blocked: IsCrabCageNow")
        return false
    end

    if IsCrimsonRerollNow then
        DebugPrint("[Crab Cage Debug] Blocked: IsCrimsonRerollNow")
        return false
    end

    if not HasRod("Great Rod of Oscar") then
        DebugPrint("[Crab Cage Debug] Blocked: Missing Great Rod of Oscar")
        return false
    end

    if HasRod(Config.LuminescentCavern.TargetRod) then
        DebugPrint("[Crab Cage Debug] Blocked: Already has", Config.LuminescentCavern.TargetRod)
        return false
    end

    local hasAllLuminescentFish, missingFish = HasAllLuminescentFish()

    if hasAllLuminescentFish then
        DebugPrint("[Crab Cage Debug] Blocked: Luminescent fish complete")
        return false
    end

    DebugPrint("[Crab Cage Debug] Passed. Missing fish:", tostring(missingFish))

    return true
end

local function EquipAndUseTotem(totemName)
    if not BuyTotemIfMissing(totemName) then
        DebugPrint("[Totem] Missing:", totemName)
        return false
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local tool = GetItemTool(totemName)

    if not humanoid or not tool then
        return false
    end

    IsUsingTotemNow = true
    SetFishingState(false)

    humanoid:UnequipTools()
    task.wait(0.25)

    if tool.Parent ~= character then
        humanoid:EquipTool(tool)
        task.wait(0.4)
    end

    pcall(function()
        tool:Activate()
    end)

    LastTotemUseTime = tick()
    task.wait(1)

    return true
end

local DataController = nil
local BestiaryCache = nil
local BestiaryCacheSource = "None"
local LastBestiaryCacheUpdate = 0
local BestiaryCacheDelay = 1.5

local function LoadDataController()
    if DataController then
        return DataController
    end

    pcall(function()
        local client = ReplicatedStorage:WaitForChild("client", 10)
        local legacyControllers = client and client:WaitForChild("legacyControllers", 10)
        local dataControllerModule = legacyControllers and legacyControllers:WaitForChild("DataController", 10)

        if dataControllerModule then
            DataController = require(dataControllerModule)
        end
    end)

    return DataController
end

local function GetWorkspaceBestiaryFolder()
    local playerName = LocalPlayer.Name

    local playerStats = workspace:FindFirstChild("PlayerStats")
    local playerFolder = playerStats and playerStats:FindFirstChild(playerName)
    local tFolder = playerFolder and playerFolder:FindFirstChild("T")
    local innerPlayerFolder = tFolder and tFolder:FindFirstChild(playerName)
    local bestiary = innerPlayerFolder and innerPlayerFolder:FindFirstChild("Bestiary")

    return bestiary
end

local function ReadDataControllerBestiary()
    local controller = LoadDataController()

    if not controller then
        return nil
    end

    if not controller.BestiaryReplicator then
        return nil
    end

    if not controller.BestiaryReplicator.TryIndex then
        return nil
    end

    local success, bestiaryData = pcall(function()
        return controller.BestiaryReplicator:TryIndex({ "Bestiary" })
    end)

    if success and typeof(bestiaryData) == "table" then
        return bestiaryData
    end

    return nil
end

local function GetBestiaryData(forceRefresh)
    if not forceRefresh and tick() - LastBestiaryCacheUpdate < BestiaryCacheDelay then
        return BestiaryCache, BestiaryCacheSource
    end

    LastBestiaryCacheUpdate = tick()

    local dataControllerBestiary = ReadDataControllerBestiary()

    if dataControllerBestiary then
        BestiaryCache = dataControllerBestiary
        BestiaryCacheSource = "DataController"
        return BestiaryCache, BestiaryCacheSource
    end

    local workspaceBestiary = GetWorkspaceBestiaryFolder()

    if workspaceBestiary then
        BestiaryCache = workspaceBestiary
        BestiaryCacheSource = "Workspace"
        return BestiaryCache, BestiaryCacheSource
    end

    BestiaryCache = nil
    BestiaryCacheSource = "None"

    return nil, "None"
end

function HasBestiaryFish(fishName, includeGivenBy, forceRefresh)
    local bestiaryData, source = GetBestiaryData(forceRefresh == true)

    if not bestiaryData then
        DebugPrint("[Bestiary] Not found:", fishName)
        return false
    end

    -- วิธีหลัก: DataController.BestiaryReplicator
    if typeof(bestiaryData) == "table" then
        local fishData = bestiaryData[fishName]

        if not fishData then
            DebugPrint("[Bestiary]", fishName, "= false | Source =", source)
            return false
        end

        -- ตามระบบจริงของเกม ถ้าเป็น GivenBy จะยังไม่นับ เว้นแต่สั่ง includeGivenBy = true
        if fishData.GivenBy and not includeGivenBy then
            DebugPrint("[Bestiary]", fishName, "= false | GivenBy | Source =", source)
            return false
        end

        DebugPrint("[Bestiary]", fishName, "= true | Source =", source)
        return true
    end

    -- fallback แบบเก่า: workspace.PlayerStats
    if typeof(bestiaryData) == "Instance" then
        local found = bestiaryData:FindFirstChild(fishName) ~= nil

        DebugPrint("[Bestiary]", fishName, "=", found, "| Source =", source)

        return found
    end

    return false
end

local function DeepFindKeyValue(data, targetKey)
    if typeof(data) ~= "table" then
        return false
    end

    targetKey = tostring(targetKey):lower()

    for key, value in pairs(data) do
        local keyLower = tostring(key):lower()

        if keyLower == targetKey then
            if value == true then
                return true
            end

            if typeof(value) == "number" and value > 0 then
                return true
            end

            if typeof(value) == "string" and value ~= "" and value:lower() ~= "false" then
                return true
            end
        end

        if typeof(value) == "table" then
            if DeepFindKeyValue(value, targetKey) then
                return true
            end
        end
    end

    return false
end

local function HasBestiaryFishShinySparkling(fishName)
    local bestiaryData, source = GetBestiaryData(true)

    if not bestiaryData then
        DebugPrint("[Ruinous Oath] Bestiary not found:", fishName)
        return false, "NoBestiary"
    end

    local fishData = nil

    if typeof(bestiaryData) == "table" then
        fishData = bestiaryData[fishName]
    elseif typeof(bestiaryData) == "Instance" then
        fishData = bestiaryData:FindFirstChild(fishName)
    end

    if not fishData then
        DebugPrint("[Ruinous Oath] Missing fish:", fishName)
        return false, "MissingFish"
    end

    -- DataController table
    if typeof(fishData) == "table" then
        local hasShiny = DeepFindKeyValue(fishData, "Shiny")
        local hasSparkling = DeepFindKeyValue(fishData, "Sparkling")

        DebugPrint(
            "[Ruinous Oath]",
            fishName,
            "Shiny =",
            hasShiny,
            "Sparkling =",
            hasSparkling,
            "Source =",
            source
        )

        return hasShiny and hasSparkling, {
            Shiny = hasShiny,
            Sparkling = hasSparkling,
        }
    end

    -- Workspace fallback
    if typeof(fishData) == "Instance" then
        local hasShiny =
            fishData:GetAttribute("Shiny") == true
            or fishData:FindFirstChild("Shiny") ~= nil

        local hasSparkling =
            fishData:GetAttribute("Sparkling") == true
            or fishData:FindFirstChild("Sparkling") ~= nil

        DebugPrint(
            "[Ruinous Oath]",
            fishName,
            "Shiny =",
            hasShiny,
            "Sparkling =",
            hasSparkling,
            "Source =",
            source
        )

        return hasShiny and hasSparkling, {
            Shiny = hasShiny,
            Sparkling = hasSparkling,
        }
    end

    return false, "InvalidData"
end

function HasAllCrimsonShinySparklingFish()
    for _, fishName in ipairs(Config.RuinousOath.RequiredFish) do
        local ok, info = HasBestiaryFishShinySparkling(fishName)

        if not ok then
            return false, fishName, info
        end
    end

    return true, nil, nil
end

local function HasAllCarrotFish()
    for _, fishName in ipairs(Config.CarrotRod.RequiredFish) do
        if not HasBestiaryFish(fishName) then
            return false, fishName
        end
    end

    return true, nil
end

function HasAllLuminescentFish()
    for _, fishName in ipairs(Config.LuminescentCavern.RequiredFish) do
        if not HasBestiaryFish(fishName) then
            return false, fishName
        end
    end

    return true, nil
end

DialogInteractRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RF/DialogInteract")

CrimsonQuestBusy = false
CrimsonQuestFinished = false
LastCrimsonQuestAction = 0
DidAcceptCrimsonGuardQuest = false

function IsCrimsonCavernUnlocked()
    local controller = LoadDataController and LoadDataController()

    if not controller then
        return false
    end

    if not controller.PlayerDataReplicator then
        return false
    end

    local success, value = pcall(function()
        return controller.PlayerDataReplicator:TryIndex({
            "LuminescentCavern",
            "KeystoneData",
            "CrimsonCavernUnlocked"
        })
    end)

    return success and value == true
end

function GetInventoryData()
    local controller = LoadDataController and LoadDataController()

    if not controller then
        return nil
    end

    if not controller.InventoryReplicator then
        return nil
    end

    local success, inventoryData = pcall(function()
        return controller.InventoryReplicator:TryIndex({ "Inventory" })
    end)

    if success and typeof(inventoryData) == "table" then
        return inventoryData
    end

    return nil
end

function CleanInventoryItemName(rawKey, itemData)
    if typeof(itemData) == "table" then
        if typeof(itemData.Name) == "string" then
            return itemData.Name
        end

        if typeof(itemData.name) == "string" then
            return itemData.name
        end

        if typeof(itemData.sub) == "table" then
            if typeof(itemData.sub.Name) == "string" then
                return itemData.sub.Name
            end

            if typeof(itemData.sub.name) == "string" then
                return itemData.sub.name
            end
        end
    end

    return tostring(rawKey):gsub("%d+$", "")
end

function GetInventorySubData(itemData)
    if typeof(itemData) ~= "table" then
        return nil
    end

    if typeof(itemData.sub) == "table" then
        return itemData.sub
    end

    return itemData
end

function GetInventoryMutation(itemData)
    local sub = GetInventorySubData(itemData)

    if not sub then
        return nil
    end

    return sub.Mutation or sub.mutation
end

function FindInventoryFishByName(targetFishName)
    local inventoryData = GetInventoryData()

    if not inventoryData then
        return nil
    end

    local targetLower = tostring(targetFishName):lower()
    local bestMatch = nil

    for rawKey, itemData in pairs(inventoryData) do
        local itemName = CleanInventoryItemName(rawKey, itemData)

        if tostring(itemName):lower() == targetLower then
            local mutation = GetInventoryMutation(itemData)

            local data = {
                Key = tostring(rawKey),
                Name = itemName,
                Mutation = mutation,
                RawData = itemData,
            }

            if tostring(mutation):lower() == tostring(Config.CrimsonQuest.TargetMutation):lower() then
                return data
            end

            if not bestMatch then
                bestMatch = data
            end
        end
    end

    return bestMatch
end

function FindFishToolByInventoryData(fishData)
    if not fishData then
        return nil
    end

    local targetFishName = tostring(fishData.Name)
    local targetKey = tostring(fishData.Key)
    local targetKeyLower = targetKey:lower()
    local targetNameLower = targetFishName:lower()

    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    local containers = {
        character,
        backpack,
    }

    local nameFallback = nil

    local function objectHasMatchingAttribute(obj)
        if not obj then
            return false
        end

        for attrName, attrValue in pairs(obj:GetAttributes()) do
            local valueText = tostring(attrValue):lower()

            if valueText == targetKeyLower then
                return true
            end
        end

        return false
    end

    for _, container in ipairs(containers) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolNameLower = tostring(tool.Name):lower()

                    -- [PERF FIX] tool attrs first
                    if objectHasMatchingAttribute(tool) then
                        return tool
                    end

                    -- [PERF FIX] name match -> skip child scan
                    if toolNameLower:find(targetNameLower, 1, true) then
                        nameFallback = nameFallback or tool
                    else
                        -- GetChildren only, not GetDescendants
                        for _, obj in ipairs(tool:GetChildren()) do
                            if objectHasMatchingAttribute(obj) then
                                return tool
                            end
                        end
                    end
                end
            end
        end
    end

    return nameFallback
end

function EquipFishToolByInventoryData(fishData)
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return false
    end

    local tool = FindFishToolByInventoryData(fishData)

    if not tool then
        DebugPrint("[Crimson Quest] Fish tool not found:", fishData and fishData.Name)
        return false
    end

    humanoid:UnequipTools()
    task.wait(0.2)

    if tool.Parent ~= character then
        humanoid:EquipTool(tool)
        task.wait(0.35)
    end

    DebugPrint("[Crimson Quest] Equipped fish:", tool.Name)

    return true
end

function IsFishToolMatchingInventoryData(tool, fishData)
    if not tool or not fishData then
        return false
    end

    if not tool:IsA("Tool") then
        return false
    end

    local targetFishName = tostring(fishData.Name or "")
    local targetKey = tostring(fishData.Key or "")

    local targetNameLower = targetFishName:lower()
    local targetKeyLower = targetKey:lower()
    local toolNameLower = tostring(tool.Name):lower()

    -- [PERF FIX] tool attrs first (fast path)
    for _, attrValue in pairs(tool:GetAttributes()) do
        if tostring(attrValue):lower() == targetKeyLower then
            return true
        end
    end

    -- [PERF FIX] name match -> return immediately, skip descendants
    if targetNameLower ~= "" and toolNameLower:find(targetNameLower, 1, true) then
        return true
    end

    -- [PERF FIX] GetChildren only, not GetDescendants
    for _, obj in ipairs(tool:GetChildren()) do
        for _, attrValue in pairs(obj:GetAttributes()) do
            if tostring(attrValue):lower() == targetKeyLower then
                return true
            end
        end
    end

    return false
end

function IsFishEquippedByInventoryData(fishData)
    local character = LocalPlayer.Character

    if not character then
        return false
    end

    local currentTool = character:FindFirstChildOfClass("Tool")

    if not currentTool then
        return false
    end

    return IsFishToolMatchingInventoryData(currentTool, fishData)
end

function EnsureFishEquippedBeforeReroll(fishData)
    local maxTries = Config.CrimsonQuest.EquipFishMaxTries or 10
    local retryDelay = Config.CrimsonQuest.EquipFishRetryDelay or 0.35

    for i = 1, maxTries do
        if IsFishEquippedByInventoryData(fishData) then
            DebugPrint("[Crimson Quest] Fish already equipped and ready")
            return true
        end

        DebugPrint(
            "[Crimson Quest] Equipping fish before reroll...",
            i,
            "/",
            maxTries
        )

        EquipFishToolByInventoryData(fishData)

        task.wait(retryDelay)

        if IsFishEquippedByInventoryData(fishData) then
            DebugPrint("[Crimson Quest] Fish equipped confirmed")
            return true
        end
    end

    DebugPrint("[Crimson Quest] Failed to equip fish before reroll")

    return false
end

function PressEOnce()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

function AcceptCrimsonGuardQuest()
    if DidAcceptCrimsonGuardQuest then
        return true
    end

    if IsCrimsonCavernUnlocked() then
        DebugPrint("[Crimson Quest] Already unlocked, skip accept")
        CrimsonQuestFinished = true
        DidAcceptCrimsonGuardQuest = true
        return true
    end

    if not HasRod(Config.LuminescentCavern.TargetRod, true) then
        DebugPrint("[Crimson Quest] Cannot accept: missing", Config.LuminescentCavern.TargetRod)
        return false
    end

    DebugPrint("[Crimson Quest] Accept quest started")

    SetFishingState(false)
    task.wait(0.3)

    local questCFrame = TeleportToCFrame(
        Config.CrimsonQuest.AcceptPosition,
        Config.CrimsonQuest.AcceptRotationY
    )

    if questCFrame then
        FrozenCFrame = questCFrame
    end

    task.wait(Config.CrimsonQuest.ActionDelay or 0.6)

    PressEOnce()

    task.wait(0.4)

    local success, result = InvokeDialogArgs(Config.CrimsonQuest.AcceptDialogArgs)

    DebugPrint(
        "[Crimson Quest] Accept remote:",
        success,
        tostring(result)
    )

    task.wait(1)

    if success then
        DidAcceptCrimsonGuardQuest = true
        DebugPrint("[Crimson Quest] Accepted, next step will check dragon")
    else
        DebugPrint("[Crimson Quest] Accept failed, will retry later")
    end

    ReturnToGreatRodFarmForCrimson()

    return success
end

function ReturnToGreatRodFarmForCrimson()
    local farmCFrame = TeleportToCFrame(
        Config.GreatRodFarm.Position,
        Config.GreatRodFarm.RotationY
    )

    if farmCFrame then
        FrozenCFrame = farmCFrame
    end

    SetFishingState(true)
end

function InvokeDialogArgs(args)
    local success, result = pcall(function()
        return DialogInteractRemote:InvokeServer(unpack(args))
    end)

    return success, result
end

function WaitMoneyDecrease(beforeMoney, timeout)
    local startTime = tick()

    while tick() - startTime < timeout do
        local currentMoney = GetMoney()

        if currentMoney < beforeMoney then
            return true, currentMoney
        end

        task.wait(0.25)
    end

    return false, GetMoney()
end

function SubmitCrimsonDragon(fishData)
    DebugPrint("[Crimson Quest] Submit Crimson Dragon started")

    -- ใช้ flag นี้เพื่อกัน AutoCast / AutoEquip / Freeze / Sell / Crab Cage แทรก
    if IsCrimsonRerollNow then
        return false
    end

    IsCrimsonRerollNow = true

    local function finishSubmit(success, reason)
        IsCrimsonRerollNow = false

        if success then
            return true, reason
        end

        return false, reason
    end

    -- หยุดฟาร์มก่อนส่งเควส
    SetFishingState(false)

    AutoShake = false
    AutoCast = false
    AutoEquipRod = false
    AutoFish = false
    InstantReel = false
    FreezePosition = false
    LastBobber = nil

    task.wait(0.5)

    -- วาร์ปไปจุดส่งเควส และเช็คซ้ำจนกว่าจะอยู่ตรงจุดจริง
    local reachedSubmitPoint = TeleportUntilNear(
        Config.CrimsonQuest.SubmitPosition,
        Config.CrimsonQuest.SubmitRotationY,
        Config.CrimsonQuest.SubmitPositionCheckDistance or 8,
        Config.CrimsonQuest.SubmitTeleportMaxTries or 10,
        Config.CrimsonQuest.SubmitTeleportRetryDelay or 0.4
    )

    if not reachedSubmitPoint then
        DebugPrint("[Crimson Quest] Failed to reach submit position. Back to farm.")

        ReturnToGreatRodFarmForCrimson()

        return finishSubmit(false, "TeleportFailed")
    end

    task.wait(Config.CrimsonQuest.ActionDelay or 0.6)

    -- ถือ Colossal Blue Dragon ให้สำเร็จก่อน
    if not EnsureFishEquippedBeforeReroll(fishData) then
        DebugPrint("[Crimson Quest] Cannot submit: fish not equipped")

        ReturnToGreatRodFarmForCrimson()

        return finishSubmit(false, "NoFishEquipped")
    end

    -- เช็คซ้ำว่าถือปลาจริง
    if not IsFishEquippedByInventoryData(fishData) then
        DebugPrint("[Crimson Quest] Submit blocked: fish is not equipped")

        ReturnToGreatRodFarmForCrimson()

        return finishSubmit(false, "FishNotEquipped")
    end

    DebugPrint("[Crimson Quest] Fish equipped. Press E before submit.")

    task.wait(0.3)

    -- กด E
    PressEOnce()

    task.wait(0.4)

    -- ยิงรีโมทส่งเควส DialogInteract(1,1)
    local success, result = InvokeDialogArgs(
        Config.CrimsonQuest.SubmitDialogArgs or { 1, 1 }
    )

    DebugPrint(
        "[Crimson Quest] Submit remote:",
        success,
        tostring(result)
    )

    task.wait(1)

    -- เช็คว่าเควสผ่านไหม
    if IsCrimsonCavernUnlocked() then
        DebugPrint("[Crimson Quest] Completed: Crimson Cavern unlocked")

        CrimsonQuestFinished = true
        DidAcceptCrimsonGuardQuest = true
        IsFinalFarmActive = true

        IsCrimsonRerollNow = false

        task.spawn(function()
            task.wait(1)

            if not StartLuminescentOathBlessedEnchant() then
                ReturnToPostCrimsonFarm()
                SetFishingState(true)
            end
        end)

        return true, "Completed"
    end

    DebugPrint("[Crimson Quest] Submit sent but not unlocked yet")

    ReturnToGreatRodFarmForCrimson()

    return finishSubmit(false, "NotUnlocked")
end

function RerollDragonMutation(fishData)
    if IsCrimsonRerollNow then
        return false, "Busy"
    end

    IsCrimsonRerollNow = true

    DebugPrint(
        "[Crimson Quest] Reroll loop started:",
        tostring(fishData and fishData.Name),
        "Current Mutation:",
        tostring(fishData and fishData.Mutation)
    )

    local function finishReroll(success, reason)
        IsCrimsonRerollNow = false

        if success then
            return true, reason
        end

        return false, reason
    end

    SetFishingState(false)

    AutoShake = false
    AutoCast = false
    AutoEquipRod = false
    AutoFish = false
    InstantReel = false
    FreezePosition = false
    LastBobber = nil

    task.wait(0.5)

    local noMoneyDecreaseCount = 0

    while IsCrimsonRerollNow do
        local currentFishData = FindInventoryFishByName(Config.CrimsonQuest.TargetFish)

        if not currentFishData then
            DebugPrint("[Crimson Quest] Missing fish while rerolling:", Config.CrimsonQuest.TargetFish)

            ReturnToGreatRodFarmForCrimson()

            return finishReroll(false, "MissingFish")
        end

        local currentMutation = tostring(currentFishData.Mutation or "")

        DebugPrint(
            "[Crimson Quest] Current mutation check:",
            currentFishData.Name,
            "Key:",
            currentFishData.Key,
            "Mutation:",
            currentMutation
        )

        if currentMutation:lower() == tostring(Config.CrimsonQuest.TargetMutation):lower() then
            DebugPrint("[Crimson Quest] Target mutation found:", currentMutation)

            ReturnToGreatRodFarmForCrimson()

            return finishReroll(true, "GotCrimson")
        end

        local moneyBefore = GetMoney()

        if moneyBefore < Config.CrimsonQuest.MinMoneyToReroll then
            DebugPrint(
                "[Crimson Quest] Money below minimum. Stop reroll:",
                moneyBefore,
                "/",
                Config.CrimsonQuest.MinMoneyToReroll
            )

            ReturnToGreatRodFarmForCrimson()

            return finishReroll(false, "NeedMoney")
        end

        local reachedRerollPoint = TeleportUntilNear(
            Config.CrimsonQuest.RerollPosition,
            Config.CrimsonQuest.RerollRotationY,
            Config.CrimsonQuest.RerollPositionCheckDistance or 8,
            Config.CrimsonQuest.RerollTeleportMaxTries or 8,
            Config.CrimsonQuest.RerollTeleportRetryDelay or 0.4
        )

        if not reachedRerollPoint then
            DebugPrint("[Crimson Quest] Failed to reach reroll position. Back to farm.")

            ReturnToGreatRodFarmForCrimson()

            return finishReroll(false, "TeleportFailed")
        end

        task.wait(0.3)

        if Config.CrimsonQuest.RequireFishEquippedBeforeReroll ~= false then
            if not EnsureFishEquippedBeforeReroll(currentFishData) then
                DebugPrint("[Crimson Quest] Fish not equipped. Retry next loop.")

                task.wait(1)

                continue
            end
        else
            EquipFishToolByInventoryData(currentFishData)
            task.wait(0.35)
        end

        if not IsFishEquippedByInventoryData(currentFishData) then
            DebugPrint("[Crimson Quest] Block reroll remote: fish is not equipped")

            task.wait(1)

            continue
        end

        DebugPrint("[Crimson Quest] Fish equipped. Ready to fire reroll remote.")

        if (Config.CrimsonQuest.HoldBeforeRerollDelay or 0) > 0 then
            task.wait(Config.CrimsonQuest.HoldBeforeRerollDelay)
        end

        DebugPrint("[Crimson Quest] Pre reroll remote fire once")

        local preSuccess, preResult = InvokeDialogArgs(
            Config.CrimsonQuest.PreRerollDialogArgs or { 1, 1 }
        )

        DebugPrint(
            "[Crimson Quest] Pre reroll remote:",
            preSuccess,
            tostring(preResult)
        )

        task.wait(Config.CrimsonQuest.PreRerollDelay or 0.2)

        local moneyDecreased = false
        local moneyAfter = moneyBefore
        local fireCount = Config.CrimsonQuest.RerollFireCount or 4
        local fireDelay = Config.CrimsonQuest.RerollFireDelay or 1

        for i = 1, fireCount do
            if not IsCrimsonRerollNow then
                break
            end

            if not IsFishEquippedByInventoryData(currentFishData) then
                DebugPrint("[Crimson Quest] Fish unequipped before 6,1. Re-equipping.")

                if not EnsureFishEquippedBeforeReroll(currentFishData) then
                    break
                end
            end

            DebugPrint("[Crimson Quest] Reroll remote fire 6,1", i, "/", fireCount)

            local rerollSuccess, rerollResult = InvokeDialogArgs(
                Config.CrimsonQuest.RerollDialogArgs
            )

            DebugPrint(
                "[Crimson Quest] Reroll remote:",
                rerollSuccess,
                tostring(rerollResult)
            )

            task.wait(0.35)

            moneyAfter = GetMoney()

            if moneyAfter < moneyBefore then
                moneyDecreased = true
                break
            end

            if i < fireCount then
                task.wait(fireDelay)
            end
        end

        if moneyAfter < moneyBefore then
            noMoneyDecreaseCount = 0

            DebugPrint(
                "[Crimson Quest] Money decreased. Reroll consumed money.",
                "Before:",
                moneyBefore,
                "After:",
                moneyAfter
            )

            task.wait(Config.CrimsonQuest.RerollAfterMoneyDecreaseDelay or 1)

            GetInventoryData()

            if moneyAfter < Config.CrimsonQuest.MinMoneyToReroll then
                DebugPrint("[Crimson Quest] Money below minimum after reroll. Back to farm.")

                ReturnToGreatRodFarmForCrimson()

                return finishReroll(false, "NeedMoney")
            end

            task.wait(Config.CrimsonQuest.RerollFireDelay or 1)

            continue
        end

        noMoneyDecreaseCount += 1

        DebugPrint(
            "[Crimson Quest] Money did not decrease. Retry:",
            noMoneyDecreaseCount,
            "/",
            Config.CrimsonQuest.NoMoneyDecreaseRetryLimit or 5
        )

        if noMoneyDecreaseCount >= (Config.CrimsonQuest.NoMoneyDecreaseRetryLimit or 5) then
            DebugPrint("[Crimson Quest] Too many no-money-decrease tries. Back to farm and retry later.")

            ReturnToGreatRodFarmForCrimson()

            return finishReroll(false, "NoMoneyDecrease")
        end

        task.wait(Config.CrimsonQuest.RerollFireDelay or 1)
    end

    ReturnToGreatRodFarmForCrimson()

    return finishReroll(false, "Stopped")
end

function RunCrimsonDragonQuestStep()
    if CrimsonQuestBusy then
        return
    end

    if CrimsonQuestFinished then
        return
    end

    if not Config.CrimsonQuest.Enabled then
        return
    end

    if not HasRod(Config.LuminescentCavern.TargetRod, true) then
        return
    end

    if IsCrimsonCavernUnlocked() then
        DebugPrint("[Crimson Quest] Already unlocked")

        CrimsonQuestFinished = true
        DidAcceptCrimsonGuardQuest = true
        IsFinalFarmActive = true

        if not StartLuminescentOathBlessedEnchant() then
            ReturnToPostCrimsonFarm()
            SetFishingState(true)
        end

        return
    end

    if IsSellingNow or IsEnchantingNow or IsUsingTotemNow or IsCrabCageNow or IsCrimsonRerollNow then
        return
    end

    CrimsonQuestBusy = true

    -- ขั้นที่ 1: หลังมี Luminescent Oath ต้องรับเควสก่อนเสมอ
    if not DidAcceptCrimsonGuardQuest then
        AcceptCrimsonGuardQuest()

        LastCrimsonQuestAction = tick()
        CrimsonQuestBusy = false
        return
    end

    -- ขั้นที่ 2: หลังรับเควสแล้ว ค่อยเช็คปลา
    local fishData = FindInventoryFishByName(Config.CrimsonQuest.TargetFish)

    if not fishData then
        DebugPrint("[Crimson Quest] Missing fish:", Config.CrimsonQuest.TargetFish)
        ReturnToGreatRodFarmForCrimson()
        CrimsonQuestBusy = false
        return
    end

    DebugPrint(
        "[Crimson Quest] Found fish:",
        fishData.Name,
        "Key:",
        fishData.Key,
        "Mutation:",
        tostring(fishData.Mutation)
    )

    local mutation = tostring(fishData.Mutation or "")

    if mutation:lower() == tostring(Config.CrimsonQuest.TargetMutation):lower() then
        SubmitCrimsonDragon(fishData)
    else
        local rerollSuccess, rerollReason = RerollDragonMutation(fishData)

        DebugPrint(
            "[Crimson Quest] Reroll finished:",
            rerollSuccess,
            tostring(rerollReason)
        )

        if rerollSuccess and rerollReason == "GotCrimson" then
            local crimsonFishData = FindInventoryFishByName(Config.CrimsonQuest.TargetFish)

            if crimsonFishData
                and tostring(crimsonFishData.Mutation or ""):lower() == tostring(Config.CrimsonQuest.TargetMutation):lower() then

                SubmitCrimsonDragon(crimsonFishData)
            end
        end
    end

    LastCrimsonQuestAction = tick()
    CrimsonQuestBusy = false
end

local AutoEnchant = false
local SelectedEnchantToKeep = nil
local CurrentEnchantRodName = nil

local EnchantRemote = ReplicatedStorage
    :WaitForChild("packages")
    :WaitForChild("Net")
    :WaitForChild("RF/EnchantAltar/Interact")

local function CleanEnchantText(text)
    return tostring(text)
        :gsub("<[^>]->", "")
        :gsub("★", "")
        :gsub("%s+", " ")
        :match("^%s*(.-)%s*$")
end

local function GetCurrentRodName()
    if CurrentEnchantRodName then
        return CurrentEnchantRodName
    end

    local priority = {
        "Luminescent Oath",
        "Great Rod of Oscar",
        "Carrot Rod",
        "Splitbranch Twig",
    }

    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    for _, rodName in ipairs(priority) do
        if character and character:FindFirstChild(rodName) then
            return rodName
        end

        if backpack and backpack:FindFirstChild(rodName) then
            return rodName
        end
    end

    return nil
end

local function GetCurrentRodEnchant()
    local rodName = GetCurrentRodName()
    if not rodName then
        return nil
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local hud = playerGui and playerGui:FindFirstChild("hud")
    local safezone = hud and hud:FindFirstChild("safezone")
    local equipment = safezone and safezone:FindFirstChild("equipment")
    local rods = equipment and equipment:FindFirstChild("rods")
    local scroll = rods and rods:FindFirstChild("scroll")
    local rodSafezone = scroll and scroll:FindFirstChild("safezone")
    local rodFrame = rodSafezone and rodSafezone:FindFirstChild(rodName)
    local rod = rodFrame and rodFrame:FindFirstChild("rod")
    local enchants = rod and rod:FindFirstChild("enchants")
    local enchantLabel = enchants and enchants:FindFirstChild("enchant")

    if enchantLabel and enchantLabel:IsA("TextLabel") then
        local rawText = tostring(enchantLabel.Text)
        local cleanText = CleanEnchantText(rawText)

        DebugPrint("[Enchant Read] Rod =", rodName)
        DebugPrint("[Enchant Read] Raw =", rawText)
        DebugPrint("[Enchant Read] Clean =", cleanText)

        return cleanText
    end

    return nil
end

local function HasGreatRodOscarClever()
    CurrentEnchantRodName = "Great Rod of Oscar"

    local enchant = GetCurrentRodEnchant()

    CurrentEnchantRodName = nil

    return enchant == "Clever"
end

local function IsEnchantSelected(currentEnchant, selectedEnchant)
    DebugPrint("[Enchant Check] Current =", tostring(currentEnchant))

    if typeof(selectedEnchant) == "table" then
        for enchantName, enabled in pairs(selectedEnchant) do
            DebugPrint("[Enchant Check] Keep =", enchantName, enabled)
        end
    else
        DebugPrint("[Enchant Check] Keep =", tostring(selectedEnchant))
    end

    if not currentEnchant or not selectedEnchant then
        return false
    end

    if typeof(selectedEnchant) == "string" then
        return currentEnchant == selectedEnchant
    end

    if typeof(selectedEnchant) == "table" then
        for enchantName, enabled in pairs(selectedEnchant) do
            if enabled and currentEnchant == enchantName then
                DebugPrint("[Enchant Check] MATCH FOUND =", currentEnchant)
                return true
            end
        end
    end

    DebugPrint("[Enchant Check] NO MATCH")
    return false
end

local function GetEnchantRelic()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    return (character and character:FindFirstChild("Enchant Relic"))
        or (backpack and backpack:FindFirstChild("Enchant Relic"))
end

local function EquipEnchantRelic()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local relic = GetEnchantRelic()

    if not humanoid or not relic then
        return false
    end

    if relic.Parent ~= character then
        humanoid:EquipTool(relic)
        task.wait(0.2)
    end

    return true
end

local function TeleportToEnchantAltar()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if root then
        root.CFrame = CFrame.new(1311, -802, -82)
        return true
    end

    return false
end

local function IsRodEquippedOrInBackpack(rodName)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if character then
        local tool = character:FindFirstChild(rodName)
        if tool and tool:IsA("Tool") then
            return true
        end
    end

    if backpack then
        local tool = backpack:FindFirstChild(rodName)
        if tool and tool:IsA("Tool") then
            return true
        end
    end

    return false
end

local function EquipRodByRemote(rodName)
    -- หลังมี Ruinous Oath ให้ล็อกเป็น Ruinous Oath ก่อน
    if HasRuinousOath() then
        DebugPrint(
            "[Equip Rod] Force Ruinous Oath because owned:",
            rodName
        )

        rodName = "Ruinous Oath"

    -- หลังมี Luminescent Oath ห้ามระบบอื่นดึงกลับไปถือ Great Rod / Carrot Rod
    elseif ShouldLockToLuminescentOath()
        and rodName ~= "Luminescent Oath" then

        DebugPrint(
            "[Equip Rod] Block lower rod because Luminescent Oath owned:",
            rodName
        )

        rodName = "Luminescent Oath"
    end

    local character = LocalPlayer.Character
    local currentTool = character and character:FindFirstChildOfClass("Tool")

    if currentTool and currentTool.Name == rodName then
        return
    end

    -- กันยิง Equip Remote รัวเกินไป
    if LastRodEquipTarget == rodName
        and tick() - LastRodEquipAttempt < RodEquipCooldown then
        return
    end

    LastRodEquipTarget = rodName
    LastRodEquipAttempt = tick()

    pcall(function()
        RodEquipRemote:InvokeServer(rodName)
    end)

    task.wait(0.5)

    local rod = FindRodToolByName(rodName)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if rod and humanoid and rod.Parent ~= character then
        humanoid:UnequipTools()
        task.wait(0.15)
        humanoid:EquipTool(rod)
    end

    DebugPrint("Rod equip remote sent:", rodName)
end

function HasLuminescentOathBlessed()
    CurrentEnchantRodName = "Luminescent Oath"

    local enchant = GetCurrentRodEnchant()

    CurrentEnchantRodName = nil

    return enchant == "Blessed"
end

function ReturnToPostCrimsonFarm()
    if not Config.PostCrimsonFarm or not Config.PostCrimsonFarm.Enabled then
        return false
    end

    local farmCFrame = TeleportToCFrame(
        Config.PostCrimsonFarm.Position,
        Config.PostCrimsonFarm.RotationY
    )

    if farmCFrame then
        FrozenCFrame = farmCFrame
    end

    return true
end

function StartLuminescentOathBlessedEnchant()
    if not Config.Enchant.Enabled then
        return false
    end

    if not Config.Enchant.LuminescentOath then
        return false
    end

    if not HasRod("Luminescent Oath", true) then
        return false
    end

    if HasLuminescentOathBlessed() then
        DebugPrint("[Post Crimson] Luminescent Oath already Blessed")
        return false
    end

    if not GetEnchantRelic() then
        DebugPrint("[Post Crimson] No Enchant Relic for Luminescent Oath")
        ReturnToPostCrimsonFarm()
        SetFishingState(true)
        return false
    end

    if not IsNight() then
        DebugPrint("[Post Crimson] Waiting night for Blessed enchant")
        ReturnToPostCrimsonFarm()
        SetFishingState(true)
        return false
    end

    DebugPrint("[Post Crimson] Start enchanting Luminescent Oath -> Blessed")

    SetFishingState(false)

    EquipRodByRemote("Luminescent Oath")
    task.wait(0.5)

    CurrentEnchantRodName = "Luminescent Oath"
    SelectedEnchantToKeep = Config.Enchant.LuminescentOath.EnchantsToKeep
    AutoEnchant = true

    return true
end

task.spawn(function()
    while task.wait(5) do
        if not Config.PostCrimsonFarm or not Config.PostCrimsonFarm.Enabled then
            continue
        end

        if not HasRod("Luminescent Oath", true) then
            continue
        end

        if not IsCrimsonCavernUnlocked() then
            continue
        end

        IsFinalFarmActive = true
        CrimsonQuestFinished = true
        DidAcceptCrimsonGuardQuest = true

        if IsAnySpecialActionRunning() then
            continue
        end

        if HasRod("Ruinous Oath", true) then
            EquipRodByRemote("Ruinous Oath")
            ReturnToPostCrimsonFarm()
            SetFishingState(true)
            continue
        end

        if not HasLuminescentOathBlessed() then
            local enchantStarted = StartLuminescentOathBlessedEnchant()

            -- ถ้าเริ่ม Enchant จริง ค่อยหยุด Flow อื่นไว้ก่อน
            if enchantStarted then
                continue
            end

            -- ถ้ายัง Enchant ไม่ได้ เช่น ไม่มี Relic / ยังไม่กลางคืน
            -- ให้กลับไปฟาร์มและปล่อย Crab Cage ทำงานต่อ
        end

        EquipRodByRemote("Luminescent Oath")

        ReturnToPostCrimsonFarm()
        SetFishingState(true)
    end
end)

local function BuySplitbranchTwig()
    if BuyingRodNow then
        return
    end

    if HasRod(Config.BuyRod.TargetRod) then
        DebugPrint("Already has rod:", Config.BuyRod.TargetRod)
        return
    end

    local money = GetMoney()
    if money < Config.BuyRod.MoneyRequired then
        return
    end

    BuyingRodNow = true
    DebugPrint("Money reached:", money)
    DebugPrint("Buying rod:", Config.BuyRod.TargetRod)

    SetFishingState(false)

    task.wait(0.3)

    TeleportToCFrame(Config.BuyRod.Position, Config.BuyRod.RotationY)

    task.wait(0.5)

    pcall(function()
        PurchaseRemote:FireServer(Config.BuyRod.TargetRod, "Rod", nil, 1)
    end)

    task.wait(1)

    if HasRod(Config.BuyRod.TargetRod) then
        DebugPrint("Buy success:", Config.BuyRod.TargetRod)

        if not IsRodEquippedOrInBackpack(Config.BuyRod.TargetRod) then
            EquipRodByRemote(Config.BuyRod.TargetRod)
            task.wait(0.5)
        end
    else
        DebugPrint("Buy sent, but rod not detected yet")
    end

    BuyingRodNow = false
end

task.spawn(function()
    while task.wait(2) do
        if HasRod("Great Rod of Oscar") then
            continue
        end

        if Config.BuyRod.Enabled then
            if not HasRod(Config.BuyRod.TargetRod) then
                BuySplitbranchTwig()
            end
        end
    end
end)

local BuyingCarrotRodNow = false

local function BuyCarrotRod()
    if BuyingCarrotRodNow then
        return
    end

    if HasRod(Config.CarrotRod.TargetRod) then
        DebugPrint("Already has rod:", Config.CarrotRod.TargetRod)
        return
    end

    if not HasRod("Splitbranch Twig") then
        return
    end

    local hasAllFish, missingFish = HasAllCarrotFish()
    if not hasAllFish then
        DebugPrint("Missing carrot fish:", missingFish)
        return
    end

    local money = GetMoney()
    if money < Config.CarrotRod.MoneyRequired then
        DebugPrint("Need more money for Carrot Rod:", money)
        return
    end

    BuyingCarrotRodNow = true
    DebugPrint("Buying Carrot Rod")

    SetFishingState(false)

    task.wait(0.3)

    TeleportToCFrame(Config.CarrotRod.BuyPosition, Config.CarrotRod.BuyRotationY)

    task.wait(0.5)

    pcall(function()
        PurchaseRemote:FireServer(Config.CarrotRod.TargetRod, "Rod", nil, 1)
    end)

    task.wait(1)

    if HasRod(Config.CarrotRod.TargetRod) then
        DebugPrint("Buy success:", Config.CarrotRod.TargetRod)

        EquipRodByRemote(Config.CarrotRod.TargetRod)
        task.wait(0.5)

        local farmCFrame = TeleportToCFrame(
            Config.CarrotRodFarm.Position,
            Config.CarrotRodFarm.RotationY
        )

        if farmCFrame then
            FrozenCFrame = farmCFrame
        end

        SetFishingState(true)
    else
        DebugPrint("Buy sent, but Carrot Rod not detected yet")
    end

    BuyingCarrotRodNow = false
end

task.spawn(function()
    while task.wait(3) do
        if IsAnySpecialActionRunning() then
            continue
        end

        if HasRod("Great Rod of Oscar") then
            continue
        end

        if Config.CarrotRod.Enabled then
            if HasRod("Splitbranch Twig") and not HasRod(Config.CarrotRod.TargetRod) then
                local hasAllFish = HasAllCarrotFish()
                local money = GetMoney()

                if not hasAllFish or money < Config.CarrotRod.MoneyRequired then
                    if not IsSellingNow
                        and not IsEnchantingNow
                        and not IsUsingTotemNow
                        and not IsCrimsonRerollNow then

                        local farmCFrame = TeleportToCFrame(Config.Farm.Position, Config.Farm.RotationY)
                        if farmCFrame then
                            FrozenCFrame = farmCFrame
                        end
                        SetFishingState(true)
                    end
                else
                    BuyCarrotRod()
                end
            end
        end
    end
end)

local DidTryCarrotCleverEnchant = false
local DidTryGreatOscarCleverEnchant = false

task.spawn(function()
    while task.wait(3) do
        if IsAnySpecialActionRunning() then
            continue
        end

        -- มี Luminescent Oath แล้ว ห้ามระบบ Great Rod Enchant ทำงานอีก
        if HasLuminescentOath() then
            continue
        end

        if not Config.Enchant.Enabled then
            continue
        end

        if not HasItem(Config.Enchant.RequiredItem) then
            continue
        end

        if not IsNight() then
            DebugPrint("Waiting Night for enchant")
            continue
        end

        -- Carrot Rod Enchant
        if HasRod("Carrot Rod")
            and not HasRod("Great Rod of Oscar")
            and not DidTryCarrotCleverEnchant then

            DidTryCarrotCleverEnchant = true

            IsEnchantingNow = true
            SetFishingState(false)

            task.wait(0.3)

            EquipRodByRemote(
                Config.Enchant.CarrotRod.TargetRod
            )

            task.wait(0.5)

            SelectedEnchantToKeep =
                Config.Enchant.CarrotRod.EnchantsToKeep

            CurrentEnchantRodName = Config.Enchant.CarrotRod.TargetRod

            AutoEnchant = true

            DebugPrint(
                "Auto Enchant started:",
                Config.Enchant.CarrotRod.TargetRod,
                Config.Enchant.CarrotRod.EnchantsToKeep
            )
        end

        -- Great Rod of Oscar Enchant
        if HasRod("Great Rod of Oscar")
            and not DidTryGreatOscarCleverEnchant then

            DidTryGreatOscarCleverEnchant = true

            IsEnchantingNow = true
            SetFishingState(false)

            task.wait(0.3)

            EquipRodByRemote(
                Config.Enchant.GreatRodOscar.TargetRod
            )

            task.wait(0.5)

            SelectedEnchantToKeep =
                Config.Enchant.GreatRodOscar.EnchantsToKeep

            CurrentEnchantRodName = Config.Enchant.GreatRodOscar.TargetRod

            AutoEnchant = true

            DebugPrint(
                "Auto Enchant started:",
                Config.Enchant.GreatRodOscar.TargetRod,
                Config.Enchant.GreatRodOscar.EnchantsToKeep
            )
        end
    end
end)

local BuyingGreatRodOscarNow = false

local function BuyGreatRodOscar()
    if BuyingGreatRodOscarNow then
        return
    end

    if HasRod(Config.GreatRodOscar.TargetRod) then
        DebugPrint("Already has rod:", Config.GreatRodOscar.TargetRod)
        return
    end

    if not HasRod("Carrot Rod") then
        return
    end

    local level = GetLevel()
    if level < Config.GreatRodOscar.LevelRequired then
        DebugPrint("Need more level for Great Rod of Oscar:", level)
        return
    end

    local money = GetMoney()
    if money < Config.GreatRodOscar.MoneyRequired then
        DebugPrint("Need more money for Great Rod of Oscar:", money)
        return
    end

    BuyingGreatRodOscarNow = true
    DebugPrint("Buying Great Rod of Oscar")

    SetFishingState(false)

    task.wait(0.3)

    TeleportToCFrame(
        Config.GreatRodOscar.BuyPosition,
        Config.GreatRodOscar.BuyRotationY
    )

    task.wait(0.5)

    pcall(function()
        PurchaseRemote:FireServer(Config.GreatRodOscar.TargetRod, "Rod", nil, 1)
    end)

    task.wait(1)

    if HasRod(Config.GreatRodOscar.TargetRod) then
        DebugPrint("Buy success:", Config.GreatRodOscar.TargetRod)

        EquipRodByRemote(Config.GreatRodOscar.TargetRod)
        task.wait(0.5)

        local farmCFrame = TeleportToCFrame(Config.Farm.Position, Config.Farm.RotationY)
        if farmCFrame then
            FrozenCFrame = farmCFrame
        end

        SetFishingState(true)
    else
        DebugPrint("Buy sent, but Great Rod of Oscar not detected yet")
    end

    BuyingGreatRodOscarNow = false
end

task.spawn(function()
    while task.wait(3) do
        if IsAnySpecialActionRunning() then
            continue
        end

        -- หลังมี Luminescent Oath แล้ว ไม่ต้องให้ระบบ Great Rod ทำงานอีก
        if HasLuminescentOath() then
            continue
        end

        if HasRod("Great Rod of Oscar")
            and HasGreatRodOscarClever() then
            continue
        end

        if Config.GreatRodOscar.Enabled then
            if HasRod("Carrot Rod") and not HasRod(Config.GreatRodOscar.TargetRod) then
                local level = GetLevel()
                local money = GetMoney()

                if level < Config.GreatRodOscar.LevelRequired
                    or money < Config.GreatRodOscar.MoneyRequired then

                    if not IsSellingNow
                        and not IsEnchantingNow
                        and not IsUsingTotemNow
                        and not IsCrimsonRerollNow then

                        EquipRodByRemote("Carrot Rod")

                        local farmCFrame = TeleportToCFrame(
                            Config.CarrotRodFarm.Position,
                            Config.CarrotRodFarm.RotationY
                        )

                        if farmCFrame then
                            FrozenCFrame = farmCFrame
                        end

                        SetFishingState(true)
                    end
                else
                    BuyGreatRodOscar()
                end
            end
        end
    end
end)

local BuyingLuminescentNow = false

local function BuyLuminescentCavern()
    if BuyingLuminescentNow then
        return
    end

    if HasRod(Config.LuminescentCavern.TargetRod) then
        return
    end

    local hasAllFish, missingFish = HasAllLuminescentFish()
    if not hasAllFish then
        DebugPrint("Missing Luminescent fish:", missingFish)
        return
    end

    if GetLevel() < Config.LuminescentCavern.LevelRequired then
        return
    end

    if GetMoney() < Config.LuminescentCavern.MoneyRequired then
        return
    end

    BuyingLuminescentNow = true
    SetFishingState(false)

    task.wait(0.3)

    TeleportToCFrame(
        Config.LuminescentCavern.BuyPosition,
        Config.LuminescentCavern.BuyRotationY
    )

    task.wait(0.5)

    DebugPrint(
        "[Luminescent Buy] Buying:",
        Config.LuminescentCavern.TargetRod,
        "At:",
        Config.LuminescentCavern.BuyPosition
    )

    pcall(function()
        PurchaseRemote:FireServer(
            Config.LuminescentCavern.TargetRod,
            "Rod",
            nil,
            1
        )
    end)

    task.wait(1)

    if HasRod(Config.LuminescentCavern.TargetRod, true) then
        EquipRodByRemote(Config.LuminescentCavern.TargetRod)

        task.wait(1)

        task.spawn(function()
            AcceptCrimsonGuardQuest()
        end)
    end

    BuyingLuminescentNow = false
end

local BuyingRuinousOathNow = false

function BuyRuinousOath()
    if BuyingRuinousOathNow then
        return false
    end

    if not Config.RuinousOath or not Config.RuinousOath.Enabled then
        return false
    end

    if HasRod(Config.RuinousOath.TargetRod, true) then
        return true
    end

    if not IsCrimsonCavernUnlocked() then
        return false
    end

    local hasAllFish, missingFish, missingInfo = HasAllCrimsonShinySparklingFish()

    if not hasAllFish then
        DebugPrint(
            "[Ruinous Oath] Missing shiny/sparkling:",
            tostring(missingFish),
            tostring(missingInfo)
        )

        return false
    end

    if GetLevel() < Config.RuinousOath.LevelRequired then
        DebugPrint(
            "[Ruinous Oath] Need level:",
            GetLevel(),
            "/",
            Config.RuinousOath.LevelRequired
        )

        return false
    end

    if GetMoney() < Config.RuinousOath.MoneyRequired then
        DebugPrint(
            "[Ruinous Oath] Need money:",
            GetMoney(),
            "/",
            Config.RuinousOath.MoneyRequired
        )

        return false
    end

    BuyingRuinousOathNow = true

    SetFishingState(false)

    AutoShake = false
    AutoCast = false
    AutoEquipRod = false
    AutoFish = false
    InstantReel = false
    FreezePosition = false
    LastBobber = nil

    task.wait(0.5)

    local reachedBuyPoint = TeleportUntilNear(
        Config.RuinousOath.BuyPosition,
        Config.RuinousOath.BuyRotationY,
        8,
        10,
        0.4
    )

    if not reachedBuyPoint then
        DebugPrint("[Ruinous Oath] Failed to reach buy position")

        BuyingRuinousOathNow = false

        ReturnToPostCrimsonFarm()
        SetFishingState(true)

        return false
    end

    task.wait(0.8)

    DebugPrint(
        "[Ruinous Oath] Buying:",
        Config.RuinousOath.TargetRod,
        "At:",
        Config.RuinousOath.BuyPosition
    )

    pcall(function()
        PurchaseRemote:FireServer(
            Config.RuinousOath.TargetRod,
            "Rod",
            nil,
            1
        )
    end)

    task.wait(1.5)

    if HasRod(Config.RuinousOath.TargetRod, true) then
        DebugPrint("[Ruinous Oath] Bought successfully")

        EquipRodByRemote(Config.RuinousOath.TargetRod)

        BuyingRuinousOathNow = false

        SetFishingState(true)

        return true
    end

    DebugPrint("[Ruinous Oath] Buy sent but rod not detected")

    BuyingRuinousOathNow = false

    ReturnToPostCrimsonFarm()
    SetFishingState(true)

    return false
end

task.spawn(function()
    while task.wait(Config.RuinousOath.CheckDelay or 5) do
        if not Config.RuinousOath or not Config.RuinousOath.Enabled then
            continue
        end

        if HasRod("Ruinous Oath", true) then
            continue
        end

        if not IsCrimsonCavernUnlocked() then
            continue
        end

        if not HasRod("Luminescent Oath", true) then
            continue
        end

        if IsSellingNow
            or IsEnchantingNow
            or IsUsingTotemNow
            or IsCrabCageNow
            or IsCrimsonRerollNow then

            continue
        end

        -- ยังฟาร์ม End game ต่อไปเรื่อย ๆ จนกว่าเงื่อนไขครบ
        local hasAllFish, missingFish, missingInfo = HasAllCrimsonShinySparklingFish()

        if not hasAllFish then
            DebugPrint(
                "[Ruinous Oath] Keep farming. Missing:",
                tostring(missingFish),
                tostring(missingInfo)
            )

            ReturnToPostCrimsonFarm()
            SetFishingState(true)

            continue
        end

        if GetLevel() < Config.RuinousOath.LevelRequired then
            ReturnToPostCrimsonFarm()
            SetFishingState(true)
            continue
        end

        if GetMoney() < Config.RuinousOath.MoneyRequired then
            ReturnToPostCrimsonFarm()
            SetFishingState(true)
            continue
        end

        BuyRuinousOath()
    end
end)

task.spawn(function()
    while task.wait(5) do
        if IsAnySpecialActionRunning() then
            continue
        end

        if not Config.LuminescentCavern.Enabled then
            continue
        end

        if not HasRod("Great Rod of Oscar") then
            continue
        end

        if HasRod(Config.LuminescentCavern.TargetRod) then
            continue
        end

        local hasAllFish, missingFish = HasAllLuminescentFish()
        if not hasAllFish then
            DebugPrint("Missing Luminescent fish:", missingFish)
            continue
        end

        if GetLevel() < Config.LuminescentCavern.LevelRequired then
            continue
        end

        if GetMoney() < Config.LuminescentCavern.MoneyRequired then
            continue
        end

        BuyLuminescentCavern()
    end
end)

task.spawn(function()
    while task.wait(Config.CrimsonQuest.CheckDelay) do
        RunCrimsonDragonQuestStep()
    end
end)


local SelectedRodToBuy = nil
local RodDisplayToName = {}

local RodsModule = game:GetService("ReplicatedStorage")
    :WaitForChild("shared")
    :WaitForChild("modules")
    :WaitForChild("library")
    :WaitForChild("rods")

local function GetBuyableRodList()
    local list = {}
    RodDisplayToName = {}

    local success, rodsData = pcall(require, RodsModule)
    if not success or typeof(rodsData) ~= "table" then
        warn("Failed to load rods module")
        return list
    end

    local rods = {}

    for rodName, rodInfo in pairs(rodsData) do
        if typeof(rodInfo) == "table" then
            local price = rodInfo.Price or rodInfo.price or rodInfo.Cost or rodInfo.cost

            if typeof(price) == "number" and price ~= math.huge and price >= 300 then
                table.insert(rods, {
                    Name = rodName,
                    Price = price
                })
            end
        end
    end

    table.sort(rods, function(a, b)
        return a.Price < b.Price
    end)

    for _, rod in ipairs(rods) do
        local displayName = string.format("%s (%s $)", rod.Name, tostring(rod.Price))
        RodDisplayToName[displayName] = rod.Name
        table.insert(list, displayName)
    end

    return list
end









local function GetCurrentFarmCFrame()
    if IsFinalFarmActive
        and Config.PostCrimsonFarm
        and Config.PostCrimsonFarm.Enabled
        and HasRod(Config.PostCrimsonFarm.TargetRod) then

        return Config.PostCrimsonFarm.Position,
            Config.PostCrimsonFarm.RotationY
    end

    if HasRod("Great Rod of Oscar") then
        return Config.GreatRodFarm.Position,
            Config.GreatRodFarm.RotationY
    end

    if HasRod("Carrot Rod") then
        return Config.CarrotRodFarm.Position,
            Config.CarrotRodFarm.RotationY
    end

    return Config.Farm.Position,
        Config.Farm.RotationY
end

task.spawn(function()
    while task.wait(0.5) do
        if AutoEnchant then
            IsEnchantingNow = true
            SetFishingState(false)

            if not SelectedEnchantToKeep then
                AutoEnchant = false
                IsEnchantingNow = false
                CurrentEnchantRodName = nil
                SetFishingState(true)
                continue
            end

            if not IsNight() then
                DebugPrint("[Enchant] Day detected, stop enchant")
                AutoEnchant = false
                IsEnchantingNow = false
                CurrentEnchantRodName = nil

                local pos, rot = GetCurrentFarmCFrame()
                local farmCFrame = TeleportToCFrame(pos, rot)
                if farmCFrame then
                    FrozenCFrame = farmCFrame
                end

                SetFishingState(true)
                continue
            end

            local currentEnchant

            for i = 1, 8 do
                currentEnchant = GetCurrentRodEnchant()

                if IsEnchantSelected(currentEnchant, SelectedEnchantToKeep) then
                    break
                end

                task.wait(0.25)
            end

            if IsEnchantSelected(currentEnchant, SelectedEnchantToKeep) then
                DebugPrint("[Enchant] Done:", currentEnchant)

                AutoEnchant = false
                IsEnchantingNow = false
                CurrentEnchantRodName = nil

                if HasRod("Great Rod of Oscar") and currentEnchant == "Clever" then
                    local farmCFrame = TeleportToCFrame(
                        Config.GreatRodFarm.Position,
                        Config.GreatRodFarm.RotationY
                    )

                    if farmCFrame then
                        FrozenCFrame = farmCFrame
                    end

                    SetFishingState(true)
                    continue
                end

                local pos, rot = GetCurrentFarmCFrame()
                local farmCFrame = TeleportToCFrame(pos, rot)
                if farmCFrame then
                    FrozenCFrame = farmCFrame
                end

                SetFishingState(true)
                continue
            end

            local relic = GetEnchantRelic()
            if not relic then
                DebugPrint("[Enchant] No Enchant Relic found")

                AutoEnchant = false
                IsEnchantingNow = false
                CurrentEnchantRodName = nil

                local pos, rot = GetCurrentFarmCFrame()
                local farmCFrame = TeleportToCFrame(pos, rot)
                if farmCFrame then
                    FrozenCFrame = farmCFrame
                end

                SetFishingState(true)
                continue
            end

            TeleportToEnchantAltar()
            task.wait(0.2)

            if EquipEnchantRelic() then
                DebugPrint("[Enchant Roll] Rolling enchant...")

                pcall(function()
                    EnchantRemote:InvokeServer("Enchant Relic")
                end)

                task.wait(0.8)

                local afterRollEnchant = GetCurrentRodEnchant()
                DebugPrint("[Enchant Roll] After 0.8s =", tostring(afterRollEnchant))

                task.wait(1.7)

                afterRollEnchant = GetCurrentRodEnchant()
                DebugPrint("[Enchant Roll] After 2.5s =", tostring(afterRollEnchant))
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if AutoExaltedEnchant then

            local currentEnchant = GetCurrentRodEnchant()

            if IsEnchantSelected(currentEnchant, SelectedExaltedEnchantToKeep) then
                print("[Exalted Enchant] Done:", currentEnchant)
                AutoExaltedEnchant = false
                continue
            end

            local character = Players.LocalPlayer.Character
            local backpack = Players.LocalPlayer:FindFirstChild("Backpack")

            local relic =
                (character and character:FindFirstChild("Exalted Relic"))
                or (backpack and backpack:FindFirstChild("Exalted Relic"))

            if not relic then
                warn("[Exalted Enchant] No Exalted Relic found")
                AutoExaltedEnchant = false
                continue
            end

            TeleportToEnchantAltar()
            task.wait(0.2)

            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid and relic.Parent ~= character then
                humanoid:EquipTool(relic)
                task.wait(0.2)
            end

            pcall(function()
                EnchantRemote:InvokeServer("Exalted Relic")
            end)

            task.wait(1)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if AutoCosmicEnchant then
            local currentEnchant = GetCurrentRodEnchant()

            if IsEnchantSelected(currentEnchant, SelectedCosmicEnchantToKeep) then
                AutoCosmicEnchant = false
                continue
            end

            local character = Players.LocalPlayer.Character
            local backpack = Players.LocalPlayer:FindFirstChild("Backpack")

            local relic =
                (character and character:FindFirstChild("Cosmic Relic"))
                or (backpack and backpack:FindFirstChild("Cosmic Relic"))

            if not relic then
                AutoCosmicEnchant = false
                continue
            end

            TeleportToEnchantAltar()
            task.wait(0.2)

            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid and relic.Parent ~= character then
                humanoid:EquipTool(relic)
                task.wait(0.2)
            end

            pcall(function()
                EnchantRemote:InvokeServer("Cosmic Relic")
            end)

            task.wait(1)
        end
    end
end)

local EventZoneList = {
    "Sovereign Beam",
    "Olympian Devil Hunt",
    "Styx Angler Hunt",
    "Legionnaire Lamprey Hunt",
    "Kerauno Wyrm Pool",
    "Helios Ray Hunt",
    "Tidecrasher Archon Hunt",
    "WarSurgeOverlay",
    "Soul Pool",
    "Wisp Hunt",
    "Poseidonโ€s Whirlpool",
    "Apolloโ€s Light Beam",
    "Dreadfin Hunt",
    "Rotbloom Hunt",
    "Flower Guardian Hunt",
    "Nectar Den - Serpent",
    "Toxic Boil",
    "Wyvern Hunt",
    "Skeletal Leviathan Hunt",
    "Brine Storm",
    "Omnithal Hunt",
    "Plesiosaur Hunt",
    "Reef Titan Hunt",
    "Pliosaur Hunt",
    "Goldwraith Hunt",
    "Frostwyrm Hunt",
    "Baby Bloop Fish",
    "Bloop Fish",
    "The Sanctum Profane Hunt",
    "The Sanctum Hunt",
    "Cathulid Abundance",
    "Cthulith Abundance",
    "Eruption",
    "Earthquake",
    "Mosslurker",
    "MossjawHunt",
    "Magician Narwhal - Sea 1",
    "Beluga - Sea 1",
    "Narwhal - Sea 1",
    "Colossal Ethereal Dragon",
    "Colossal Ancient Dragon",
    "Colossal Blue Dragon",
    "The Depths - Serpent",
    "Forsaken Veil - Scylla",
    "Orcas Pool",
    "Whales Pool",
    "Ancient Orcas Pool",
    "Isonade",
    "The Kraken Pool",
    "Megalodon Default",
    "Megalodon Ancient",
    "Great White Shark",
    "Great Hammerhead Shark",
    "Whale Shark",
    "Cursed Isle"
}

local function FindEventZonePart(zoneName)
    local zones = workspace:FindFirstChild("zones")
    local fishing = zones and zones:FindFirstChild("fishing")

    if not fishing or not zoneName then
        return nil
    end

    for _, zone in ipairs(fishing:GetChildren()) do
        if zone.Name == zoneName then
            if zone:IsA("BasePart") then
                return zone
            end

            if zone:IsA("Model") then
                return zone.PrimaryPart or zone:FindFirstChildWhichIsA("BasePart", true)
            end

            return zone:FindFirstChildWhichIsA("BasePart", true)
        end
    end

    return nil
end


local SelectedTotemEventZones = {}
local SelectedWeatherZones = {}
local SelectedTotemName = nil
local AutoTotem = false
local LastTotemUse = 0

local WeatherList = {
    "Clear",
    "Rain",
    "Stormy",
    "Windy",
    "Foggy",
    "Aurora_Borealis"
}

local TotemList = {
    "Sundial Totem",
    "Clearcast Totem",
    "Tempest Totem",
    "Windset Totem",
    "Smokescreen Totem",
    "Meteor Totem",
    "Avalanche Totem",
    "Eclipse Totem",
    "Blizzard Totem",
    "Aurora Totem",
    "Zeus Storm Totem",
    "Poseidon Wrath Totem",
    "Blue Moon Totem",
    "Dripstone Collapse Totem",
    "Bloom Totem",
    "Shiny Totem",
    "Sparkling Totem",
    "Mutation Totem",
    "Starfall Totem",
    "Rainbow Totem",
    "Megalodon Hunt Totem",
    "Kraken Hunt Totem",
    "Colossal Dragon Hunt Totem",
    "Scylla Hunt Totem",
    "Brine Storm Totem"
}

local WeatherValue = game:GetService("ReplicatedStorage")
    :WaitForChild("world")
    :WaitForChild("weather")

local ClientWeatherValue = game:GetService("ReplicatedStorage")
    :WaitForChild("world")
    :WaitForChild("clientWeather")

local function GetCurrentWeather()
    if ClientWeatherValue.Value ~= "" then
        return ClientWeatherValue.Value
    end

    return WeatherValue.Value
end

local function GetAuroraTotemToUse()
    local currentWeather = tostring(GetCurrentWeather())
    local state, clockTime = GetDayNightState()

    if currentWeather == Config.AuroraFarm.TargetWeather then
        return nil, "Aurora already active", currentWeather, state, clockTime
    end

    if state == "Day" then
        return Config.AuroraFarm.SundialTotem, "Day -> Sundial", currentWeather, state, clockTime
    end

    if state == "Night" then
        return Config.AuroraFarm.AuroraTotem, "Night -> Aurora", currentWeather, state, clockTime
    end

    return nil, "Unknown state", currentWeather, state, clockTime
end

task.spawn(function()
    while task.wait(Config.AuroraFarm.CheckDelay) do
        if not Config.AuroraFarm.Enabled then
            continue
        end

        if IsFinalFarmActive then
            continue
        end

        if IsAnySpecialActionRunning() then
            continue
        end

        if not HasRod("Great Rod of Oscar") then
            continue
        end

        if not HasGreatRodOscarClever() then
            continue
        end

        IsFinalFarmActive = true
        DidTryCarrotCleverEnchant = true
        DidTryGreatOscarCleverEnchant = true

        local totemToUse, reason, currentWeather, state, clockTime = GetAuroraTotemToUse()

        warn(
            "[Aurora Totem Check]",
            "Weather =", currentWeather,
            "State =", state,
            "ClockTime =", clockTime,
            "Action =", reason,
            "Totem =", tostring(totemToUse)
        )

        -- ถ้าเป็น Aurora_Borealis แล้ว ไม่ต้องทำอะไร ฟาร์มต่อ
        if not totemToUse then
            local farmCFrame = TeleportToCFrame(
                Config.GreatRodFarm.Position,
                Config.GreatRodFarm.RotationY
            )

            if farmCFrame then
                FrozenCFrame = farmCFrame
            end

            SetFishingState(true)
            continue
        end

        IsUsingTotemNow = true
        SetFishingState(false)

        task.wait(0.3)

        EquipAndUseTotem(totemToUse)

        task.wait(3)

        IsUsingTotemNow = false

        local farmCFrame = TeleportToCFrame(
            Config.GreatRodFarm.Position,
            Config.GreatRodFarm.RotationY
        )

        if farmCFrame then
            FrozenCFrame = farmCFrame
        end

        SetFishingState(true)
    end
end)

local CrabCageCountdownStartedAt = 0

local function ReturnToGreatRodFarm()
    local farmCFrame = TeleportToCFrame(
        Config.GreatRodFarm.Position,
        Config.GreatRodFarm.RotationY
    )

    if farmCFrame then
        FrozenCFrame = farmCFrame
    end
end

task.spawn(function()
    while task.wait(Config.CrabCageFarm.CheckDelay) do
        if not ShouldRunCrabCageFarm() then
            continue
        end

        if CrabCageBusy then
            continue
        end

        local placedCount = CountPlacedCrabCages()

        DebugPrint(
            "[Crab Cage]",
            "Placed =",
            placedCount,
            "/",
            Config.CrabCageFarm.TargetAmount,
            "TimerStartedAt =",
            CrabCageCountdownStartedAt
        )

        -- ถ้ามี Timer กำลังนับอยู่แล้ว ห้ามรีเซ็ตเพราะ Count กรงตกชั่วคราวจาก Auto Sell / Teleport
        if CrabCageCountdownStartedAt > 0 then
            local elapsed = tick() - CrabCageCountdownStartedAt
            local remaining = Config.CrabCageFarm.WaitAfterFullPlace - elapsed

            if remaining > 0 then
                DebugPrint(
                    "[Crab Cage] Timer running. Waiting:",
                    math.floor(remaining),
                    "seconds left | Placed:",
                    placedCount,
                    "/",
                    Config.CrabCageFarm.TargetAmount
                )

                IsCrabCageNow = false
                CrabCageBusy = false

                ReturnToGreatRodFarm()
                SetFishingState(true)

                continue
            end
        end

        -- ยังไม่เคยเริ่มนับ และกรงยังไม่ครบ 50 ค่อยไปวางเพิ่ม
        if placedCount < Config.CrabCageFarm.TargetAmount then
            CrabCageBusy = true
            IsCrabCageNow = true

            DebugPrint("[Crab Cage] Not full and no active timer. Placing to 50...")

            SetFishingState(false)
            task.wait(0.25)

            ReturnToGreatRodFarm()
            task.wait(0.25)

            local placedSuccess = PlaceCrabCagesToTarget()

            placedCount = CountPlacedCrabCages()

            DebugPrint("[Crab Cage] After place count:", placedCount)

            if placedSuccess and placedCount >= Config.CrabCageFarm.TargetAmount then
                CrabCageCountdownStartedAt = tick()

                DebugPrint(
                    "[Crab Cage] Full 50. Countdown started:",
                    Config.CrabCageFarm.WaitAfterFullPlace,
                    "seconds"
                )
            end

            ReturnToGreatRodFarm()
            SetFishingState(true)

            IsCrabCageNow = false
            CrabCageBusy = false

            continue
        end

        -- ถ้าครบ 50 แล้ว แต่ยังไม่เคยเริ่มนับ ให้เริ่มนับตอนนี้
        if placedCount >= Config.CrabCageFarm.TargetAmount
            and CrabCageCountdownStartedAt <= 0 then

            CrabCageCountdownStartedAt = tick()

            DebugPrint(
                "[Crab Cage] Already full 50. Countdown started:",
                Config.CrabCageFarm.WaitAfterFullPlace,
                "seconds"
            )

            ReturnToGreatRodFarm()
            SetFishingState(true)

            continue
        end

        -- ครบ 300 วิแล้ว เก็บกรงทั้งหมด
        CrabCageBusy = true
        IsCrabCageNow = true

        DebugPrint("[Crab Cage] Countdown finished. Claim all cages.")

        SetFishingState(false)
        task.wait(0.3)

        ClaimAllReadyCrabCages()

        task.wait(0.5)

        -- รีเซ็ตเวลา เพื่อให้รอบใหม่ต้องวางครบ 50 ก่อน
        CrabCageCountdownStartedAt = 0
        LastCrabCageFullPlace = 0

        ReturnToGreatRodFarm()
        SetFishingState(true)

        IsCrabCageNow = false
        CrabCageBusy = false

        DebugPrint("[Crab Cage] Claim finished. Restart checking loop.")
    end
end)

PostCrimsonCrabCageCountdownStartedAt = 0
PostCrimsonCrabCageBusy = false

function ShouldRunPostCrimsonCrabCage()
    if not Config.PostCrimsonFarm then
        return false
    end

    if not Config.PostCrimsonFarm.Enabled then
        return false
    end

    if not Config.PostCrimsonFarm.CrabCage then
        return false
    end

    if not Config.PostCrimsonFarm.CrabCage.Enabled then
        return false
    end

    if not IsCrimsonCavernUnlocked() then
        return false
    end

    if not HasRod("Luminescent Oath", true) then
        return false
    end

    -- ไม่ต้องเช็ค Blessed แล้ว
    -- มี Luminescent Oath + ปลด Crimson Cavern ก็เปิด Crab Cage ได้เลย

    if not IsFinalFarmActive then
        return false
    end

    if IsSellingNow
        or IsEnchantingNow
        or IsUsingTotemNow
        or IsCrabCageNow
        or IsCrimsonRerollNow then

        return false
    end

    return true
end

function PlacePostCrimsonCrabCagesToTarget()
    local cageConfig = Config.PostCrimsonFarm.CrabCage

    if CountPlacedCrabCages() >= cageConfig.TargetAmount then
        return true
    end

    if not EquipCrabCages() then
        return false
    end

    local failCount = 0

    while CountPlacedCrabCages() < cageConfig.TargetAmount do
        if not Config.PostCrimsonFarm.Enabled
            or not cageConfig.Enabled
            or not IsCrimsonCavernUnlocked()
            or not HasRod("Luminescent Oath", true)
            or not IsFinalFarmActive then

            break
        end

        local before = CountPlacedCrabCages()

        pcall(function()
            CrabCagePlaceRemote:InvokeServer(
                cageConfig.PlaceCFrame,
                0
            )
        end)

        task.wait(cageConfig.PlaceDelay or 0.18)

        local after = CountPlacedCrabCages()

        if after <= before then
            failCount += 1
        else
            failCount = 0
        end

        if failCount >= 10 then
            DebugPrint("[Post Crimson Crab Cage] Place failed too many times")
            break
        end
    end

    return CountPlacedCrabCages() >= cageConfig.TargetAmount
end

task.spawn(function()
    while task.wait(2) do
        if not ShouldRunPostCrimsonCrabCage() then
            continue
        end

        if PostCrimsonCrabCageBusy then
            continue
        end

        local cageConfig = Config.PostCrimsonFarm.CrabCage
        local placedCount = CountPlacedCrabCages()

        DebugPrint(
            "[Post Crimson Crab Cage]",
            "Placed =",
            placedCount,
            "/",
            cageConfig.TargetAmount,
            "TimerStartedAt =",
            PostCrimsonCrabCageCountdownStartedAt
        )

        -- ถ้ามี Timer กำลังนับอยู่แล้ว ห้ามรีเซ็ตเพราะ Count กรงตกชั่วคราวจาก Auto Sell / Teleport
        if PostCrimsonCrabCageCountdownStartedAt > 0 then
            local elapsed = tick() - PostCrimsonCrabCageCountdownStartedAt
            local remaining = cageConfig.WaitAfterFullPlace - elapsed

            if remaining > 0 then
                DebugPrint(
                    "[Post Crimson Crab Cage] Timer running. Waiting:",
                    math.floor(remaining),
                    "seconds left | Placed:",
                    placedCount,
                    "/",
                    cageConfig.TargetAmount
                )

                PostCrimsonCrabCageBusy = false
                IsCrabCageNow = false

                ReturnToPostCrimsonFarm()
                SetFishingState(true)

                continue
            end
        end

        -- ยังไม่เคยเริ่มนับ และกรงยังไม่ครบ ค่อยไปวางเพิ่ม
        if placedCount < cageConfig.TargetAmount then
            PostCrimsonCrabCageBusy = true
            IsCrabCageNow = true

            DebugPrint("[Post Crimson Crab Cage] Not full and no active timer. Placing to target...")

            SetFishingState(false)
            task.wait(0.25)

            ReturnToPostCrimsonFarm()
            task.wait(0.25)

            local placedSuccess = PlacePostCrimsonCrabCagesToTarget()

            placedCount = CountPlacedCrabCages()

            DebugPrint("[Post Crimson Crab Cage] After place count:", placedCount)

            if placedSuccess and placedCount >= cageConfig.TargetAmount then
                PostCrimsonCrabCageCountdownStartedAt = tick()

                DebugPrint(
                    "[Post Crimson Crab Cage] Full. Countdown started:",
                    cageConfig.WaitAfterFullPlace,
                    "seconds"
                )
            end

            ReturnToPostCrimsonFarm()
            SetFishingState(true)

            IsCrabCageNow = false
            PostCrimsonCrabCageBusy = false

            continue
        end

        -- ถ้าครบแล้ว แต่ยังไม่เคยเริ่มนับ ให้เริ่มนับตอนนี้
        if placedCount >= cageConfig.TargetAmount
            and PostCrimsonCrabCageCountdownStartedAt <= 0 then

            PostCrimsonCrabCageCountdownStartedAt = tick()

            DebugPrint(
                "[Post Crimson Crab Cage] Already full. Countdown started:",
                cageConfig.WaitAfterFullPlace,
                "seconds"
            )

            ReturnToPostCrimsonFarm()
            SetFishingState(true)

            continue
        end

        PostCrimsonCrabCageBusy = true
        IsCrabCageNow = true

        SetFishingState(false)
        task.wait(0.3)

        ClaimAllReadyCrabCages()

        task.wait(0.5)

        PostCrimsonCrabCageCountdownStartedAt = 0

        ReturnToPostCrimsonFarm()
        SetFishingState(true)

        IsCrabCageNow = false
        PostCrimsonCrabCageBusy = false
    end
end)

local function IsSelectedMapHasValue(mapTable, valueName)
    if not valueName then
        return false
    end

    for name, enabled in pairs(mapTable) do
        if enabled and name == valueName then
            return true
        end
    end

    return false
end

local function GetTotemTool(totemName)
    local character = Players.LocalPlayer.Character
    local backpack = Players.LocalPlayer:FindFirstChild("Backpack")

    return (character and character:FindFirstChild(totemName))
        or (backpack and backpack:FindFirstChild(totemName))
end

local function EquipTool(tool)
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid or not tool then
        return false
    end

    if tool.Parent ~= character then
        humanoid:EquipTool(tool)
        task.wait(0.15)
    end

    return true
end

local function UnequipCurrentTool()
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:UnequipTools()
        task.wait(0.1)
    end
end

local function UseSelectedTotem()
    if not SelectedTotemName then
        return false
    end

    if tick() - LastTotemUse < 3 then
        return false
    end

    local totem = GetTotemTool(SelectedTotemName)
    if not totem then
        warn("[Totem] Not found:", SelectedTotemName)
        return false
    end

    local oldAutoEquipRod = AutoEquipRod
    AutoEquipRod = false

    UnequipCurrentTool()

    if EquipTool(totem) then
        pcall(function()
            totem:Activate()
        end)

        LastTotemUse = tick()
    end

    task.wait(0.2)

    AutoEquipRod = oldAutoEquipRod
    return true
end

local function FindSelectedTotemEventZone()
    for zoneName, enabled in pairs(SelectedTotemEventZones) do
        if enabled then
            local zonePart = FindEventZonePart(zoneName)

            if zonePart then
                return zonePart, zoneName
            end
        end
    end

    return nil, nil
end







task.spawn(function()
    while task.wait(1) do
        if AutoTotem
            and not IsUsingTotemNow
            and not IsEnchantingNow
            and not IsCrimsonRerollNow then

            local shouldUseTotem = false

            local zonePart = FindSelectedTotemEventZone()
            if zonePart then
                shouldUseTotem = true
            end

            local currentWeather = GetCurrentWeather()
            if IsSelectedMapHasValue(SelectedWeatherZones, currentWeather) then
                shouldUseTotem = true
            end

            if shouldUseTotem then
                UseSelectedTotem()
            end
        end
    end
end)


SelectedTeleportZone = nil
ZoneDropdown = nil

local function GetZoneFolder()
    local zones = workspace:FindFirstChild("zones")
    if not zones then
        return nil
    end

    return zones:FindFirstChild("player")
end

local function GetZoneList()
    local zoneFolder = GetZoneFolder()
    local list = {}
    local added = {}

    if not zoneFolder then
        return list
    end

    for _, zone in ipairs(zoneFolder:GetChildren()) do
        if not added[zone.Name] then
            added[zone.Name] = true
            table.insert(list, zone.Name)
        end
    end

    table.sort(list)
    return list
end

local function FindZonePart(zoneName)
    local zoneFolder = GetZoneFolder()
    if not zoneFolder or not zoneName then
        return nil
    end

    for _, zone in ipairs(zoneFolder:GetChildren()) do
        if zone.Name == zoneName then
            if zone:IsA("BasePart") then
                return zone
            end

            if zone:IsA("Model") then
                if zone.PrimaryPart then
                    return zone.PrimaryPart
                end

                local part = zone:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    return part
                end
            end

            local part = zone:FindFirstChildWhichIsA("BasePart", true)
            if part then
                return part
            end
        end
    end

    return nil
end

local function TeleportToZone(zoneName)
    local character = Players.LocalPlayer.Character
    if not character then
        warn("Character not found")
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        warn("HumanoidRootPart not found")
        return
    end

    local zonePart = FindZonePart(zoneName)
    if not zonePart then
        warn("Zone part not found:", zoneName)
        return
    end

    root.CFrame = zonePart.CFrame + Vector3.new(0, 5, 0)
end





AutoEventZone = false
SelectedEventZones = {}
SavedBackCFrame = nil
TeleportBackAfterEvent = false
WasEventFound = false

local function GetMyBoat()
    local active = workspace:FindFirstChild("active")
    local boats = active and active:FindFirstChild("boats")
    if not boats then
        return nil
    end

    local playerFolder = boats:FindFirstChild(Players.LocalPlayer.Name)
    if not playerFolder then
        return nil
    end

    for _, boat in ipairs(playerFolder:GetChildren()) do
        if boat:IsA("Model") then
            return boat
        end
    end

    return nil
end

local function SpawnBoatIfNeeded()
    if GetMyBoat() then
        return true
    end

    local npcs = workspace:WaitForChild("world"):WaitForChild("npcs")
    local shipwright = npcs:WaitForChild("Moosewood Shipwright")

    local args = {
        {
            voice = 8,
            idle = shipwright:WaitForChild("description"):WaitForChild("idle"),
            npc = shipwright
        }
    }

    pcall(function()
        shipwright:WaitForChild("shipwright")
            :WaitForChild("giveUI")
            :InvokeServer(unpack(args))
    end)

    task.wait(0.3)

    pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("packages")
            :WaitForChild("Net")
            :WaitForChild("RF/Boats/Spawn")
            :InvokeServer("Rowboat")
    end)

    task.wait(0.2)

    pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("packages")
            :WaitForChild("Net")
            :WaitForChild("RE/Boats/Close")
            :FireServer()
    end)

    local start = tick()

    repeat
        task.wait(0.2)
    until GetMyBoat() or tick() - start > 5

    return GetMyBoat() ~= nil
end

local function SitOnBoat()
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return false
    end

    local boat = GetMyBoat()
    if not boat then
        return false
    end

    local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true)
        or boat:FindFirstChildWhichIsA("Seat", true)

    if not seat then
        return false
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
    end

    task.wait(0.3)

    pcall(function()
        seat:Sit(humanoid)
    end)

    return true
end

local function MoveBoatTo(cf)
    local boat = GetMyBoat()
    if not boat then
        return false
    end

    local primary = boat.PrimaryPart
        or boat:FindFirstChildWhichIsA("BasePart")

    if not primary then
        return false
    end

    pcall(function()
        boat:PivotTo(cf)
    end)

    return true
end

local EventZoneList = {
    "Sovereign Beam",
    "Olympian Devil Hunt",
    "Styx Angler Hunt",
    "Legionnaire Lamprey Hunt",
    "Kerauno Wyrm Pool",
    "Helios Ray Hunt",
    "Tidecrasher Archon Hunt",
    "WarSurgeOverlay",
    "Soul Pool",
    "Wisp Hunt",
    "Poseidonโ€s Whirlpool",
    "Apolloโ€s Light Beam",
    "Dreadfin Hunt",
    "Rotbloom Hunt",
    "Flower Guardian Hunt",
    "Nectar Den - Serpent",
    "Toxic Boil",
    "Wyvern Hunt",
    "Skeletal Leviathan Hunt",
    "Brine Storm",
    "Omnithal Hunt",
    "Plesiosaur Hunt",
    "Reef Titan Hunt",
    "Pliosaur Hunt",
    "Goldwraith Hunt",
    "Frostwyrm Hunt",
    "Baby Bloop Fish",
    "Bloop Fish",
    "The Sanctum Profane Hunt",
    "The Sanctum Hunt",
    "Cathulid Abundance",
    "Cthulith Abundance",
    "Eruption",
    "Earthquake",
    "Mosslurker",
    "MossjawHunt",
    "Magician Narwhal - Sea 1",
    "Beluga - Sea 1",
    "Narwhal - Sea 1",
    "Colossal Ethereal Dragon",
    "Colossal Ancient Dragon",
    "Colossal Blue Dragon",
    "The Depths - Serpent",
    "Forsaken Veil - Scylla",
    "Orcas Pool",
    "Whales Pool",
    "Ancient Orcas Pool",
    "Isonade",
    "The Kraken Pool",
    "Megalodon Default",
    "Megalodon Ancient",
    "Great White Shark",
    "Great Hammerhead Shark",
    "Whale Shark",
    "Cursed Isle"
}

local function FindEventZonePart(zoneName)
    local zones = workspace:FindFirstChild("zones")
    local fishing = zones and zones:FindFirstChild("fishing")

    if not fishing or not zoneName then
        return nil
    end

    for _, zone in ipairs(fishing:GetChildren()) do
        if zone.Name == zoneName then
            if zone:IsA("BasePart") then
                return zone
            end

            if zone:IsA("Model") then
                return zone.PrimaryPart or zone:FindFirstChildWhichIsA("BasePart", true)
            end

            return zone:FindFirstChildWhichIsA("BasePart", true)
        end
    end

    return nil
end

local function TeleportToEventZone()
    for zoneName, enabled in pairs(SelectedEventZones) do
        if enabled then
            local zonePart = FindEventZonePart(zoneName)

            if zonePart then
                -- spawn boat เธ–เนเธฒเธขเธฑเธเนเธกเนเธกเธต
                SpawnBoatIfNeeded()

                -- เธเธฑเนเธเน€เธฃเธทเธญ
                SitOnBoat()

                -- เธงเธฒเธเน€เธฃเธทเธญ
                local boat = GetMyBoat()
                local primary = boat and (boat.PrimaryPart or boat:FindFirstChildWhichIsA("BasePart"))

                local targetCFrame = zonePart.CFrame + Vector3.new(0, 5, 0)

                if primary then
                    local distance = (primary.Position - targetCFrame.Position).Magnitude

                    if distance > 10 then
                        MoveBoatTo(targetCFrame)
                    end
                else
                    MoveBoatTo(targetCFrame)
                end

                return true
            end
        end
    end

    return false
end






task.spawn(function()
    while task.wait(1) do
        if AutoEventZone then
            local foundEvent = TeleportToEventZone()

            if foundEvent then
                WasEventFound = true
            else
                if WasEventFound and TeleportBackAfterEvent and SavedBackCFrame then
                    local character = Players.LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")

                    if root then
                        root.CFrame = SavedBackCFrame
                    end
                end

                WasEventFound = false
            end
        else
            WasEventFound = false
        end
    end
end)


Rejoin = true

HttpService = game:GetService("HttpService")
TeleportService = game:GetService("TeleportService")

FILE_NAME = "ServerCache.json"
PLACE_ID = game.PlaceId
CACHE_TIME = 60

function FetchAndSaveServers()
    local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local decoded = HttpService:JSONDecode(response)
        if decoded and decoded.data then
            local cacheData = {
                UpdateTime = os.time(),
                Servers = decoded.data
            }
            writefile(FILE_NAME, HttpService:JSONEncode(cacheData))
            print("--- เธญเธฑเธเน€เธ”เธ•เธฃเธฒเธขเธเธทเนเธญเน€เธเธดเธฃเนเธเน€เธงเธญเธฃเนเนเธซเธกเนเนเธฅเนเธง ---")
            return cacheData
        end
    end

    return nil
end

function Hop_Server()
    local cacheData = nil

    if isfile(FILE_NAME) then
        local fileContent = readfile(FILE_NAME)
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(fileContent)
        end)

        if success and decoded.UpdateTime and os.time() - decoded.UpdateTime < CACHE_TIME then
            cacheData = decoded
            print("เนเธเนเธเนเธญเธกเธนเธฅเธเธฒเธ Cache (เธขเธฑเธเนเธกเนเธ–เธถเธ 60 เธงเธดเธเธฒเธ—เธต)")
        end
    end

    if not cacheData then
        cacheData = FetchAndSaveServers()
    end

    if not cacheData or #cacheData.Servers == 0 then
        warn("เนเธกเนเธชเธฒเธกเธฒเธฃเธ–เธ”เธถเธเธเนเธญเธกเธนเธฅเน€เธเธดเธฃเนเธเน€เธงเธญเธฃเนเนเธ”เน")
        return
    end

    for _, server in pairs(cacheData.Servers) do
        if server.id ~= game.JobId and tonumber(server.playing) < tonumber(server.maxPlayers) then
            print("เธเธณเธฅเธฑเธเธขเนเธฒเธขเนเธเน€เธเธดเธฃเนเธเน€เธงเธญเธฃเน: " .. server.id .. " (เธเธเนเธเน€เธเธดเธฃเนเธ: " .. server.playing .. ")")

            pcall(function()
                TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, Players.LocalPlayer)
            end)
            task.wait(1.5)
        end
    end

    print("เนเธกเนเธเธเน€เธเธดเธฃเนเธเน€เธงเธญเธฃเนเธญเธทเนเธเธ—เธตเนเน€เธซเธกเธฒเธฐเธชเธกเนเธเธฃเธฒเธขเธเธฒเธฃเธเธฑเธเธเธธเธเธฑเธ")
end

VirtualUser = game:GetService("VirtualUser")
CoreGui = game:GetService("CoreGui")

-- กัน AFK 20 นาที
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    DebugPrint("Anti AFK triggered")
end)

task.spawn(function()
    local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 60)
    if not promptGui then
        return
    end

    local promptOverlay = promptGui:WaitForChild("promptOverlay", 60)
    if not promptOverlay then
        return
    end

    DebugPrint("[Auto Rejoin] Started")

    local function RejoinCurrentPlace()
        if not Rejoin then
            return
        end

        DebugPrint("Rejoining current place...")

        task.wait(5)

        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end

    promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            DebugPrint("ErrorPrompt detected")
            RejoinCurrentPlace()
        end
    end)

    -- เผื่อ ErrorPrompt มีอยู่ก่อนสคริปต์จับ ChildAdded
    local existingPrompt = promptOverlay:FindFirstChild("ErrorPrompt")
    if existingPrompt then
        DebugPrint("Existing ErrorPrompt detected")
        RejoinCurrentPlace()
    end
end)

