local Config = {
    Zones = {
        { coords = vector3(100.0, -1000.0, 30.0), radius = 5.0 }, -- salida paintball 1
        { coords = vector3(250.5, -800.2, 30.0), radius = 7.5 },  -- salida paintball 2
    },
    Debug = false -- logs en F8
}

local hasDisarmedForEntry = false
local showZones = false -- estado del /testzone

local function DebugLog(msg)
    if Config.Debug then
        print("^3[redrox-antiduplicate]^7 " .. msg)
    end
end

local function ForceHolster(ped)
    local currentWeapon = GetSelectedPedWeapon(ped)
    if currentWeapon == GetHashKey("WEAPON_UNARMED") then return end

    DebugLog("Arma detectada -> Forzando WEAPON_UNARMED")
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)

    -- COMPATIBILIDAD (descomenta el que uses)
    -- exports.ox_inventory:disarm(true)
    -- TriggerEvent('ox_inventory:disarm', true)
end

-- HILO 1: Logica principal optimizada
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local isInsideZone = false
        local closestDistance = math.huge

        for _, zone in ipairs(Config.Zones) do
            local dist = #(playerCoords - zone.coords)
            if dist < closestDistance then closestDistance = dist end
            if dist <= zone.radius then isInsideZone = true break end
        end

        if isInsideZone then
            sleep = 100
            if not hasDisarmedForEntry then
                if IsPedArmed(ped, 4 | 2 | 1) then
                    ForceHolster(ped)
                end
                hasDisarmedForEntry = true
                DebugLog("Entrada a zona -> desarmado y bloqueado")
            end
        else
            if hasDisarmedForEntry then DebugLog("Salio de zona -> bloqueo reseteado") end
            hasDisarmedForEntry = false
            if closestDistance < 50.0 then sleep = 250 else sleep = 1000 end
        end
        Wait(sleep)
    end
end)

-- HILO 2: Visualizador /testzone (no consume nada si esta apagado)
CreateThread(function()
    while true do
        local sleep = 500
        if showZones then
            sleep = 0
            local playerCoords = GetEntityCoords(PlayerPedId())
            for i, zone in ipairs(Config.Zones) do
                local dist = #(playerCoords - zone.coords)
                -- Cilindro rojo transparente
                DrawMarker(28, zone.coords.x, zone.coords.y, zone.coords.z, 0,0,0,0,0,0, zone.radius * 2.0, zone.radius * 2.0, 1.0, 255, 42, 42, 100, false, false, 2, false, nil, nil, false)
                -- Marcador verde si estas dentro
                if dist <= zone.radius then
                    DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 1.0, 0,0,0,0,0,0, zone.radius * 2.0, zone.radius * 2.0, 0.5, 42, 255, 42, 120, false, false, 2, false, nil, nil, false)
                end
            end
        end
        Wait(sleep)
    end
end)

-- Comando para activar/desactivar
RegisterCommand('testzone', function()
    showZones = not showZones
    Config.Debug = showZones -- activamos logs tambien mientras testeas
    if showZones then
        TriggerEvent('chat:addMessage', { args = {'^3[Antiduplicate]^7 Zonas visibles ^2ON^7 - Rojo = zona / Verde = estas DENTRO. Hace ^3/testzone^7 de nuevo para apagar.'} })
        print("^2[redrox-antiduplicate] /testzone ON - " .. #Config.Zones .. " zonas dibujadas^7")
        for i, z in ipairs(Config.Zones) do
            print(string.format("  Zona %s: vector3(%s, %s, %s) radius %s", i, z.coords.x, z.coords.y, z.coords.z, z.radius))
        end
    else
        TriggerEvent('chat:addMessage', { args = {'^3[Antiduplicate]^7 Zonas visibles ^1OFF^7'} })
        print("^1[redrox-antiduplicate] /testzone OFF^7")
    end
end, false)

-- Sugerencia para el chat de FiveM
TriggerEvent('chat:addSuggestion', '/testzone', 'Muestra/oculta los radios de desarme para configurar coords')
