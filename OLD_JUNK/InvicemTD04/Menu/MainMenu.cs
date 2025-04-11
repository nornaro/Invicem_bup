using Godot;
using System;
using InvicemTD.World;
using Godot.Collections;

public partial class MainMenu : Node2D
{
	private const int Port = 25541;
	private ENetMultiplayerPeer ENetMultiplayerPeer { get; set; }	
	private Button JoinButton { get; set; }
	private Button HostButton { get; set; }
	private LineEdit InputField { get; set; }
	private Node2D Menu { get; set; }
	private Node3D Level { get; set; }

	Dictionary<string, Player> PlayerList = new Dictionary<string, Player>();
	Dictionary<string, Camera3D> PlayerCamera = new Dictionary<string, Camera3D>();
	Dictionary<string, GridMap> PlayerMap = new Dictionary<string, GridMap>();
	
	public override void _Ready()
	{
		if (OS.GetName() != "iOS" && OS.GetName() != "Android")
		{
			// GetTree().Root.Size = new Vector2i(2560, 1440);
		}
		Menu = GetNode<Node2D>("%MainMenu");
		Menu.Position = Vector2.Zero; // Position Main menu over the level.

		Level = GetNode<Node3D>("%Level"); 
		Level.Hide(); // Hide the level.
		
		JoinButton = GetNode<Button>("Redwall/JoinGameButton");
		JoinButton.Pressed += OnJoinButtonPressed; 
		HostButton = GetNode<Button>("Redwall/HostGameButton");
		HostButton.Pressed += OnHostButtonPressed;
		ENetMultiplayerPeer = new ENetMultiplayerPeer();
		InputField = GetNode<LineEdit>("Redwall/IPAddress");
	}

	private void OnJoinButtonPressed()
	{
		var address = InputField.Text;
		ENetMultiplayerPeer.CreateClient(address, Port);
		Multiplayer.MultiplayerPeer = ENetMultiplayerPeer;
		HideMenu();
	}

	private void OnHostButtonPressed()
	{
		ENetMultiplayerPeer.CreateServer(Port);
		Multiplayer.MultiplayerPeer = ENetMultiplayerPeer;
		ENetMultiplayerPeer.PeerConnected += OnPeerConnected;
		ENetMultiplayerPeer.PeerDisconnected += OnPeerDisconnected;
		HideMenu();
		//OnPeerConnected(1); // Let the host join the game. 
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
		/*var playerSscene = (PackedScene)ResourceLoader.Load("res://Player/player.tscn");
		var player = (Player)playerSscene.Instantiate();
		player.Name = id.ToString();
		player.Position += player.Position + new Vector3(500,0,0);
		PlayerList.Add(player.Name, player);*/

		var mapScene = (PackedScene)ResourceLoader.Load("res://grid_map.tscn");
		var map = (GridMap)mapScene.Instantiate();
		map.Position = map.Position + new Vector3(500, 0, 0);
		map.Name = id.ToString();
		PlayerMap.Add(map.Name, map);

		/*var camScene = (PackedScene)ResourceLoader.Load("res://camera_3d.tscn");
		var cam = (Camera3D)camScene.Instantiate();
		PlayerCamera.Add(player.Name, cam);
		cam.Position = player.Position;
		cam.MakeCurrent();*/

		Level.AddChild(map, true);
		//map.AddChild(player, true);
		//player.AddChild(cam, true);
	}	
}
