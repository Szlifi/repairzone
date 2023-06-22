ESX = exports['es_extended']:getSharedObject()

function pedspawn()
  for k, v in ipairs(Config.points) do
      lib.RequestModel(v.model)
      ped = CreatePed(0, v.model, v.pedcoords, false, false)
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
  end
end

function zone()
  for k, v in ipairs(Config.points) do
      local zone = lib.zones.sphere({
          coords = v.coords,
          onExit = function()
              lib.hideTextUI()
          end,
          radius = v.radius,
          debug = v.debug,
          inside = function()
              local playerJob = ESX.PlayerData.job.name

              if playerJob == v.job then
                  if IsControlJustPressed(119, 119) then
                      if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        local playerPed = GetPlayerPed(-1)
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        FreezeEntityPosition(vehicle, true)
                          if lib.progressCircle({
                              label = 'Szerelés',
                              duration = 10000,
                              position = 'bottom',
                              useWhileDead = false,
                              canCancel = true,
                              disable = {
                                  car = false,
                              },
                          }) then
                          end
                          SetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1000)
                          SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, true)
                          SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                          FreezeEntityPosition(vehicle, false)
                          lib.notify({
                              title = 'Sikeresen megjavítottad!',
                              description = 'HeliosRP',
                              type = 'success',
                              position = 'top'
                          })
                      else
                          lib.notify({
                              title = 'Nem ülsz járműben!',
                              description = 'HeliosRP',
                              type = 'error',
                              position = 'top'
                          })
                      end
                  end
                  lib.showTextUI('[E] - Szerelés')
              end
          end,
      })
  end
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    zone()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    zone()
end)