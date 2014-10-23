return {
	Name = "Walk";
	Speed = 0.7;
	WrapMode = "Loop";
	Joints = {
		["Root"] = {
			{
				CFrame = CFrame.Angles(0, 0, 0),
				Frame = 1,
				Style = "SineOut"
			},
			{
				CFrame = CFrame.Angles(0, math.rad(4), 0),
				Frame = 6,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.Angles(0, math.rad(-4), 0),
				Frame = 16,
				Style = "SineIn"
			},
			{
				CFrame = CFrame.new(0, 0, 0),
				Frame = 21,
			}
		};
		["Neck"] = {
			{
				CFrame = CFrame.new(0, 1, 0),
				Frame = 1,
				Style = "SineOut"
			},
			{
				CFrame = CFrame.new(0, 1, 0) * CFrame.Angles(0, math.rad(-4), 0),
				Frame = 6,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0, 1, 0) * CFrame.Angles(0, math.rad(4), 0),
				Frame = 16,
				Style = "SineIn"
			},
			{
				CFrame = CFrame.new(0, 1, 0),
				Frame = 21,
			}
		};
		["RightHip"] = {
			{
				CFrame = CFrame.new(-0.5, -1, 0),
				Frame = 1,
				Style = "SineOut"

			},
			{
				CFrame = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(-45), 0, 0),
				Frame = 6,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(45), 0, 0),
				Frame = 16,
				Style = "SineIn"
			},
			{
				CFrame = CFrame.new(-0.5, -1, 0),
				Frame = 21,
			},
		};
		["LeftHip"] = {
			{
				CFrame = CFrame.new(0.5, -1, 0),
				Frame = 1,
				Style = "SineOut"

			},
			{
				CFrame = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(45), 0, 0),
				Frame = 6,
				Style = "SineInOut"
			},
			{
				CFrame = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(-45), 0, 0),
				Frame = 16,
				Style = "SineIn"
			},
			{
				CFrame = CFrame.new(0.5, -1, 0),
				Frame = 21,
			},
		};
		
		["RightShoulder"] = {
			{
				CFrame = CFrame.new(1, 0.5, 0),
				Frame = 1,
			},
			{
				CFrame = CFrame.new(1, 0.5, 0),
				Frame = 21,
			},
		};
		["LeftShoulder"] = {
			{
				CFrame = CFrame.new(-1, 0.5, 0),
				Frame = 1,
			},
			{
				CFrame = CFrame.new(-1, 0.5, 0),
				Frame = 21,
			},
		};
	};
}