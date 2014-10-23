return {
	Name = "Idle2";
	Speed = 0.1;
	WrapMode = "Loop";
	Joints = {
		["RootJoint"] = {
			{
				CFrame = CFrame.new(0, 0, 0),
				Frame = 1,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0.05, 0, 0) * CFrame.Angles(math.rad(1), 0, math.rad(-3)),
				Frame = 28,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(-0.1, 0, 0) * CFrame.Angles(math.rad(-2), math.rad(2.5), 0),
				Frame = 42,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0, 0, 0),
				Frame = 56,
			},
		};
		["Right Shoulder"] = {
			{
				CFrame = CFrame.new(1, 0.5, 0) * CFrame.Angles(0, math.rad(42), 0) * CFrame.Angles(math.rad(50), 0, 0),
				Frame = 1,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(1, 0.6, 0) * CFrame.Angles(0, math.rad(48), 0) * CFrame.Angles(math.rad(49), 0, 0),
				Frame = 15,
				Style = "SineInOut",
				EasingParameters = {1, 5}
			},
			{
				CFrame = CFrame.new(1, 0.48, 0) * CFrame.Angles(0, math.rad(49), 0) * CFrame.Angles(math.rad(52), 0, 0),
				Frame = 42,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(1, 0.5, 0) * CFrame.Angles(0, math.rad(42), 0) * CFrame.Angles(math.rad(50), 0, 0),
				Frame = 56,
			},
		};
		["Left Shoulder"] = {
			{
				CFrame = CFrame.new(-1, 0.5, 0),
				Frame = 1,
			},
			{
				CFrame = CFrame.new(-1, 0.5, 0),
				Frame = 56,
			},
		};
		["Right Hip"] = {
			{
				CFrame = CFrame.new(-0.5, -1, 0),
				Frame = 1,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(-0.5, -1, 0),
				Frame = 56,
			},
		};
		["Left Hip"] = {
			{
				CFrame = CFrame.new(0.5, -1, 0),
				Frame = 1,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0.5, -1, 0),
				Frame = 56,
			},
		};
		["Neck"] = {
			{
				CFrame = CFrame.new(0, 1, 0),
				Frame = 1,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0, 1, 0) * CFrame.Angles(math.rad(-5), math.rad(-5), 0),
				Frame = 28,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0, 1, 0),
				Frame = 56,
			}
		}
	};
}