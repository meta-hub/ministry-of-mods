local authorImage = nil

<<<<<<< Updated upstream
local function LogToDiscord(name, title, color, message, tagEveryone)
=======
--[[
    Functions
]]

function LogToDiscord(name, title, color, message, tagEveryone)
>>>>>>> Stashed changes
    local colorMath = math.floor(color.r) * 65536 + math.floor(color.g) * 256 + math.floor(color.b)
    local body = nil

    if tagEveryone then
        body = "@everyone"
    end

    local webhook = Config.WebhookTable[name] or Config.WebhookTable['default']
    local data = json.encode({
        ["username"] = webhook.botName,
        ["avatar_url"] = webhook.botImage,
        ["content"] = body,
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = colorMath,
            ["footer"] = {
                ["text"] = os.date('%c')
            },
            ["author"] = {
                ["name"] = "Ministry of Mods",
                ["icon_url"] = authorImage,
            },
        }}
    })

<<<<<<< Updated upstream
    print(message)

=======
>>>>>>> Stashed changes
    --[[local succes, response, header = pcall(function()
		return --REQUIRED HTTP REQUEST
	end)
	if not succes then
		print(response)
	end]]
end

--[[
    Exports
]]

Exports("LogToDiscord", LogToDiscord)