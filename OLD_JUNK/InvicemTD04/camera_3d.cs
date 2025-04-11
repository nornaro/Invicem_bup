using Godot;
using InvicemTD.World;
using System;

public partial class camera_3d : Camera3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Position = GetParent<Player>().Position;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Position = GetParent<Player>().Position;
	}
}
