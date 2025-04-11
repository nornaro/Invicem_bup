using System;
using System.Linq;
using Godot;
using Multiplayerdemo.Player;

namespace Multiplayerdemo.World;

public partial class Player : CharacterBody2D
{
	// Constants
	private const float Speed = 330.0f;
	
	// Player skin
	public AnimatedSprite2D CurrentSkin => SkinsArray[(int)Skin];
	private AnimatedSprite2D[] SkinsArray { get; set; }
	private Skins Skin { get; set; }
	
	// Networking
	private MultiplayerSynchronizer MultiplayerSynchronizer { get; set; }
	private MultiplayerPlayer MultiplayerPlayer { get; set; }
	
	public override void _EnterTree()
	{
		MultiplayerSynchronizer = GetNode<MultiplayerSynchronizer>("MultiplayerPlayer/MultiplayerSynchronizer");
		MultiplayerSynchronizer.SetMultiplayerAuthority((int.Parse(Name)));

	}

	public override void _Ready()
	{
		SetSkin((int)Skins.MaskFrog);
		SkinsArray = GetChildren().OfType<AnimatedSprite2D>().ToArray();
		MultiplayerPlayer = GetNode<MultiplayerPlayer>("MultiplayerPlayer");
		Position = new Vector2(140, 187); // Teleport the player to the spawnpoint
		var playerName = GetNode<LineEdit>("/root/Root/MainMenu/Redwall/PlayerName").Text;
		Rpc(nameof(SetPlayerNameTag), playerName, Multiplayer.GetUniqueId());
		Rpc(nameof(GetOtherPlayerTags), Multiplayer.GetUniqueId());
		
		SetPhysicsProcess(MultiplayerSynchronizer.IsMultiplayerAuthority()); // Enable physics process only on the local authority 
		SetProcessInput(MultiplayerSynchronizer.IsMultiplayerAuthority());
	}
	
	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		Vector2 direction = Input.GetVector("left", "right", "up", "down");
		if (direction != Vector2.Zero)
		{
			CurrentSkin.Animation = "run";
			velocity.X = direction.X * Speed;
			velocity.Y = direction.Y * Speed;
			CurrentSkin.FlipH = direction.X < 0;
		}
		else
		{
			CurrentSkin.Animation = "idle";
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Y = Mathf.MoveToward(Velocity.Y, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
		
		MultiplayerPlayer.SyncPosition = Position;
		MultiplayerPlayer.SyncFlipH = CurrentSkin.FlipH;
		Rpc(nameof(SetAnimation), CurrentSkin.Animation);
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("change_skin1"))
		{
			Rpc(nameof(SetSkin), (int)Skins.MaskFrog);
		} else if (@event.IsActionPressed("change_skin2"))
		{
			Rpc(nameof(SetSkin), (int)Skins.VirtualGuy);
		} else if (@event.IsActionPressed("change_skin3"))
		{
			Rpc(nameof(SetSkin), (int)Skins.PinkMan);
		}
	}
	
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, TransferMode = MultiplayerPeer.TransferModeEnum.Reliable, CallLocal = true)]
	private void SetSkin(int skin)
	{
		Skin = (Skins) skin;
		var list = GetChildren().OfType<AnimatedSprite2D>().ToList();
		list.ForEach(x =>
		{
			if (x.Name.Equals(Skin.ToString())) 
				x.Show();
			else
				x.Hide();
		});
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, TransferMode = MultiplayerPeer.TransferModeEnum.Unreliable, CallLocal = false)]
	private void SetAnimation(string name)
	{
		CurrentSkin.Animation = name;
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, TransferMode = MultiplayerPeer.TransferModeEnum.Reliable, CallLocal = true)]
	private void SetPlayerNameTag(string playerName, int peerId)
	{
		if (String.IsNullOrEmpty(playerName))
		{
			playerName = "Player";
		}

		var player = GetParent().GetNodeOrNull<Player>(peerId.ToString());
		if (player != null)
		{
			player.GetNode<Label>("PlayerTag").Text = playerName;
		}
	}
	
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, TransferMode = MultiplayerPeer.TransferModeEnum.Reliable, CallLocal = false)]
	private void GetOtherPlayerTags(int peerId)
	{
		var players = GetParent().GetChildren().OfType<Player>().ToList();
		foreach (var player in players)
		{
			var playerName = GetNode<LineEdit>("/root/Root/MainMenu/Redwall/PlayerName").Text;
			player.RpcId(peerId, nameof(SetPlayerNameTag), playerName, Multiplayer.GetUniqueId());
		}
	}
	
	public enum Skins
	{
		MaskFrog = 0,
		VirtualGuy = 1,
		PinkMan = 2,
	}
}
