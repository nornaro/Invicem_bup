using Godot;

public partial class World : WorldEnvironment
{
	private PanelContainer mainMenu;
	private LineEdit addressEntry;
	private PackedScene player = (PackedScene)GD.Load("res://player.tscn");
	private PackedScene map = (PackedScene)GD.Load("res://grid_map.tscn");
	private const int PORT = 9999;
	private ENetMultiplayerPeer MultiplayerPeer = new ENetMultiplayerPeer();

	public override void _UnhandledInput(InputEvent @event)
	{
		if (Input.IsActionJustPressed("quit"))
		{
			GetTree().Quit();
		}
	}

	public override void _Ready()
	{
		mainMenu = (PanelContainer)GetNode("CanvasLayer/MainMenu");
		addressEntry = GetNode<LineEdit>("CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry");
	}

	private void _on_host_button_pressed()
	{
		mainMenu.Hide();

		MultiplayerPeer = new ENetMultiplayerPeer();
		MultiplayerPeer.CreateServer(PORT);
		Multiplayer.MultiplayerPeer = MultiplayerPeer;
		Multiplayer.PeerConnected += AddPlayer;
		Multiplayer.PeerDisconnected += RemovePlayer;
		AddTerrain();
		AddPlayer(Multiplayer.GetUniqueId());
	}

	private void AddTerrain()
	{
		var scene = map;
		var mapInstance = (GridMap)scene.Instantiate();
		mapInstance.Name = mapInstance.GetIndex().ToString();
		GetNode("Map").AddChild(mapInstance);
	}

	private void _on_join_button_pressed()
	{
		mainMenu.Hide();
		AddTerrain();
		MultiplayerPeer.CreateClient(addressEntry.Text, PORT);
		Multiplayer.MultiplayerPeer = MultiplayerPeer;
	}

	private void AddPlayer(long peerId)
	{
		var scene = player;
		var playerInstance = (Player)scene.Instantiate();
		playerInstance.Name = playerInstance.GetIndex().ToString();
		GetNode("Spawn").AddChild(playerInstance);
	}

	private void RemovePlayer(long peerId)
	{
		Node player = GetNode(peerId.ToString());
		if (player != null)
		{
			player.QueueFree();
		}
	}

	private void OnMultiplayerSpawnerSpawned(Node node)
	{
		if (node.IsMultiplayerAuthority())
		{
			// TODO: Add logic here
		}
	}

	public void Damage(RayCast3D raycast)
	{
		if (raycast.IsColliding())
		{
			var hitPlayer = (Player)raycast.GetCollider();
			if (hitPlayer != null) { 
				GD.Print(hitPlayer);
				hitPlayer.Health -= 1;
				if (hitPlayer.Health <= 0) {
					hitPlayer.Health = 3;
					hitPlayer.Dead();
				}
			}
		}
	}
}
