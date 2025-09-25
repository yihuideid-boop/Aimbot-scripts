local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👌Aimbot and Esp👌",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "enjoy the script",
   LoadingSubtitle = "by Mondan",
   ShowText = "Mondan160", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "J", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "MD Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"MondanScript"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main Tab", 4483362458) -- Title, Image
local MainSection = MainTab:CreateSection("ESP and Aimbot Section")

Rayfield:Notify({
   Title = "enjoy the script",
   Content = "Aimbot and Esp",
   Duration = 5,
   Image = 4483362458,
})
--ESP
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPConnections = {}

local function createHighlight(character)
	if not character:FindFirstChild("ESP_Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "ESP_Highlight"
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Adornee = character
		highlight.Parent = character
	end
end

local function removeHighlight(character)
	local highlight = character:FindFirstChild("ESP_Highlight")
	if highlight then
		highlight:Destroy()
	end
end

local function enableESP()
	ESPEnabled = true

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if player.Character then
				createHighlight(player.Character)
			end

			if not ESPConnections[player] then
				local conn = player.CharacterAdded:Connect(function(char)
					if ESPEnabled then
						createHighlight(char)
					end
				end)
				ESPConnections[player] = conn
			end
		end
	end

	if not ESPConnections["_PlayerAdded"] then
		ESPConnections["_PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
			if player == LocalPlayer then return end

			if player.Character then
				createHighlight(player.Character)
			end

			local conn = player.CharacterAdded:Connect(function(char)
				if ESPEnabled then
					createHighlight(char)
				end
			end)
			ESPConnections[player] = conn
		end)
	end
end

local function disableESP()
	ESPEnabled = false

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			removeHighlight(player.Character)
		end
	end
end

-- ✅ RayfieldのToggleに正しく接続する
local Toggle = MainTab:CreateToggle({
   Name = "Toggle ESP",
   CurrentValue = false,
   Flag = "ToggleESP",
   Callback = function(Value)
       if Value then
           enableESP()
           warn("ESP ON")
       else
           disableESP()
           warn("ESP OFF")
       end
   end,
})

local AimbotLoaded = false
local AimbotEnabled = false
local AimbotFunctions = nil
local AimbotLibrary = nil

local AimbotToggle = MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "ToggleAimbot",
    Callback = function(Value)
        if Value and not AimbotEnabled then
            AimbotEnabled = true
            if not AimbotLoaded then
                AimbotLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/refs/heads/main/Resources/Scripts/Aimbot%20V2%20GUI.lua"))()
                -- 読み込み後にgetgenv()から必要な変数を取り出す
                wait(1) -- 少し待つ（ロード完了のため）
                if getgenv().Aimbot and getgenv().Aimbot.Functions then
                    AimbotFunctions = getgenv().Aimbot.Functions
                end
                -- UIライブラリも同様に
                if getgenv().Aimbot and getgenv().Aimbot.Library then
                    AimbotLibrary = getgenv().Aimbot.Library
                elseif getgenv().Library then
                    AimbotLibrary = getgenv().Library
                end
            end
            if getgenv().Aimbot and getgenv().Aimbot.Settings then
                getgenv().Aimbot.Settings.Enabled = true
            end
            warn("Aimbot ON")
        elseif not Value and AimbotEnabled then
            AimbotEnabled = false
            if getgenv().Aimbot and getgenv().Aimbot.Settings then
                getgenv().Aimbot.Settings.Enabled = false
            end
            if AimbotFunctions and AimbotFunctions.Exit then
                pcall(function()
                    AimbotFunctions:Exit() -- UIやイベントの終了処理
                end)
            end
            if AimbotLibrary and AimbotLibrary.Unload then
                pcall(function()
                    AimbotLibrary:Unload() -- UIのアンロード処理
                end)
            end
            warn("Aimbot OFF")
        end
    end,
})

local SecoundTab = Window:CreateTab("Player State", 4483362458) -- Title, Image
local MainSection = SecoundTab:CreateSection("Player State")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Slider = SecoundTab:CreateSlider({
   Name = "Player WalkSpeed Slider",
   Range = {0, 200},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 16, -- 通常は16
   Flag = "Slider1",
   Callback = function(Value)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
   end,
})

local Slider = SecoundTab:CreateSlider({
   Name = "Player JumpPower Slider",
   Range = {0, 200},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 16, -- 通常は16
   Flag = "Slider1",
   Callback = function(Value)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        end
   end,
})
