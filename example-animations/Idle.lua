return {
	Name = "Idle";
	Speed = 1;
	WrapMode = "Loop";
	Joints = {
		["RootJoint"] = {
			{
				CFrame = CFrame.new(0, 0, 0),
				Frame = 1,
			},
		};
		["Right Shoulder"] = {
			{
				CFrame = CFrame.new(1, 0.5, 0),
				Frame = 1,
			},
		};
		["Left Shoulder"] = {
			{
				CFrame = CFrame.new(-1, 0.5, 0),
				Frame = 1,
			},
		};
		["Right Hip"] = {
			{
				CFrame = CFrame.new(-0.5, -1, 0),
				Frame = 1,
			},
		};
		["Left Hip"] = {
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