Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if aiming == 1 and entity > 0 and GetEntityModel(entity) == 416176080 and isRob == false then -- do zmiany jesli chodzi o modele!
                ESX.TriggerServerCallback('i:PoliceOnDutyShop', function(police)
                    print(police)
                    if police > Config.PoliceReq then
                        print(police) 
                        zaczynamyzabawe(entity)
                    end
                end)
            end
    Citizen.Wait(2000)
    end
end)


--trzeba dodać, żeby ped, który został zabity był podmieniony lub powstał nowy

RegisterNetEvent("Infram:DokonczNapad")
AddEventHandler("Infram:DokonczNapad", function()
    exports['qtarget']:RemoveZone("CashBoard")
    exports.rprogress:Custom({
        Duration = 10000,
        canCancel = true,
        -- Label = "Handing over a package...",
        Label = "Bierzesz pieniądze!",
        Animation = {
            --scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
            animationDictionary = "oddjobs@shop_robbery@rob_till", -- https://alexguirre.github.io/animations-list/
            animationName = "loop",
        },
        DisableControls = {
            Mouse = false,
            Player = true,
            Vehicle = true
        },	
        onComplete = function(cancelled)
            TriggerServerEvent("Infram:RobberyWin", PlayerId())
        end
    })
end)

function anim(ped,add, animm)
    local ad = add
    local anim = animm --- insert the animation name here
    ESX.Streaming.RequestAnimDict(ad, function()
        isDoingAnimation = true
        TaskPlayAnim(ped, ad, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    end)
    Citizen.Wait(1000)
end

function zaczynamyzabawe(ent)
    --TriggerServerEvent('inside-shoprobbery:PoliceNotifyRobberySHOP', exports['cd_dispatch']:GetPlayerInfo())
    local l = math.random(1,4)
    local counter = 0
    local pedc = GetEntityCoords(ent)
        if l <= 1 and isRob == false then 
            isRob = true
            FreezeEntityPosition(ent, false)
            SetBlockingOfNonTemporaryEvents(ent, false)
            SetEntityInvincible(ent, false)
            GiveWeaponToPed(ent,2017895192,20,1,1)
            exports.rprogress:Custom({
                Duration = 1000,
                canCancel = true,
                Label = "Gość miał broń, spierdalaj!",
                Animation = {
                    --scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
                    animationDictionary = "", -- https://alexguirre.github.io/animations-list/
                    animationName = "",
                },
                DisableControls = {
                    Mouse = false,
                    Player = false,
                    Vehicle = true
                },	
                onComplete = function(cancelled)

                end
            })
            Citizen.Wait(5000)
            TaskCombatPed(ent, PlayerPedId(),0,16)
            local l = GetEntityCoords(GetClosestObjectOfType(pedc,7.0,303280717))
            local pedc = GetEntityCoords(ent)
            local coo = GetEntityCoords(ent)
            while counter < 30 do
                if IsEntityDead(ent) then
                    --informacja że został zabity ped i że trzeba samemu dokończyć napad
                    exports.qtarget:AddBoxZone("CashBoard", vector3(l.x,l.y,l.z), 0.5, 0.6, {
                        name="CashBoard",
                        debugPoly = false,
                        minZ=l.z-0.1,
                        maxZ=l.z+0.3,
                        }, {
                            options = {
                                {
                                event = "Infram:DokonczNapad",
                                icon = "fa fa-university",
                                label = "Dokończ napad",
                                itemek = "dekoder",
                                num = 1,
                                },
                            },
                            job = "all",
                            distance = 3.5
                    })
                    DeletePed(ent)
                    isRob = false
                    --ent = CreatePed(4, 416176080, pedc.x, pedc.y, pedc.z-0.99, pedh)
                    -- SetEntityAsMissionEntity(ent)
                    -- SetBlockingOfNonTemporaryEvents(ent, true)
                    -- FreezeEntityPosition(ent, true)
                    -- SetEntityInvincible(ent, true)
                    -- SetModelAsNoLongerNeeded(ent)
                    break
                end
                Citizen.Wait(2000)
                counter = counter + 1
            end
        elseif l > 1 then 
            local pedc = GetEntityCoords(ent)
            local pedh = GetEntityHeading(ent)
            local l = GetEntityCoords(GetClosestObjectOfType(pedc,7.0,303280717))
            SetFacialIdleAnimOverride(ent, "mood_stressed_1")
            SetEntityInvincible(ent, false)
            anim(ent, "random@robbery","robbery_main_female")
            exports.rprogress:Custom({
                Duration = 10000,
                canCancel = true,
                -- Label = "Handing over a package...",
                Label = "Napadasz na sklep!",
                Animation = {
                    --scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
                    animationDictionary = "", -- https://alexguirre.github.io/animations-list/
                    animationName = "",
                },
                DisableControls = {
                    Mouse = false,
                    Player = false,
                    Vehicle = true
                },	
                onComplete = function(cancelled)
                    if not IsEntityDead(ent) then
                    exports.rprogress:Custom({
                        Duration = 38000,
                        canCancel = true,
                        -- Label = "Handing over a package...",
                        Label = "Drzesz się ostro na sprzedawcę, napad trwa!",
                        Animation = {
                            --scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
                            animationDictionary = "", -- https://alexguirre.github.io/animations-list/
                            animationName = "",
                        },
                        DisableControls = {
                            Mouse = false,
                            Player = false,
                            Vehicle = true
                        },
                        onComplete = function(cancelled)
                            if IsEntityDead(ent) then
                                -- gracz musi dokończyć napad, notyfikacja---
                                exports.qtarget:AddBoxZone("CashBoard", vector3(l.x,l.y,l.z), 0.5, 0.6, {
                                    name="CashBoard",
                                    debugPoly = false,
                                    minZ=l.z-0.1,
                                    maxZ=l.z+0.3,
                                    }, {
                                        options = {
                                            {
                                            event = "Infram:DokonczNapad",
                                            icon = "fa fa-university",
                                            label = "Dokończ napad",
                                            itemek = "dekoder",
                                            num = 1,
                                            },
                                        },
                                        job = "all",
                                        distance = 3.5
                                })
                                DeletePed(ent)
                                isRob = false
                                --ent = CreatePed(4, 416176080, pedc.x, pedc.y, pedc.z-0.99, pedh)
                                -- SetEntityAsMissionEntity(ent)
                                -- SetBlockingOfNonTemporaryEvents(ent, true)
                                -- FreezeEntityPosition(ent, true)
                                -- SetEntityInvincible(ent, true)
                                -- SetModelAsNoLongerNeeded(ent)
                            end	
                        end
                    })
                elseif IsEntityDead(ent) then
                    -- gracz musi dokończyć napad, notyfikacja---
                    exports.qtarget:AddBoxZone("CashBoard", vector3(l.x,l.y,l.z), 0.5, 0.6, {
                        name="CashBoard",
                        debugPoly = false,
                        minZ=l.z-0.1,
                        maxZ=l.z+0.3,
                        }, {
                            options = {
                                {
                                event = "Infram:DokonczNapad",
                                icon = "fa fa-university",
                                label = "Dokończ napad",
                                itemek = "dekoder",
                                num = 1,
                                },
                            },
                            job = "all",
                            distance = 3.5
                    })
                    DeletePed(ent)
                    isRob = false
                    --ent = CreatePed(4, 416176080, pedc.x, pedc.y, pedc.z-0.99, pedh)
                    -- SetEntityAsMissionEntity(ent)
                    -- SetBlockingOfNonTemporaryEvents(ent, true)
                    -- FreezeEntityPosition(ent, true)
                    -- SetEntityInvincible(ent, true)
                    -- SetModelAsNoLongerNeeded(ent)

                    end
                end
            })
            Citizen.Wait(48000)
            ClearPedTasks(ent)
            anim(ent, "random@robbery","return_bag_stand_b")
            SetFacialIdleAnimOverride(ent, "mood_normal_1")
            TriggerServerEvent("Infram:RobberyWin")
            if IsEntityDead(ent) and pedc.x  then
                DeletePed(ent)
                isRob = false
                --ent = CreatePed(4, 416176080, pedc.x, pedc.y, pedc.z-0.99, pedh)
                -- SetEntityAsMissionEntity(ent)
                -- SetBlockingOfNonTemporaryEvents(ent, true)
                -- FreezeEntityPosition(ent, true)
                -- SetEntityInvincible(ent, true)

            end
    end
end
