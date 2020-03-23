local component = require("component")
local gpu = component.gpu
local thread = require("thread")
local config = require("spawner/config")
local availableMobs = require("spawner/lib/mobs")
local nbt = require("spawner/lib/nbt")
local libdeflate = require("spawner/lib/LibDeflate")
local livingmatter = require("spawner/lib/livingmatter")
local wm = require("windowmanager/libs/wm")
local gui = require("windowmanager/libs/guiElements")

-- local state for running the program
local screenWidth, _ = gpu.getResolution()
local isRunning = false
local isShuttingDown = false
local configuredMobToSpawn = 1
local machineStatusMessage = "Idle"
local loggerMessageCount = 1
local loggerSelectedLine = 1
local spawningThread = nil
local noLog = true
-- local references to UI objects
local tempMessageBeingDisplayed = false
local pendingStatusUpdate = false
local aboutWindow, statusWindow, controlWindow, configWindow, loggerWindow
local mobSelectionRadioGroups = {}
local aboutText1, aboutText2, aboutText3, infoLabel, buttonFrame, startStopButton, abortButton, clearLoggerButton, selectionBlurbFrame, selectionBlurbText, mobHeader, mobLabel, batchSizeHeader, batchSizeLabel, keyMatterHeader, keyMatterLabel, bulkMatterHeader, bulkMatterLabel, loggerList, loggerSlider

--------------------------------------------------------------------------------
-- HELPER METHODS
--------------------------------------------------------------------------------
function stopThread(theThread, graceful)
  if (theThread ~= nil) then
    if (graceful) then
      theThread:join()
    else
      theThread:suspend()
    end
  end
end

function _winSize(size, percent)
  local max = size - 3
  local adjusted = math.floor(size * percent)
  return math.min(adjusted, max)
end

function _setStatusWindowText(text, bgColor)
  gui.setElementText(infoLabel, text)
  gui.setElementBackground(infoLabel, bgColor)
  gui.drawElement(statusWindow, infoLabel)
end

function _getColorForMessage(type)
  local color = config.ui.colors.gray
  local types = config.ui.messageTypes

  if (type == types.info or type == nil) then
    color = config.ui.colors.gray
  elseif (type == types.warn) then
    color = config.ui.colors.yellow
  elseif (type == types.error) then
    color = config.ui.colors.red
  end

  return color
end

function setMachineStatus(message)
  thread.create(function()
    if (noLog) then return end
    machineStatusMessage = message
    pendingStatusUpdate = true
    while (tempMessageBeingDisplayed) do os.sleep(0) end
    addLoggerMessage(machineStatusMessage)
    _setStatusWindowText(machineStatusMessage, _getColorForMessage(config.ui.messageTypes.info))
    pendingStatusUpdate = false
  end)
end

function setTemporaryMachineStatus(message, type)
  thread.create(function()
    if (noLog) then return end
    if (type == nil) then type = config.ui.messageTypes.info end
    tempMessageBeingDisplayed = true
    addLoggerMessage(message)
    _setStatusWindowText(message, _getColorForMessage(type))

    os.sleep(config.ui.messageDisplayDuration)

    if (not pendingStatusUpdate) then
      addLoggerMessage(machineStatusMessage)
      _setStatusWindowText(machineStatusMessage, _getColorForMessage(config.ui.messageTypes.info))
    end

    tempMessageBeingDisplayed = false
  end)
end

function setWindowConfig(win)
  wm.disableWindowButtons(win, true)
  wm.setWindowSticky(win, true)
end

function setLabelHeaderFormat(label)
  gui.setElementBackground(label, config.ui.colors.darkgray)
  gui.setElementForeground(label, config.ui.colors.white)
  gui.setElementAlignment(label, "center")
end

function setConfigDisplayForMob(choice)
  local mobConfig = availableMobs[choice]

  gui.setElementText(mobLabel, mobConfig.mobName)
  gui.setElementText(batchSizeLabel, getBatchSize(mobConfig))
  gui.setElementText(keyMatterLabel, mobConfig.matter.key.name)
  gui.setElementText(bulkMatterLabel, mobConfig.matter.bulk.name)

  gui.drawElement(configWindow, mobLabel)
  gui.drawElement(configWindow, batchSizeLabel)
  gui.drawElement(configWindow, keyMatterLabel)
  gui.drawElement(configWindow, bulkMatterLabel)
end

function setStartStopButtonState(isStart)
  if (isStart) then
    gui.setElementText(startStopButton, "Start")
    gui.setElementBackground(startStopButton, config.ui.colors.blue)
    gui.setElementForeground(startStopButton, config.ui.colors.white)
  else
    gui.setElementText(startStopButton, "Stop")
    gui.setElementBackground(startStopButton, config.ui.colors.red)
    gui.setElementForeground(startStopButton, config.ui.colors.black)
  end

  gui.drawElement(controlWindow, startStopButton)
end

function addLoggerMessage(text)
  if (noLog) then return end
  gui.insertElementData(loggerList, text)
  if (loggerMessageCount < config.logger.maxBufferSize) then
    if (loggerMessageCount < 15) then
      loggerSelectedLine = loggerSelectedLine
    else
      loggerSelectedLine = loggerMessageCount - 13
    end

    loggerMessageCount = loggerMessageCount + 1
  else
    gui.removeElementData(loggerList, 1)
  end
  gui.setElementSelected(loggerList, loggerSelectedLine)
  gui.drawElement(loggerWindow, loggerList)
end

function getBatchSize(mob)
  local matter = config.components.matter
  return (getMatterMultiplier(1, matter.key.infusion) / mob.matter.key.amount)
end

--------------------------------------------------------------------------------
-- SPAWNER METHODS
--------------------------------------------------------------------------------
function getMatterMultiplier(matterValue, infusePercentage)
  -- AmountSent = <number items> * <item value> * 3.0 / (3.0 - <infusion amount>)
  return 1 * matterValue * 3.0 / (3.0 - (infusePercentage / 100))
end

function spawnMobs(choice)
  local mob = availableMobs[choice]
  local matter = config.components.matter

  local numberMobsPerKey = getBatchSize(mob)

  local bulkMultiplier = getMatterMultiplier(1, matter.bulk.infusion)
  local livingMultiplier = getMatterMultiplier(livingmatter[mob.matter.living.id], matter.living.infusion)

  local bulkTotal = ((numberMobsPerKey * mob.matter.bulk.amount) / bulkMultiplier)
  local livingTotal = ((numberMobsPerKey * mob.matter.living.amount) / livingMultiplier)

  if (not transferMatter(config.components.matter.key, mob.matter.key, 1)) then
    return false
  end

  if (not transferMatter(config.components.matter.bulk, mob.matter.bulk, bulkTotal)) then
    return false
  end

  if (not transferMatter(config.components.matter.living, mob.matter.living, livingTotal)) then
    return false
  end

  return true
end

function transferMatter(device, matter, total)
  local remaining = math.ceil(total)
  local amountToMove = math.min(64, remaining)
  local moved = 0
  local interface = device.interface
  local transposer = device.transposer
  local redstone = device.redstone
  local itemStack = {name = matter.id}

  if (device.transposer.getSlotStackSize(device.io.transposer.output, 1) ~= 0) then
    setTemporaryMachineStatus("A matter beamer is not empty! Contact Wrath!", config.ui.messageTypes.error)
    return false
  end

  local status, result = pcall(function() return device.interface.getItem(itemStack) end)
  if ((not status) or result == nil) then
    -- Could not find the item
    setTemporaryMachineStatus("Unable to find " .. matter.name .. " (" .. matter.id .. ") in the RS network!", config.ui.messageTypes.error)
    return false
  elseif (result.size < amountToMove) then
    -- Too little available
    setTemporaryMachineStatus("Not enough " .. matter.name .. " available!", config.ui.messageTypes.error)
    return false
  end

  while (remaining > 0) do
    amountToMove = math.min(64, remaining)

    status, result = pcall(function() return interface.extractItem(itemStack, amountToMove, device.io.interface.output) end)
    if (status and result == amountToMove) then

      -- Everything succeeded, Move through transposer to matter beamer
      status, result = pcall(function() return transposer.transferItem(device.io.transposer.input, device.io.transposer.output, amountToMove, 1, 1) end)
      if (status and result == amountToMove) then
        -- Matter is in beamer, wait for beaming to finish
        remaining = remaining - amountToMove
        moved = amountToMove

        addLoggerMessage("Beaming " .. moved .. " " .. matter.name .. " into spawner. " .. remaining .. " remaining.")
        redstone.setOutput(device.io.redstone.output, 15)
        while (transposer.getSlotStackSize(device.io.transposer.output, 1) ~= 0) do os.sleep(0) end
        redstone.setOutput(device.io.redstone.output, 0)
      elseif (status and result == 0) then
        -- The beamer is either full or has a different kind of item
        setTemporaryMachineStatus("Could not move any " .. matter.name .. " into matter beamer! Error: " .. result, config.ui.messageTypes.error)
        return false
      elseif (status and result < amountToMove) then
        -- The beamer is full and there is more material to transfer
        setTemporaryMachineStatus("Could not move " .. result .. " " .. matter.name .. " into matter beamer!", config.ui.messageTypes.error)
        return false
      else
        -- Some kind of error occurred pushing into the beamer
        setTemporaryMachineStatus("Unknown error while moving " .. matter.name .. " into matter beamer!", config.ui.messageTypes.error)
        return false
      end
    elseif (status and result == 0) then
      -- The cache is full or has a different type of item
      setTemporaryMachineStatus("Could not move any " .. matter.name .. " into cache! Error: " .. result, config.ui.messageTypes.error)
      return false
    elseif (status and result < amountToMove) then
      -- The cache is full and there is still material to transfer
      setTemporaryMachineStatus("Could not move " .. result .. " " .. matter.name .. " into cache! Error: " .. result, config.ui.messageTypes.error)
      return false
    else
      -- Some kind of error from RS occurred
      setTemporaryMachineStatus("Unknown error while moving " .. matter.name .. " into cache! Error: " .. result, config.ui.messageTypes.error)
      return false
    end
  end

  return true
end

function doShutdown(theThread)
  isRunning = false
  isShuttingDown = true

  setMachineStatus("Stopping")
  setStartStopButtonState(true)

  -- Stop the spawner thread
  addLoggerMessage("Shutting down gracefully.")
  addLoggerMessage("Finishing this current batch of " .. getBatchSize(availableMobs[configuredMobToSpawn]) .. " mobs.")
  stopThread(theThread, true)
  addLoggerMessage("Batch finished spawning.")

  -- Empty the matter beamers
  emptyMatterBeamers()

  addLoggerMessage("Graceful shutdown complete.")

  setMachineStatus("Idle")
  isShuttingDown = false
end

function doAbort(theThread)
  local device = config.components.syringe
  local itemStack = getSyringeItemStackForMob(nil)

  isRunning = false
  isShuttingDown = true

  setMachineStatus("Aborting (all transferred material will be disposed of)")
  setStartStopButtonState(true)

  stopThread(theThread, false)

  -- Empty the matter beamers
  emptyMatterBeamers()

  device.transposer.transferItem(device.io.transposer.input, device.io.transposer.output, 1, 1, 1)
  os.sleep(1)
  device.interface.extractItem(itemStack, 1, device.io.interface.output)

  setTemporaryMachineStatus("Aborted successfully!", config.ui.messageTypes.info)
  setMachineStatus("Idle")
  isShuttingDown = false
end

function emptyMatterBeamers()
  for _, device in pairs(config.components.matter) do
    device.redstone.setOutput(device.io.redstone.output, 15)
    while (device.transposer.getSlotStackSize(device.io.transposer.output, 1) ~= 0) do os.sleep(0) end
    device.redstone.setOutput(device.io.redstone.output, 0)
  end
end

function emptySpawner()
  local syringe = config.components.syringe
  local input = syringe.io.transposer.input
  local output = syringe.io.transposer.output

  if (syringe.transposer.getSlotStackSize(input, 1) ~= 0) then
    if (syringe.transposer.transferItem(input, output, 1, 1, 1) ~= 1) then
      return false
    end
  end

  return true
end

function getSyringeItemStackForMob(choice)
  local chosenMob = choice
  if (choice == nil) then chosenMob = configuredMobToSpawn end
  local mob = availableMobs[chosenMob]
  local nbtString = '{name="",type="compound",values={{name="mobName",type="string",value="'
      .. mob.mobName .. '"},{name="level",type="int",value=10},{name="mobId",type="string",value="'
      .. mob.mobId .. '"}}}'
  local deflatedNbtData, _ = libdeflate:CompressGzip(nbt.encode(nbtString))

  return {name="rftools:syringe", tag=deflatedNbtData}
end

function configureMachineForChosenMob(choice, indexOffset)
  local chosenMob = choice + indexOffset
  local mob = availableMobs[chosenMob]
  local syringe = config.components.syringe
  local chosenMobSyringe =  getSyringeItemStackForMob(chosenMob)

  -- Do not configure if the syringe is not in the RS network
  local status, result = pcall(function() return syringe.interface.getItem(chosenMobSyringe, false, true) end)
  if (status and result == nil) then return end

  -- The syringe we want is in the RS network, so empty spawner
  if (not emptySpawner()) then
    setTemporaryMachineStatus("[FATAL] Could not empty spawner! Contact Wrath!", config.ui.messageTypes.error)
    return
  end

  status, result = pcall(function()
    return syringe.interface.extractItem(chosenMobSyringe, 1, syringe.io.interface.output)
  end)
  if (status) then
    configuredMobToSpawn = chosenMob
    setConfigDisplayForMob(chosenMob)
    setTemporaryMachineStatus("Configured for " .. mob.mobName .. " successfully!")
    setMachineStatus("Idle")
  else
    setTemporaryMachineStatus("[FATAL] Could not add syringe to spawner! Contact Wrath! Error: " .. result, config.ui.messageTypes.error)
  end
end
--------------------------------------------------------------------------------
-- UI CALLBACKS
--------------------------------------------------------------------------------
function mobSelectionCallback1(self, win)
  if (isShuttingDown) then return end
  local picked = gui.getElementSelected(self)

  if (picked == configuredMobToSpawn) then return end

  if (not isRunning) then
    configureMachineForChosenMob(picked, 0)
  else
    setTemporaryMachineStatus("Cannot reconfigure while running!", config.ui.messageTypes.error)
  end
end

function mobSelectionCallback2(self, win)
  if (isShuttingDown) then return end
  local picked = gui.getElementSelected(self)

  if (picked == configuredMobToSpawn) then return end

  if (not isRunning) then
    configureMachineForChosenMob(picked, 18)
  else
    setTemporaryMachineStatus("Cannot reconfigure while running!", config.ui.messageTypes.error)
  end
end

function mobSelectionCallback3(self, win)
  if (isShuttingDown) then return end
  local picked = gui.getElementSelected(self)

  if (picked == configuredMobToSpawn) then return end

  if (not isRunning) then
    configureMachineForChosenMob(picked, 36)
  else
    setTemporaryMachineStatus("Cannot reconfigure while running!", config.ui.messageTypes.error)
  end
end

function startStopButtonCallback(self, win)
  if (isShuttingDown) then return end
  if (not isRunning) then
    -- Start the machine; Set the start/stop button to stop state
    local mob = availableMobs[configuredMobToSpawn]
    setStartStopButtonState(false)
    isRunning = true
    setMachineStatus("Spawning " .. mob.mobName .. " in batches of " .. getBatchSize(mob) .. ".")
    spawningThread = thread.create(function()
      local error = false

      while (isRunning) do
        if (not spawnMobs(configuredMobToSpawn)) then
          isRunning = false
          error = true
        end
      end

      isShuttingDown = true
      if (error) then
        setTemporaryMachineStatus("An error has occurred causing spawning to stop!", config.ui.messageTypes.error)
        setMachineStatus("Idle")
        setStartStopButtonState(true)
      end

      isShuttingDown = false
    end)
  else
    -- Stop the machine; Set the start/stop button to start state
    setStartStopButtonState(true)
    isRunning = false
    doShutdown(spawningThread)
  end
end

function abortButtonCallback(self, win)
  if (isShuttingDown) then return end
  if (not isRunning) then
    setTemporaryMachineStatus("Machine not currently running!", config.ui.messageTypes.error)
  else
    doAbort(spawningThread)
  end
end

function clearLoggerButtonCallback(self, win)
  loggerList = gui.newList(2, 2, _winSize(screenWidth, 0.95), 14, "", function()
    loggerSelectedLine = gui.getElementSelected(loggerList)
    gui.setElementValue(loggerSlider, loggerSelectedLine)
    gui.drawElement(loggerWindow, loggerSlider)
  end)
  gui.clearElementData(loggerList)
  gui.setElementBackground(loggerList, 0xFFFFFF)
  gui.setElementActiveBackground(loggerList, 0x202020)
  gui.setElementForeground(loggerList, 0x000000)
  gui.setElementActiveForeground(loggerList, 0xFFFFFF)

  loggerSlider = gui.newVSlider(_winSize(screenWidth, 0.965), 2, 14, function()
    loggerSelectedLine = gui.getElementValue(loggerSlider)
    gui.setElementSelected(loggerList, loggerSelectedLine)
    gui.drawElement(loggerWindow, loggerList)
  end)
  gui.setElementMin(loggerSlider, 1)
  gui.setElementValue(loggerSlider, 1)
  gui.setElementMax(loggerSlider, config.logger.maxBufferSize)

  wm.addElement(loggerWindow, loggerList)
  wm.addElement(loggerWindow, loggerSlider)

  loggerSelectedLine = 1
  loggerMessageCount = 1
  addLoggerMessage("Log cleared")

  wm.drawElement(loggerWindow, loggerList)
  wm.drawElement(loggerWindow, loggerSlider)
end

--------------------------------------------------------------------------------
-- INITIALIZE AND BUILD UI
--------------------------------------------------------------------------------
wm.startGui()
wm.setTopText("Mob Drop Collector 1.0 (MDC-1)")

wm.setSystemMenuPos("right")
wm.addSystemMenu("Shutdown", wm.shutdown, nil, 0, 1)
wm.addSystemMenu("Reboot", wm.shutdown, true, 0, 1)

--
-- About Window
--
aboutWindow = wm.newWindow(2, 2, _winSize(screenWidth, 0.25), 24, "About")
setWindowConfig(aboutWindow)

aboutText1 = gui.newLabel(1, 1, _winSize(screenWidth, 0.24), 8, "MDC-1 is a machine which when provided with the proper materials will and power will spawn and destroy mobs automatically. It will collect the drops (including the experience) and store them in the attached system. Only the configured mobs are able to be spawned.")
gui.setElementAutoWordWrap(aboutText1, true)

aboutText2 = gui.newLabel(1, 10, _winSize(screenWidth, 0.24), 9, "It should be noted that due to how materials are consumed by the RFTools Spawner you are never guaranteed to use all matter. When you stop the machine you will often see leftover bulk/living matter. This is because the choice was made to prioritize utilization of key matter (which is harder to come by).")
gui.setElementAutoWordWrap(aboutText2, true)

aboutText3 = gui.newLabel(1, 20, _winSize(screenWidth, 0.24), 4, "Use the buttons on the interface to control the spawner. The computer itself can be controlled through the [system] menu in the top-right corner.")
gui.setElementAutoWordWrap(aboutText3, true)

wm.addElement(aboutWindow, aboutText1)
wm.addElement(aboutWindow, aboutText2)
wm.addElement(aboutWindow, aboutText3)
wm.raiseWindow(aboutWindow)

--
-- Status Window
--
statusWindow = wm.newWindow(_winSize(screenWidth, 0.25) + 4, 2, _winSize(screenWidth, 0.59), 2, "Status")
setWindowConfig(statusWindow)

infoLabel = gui.newLabel(1, 1, _winSize(screenWidth, 0.58), 1, machineStatusMessage)

wm.addElement(statusWindow, infoLabel)
wm.raiseWindow(statusWindow)

--
-- Control Window
--
controlWindow = wm.newWindow(_winSize(screenWidth, 0.25) + 4, 7, _winSize(screenWidth, 0.59), 19, "Control")
setWindowConfig(controlWindow)

-- we cannot list more than 18 per column for the radioGroup
mobSelectionRadioGroups[1] = gui.newRadioGroup(1, 1, 25, mobSelectionCallback1)
mobSelectionRadioGroups[2] = gui.newRadioGroup(26, 1, 25, mobSelectionCallback2)
mobSelectionRadioGroups[3] = gui.newRadioGroup(52, 1, 25, mobSelectionCallback3)
gui.setElementAlignment(mobSelectionRadioGroups[1], "right")
gui.setElementAlignment(mobSelectionRadioGroups[2], "right")
gui.setElementAlignment(mobSelectionRadioGroups[3], "right")

local radioGroupIndex = 1
for i = 1, #availableMobs do
  gui.insertElementData(mobSelectionRadioGroups[radioGroupIndex], availableMobs[i].mobName)
  if ((i % 18) == 0) then radioGroupIndex = radioGroupIndex + 1 end
end

buttonFrame = gui.newFrame(73, 1, 20, 7)

startStopButton = gui.newButton(74, 2, 18, 1, "Start", startStopButtonCallback)
abortButton = gui.newButton(74, 4, 18, 1, "Abort", abortButtonCallback)
clearLoggerButton = gui.newButton(74, 6, 18, 1, "Clear Log", clearLoggerButtonCallback)

selectionBlurbFrame = gui.newFrame(73, 8, 20, 11)
selectionBlurbText = gui.newLabel(74, 9, 18, 9, "Each column of mobs has an X for selection but only the most recent one you've clicked on is the selection that is made.")
gui.setElementAutoWordWrap(selectionBlurbText, true)

wm.addElement(controlWindow, mobSelectionRadioGroups[1])
wm.addElement(controlWindow, mobSelectionRadioGroups[2])
wm.addElement(controlWindow, mobSelectionRadioGroups[3])
wm.addElement(controlWindow, buttonFrame)
wm.addElement(controlWindow, startStopButton)
wm.addElement(controlWindow, abortButton)
wm.addElement(controlWindow, clearLoggerButton)
wm.addElement(controlWindow, selectionBlurbFrame)
wm.addElement(controlWindow, selectionBlurbText)
wm.raiseWindow(controlWindow)

--
-- Config Window
--
configWindow = wm.newWindow(_winSize(screenWidth, 0.84) + 6, 7, _winSize(screenWidth, 0.12), 19, "Config")
setWindowConfig(configWindow)

local y = 2
mobHeader = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, "CHOSEN MOB")
setLabelHeaderFormat(mobHeader)

y = y + 2
mobLabel = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, availableMobs[configuredMobToSpawn].mobName)
gui.setElementAlignment(mobLabel, "center")

y = y + 2
batchSizeHeader = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, "BATCH SIZE")
setLabelHeaderFormat(batchSizeHeader)

y = y + 2
batchSizeLabel = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, getBatchSize(availableMobs[configuredMobToSpawn]))
gui.setElementAlignment(batchSizeLabel, "center")

y = y + 2
keyMatterHeader = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, "KEY MATTER")
setLabelHeaderFormat(keyMatterHeader)

y = y + 2
keyMatterLabel = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, availableMobs[configuredMobToSpawn].matter.key.name)
gui.setElementAlignment(keyMatterLabel, "center")

y = y + 2
bulkMatterHeader = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, "BULK MATTER")
setLabelHeaderFormat(bulkMatterHeader)

y = y + 2
bulkMatterLabel = gui.newLabel(2, y, _winSize(screenWidth, 0.09), 1, availableMobs[configuredMobToSpawn].matter.bulk.name)
gui.setElementAlignment(bulkMatterLabel, "center")

wm.addElement(configWindow, mobHeader)
wm.addElement(configWindow, mobLabel)
wm.addElement(configWindow, batchSizeHeader)
wm.addElement(configWindow, batchSizeLabel)
wm.addElement(configWindow, keyMatterHeader)
wm.addElement(configWindow, keyMatterLabel)
wm.addElement(configWindow, bulkMatterHeader)
wm.addElement(configWindow, bulkMatterLabel)
wm.raiseWindow(configWindow)

--
-- Log Window
--
loggerWindow = wm.newWindow(2, 29, _winSize(screenWidth, 0.99), 17, "Log")
setWindowConfig(loggerWindow)

loggerList = gui.newList(2, 2, _winSize(screenWidth, 0.95), 14, "", function()
  loggerSelectedLine = gui.getElementSelected(loggerList)
  gui.setElementValue(loggerSlider, loggerSelectedLine)
  gui.drawElement(loggerWindow, loggerSlider)
end)
gui.clearElementData(loggerList)
gui.setElementBackground(loggerList, 0xFFFFFF)
gui.setElementActiveBackground(loggerList, 0x202020)
gui.setElementForeground(loggerList, 0x000000)
gui.setElementActiveForeground(loggerList, 0xFFFFFF)

loggerSlider = gui.newVSlider(_winSize(screenWidth, 0.965), 2, 14, function()
  loggerSelectedLine = gui.getElementValue(loggerSlider)
  gui.setElementSelected(loggerList, loggerSelectedLine)
  gui.drawElement(loggerWindow, loggerList)
end)
gui.setElementMin(loggerSlider, 1)
gui.setElementValue(loggerSlider, 1)
gui.setElementMax(loggerSlider, config.logger.maxBufferSize)

wm.addElement(loggerWindow, loggerList)
wm.addElement(loggerWindow, loggerSlider)
wm.raiseWindow(loggerWindow)

--------------------------------------------------------------------------------
-- MAIN LOOP
--------------------------------------------------------------------------------
-- Make sure our config matches the UI
emptyMatterBeamers()
configureMachineForChosenMob(configuredMobToSpawn, 0)

-- Turn on logging
noLog = false

running = true
while running == true do
  os.sleep(0)
end

wm.exitGui()
