using System;
using System.Linq;
using Godot;
using Godot.Collections;

namespace InvicemTD.World;

public partial class Player : CharacterBody3D
{
	private const int Speed = 330;
	public AnimatedSprite3D CurrentSkin;

	// Networking
	private MultiplayerSynchronizer MultiplayerSynchronizer { get; set; }

	public override void _EnterTree()
	{
		GD.Print(this.GetPath());
		MultiplayerSynchronizer = GetParent().GetNode<MultiplayerSynchronizer>("MultiplayerSynchronizer");
		

		//GD.Print(GetParent().GetNode<MultiplayerSynchronizer>("MultiplayerSynchronizer"));
		MultiplayerSynchronizer.SetMultiplayerAuthority(int.Parse(GetParent().Name));
	}

	public override void _Ready()
	{
		CurrentSkin = GetNode<AnimatedSprite3D>("Sprite");

		var playerName = GetParent().GetParent().GetParent().GetNode<LineEdit>("MainMenu/Redwall/PlayerName").Text;
		GetNode<Label>("PlayerTag").Text = playerName;

		SetPhysicsProcess(MultiplayerSynchronizer.IsMultiplayerAuthority());
		SetProcessInput(MultiplayerSynchronizer.IsMultiplayerAuthority());
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		Vector2 direction = Input.GetVector("left", "right", "up", "down");
		CurrentSkin.Animation = "Idle";
		velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
		velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
		if (direction != Vector2.Zero)
		{
			CurrentSkin.Animation = "Run";
			velocity = new Vector3(direction.X * Speed, velocity.Y, direction.Y * Speed);
		}
		Velocity = velocity;
		MoveAndSlide();
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("change_skin1"))
		{
			CurrentSkin.SpriteFrames.AddAnimation("res://Player/NinjaFrog.tres");
		}
	}
}
