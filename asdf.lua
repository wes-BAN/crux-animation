local RunService = game:GetService("RunService")
local TestService = game:GetService("TestService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local LocalPlayer
if RunService:IsClient() then
  LocalPlayer = Players.LocalPlayer
end
local log
log = function(...)
  if not RunService:IsStudio() then
    return 
  end
  local msg = table.concat({
    ...
  })
  return warn(msg)
end
local warnMsg
warnMsg = function(...)
  if not RunService:IsStudio() then
    return 
  end
  local msg = table.concat({
    ...
  })
  return warn("Warning: " .. msg)
end
local SteppedBindings
do
  local _class_0
  local isActive, order
  local _base_0 = {
    _addToOrder = function(name, priority, f)
      order[priority] = order[priority] or { }
      order[priority][name] = f
    end,
    _removeFromOrder = function(name)
      for pos, group in next,order do
        for bindingName, func in next,group do
          if bindingName == name then
            order[pos][bindingName] = nil
            return true
          end
        end
      end
      return false
    end,
    bind = function(name, priority, f)
      if priority >= 0 and math.floor(priority) == priority then
        SteppedBindings._addToOrder(name, priority, f)
      else
        warnMsg("Function position must be a non-negative integer: ", name, priority)
      end
      if not (isActive) then
        isActive = true
        return RunService.Stepped:connect(function()
          for _, group in next,order do
            for bind, func in next,group do
              func()
            end
          end
        end)
      end
    end,
    unbind = function(name)
      local found = SteppedBindings._removeFromOrder(name)
      if not (found) then
        return warnMsg("Did not find function under ID: " .. name)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "SteppedBindings"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  isActive = false
  order = { }
  SteppedBindings = _class_0
end
local getAllChildren
getAllChildren = function(parent, allChildren)
  allChildren = allChildren or { }
  local _list_0 = parent:GetChildren()
  for _index_0 = 1, #_list_0 do
    local child = _list_0[_index_0]
    table.insert(allChildren, child)
    getAllChildren(child, allChildren)
  end
  return allChildren
end
local RemoteEvent
do
  local _class_0
  local _base_0 = {
    remoteEventName = "__ExecutionRemoteEvent",
    Initialize = function(self)
      if RunService:IsServer() then
        self.networkBufferPerClient = { }
        self.networkBufferAll = { }
        do
          local _with_0 = Instance.new("RemoteEvent", script)
          _with_0.Name = self.__class.remoteEventName
          self._object = _with_0
        end
      elseif RunService:IsClient() then
        self.networkBuffer = { }
        self._object = script:WaitForChild(self.__class.remoteEventName)
      end
    end,
    EnableServerReceive = function(self, action)
      if RunService:IsServer() then
        return self._object.OnServerEvent:connect(function(client, receivedBuffer)
          return self:ReadBuffer(receivedBuffer, action, client)
        end)
      end
    end,
    EnableClientReceive = function(self, action)
      if RunService:IsClient() then
        return self._object.OnClientEvent:connect(function(receivedBuffer)
          return self:ReadBuffer(receivedBuffer, action)
        end)
      end
    end,
    ReadBuffer = function(self, receivedBuffer, perMsgAction, client)
      if client then
        for _index_0 = 1, #receivedBuffer do
          local msg = receivedBuffer[_index_0]
          perMsgAction(client, unpack(msg))
        end
      else
        for _index_0 = 1, #receivedBuffer do
          local msg = receivedBuffer[_index_0]
          perMsgAction(unpack(msg))
        end
      end
    end,
    WriteToBuffer = function(self, isAll, ...)
      if isAll then
        return table.insert(self.networkBufferAll, {
          ...
        })
      else
        return table.insert(self.networkBuffer, {
          ...
        })
      end
    end,
    WriteToPerClientBuffer = function(self, client, ...)
      self.networkBufferPerClient[client] = self.networkBufferPerClient[client] or { }
      return table.insert(self.networkBufferPerClient[client], {
        ...
      })
    end,
    SendBuffer = function(self)
      if RunService:IsClient() then
        if #self.networkBuffer > 0 then
          self._object:FireServer(self.networkBuffer)
          self.networkBuffer = { }
        end
      end
      if RunService:IsServer() then
        if #self.networkBufferAll > 0 then
          self._object:FireAllClients(self.networkBufferAll)
          self.networkBufferAll = { }
        end
        local clearBuffer = false
        for client, buffer in pairs(self.networkBufferPerClient) do
          clearBuffer = true
          self._object:FireClient(client, buffer)
        end
        if clearBuffer then
          self.networkBufferPerClient = { }
        end
      end
    end,
    FireServer = function(self, ...)
      return self:WriteToBuffer(false, ...)
    end,
    FireClient = function(self, client, ...)
      return self:WriteToPerClientBuffer(client, ...)
    end,
    FireAllClients = function(self, ...)
      return self:WriteToBuffer(true, ...)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "RemoteEvent"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RemoteEvent = _class_0
end
local UsedScriptCollection = { }
local SceneScripts = { }
local ToBeDestroyed = { }
local Entity
do
  local _class_0
  local uniqueId, uniqueNetworkId, iterModuleScripts, storedScripts
  local _base_0 = {
    getNewId = function()
      uniqueId = uniqueId + 1
      return uniqueId
    end,
    getNewNetworkId = function()
      uniqueNetworkId = uniqueNetworkId + 1
      return uniqueNetworkId
    end,
    sendMessage = function(msg, ...)
      for _, script in pairs(SceneScripts) do
        if script[msg] then
          script[msg](script, ...)
        end
      end
    end,
    sendRPCMessage = function(id, msg, ...)
      for _, script in pairs(SceneScripts) do
        if (script.__networkId == id) and script[msg] then
          script[msg](script, ...)
        end
      end
    end,
    replicatedStorageScripts = function()
      if storedScripts ~= 0 then
        return storedScripts
      end
      storedScripts = { }
      local _list_0 = getAllChildren(ReplicatedStorage)
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        if child:IsA("ModuleScript") then
          storedScripts[child.Name] = child
        end
      end
      return storedScripts
    end,
    createNewInstance = function(entity, entityScript, sourceEntity, networkId)
      if networkId == nil then
        networkId = 0
      end
      local moduleScriptName = entityScript.Name
      local existing = UsedScriptCollection[moduleScriptName]
      if existing and (existing ~= entityScript) then
        entityScript:Destroy()
        entityScript = UsedScriptCollection[moduleScriptName]
      elseif not existing then
        UsedScriptCollection[moduleScriptName] = entityScript
      end
      local newClass = require(entityScript)
      if not (newClass.__module) then
        newClass.__module = entityScript
        newClass.__index = newClass
        newClass["addMember"] = function(self, newMember)
          newMember.Parent = self.__instance
        end
        newClass["getMember"] = function(self, childName)
          return self.__instance:WaitForChild(childName)
        end
        newClass["getScript"] = function(self, scriptName)
          for _index_0 = 1, #SceneScripts do
            local script = SceneScripts[_index_0]
            if script.__class.__name == scriptName then
              return script
            end
          end
        end
        newClass["getMemberScripts"] = function(self)
          local memberScripts = { }
          for _index_0 = 1, #SceneScripts do
            local script = SceneScripts[_index_0]
            if script.__instance == self.__instance then
              table.insert(memberScripts, script)
            end
          end
          return memberScripts
        end
        newClass["getAllScripts"] = function(self, scriptName)
          local allScripts = { }
          for _index_0 = 1, #SceneScripts do
            local script = SceneScripts[_index_0]
            if script.__class.__name == scriptName then
              table.insert(allScripts, script)
            end
          end
          return allScripts
        end
        newClass["sendMessage"] = function(self, msg, ...)
          return Entity.sendMessage(msg, ...)
        end
        newClass["instantiate"] = function(self, fromEntity, attributes, networkId)
          local newEntity = fromEntity:Clone()
          local scripts = Entity.loadEntity(fromEntity, newEntity, attributes, networkId)
          return scripts, newEntity
        end
        newClass["sendNetworkMessage"] = function(self, arg1, arg2, ...)
          local code = "sendNetworkMessage"
          if self:isClient() then
            return RemoteEvent:FireServer(code, arg1, arg2, ...)
          elseif self:isServer() then
            if arg2 == "others" then
              local ignoredPlayer = arg1
              local _list_0 = Players:GetPlayers()
              for _index_0 = 1, #_list_0 do
                local player = _list_0[_index_0]
                if player ~= ignoredPlayer then
                  RemoteEvent:FireClient(player, code, ...)
                end
              end
            elseif arg1 == "all" then
              return RemoteEvent:FireAllClients(code, arg2, ...)
            else
              return RemoteEvent:FireClient(arg1, code, arg2, ...)
            end
          end
        end
        newClass["rpcMessage"] = function(self, arg1, arg2, ...)
          local code = "rpcMessage"
          local id = self.__networkId
          if self:isClient() then
            return RemoteEvent:FireServer(code, id, arg1, arg2, ...)
          elseif self:isServer() then
            if arg2 == "others" then
              local ignoredPlayer = arg1
              local _list_0 = Players:GetPlayers()
              for _index_0 = 1, #_list_0 do
                local player = _list_0[_index_0]
                if player ~= ignoredPlayer then
                  RemoteEvent:FireClient(player, code, id, ...)
                end
              end
            elseif arg1 == "all" then
              return RemoteEvent:FireAllClients(code, id, arg2, ...)
            else
              return RemoteEvent:FireClient(arg1, code, id, arg2, ...)
            end
          end
        end
        newClass["networkInstantiate"] = function(self, arg1, arg2, arg3, arg4)
          local code = "networkInstantiate"
          if self:isClient() then
            return RemoteEvent:FireServer(code, arg1, arg2)
          elseif self:isServer() then
            if arg2 == "others" then
              local _list_0 = Players:GetPlayers()
              for _index_0 = 1, #_list_0 do
                local player = _list_0[_index_0]
                if player ~= arg1 then
                  RemoteEvent:FireClient(player, code, arg3, arg4)
                end
              end
            elseif arg1 == "all" then
              local assignedNetworkId = Entity.getNewNetworkId()
              local a, b = self:instantiate(arg2, arg3, assignedNetworkId)
              RemoteEvent:FireAllClients(code, arg2, arg3, assignedNetworkId)
              return a, b
            else
              return RemoteEvent:FireClient(arg1, code, arg2, arg3)
            end
          end
        end
        newClass["networkDestroy"] = function(self, arg1, arg2, arg3, arg4)
          self:destroy()
          local code = "networkDestroy"
          if self:isClient() then
            return RemoteEvent:FireServer(code, self.__networkId)
          elseif self:isServer() then
            if arg2 == "others" then
              local _list_0 = Players:GetPlayers()
              for _index_0 = 1, #_list_0 do
                local player = _list_0[_index_0]
                if player ~= arg1 then
                  RemoteEvent:FireClient(player, code, self.__networkId)
                end
              end
            elseif arg1 == "all" then
              return RemoteEvent:FireAllClients(code, self.__networkId)
            else
              return RemoteEvent:FireClient(arg1, code, self.__networkId)
            end
          end
        end
        newClass["addBindingTag"] = function(self, bindingName)
          return table.insert(self.__bindingTags, bindingName)
        end
        newClass["_addToBeDestroyed"] = function(self, toBeGone)
          for i = 1, #ToBeDestroyed do
            if ToBeDestroyed[i] == toBeGone then
              return 
            end
          end
          return table.insert(ToBeDestroyed, toBeGone)
        end
        newClass["destroy"] = function(self)
          self:_addToBeDestroyed(self)
          local _list_0 = self:getMemberScripts()
          for _index_0 = 1, #_list_0 do
            local member = _list_0[_index_0]
            self:_addToBeDestroyed(member)
          end
          if self.onDestroy then
            return self:onDestroy()
          end
        end
        newClass["isClient"] = function(self)
          return RunService:IsClient()
        end
        newClass["isServer"] = function(self)
          return RunService:IsServer()
        end
        newClass["isStudio"] = function(self)
          return RunService:IsStudio()
        end
        newClass["isRunMode"] = function(self)
          return RunService:IsRunMode()
        end
      end
      if newClass.__name and (entityScript.Name ~= newClass.__name) then
        warnMsg("Class '", newClass.__name, "' does not match Script '", entityScript.Name, "'")
      end
      local newInstance = { }
      newInstance.__bindingTags = { }
      newInstance.__instance = entity
      newInstance.__source = sourceEntity
      newInstance.__class = newClass
      newInstance.__name = entityScript.Name
      newInstance.__id = Entity.getNewId()
      newInstance.__networkId = networkId
      newInstance.enabled = true
      if not ReplicatedStorage:FindFirstChild("Assets") then
        warnMsg("Waiting for Assets folder...")
      end
      newInstance.assets = ReplicatedStorage:WaitForChild("Assets")
      newInstance = setmetatable(newInstance, newClass)
      table.insert(SceneScripts, newInstance)
      return newInstance
    end,
    loadEntity = function(fromEntity, entity, attributes, networkId)
      if attributes == nil then
        attributes = { }
      end
      if networkId == nil then
        networkId = 0
      end
      local replicatedFromServer = entity:IsDescendantOf(ReplicatedStorage:WaitForChild("__Entities"))
      if RunService:IsServer() and (entity:IsDescendantOf(workspace) or not entity.Parent) then
        entity.Parent = workspace.CurrentCamera
      elseif RunService:IsClient() and (replicatedFromServer or not entity.Parent) then
        entity.Parent = workspace
      end
      if replicatedFromServer then
        local networkId_obj = entity:WaitForChild("__NetworkId")
        networkId = networkId_obj.Value
      elseif RunService:IsServer() and entity:FindFirstChild("__NetworkId") then
        networkId = entity["__NetworkId"].Value
      end
      local availableScripts = Entity.replicatedStorageScripts()
      local scripts = { }
      iterModuleScripts(fromEntity, function(moduleScript)
        if moduleScript:IsA("StringValue") then
          moduleScript = availableScripts[moduleScript.Value]
          if not moduleScript then
            return 
          end
        end
        local newScriptInstance = Entity.createNewInstance(entity, moduleScript, fromEntity, networkId)
        scripts[newScriptInstance.__name] = newScriptInstance
      end)
      for scriptName, attributesPerScript in pairs(attributes) do
        for k, v in pairs(attributesPerScript) do
          scripts[scriptName][k] = v
        end
      end
      for scriptName, instance in pairs(scripts) do
        if instance["onInstantiate"] then
          instance["onInstantiate"](instance)
        end
      end
      return scripts
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  uniqueId = 0
  uniqueNetworkId = 0
  iterModuleScripts = function(parent, f)
    local _list_0 = parent:GetChildren()
    for _index_0 = 1, #_list_0 do
      local child = _list_0[_index_0]
      if child:IsA("ModuleScript") or (child:IsA("StringValue") and child.Name == "__Script") then
        f(child)
      end
    end
  end
  storedScripts = 0
  Entity = _class_0
end
local constructScene
constructScene = function()
  local rbxObjects = { }
  local entities = { }
  local replicatedEntitiesFolder
  if RunService:IsServer() then
    do
      local _with_0 = Instance.new("Folder")
      _with_0.Name = "__Entities"
      _with_0.Parent = ReplicatedStorage
      replicatedEntitiesFolder = _with_0
    end
    local _list_0 = workspace:GetChildren()
    for _index_0 = 1, #_list_0 do
      local child = _list_0[_index_0]
      table.insert(rbxObjects, child)
    end
  elseif RunService:IsClient() then
    local _list_0 = workspace:GetChildren()
    for _index_0 = 1, #_list_0 do
      local child = _list_0[_index_0]
      table.insert(rbxObjects, child)
    end
    local _list_1 = ReplicatedStorage:WaitForChild("__Entities"):GetChildren()
    for _index_0 = 1, #_list_1 do
      local child = _list_1[_index_0]
      table.insert(rbxObjects, child)
    end
    local _list_2 = StarterPlayer:GetChildren()
    for _index_0 = 1, #_list_2 do
      local child = _list_2[_index_0]
      table.insert(rbxObjects, child)
    end
    if not LocalPlayer:FindFirstChild("PlayerGui") then
      LocalPlayer:WaitForChild("PlayerGui")
    end
    LocalPlayer["PlayerGui"].ChildAdded:connect(function(interface)
      if interface:IsA("ScreenGui") then
        local _list_3 = interface:GetChildren()
        for _index_0 = 1, #_list_3 do
          local child = _list_3[_index_0]
          if child:IsA("Folder") then
            Entity.loadEntity(child, child)
          end
        end
      end
    end)
    local _list_3 = LocalPlayer["PlayerGui"]:GetChildren()
    for _index_0 = 1, #_list_3 do
      local interface = _list_3[_index_0]
      if interface:IsA("ScreenGui") then
        local _list_4 = interface:GetChildren()
        for _index_1 = 1, #_list_4 do
          local child = _list_4[_index_1]
          table.insert(rbxObjects, child)
        end
      end
    end
  end
  for _index_0 = 1, #rbxObjects do
    local object = rbxObjects[_index_0]
    if object:IsA("Folder") then
      if RunService:IsServer() then
        do
          local _with_0 = Instance.new("IntValue")
          _with_0.Name = "__NetworkId"
          _with_0.Value = Entity.getNewNetworkId()
          _with_0.Parent = object
        end
        local replicatedClone = object:Clone()
        replicatedClone.Parent = replicatedEntitiesFolder
      end
      table.insert(entities, object)
    end
  end
  for _index_0 = 1, #entities do
    local entity = entities[_index_0]
    Entity.loadEntity(entity, entity)
  end
end
local RenderSteppedUpdate
do
  local _class_0
  local _base_0 = {
    bind = function(self, prefix, f)
      local bindingName = prefix .. self.name
      if RunService:IsClient() then
        RunService:BindToRenderStep(bindingName, self.priority, f)
      elseif RunService:IsServer() then
        SteppedBindings.bind(bindingName, self.priority, f)
      else
        warnMsg("Bad RunService environment.")
      end
      return {
        name = bindingName,
        priority = self.priority,
        func = f
      }
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, name, priority)
      self.name = name
      self.priority = priority
      self.preset_update = function(instance, dt)
        if instance._hasAwoken and instance._hasStarted and instance.enabled then
          return instance[name](instance, dt)
        end
      end
    end,
    __base = _base_0,
    __name = "RenderSteppedUpdate"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RenderSteppedUpdate = _class_0
end
local RPCBuffer
do
  local _class_0
  local _base_0 = {
    add = function(self, entity, msg, ...)
      return table.insert(self.buffer, {
        entity = entity,
        msg = msg,
        params = {
          ...
        }
      })
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.buffer = { }
    end,
    __base = _base_0,
    __name = "RPCBuffer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RPCBuffer = _class_0
end
local Execution
do
  local _class_0
  local _base_0 = {
    executionFunctions = {
      first_reserved = RenderSteppedUpdate("updateAbsoluteFirst", Enum.RenderPriority.First.Value),
      first = RenderSteppedUpdate("updateFirst", 1),
      input = RenderSteppedUpdate("updateInput", Enum.RenderPriority.Input.Value),
      camera = RenderSteppedUpdate("updateCamera", Enum.RenderPriority.Camera.Value),
      character_before = RenderSteppedUpdate("updateBeforeCharacter", Enum.RenderPriority.Character.Value - 1),
      character = RenderSteppedUpdate("updateCharacter", Enum.RenderPriority.Character.Value),
      gui = RenderSteppedUpdate("updateGui", Enum.RenderPriority.Character.Value + 100),
      last = RenderSteppedUpdate("updateLast", 1999),
      last_reserved = RenderSteppedUpdate("updateAbsoluteLast", Enum.RenderPriority.Last.Value)
    },
    AwakeAll = function(self)
      for _index_0 = 1, #SceneScripts do
        local instance = SceneScripts[_index_0]
        if not (instance._isBusy) then
          if not instance._hasAwoken then
            instance._isBusy = true
            for _, exec in pairs(self.__class.executionFunctions) do
              if instance[exec.name] then
                local newBinding = exec:bind(tostring(instance.__id), function()
                  return exec.preset_update(instance, self.dt)
                end)
                instance:addBindingTag(newBinding.name)
              end
            end
          end
          if instance["awake"] and not instance._hasAwoken then
            instance._isBusy = true
            log("Awaking instance of ", instance.__name, " (" .. instance.__networkId .. ")...")
            local success, status = pcall(function()
              return instance["awake"](instance)
            end)
            if not success then
              warnMsg("Error occured when awaking instance of ", instance.__name, ":\n", status)
            else
              instance._isBusy = false
              instance._hasAwoken = true
            end
          else
            instance._hasAwoken = true
            instance._isBusy = false
          end
        end
      end
    end,
    StartAll = function(self)
      for _index_0 = 1, #SceneScripts do
        local instance = SceneScripts[_index_0]
        if not (instance._isBusy or not instance._hasAwoken) then
          if instance["start"] and instance.enabled and not instance._hasStarted then
            instance._isBusy = true
            log("Starting instance of ", instance.__name, "...")
            local success, status = pcall(function()
              return instance["start"](instance)
            end)
            if not success then
              warnMsg("Error occured when starting instance of ", instance.__name, ":\n", status)
            else
              instance._isBusy = false
              instance._hasStarted = true
            end
          else
            instance._hasStarted = true
          end
        end
      end
    end,
    BindUpdates = function(self)
      local lastTime = tick()
      local shouldResetDelta = true
      self.__class.executionFunctions.first_reserved:bind("execution_", function()
        self:AwakeAll()
        self:StartAll()
        if shouldResetDelta then
          self.dt = tick() - lastTime
          lastTime = tick()
          shouldResetDelta = false
        end
      end)
      return self.__class.executionFunctions.last_reserved:bind("execution_", function()
        shouldResetDelta = true
        for i = 1, #ToBeDestroyed do
          local script = ToBeDestroyed[i]
          if script.__instance.Parent ~= nil then
            script.__instance:Destroy()
          end
          local _list_0 = script.__bindingTags
          for _index_0 = 1, #_list_0 do
            local bindingName = _list_0[_index_0]
            if script:isClient() then
              RunService:UnbindFromRenderStep(bindingName)
            elseif script:isServer() then
              SteppedBindings.unbind(bindingName)
            end
          end
          for k = #SceneScripts, 1, -1 do
            if SceneScripts[k] == script then
              table.remove(SceneScripts, k)
            end
          end
          script.enabled = false
          ToBeDestroyed[i] = nil
        end
        return RemoteEvent:SendBuffer()
      end)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.dt = 0.0
      if RunService:IsClient() then
        local characterLoaded
        characterLoaded = function()
          return log("Local Character has been loaded, interfaces now loading...")
        end
        if not game.Players.LocalPlayer.Character then
          Spawn(function()
            game.Players.LocalPlayer.CharacterAdded:wait()
            return characterLoaded()
          end)
        else
          characterLoaded()
        end
      end
      constructScene()
      RemoteEvent:Initialize()
      RemoteEvent:EnableServerReceive(function(client, code, ...)
        local _exp_0 = code
        if "networkInstantiate" == _exp_0 then
          local fromEntity = select(1, ...)
          local newEntity = fromEntity:Clone()
          local scripts = Entity.loadEntity(fromEntity, newEntity, select(2, ...))
        elseif "networkDestroy" == _exp_0 then
          return warnMsg("networkDestroy should only be called from the server (was fired by", client.Name, ")")
        elseif "sendNetworkMessage" == _exp_0 then
          return Entity.sendMessage(...)
        elseif "rpcMessage" == _exp_0 then
          return Entity.sendRPCMessage(...)
        end
      end)
      self:BindUpdates()
      if RunService:IsClient() then
        local loading = true
        local hasStartedAll
        hasStartedAll = function()
          local startedAll = true
          for _index_0 = 1, #SceneScripts do
            local entity = SceneScripts[_index_0]
            if not entity._hasStarted then
              startedAll = false
              log("Instance not yet initialized: ", entity.__name, " as member of ", tostring(entity.__source))
            end
          end
          return startedAll
        end
        while loading do
          RunService.RenderStepped:wait()
          if hasStartedAll() then
            loading = false
          end
        end
      end
      return RemoteEvent:EnableClientReceive(function(code, ...)
        local _exp_0 = code
        if "networkInstantiate" == _exp_0 then
          local fromEntity = select(1, ...)
          local newEntity = fromEntity:Clone()
          local scripts = Entity.loadEntity(fromEntity, newEntity, select(2, ...), select(3, ...))
        elseif "networkDestroy" == _exp_0 then
          local networkId = select(1, ...)
          for _, entity in pairs(SceneScripts) do
            if entity.__networkId == networkId then
              print("Destroyed instance: ", entity.__name, networkId)
              entity:destroy()
            end
          end
        elseif "sendNetworkMessage" == _exp_0 then
          return Entity.sendMessage(...)
        elseif "rpcMessage" == _exp_0 then
          return Entity.sendRPCMessage(...)
        end
      end)
    end,
    __base = _base_0,
    __name = "Execution"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Execution = _class_0
end
return Execution
