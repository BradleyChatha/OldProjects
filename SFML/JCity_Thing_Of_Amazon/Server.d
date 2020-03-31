module Server;

import std.stdio;
import std.concurrency;
import std.string;
import std.conv;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.systemtypes;

import Game;
import Commands;
import Jaster.jsocket;
import Tile;
import NormalTiles;

/// Structure containg the player's data
public struct Player
{
	/// The Player's name
	public string Name;

	/// The Player's tiles
	public Tile[25][19] Tiles;

	// The Player's resources
	public uint Food = 0;
	public uint Wood = 0;

	public ulong Gold = 0;

	/// CTOR
	this(string name, uint food, uint wood)
	{
		this.Name = name;
		this.Food = food;
		this.Wood = wood;
	}
}

/// Class that holds the server code
public class Server
{
	/// Socket used by the server
	JSocket ServerSocket;

	/// Server's data arrays
	public synchronized shared JSocket[string] Clients;
	public synchronized shared Player[string] Players;
	public synchronized shared TileInfo[short] Tiles;

	/// Used when the Clock hits 30 mins to stop anyone's resources from increasing
	public synchronized shared bool StopTileCheck = false;

	/// CTOR
	this()
	{
		// Get the IP to bind to
		write("Enter IP to bind to: ");
		ServerSocket = new JSocket();
		ServerSocket.Bind(readln.chomp(), 7777);

		// Confirm nothing went wrong
		writeln("Server set up!");

		// Register tiles
		this.Tiles[1] = cast(shared)TileInfo(null, 1, new Dirt(), 0, 0);
		this.Tiles[2] = cast(shared)TileInfo(null, 2, new Farm(), 300, 0);
		this.Tiles[3] = cast(shared)TileInfo(null, 3, new Shed(), 0, 0);
		this.Tiles[4] = cast(shared)TileInfo(null, 4, new Lumberjack(), 0, 300);
	}

	/// Starts the server's listening routine
	public void Start()
	{
		// Listen for up to 10 connections at a time
		ServerSocket.Listen(10);

		// Spawns the thread that is responsible for stopping everything when the clock hits 30 mins
		spawn(cast(immutable)&ClockThread);

		// Loop
		while(true)
		{
			// Get the next connection
			JSocket Client = ServerSocket.Accept();

			// Get it's name
			string Name = Client.RecieveString();

			// Register the client
			this.Clients[Name] = cast(shared)Client;

			// Spawn the 2 threads for the client
			spawn(cast(immutable)(&HandleClient), Name);
			spawn(cast(immutable)(&HandleClientTiles), Name);
		}
	}

	public void ClockThread()
	{
		sfClock* Clock = sfClock_create();

		while(true)
		{
			sfSleep(sfMilliseconds(200));

			// After 30 mins
			if(sfTime_asSeconds(sfClock_getElapsedTime(Clock)) >= 1800)
			{
				StopTileCheck = true;
				Player WinningPlayer = cast(Player)Players[Players.keys[0]];

				for(int i = 0; i < Players.keys.length; i++)
				{
					// TODO: Convert current resources into gold

					// If we find a player with higher gold
					if(WinningPlayer.Gold < (cast(Player)Players[Players.keys[i]]).Gold)
					{
						// Set them as the winning player
						WinningPlayer = (cast(Player)Players[Players.keys[i]]);
					}

					// TODO: Send the results to the other players, then disconnect them, make sure to try-catch for invalid sockets
				}

				return;
			}
		}
	}

	/// Handles the clients connecting
	public void HandleClient(string name)
	{
		// Get the Client's socket, and confirm the connection to the server admin
		JSocket Client = cast(JSocket)this.Clients[name];
		writeln(name ~ " has connected!");

		// Setup their player, and send confirmation to the Client to continue
		this.Players[name] = cast(shared)Player(name, 900, 1800);
		Client.SendShort(Command.Server_OK);

		// Only if the loop condition worked ¬.¬
		while(Client.isAlive())
		{
			// Get the command
			short Todo = Client.RecieveShort();

			// If we need to register a Tile Change
			if(Todo == Command.ChangeTile)
			{
				// Get the Client's player
				Player ClientPlayer = cast(Player)this.Players[name];

				// VV Data
				short X, Y, sTile;
				
				// Get the data needed
				X = Client.RecieveShort();
				Y = Client.RecieveShort();
				sTile = Client.RecieveShort();

				if(ClientPlayer.Food < (cast(TileInfo)(this.Tiles[sTile])).FoodNeeded || ClientPlayer.Wood < (cast(TileInfo)this.Tiles[sTile]).WoodNeeded)
				{
					Client.SendShort(Command.Server_NotEnoughResources);
					continue;
				}

				ClientPlayer.Food -= (cast(TileInfo)this.Tiles[sTile]).FoodNeeded;
				ClientPlayer.Wood -= (cast(TileInfo)this.Tiles[sTile]).WoodNeeded;

				// Set the Player's Tile using the data given, then send confirmation to the client to continue
				ClientPlayer.Tiles[Y][X] = (cast(TileInfo)this.Tiles[sTile]).oTile;
				Client.SendShort(Command.Server_OK);

				// Update the Player
				this.Players[name] = cast(shared)ClientPlayer;

				// Confirm to the server Admin
				writeln(name, ": ChangeTile(", X, ", ", Y, ", ", sTile, ")");
			}

			if(Todo == Command.RequestResourceInfo)
			{
				Player ClientPlayer = cast(Player)this.Players[name];

				Client.SendString("Food: " ~ to!string(ClientPlayer.Food) ~ "\nWood: " ~ to!string(ClientPlayer.Wood));

				writeln(name, ": RequestResourceInfo");
			}
		}

		// This will get called one day Q_Q
		writeln(name ~ " has disconnected!");
	}

	// Handles the Resource tiles for the player
	public void HandleClientTiles(string name)
	{
		try
		{
			sfClock* Clock = sfClock_create();

			while(true)
			{
				if(StopTileCheck)
				{
					return;
				}

				if(sfTime_asSeconds(sfClock_getElapsedTime(Clock)) >= 5)
				{
					Player Current = cast(Player)this.Players[name];
					
					for(int j = 0; j < 19; j++)
					{
						for(int i = 0; i < 25; i++)
						{
							if(Current.Tiles[j][i] !is null)
							{
								Current.Food += Current.Tiles[j][i].FoodIncome;
								Current.Wood += Current.Tiles[j][i].WoodIncome;
								this.Players[name] = cast(shared)Current;
							}
						}
					}
					
					sfClock_restart(Clock);
					writeln(name, " | Food: ", Current.Food, " | Wood: ", Current.Wood);
				}
			}
		}
		catch(Exception ex)
		{

		}
	}
}

