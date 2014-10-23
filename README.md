crux-animation
==============

Roblox animation engine originally modeled after Unity3D's animation API.

Supports animation blending, crossfading, pausing, keyframe interpolation, smooth adjustable playback speed, and a variety of playback modes.

####Basic usage

```lua
local ReplicatedStorage = Game:GetService("ReplicatedStorage")

local CruxAnim = require(ReplicatedStorage:WaitForChild("CruxAnimation")) -- Require the module (animation.lua)

-- Initialize animation clips
local clipFile = ReplicatedStorage.AnimationClips.Idle -- A ModuleScript containing the formatted animation file
local clip = CruxAnim.AnimationClip.new(clipFile) -- Clip to be loaded into the rig

-- Make the rig
local model = Workspace.MyAnimatedModel
local rig = CruxAnim.Skeleton.new(model)

-- Add the animation clips
rig:AddClip(clip)

-- Enable rig and play the idle animation!
rig.Enabled = true
rig:Play("Idle")
```

####Credits
- Liam Hutchison - Help with original concept
- Stravant - CFrame interpolation utilities
