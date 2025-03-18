--!Type(UI)


--!Bind
local titleLabel: UILabel = nil
--!Bind
local nameLabel: UILabel = nil
--!Bind
local timerLabel: UILabel = nil
--!Bind
local _ImageContainer : VisualElement = nil
--!Bind
local contestantIcon : UIUserThumbnail = nil
--!Bind
local _TimerIcon : Image = nil


function SetTitle(title: string)
    titleLabel:SetPrelocalizedText(title, true)
end

function SetContestantName(name: string)
    nameLabel:SetPrelocalizedText(name, true)
end


function HideUserThumbnail(option: boolean)
    if option == true then
        contestantIcon:Unload()
        _ImageContainer:AddToClassList("HideUserThumbnail")
    elseif option == false then
        _ImageContainer:RemoveFromClassList("HideUserThumbnail")
    else
        print("[HideUserThumbnail] Invalid option")
    end
end

function SetUserThumbnail(player: Player)
    contestantIcon:Load(player)
end

function SetTimer(time)
    if time == 0 then
        timerLabel:SetPrelocalizedText("Time's Up!", true)
        return
    elseif time <= -1 then
        timerLabel:SetPrelocalizedText(" ", true)
        _TimerIcon:AddToClassList("HideTimerIcon")
        return
    end

    _TimerIcon:RemoveFromClassList("HideTimerIcon")
    timerLabel:SetPrelocalizedText(tostring(time) .. " sec", true)
end

SetTitle("Waiting For Players")
SetContestantName("Intermission")
SetTimer(-1)
