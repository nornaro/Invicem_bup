using Godot;
using Godot.Collections;
using System;

public partial class Spawn : Node
{
	[Export] private Dictionary PlayerInstance= new Dictionary();
	[Export] private Dictionary PlayerHP = new Dictionary();
	[Export] private Dictionary PlayerMap = new Dictionary();

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
