local exports = exports
local addEvent = addEvent
local addEventHandler = addEventHandler
local toggleControl = toggleControl
local collectgarbage = collectgarbage
local root = root
local math = math
local attachment = exports.bone_attach -- https://community.multitheftauto.com/index.php?p=resources&s=details&id=2540
local balls = {}

local goal = function(player)
    if player then
        attachment:detachElementFromBone(balls[player])
        balls[player]:setPosition(player.position.x,player.position.y,player.position.z)
        balls[player]:move(500, 2111.1923828125, -1731.693359375, 15.8)
        Timer(function(object)
            object:move(500, object.position.x,object.position.y,object.position.z-3)
        end, 500, 1, balls[player])
        Timer(function(element)
            element:outputChat('good shot.')
            element:setAnimation()
            element.frozen = false
        end, 500, 1, player)
    end
end

local didnt = function(player)
    if player then
        attachment:detachElementFromBone(balls[player])
        balls[player]:setPosition(player.position.x,player.position.y,player.position.z)
        balls[player]:move(500, 2111.1923828125+math.random(1,2), -1731.693359375, 15.8)
        Timer(function(object)
            object:move(500, object.position.x,object.position.y,object.position.z-3)
        end, 500, 1, balls[player])
        Timer(function(element)
            element:outputChat('nope.')
            element:setAnimation()
            element.frozen = false
        end, 500, 1, player)
    end
end

addEvent('attach.ball', true)
addEventHandler('attach.ball', root, function()
    if source then
        if not balls[source] then
            balls[source] = Object(2114, 0, 0, 0)
        end
        attachment:attachElementToBone(balls[source], source, 12, -0.05, 0.02, 0.19, 0, -190, -110)
        source.frozen = true
        source:setAnimation('bsktball','BBALL_pickup',true,false)
        Timer(function(player)
            if player then
                player:setAnimation()
                player.frozen = false
            end
        end, 1000, 1, source)
    end
end)

addEvent('detach.ball', true)
addEventHandler('detach.ball', root, function()
    if source then
        if balls[source] then
            attachment:detachElementFromBone(balls[source])
            balls[source]:destroy()
            balls[source] = nil
            collectgarbage('collect')
        end
    end
end)

addEvent('shoot.ball', true)
addEventHandler('shoot.ball', root, function(shoot)
    if source then
        source.frozen = true
        source:setAnimation('bsktball','BBALL_Jump_Shot',true,false)
        if shoot then
            Timer(function(player)
                goal(player)
            end, 800, 1, source)
        else
            Timer(function(player)
                didnt(player)
            end, 800, 1, source)
        end
        local controls = {{'fire'},{'aim_weapon'},{'enter_exit'},}
        for index, value in ipairs(controls) do
            toggleControl(source, value[1], true)
        end
    end
end)