using Godot;
using Godot.Collections;
using Newtonsoft.Json.Linq;
using System;
using System.Reflection;

public partial class world : Node
{
	private ENetMultiplayerPeer MultiplayerPeer { get; set; }
	private PanelContainer mainMenu { get; set; }
	private LineEdit addressEntry { get; set; }
	private Control hud { get; set; }
	private ProgressBar healthBar { get; set; }

	public override void _Ready()
	{
		mainMenu = (PanelContainer)GetNode("CanvasLayer/MainMenu");
		addressEntry = (LineEdit)GetNode("CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry");
		hud = (Control)GetNode("CanvasLayer/HUD");
		healthBar = (ProgressBar)GetNode("CanvasLayer/HUD/HealthBar");
	}

	public override void _Input(InputEvent @event)
	{
		if (Input.IsActionJustPressed("quit"))
		{
			GetTree().Quit();
		}
	}

	private void AddTerrain()
	{
		var scene = (PackedScene)ResourceLoader.Load("res://grid_map.tscn");
		var env = (GridMap)scene.Instantiate();
		env.Name = env.GetInstanceId().ToString();
		AddChild(env);
	}

	private void AddPlayer(long peerID)
	{
		var scene = (PackedScene)ResourceLoader.Load("res://player.tscn");
		var player = (CharacterBody3D)scene.Instantiate();
		player.Name = peerID.ToString();
		AddChild(player);

		/*if (IsInstanceValid(player) && player.IsMultiplayerAuthority())
		{
			player.Connect(new StringName("health_changed"), nameof(UpdateHealthBar));
		}*/
	}

	private void RemovePlayer(long peerID)
	{
		var player = GetNode(peerID.ToString());
		if (player != null)
		{
			player.QueueFree();
		}
	}

	private void UpdateHealthBar(int healthValue)
	{
		healthBar.Value = healthValue;
	}

	private void OnMultiplayerSpawnerSpawned(Node node)
	{
		/*if (IsInstanceValid(node) && node.IsMultiplayerAuthority())
		{
			node.Connect("health_changed", this, nameof(UpdateHealthBar));
		}*/
	}

	private void _on_host_button_pressed()
	{
		mainMenu.Visible = false;
		hud.Visible = true;

		MultiplayerPeer = new ENetMultiplayerPeer();
		MultiplayerPeer.CreateServer(9999);
		Multiplayer.MultiplayerPeer = MultiplayerPeer;
		MultiplayerPeer.PeerConnected += AddPlayer;
		MultiplayerPeer.PeerDisconnected += RemovePlayer;
		AddTerrain();
		AddPlayer(long.Parse(Multiplayer.GetUniqueId().ToString()));
	}

	private void _on_join_button_pressed()
	{
		mainMenu.Visible = false;
		hud.Visible = true;
		AddTerrain();
		MultiplayerPeer = new ENetMultiplayerPeer();
		MultiplayerPeer.CreateClient(addressEntry.Text, 9999);
		Multiplayer.MultiplayerPeer = MultiplayerPeer;
	}
}
