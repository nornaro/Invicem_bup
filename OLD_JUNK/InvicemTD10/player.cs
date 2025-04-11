using Godot;
using System;

public partial class player : CharacterBody3D
{
	[Signal]
	public delegate void HealthChangedEventHandler(int healthValue);

	public void ReceiveDamage()
	{
		health--;
		if (health <= 0)
		{
			health = 3;
			Position = Vector3.Zero;
		}
		EmitSignal(nameof(HealthChanged), health);
	}

	public void PlayShootEffects()
	{
		animationPlayer.Stop();
		animationPlayer.Play("shoot");
		muzzleFlash.Restart();
		muzzleFlash.Emitting = true;
	}

	private AnimationPlayer animationPlayer;
	private Camera3D camera;
	private GpuParticles3D muzzleFlash;
	private RayCast3D raycast;
	private int health = 3;

	public override void _Ready()
	{
		camera = (Camera3D)GetNode("Camera3D");
		animationPlayer = (AnimationPlayer)GetNode("AnimationPlayer");
		muzzleFlash = (GpuParticles3D)GetNode("Camera3D/Pistol/MuzzleFlash");
		raycast = (RayCast3D)GetNode("Camera3D/RayCast3D");
		camera.Current = true;
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (!IsMultiplayerAuthority())
		{
			return;
		}
		if (@event is InputEventMouseMotion mouseMotion)
		{
			RotateY(-mouseMotion.Relative.X * .005f);
			camera.RotateX(-mouseMotion.Relative.Y * .005f);
			//camera.Rotation.X = Mathf.Clamp(camera.Rotation.X, -Mathf.Pi / 2, Mathf.Pi / 2);
		}
		if (Input.IsActionJustPressed("shoot") && animationPlayer.CurrentAnimation != "shoot")
		{
			/*if (raycast.IsColliding())
			{
				Node hitPlayer = raycast.GetCollider();
				int authority = hitPlayer.GetMultiplayerAuthority();
				hitPlayer.ReceiveDamageRPCID(authority);
			}*/
		}
	}
	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;
		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JumpVelocity;

		Vector2 inputDir = Input.GetVector("left", "right", "up", "down");
		GD.Print(inputDir);
		Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
		
		velocity = new Vector3(Mathf.MoveToward(Velocity.X, 0, Speed), Velocity.Y, Mathf.MoveToward(Velocity.Z, 0, Speed));
		if (direction != Vector3.Zero)
		{
			new Vector3(velocity.X = direction.X * Speed, velocity.Y, velocity.Z = direction.Z * Speed);
		}
		
		if (!IsOnFloor())
			velocity.Y -= gravity * (float)delta;
			
		Velocity = velocity;

		if (Input.IsActionJustPressed("shoot") && animationPlayer.CurrentAnimation != "shoot")
			PlayShootEffects();

		if (raycast.IsColliding())
		{
			Node hitPlayer = (Node)raycast.GetCollider();
			hitPlayer.Call("ReceiveDamage");
		}

		MoveAndSlide();
	}
	private void _on_animation_player_animation_finished(StringName anim_name)
	{
		if (anim_name == "shoot")
		{
				animationPlayer.Play("idle");
		}
	}
	
}
