return {
	Name = "Idle";
	Speed = 1;
	WrapMode = "Loop";
	Joints = {
		["Root"] = {
			{
				CFrame = CFrame.new(0, 0, 0),
				Frame = 1,
			},
		};
		["RightShoulder"] = {
			{
				CFrame = CFrame.new(1, 0.5, 0),
				Frame = 1,
			},
		};
		["LeftShoulder"] = {
			{
				CFrame = CFrame.new(-1, 0.5, 0),
				Frame = 1,
			},
		};
		["RightHip"] = {
			{
				CFrame = CFrame.new(-0.5, -1, 0),
				Frame = 1,
			},
		};
		["LeftHip"] = {
			{
				CFrame = CFrame.new(0.5, -1, 0),
				Frame = 1,
			},
		};
		["Neck"] = {
			{
				CFrame = CFrame.new(0, 1, 0),
				Frame = 1,
			}
		}
	};
}