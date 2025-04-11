using Godot;
using System;
using Invicem.World;

public partial class MainMenu : Node2D
{
	private const int Port = 25541;
	private ENetMultiplayerPeer ENetMultiplayerPeer { get; set; }	
	private Button JoinButton { get; set; }
	private Button HostButton { get; set; }
	private LineEdit InputField { get; set; }
	private Node2D Menu { get; set; }
	private Node2D Level { get; set; }
	
	public override void _Ready()
	{
		if (OS.GetName() != "iOS" && OS.GetName() != "Android")
		{
			// GetTree().Root.Size = new Vector2i(2560, 1440);
		}
		
		Menu = GetNode<Node2D>("%MainMenu");
		Menu.Position = Vector2.Zero; // Position Main menu over the level.

		Level = GetNode<Node2D>("%Level"); 
		Level.Hide(); // Hide the level.
		
		JoinButton = GetNode<Button>("Redwall/JoinGameButton");
		JoinButton.Pressed += _on_join_game_button_pressed; 
		HostButton = GetNode<Button>("Redwall/HostGameButton");
		HostButton.Pressed += _on_host_game_button_pressed;
		ENetMultiplayerPeer = new ENetMultiplayerPeer();
		InputField = GetNode<LineEdit>("Redwall/IPAddress");
	}

	private void _on_join_game_button_pressed()
	{
		var address = InputField.Text;
		ENetMultiplayerPeer.CreateClient(address, Port);
		Multiplayer.MultiplayerPeer = ENetMultiplayerPeer;
		HideMenu();
	}

	private void _on_host_game_button_pressed()
	{
		ENetMultiplayerPeer.CreateServer(Port);
		Multiplayer.MultiplayerPeer = ENetMultiplayerPeer;
		ENetMultiplayerPeer.PeerConnected += OnPeerConnected;
		ENetMultiplayerPeer.PeerDisconnected += OnPeerDisconnected;
		HideMenu();
		OnPeerConnected(1); // Let the host join the game. 
	}

	private void OnPeerDisconnected(long id)
	{
		Level.GetNode<Player>(id.ToString()).QueueFree();
	}

	private void HideMenu()
	{
		Menu.Hide();
		Position = new Vector2(3000, 3000);
		Level.Show();
	}

	private void OnPeerConnected(long id)
	{
		var scene = (PackedScene)ResourceLoader.Load("res://Player/player.tscn");
		var player = (Player)scene.Instantiate();
		player.Name = id.ToString();
		Level.AddChild(player);
	}	
}
