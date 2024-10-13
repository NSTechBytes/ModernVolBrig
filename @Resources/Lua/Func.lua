function Initialize()

    if SKIN:GetVariable('CURRENTCONFIG') == [[ModernVolBrig\Main\Controller]] then
        
        -- ------------------------ stay on desktop operation ----------------------- --
        if SKIN:GetVariable('StayOnDesktop') == '0' then

            SKIN:Bang('[!Delay 100][!EnableMeasureGroup NUOL][!UpdateMeasure ACTIONLOAD][!CommandMeasure p.Focus "#CURRENTCONFIG#"][!Draggable 0][!ZPos 1]')

        -- -------------------------------- Position -------------------------------- --
        local pos = SKIN:GetVariable('Position')
        SKIN:Bang('!Draggable', '0')
        local posX = string.sub(pos, 2, 2)
        local posY = string.sub(pos, 1, 1)
        local xpad = SKIN:GetVariable('xpad')
        local ypad = SKIN:GetVariable('ypad')
        local MonitorIndex = SKIN:GetVariable('MonitorIndex')
        local sax = SKIN:GetVariable('WORKAREAX@' .. MonitorIndex)
        local say = SKIN:GetVariable('WORKAREAY@' .. MonitorIndex)
        local saw = SKIN:GetVariable('WORKAREAWIDTH@' .. MonitorIndex)
        local sah = SKIN:GetVariable('WORKAREAHEIGHT@' .. MonitorIndex)
        moveX = 0
        moveY = 0
        anchorX = 0
        anchorXD = 0
        anchorY = 0
        anchorYD = 0

        if posX == 'L' then moveX = sax + xpad
        elseif posX == 'C' then
            moveX = (sax + saw / 2)
            anchorX = "50%"
            anchorXD = 0.5
        elseif posX == 'R' then
            moveX = (sax + saw - xpad)
            anchorX = "100%"
            anchorXD = 1
        end

        if posY == 'T' then moveY = say + ypad
        elseif posY == 'C' then
            moveY = (say + sah / 2)
            anchorY = "50%"
            anchorYD = 0.5
        elseif posY == 'B' then
            moveY = (say + sah - ypad)
            anchorY = "100%"
            anchorYD = 1
        end

        SKIN:Bang('!SetWindowPosition ' .. moveX .. ' ' .. moveY .. ' ' .. anchorX .. ' ' .. anchorY)

            -- ------------------------- handle animation toggle ------------------------ --

            if tonumber(SKIN:GetVariable('Animated')) == 1 then
                AniSteps = tonumber(SKIN:GetVariable('AniSteps'))
                TweenInterval = 100 / AniSteps
                AnimationDisplacement = SKIN:GetVariable('AnimationDisplacement')
                AniDir = SKIN:GetVariable('AniDir')
                dofile(SELF:GetOption("ScriptFile"):match("(.*[/\\])") .. "tween.lua")
                subject = {
                    TweenNode = 0
                }
                t = tween.new(AniSteps, subject, {TweenNode=100}, SKIN:GetVariable('Easetype'))
            else
                SKIN:Bang('[!SetTransparency 255]')
            end
        else
            
            SKIN:Bang('[!Delay 100][!Show][!SetTransparency 255][!Draggable 1][!ZPos 0][!SetAnchor 0 0]')
        end
    end
end
    
        
function TweenAnimation(dir)
    if dir == 'in' then
        local complete = t:update(1)
    else
        local complete = t:update(-1)
    end
    local bang = ''
    resultantTN = subject.TweenNode
    if resultantTN > 100 then resultantTN = 100 elseif resultantTN < 0 then resultantTN = 0 end
    if AniDir == 'Left' then
        bang = bang..'[!SetWindowPosition '..moveX + (resultantTN / 100 - 1) * AnimationDisplacement..' '..moveY..' '..anchorX..' '..anchorY..']'
    elseif AniDir == 'Right' then
        bang = bang..'[!SetWindowPosition '..moveX + (1 - resultantTN / 100) * AnimationDisplacement..' '..moveY..' '..anchorX..' '..anchorY..']'
    elseif AniDir == 'Top' then
        bang = bang..'[!SetWindowPosition '..moveX..' '..moveY + (resultantTN / 100 - 1) * AnimationDisplacement..' '..anchorX..' '..anchorY..']'
    elseif AniDir == 'Bottom' then
        bang = bang..'[!SetWindowPosition '..moveX..' '..moveY + (1 - resultantTN / 100) * AnimationDisplacement..' '..anchorX..' '..anchorY..']'
    end
    bang = bang .. '[!SetTransparency '..(resultantTN / 100 * 255)..']'
    
    SKIN:Bang(bang)
end

