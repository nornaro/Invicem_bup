using System;
using Godot;

public partial class Player : CharacterBody3D
{
	[Export] public int Health  = 3;

	private const int SPEED = 15;
	private const float JUMP_VELOCITY = 10.0f;
	private const float gravity = 20.0f;

	private Vector2 destination = new Vector2();
	private Vector3 rotaNormal = new Vector3();
	private Vector3 rota = new Vector3();

	private Camera3D Camera = new Camera3D();
	private Camera3D Camera1 = new Camera3D();
	private Camera3D Camera2 = new Camera3D();
	private AnimationPlayer AnimPlayer = new AnimationPlayer();
	private RayCast3D raycast = new RayCast3D();
	private RichTextLabel tooltip = new RichTextLabel();
	private GpuParticles3D MuzzleFlash = new GpuParticles3D();

	public override void _Ready()
	{
		Camera3D Camera1 = GetNode<Camera3D>("Camera3D");
		Camera3D Camera2 = GetNode<Camera3D>("../../Camera3D");
		GpuParticles3D MuzzleFlash = GetNode<GpuParticles3D>("Camera3D/Pistol/MuzzleFlash");
		RayCast3D raycast = GetNode<RayCast3D>("Camera3D/RayCast3D");
		RichTextLabel tooltip = GetNode<RichTextLabel>("HUD/ToolTip");
		Control hud = GetNode<Control>("HUD");
		ProgressBar healthbar = GetNode<ProgressBar>("HUD/HealthBar");

		var MultiplayerSynchronizer = GetNode<MultiplayerSynchronizer>("MultiplayerSynchronizer");
		MultiplayerSynchronizer.SetMultiplayerAuthority((int.Parse(Name)));
		SetProcess(MultiplayerSynchronizer.IsMultiplayerAuthority());

		if (!IsMultiplayerAuthority()) return;
		hud.Show();
		Camera2.Current = true;
		Camera = Camera2;
		Position= Position+new Vector3(0,1,0);
	}
	private new void _EnterTree()
	{
		SetMultiplayerAuthority(int.Parse(Name));
	}

	public void Dead()
	{
		Position = Vector3.Zero;
	}

	public void Hit(int newHP)
	{
		Console.WriteLine(Health);
		Health = newHP;
	}
	public override void _UnhandledInput(InputEvent @event)
	{
		if (!IsMultiplayerAuthority())
			return;

		if (@event is InputEventMouseMotion mouseMotion)
		{
			var scr = GetViewport().GetVisibleRect().Size;
			Vector2 rota = new Vector2((mouseMotion.GlobalPosition.X - scr.X / 2), (mouseMotion.GlobalPosition.Y - scr.Y / 2));
			Vector2 rotaNormal = new Vector2((mouseMotion.GlobalPosition.X - scr.X / 2) / scr.X, (mouseMotion.GlobalPosition.Y - scr.Y / 2) / scr.Y);
			float distance = Vector2.Zero.DistanceTo(new Vector2((mouseMotion.Position.X - scr.X / 2) / scr.X, (mouseMotion.Position.Y - scr.Y / 2) / scr.Y));

			if (Camera1.Current)
			{
				RotateY(-mouseMotion.Relative.X * 0.005f);
				Camera1.RotateX(-mouseMotion.Relative.Y * 0.005f);
				Vector3 camera1Rotation = Camera1.Rotation;
				camera1Rotation.X = Mathf.Clamp(camera1Rotation.X, -Mathf.Pi / 2, Mathf.Pi / 2);
				Camera1.Rotation = camera1Rotation;
			}

			if (Camera2.Current)
			{
				LookAt(new Vector3(rota.X, Position.Y, rota.Y));
				Camera2.Rotation = new Vector3(Mathf.DegToRad(-90), Mathf.DegToRad(0), Mathf.DegToRad(0));
			}

			Vector2 destination = Vector2.Zero;
			if (Input.IsMouseButtonPressed(MouseButton.Right))
				destination = rotaNormal / distance;

			if (Input.IsActionJustPressed("shoot") && AnimPlayer.CurrentAnimation != "shoot")
			{
				PlayShootEffects();
			}
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		var velocity = Velocity;
		if (!IsMultiplayerAuthority())
			return;

		if (!IsOnFloor())
			velocity.Y -= (float)(gravity * delta);

		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JUMP_VELOCITY;

		var inputDir = Input.GetVector("left", "right", "up", "down");
		Vector3 direction = new Vector3();

		if (Camera2.Current)
		{
			Camera2.Rotation = new Vector3(Mathf.DegToRad(-80), Mathf.DegToRad(0), Mathf.DegToRad(0));
			Camera2.Position = Position + new Vector3(0, 15, 0);
			Input.MouseMode = Input.MouseModeEnum.Confined;
			if (destination != Vector2.Zero)
				direction = new Vector3(destination.X, 0, destination.Y);
			if (inputDir != Vector2.Zero)
				direction = new Vector3(inputDir.X, 0, inputDir.Y).Normalized();
		}
		else if (Camera1.Current)
		{
			Input.MouseMode = Input.MouseModeEnum.Captured; ;
			if (inputDir != Vector2.Zero)
				direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
		}

		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * SPEED;
			velocity.Z = direction.Z * SPEED;
		}
		else
		{
			velocity.X = Mathf.MoveToward(velocity.X, 0, SPEED);
			velocity.Z = Mathf.MoveToward(velocity.Z, 0, SPEED);
		}

		/*if (AnimPlayer.CurrentAnimation == "shoot")
			return;
		else if (inputDir != Vector2.Zero && IsOnFloor())
			AnimPlayer.Play("move");
		else
			AnimPlayer.Play("idle");*/

		MoveAndSlide();
	}

	private void PlayShootEffects()
	{
		/*AnimPlayer.Stop();
		AnimPlayer.Play("shoot");
		MuzzleFlash.Restart();
		MuzzleFlash.Emitting = true;*/
	}

	private void _on_animation_player_animation_finished(StringName anim_name)
	{
		/*if (anim_name == "shoot")
		{
			AnimPlayer.Play("idle");
		}*/
	}

	private void UnhandledKeyInput(InputEvent @event)
	{
		tooltip.Text = "";
		if (@event.IsPressed())
		{
			switch (@event.AsText())
			{
				case "0":
					tooltip.Text = "[center]Demolish[/center]";
					break;
				case "1":
					tooltip.Text = "[center]Build Tower[/center]";
					break;
				case "2":
					tooltip.Text = "[center]Build Barack[/center]";
					break;
				case "3":
					tooltip.Text = "[center]Build Market[/center]";
					break;
				case "4":
					tooltip.Text = "[center]Build Armory[/center]";
					break;
			}
		}
		if (@event.IsActionPressed("ui_home"))
		{
			if (Camera == Camera1) { Camera = Camera2; }
			if (Camera == Camera2) { Camera = Camera1; }
		}
	}
	private void _on_animation_player_ready()
	{
		AnimationPlayer AnimPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		GD.Print(AnimPlayer.GetAnimationList());
		AnimPlayer.Play("idle");
	}
}
