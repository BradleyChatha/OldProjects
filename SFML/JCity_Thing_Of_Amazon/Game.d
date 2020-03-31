module Game;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import main;

import Commands;
import Tile;
import NormalTiles;

public class Game
{
	/// Texture pointers, to be used by whatever
	public sfTexture*[string] Textures;

	/// Information about the Tiles
	public TileInfo[string] Tiles;

	/// Pointer to the Global Data Structure
	public GlobalData* Globals;

	/// Debug
	public Dirt TestTile;

	/// Gets called before the window sets up
	public void Init(GlobalData* globals)
	{
		// Registers the textures
		RegisterTexture("assets/Dirt.png", "Dirt", 32, 32);
		RegisterTexture("assets/Farm.png", "Farm", 32, 32);
		RegisterTexture("assets/Shed.png", "Shed", 32, 32);
		RegisterTexture("assets/Lumberjack.png", "Lumberjack", 32, 32);

		// Registers the tiles
		RegisterTile("Dirt", "Dirt", 1);
		RegisterTile("Farm", "Farm", 2);
		RegisterTile("Shed", "Shed", 3);
		RegisterTile("Lumberjack", "Lumberjack", 4);

		// Set the Pointer to the Global Data
		this.Globals = globals;

		// Set the Global Data's function pointer for changing tiles
		(*globals).ChangeTile = &ChangeTile;

		// Loop through the Global Data's tiles, setting them all to dirt
		for(int j = 0; j < (*globals).MapY; j++)
		{
			for(int i = 0; i < (*globals).MapX; i++)
			{
				(*globals).Tiles[j][i] = new Dirt(Textures["Dirt"]);

				if(j == 8 && i == 12)
				{
					(*globals).Tiles[j][i] = new Shed(Textures["Shed"]);
				}

				(*globals).Tiles[j][i].SetPosition(sfVector2f(i * 32, j * 32));
			}
		}
	}

	/// Registers a tile, using the name, textureName and ID given
	public void RegisterTile(string name, string texture, ubyte id)
	{
		// Creates a new Info Struct
		TileInfo Info = TileInfo();

		// Sets the Tile's Texture name
		Info.TextureName = texture;

		// Sets the Tile's ID
		Info.ID = id;

		// Registers Info
		this.Tiles[name] = Info;
	}

	/// Changes the Tile at [Y][X] to "tile"
	public void ChangeTile(int x, int y, string tile)
	{
		// Get the Tile's info
		TileInfo Info = this.Tiles[tile];

		// Send the data needed to the server
		(*Globals).Connection.SendShort(Command.ChangeTile);
		(*Globals).Connection.SendShort(cast(short)x);
		(*Globals).Connection.SendShort(cast(short)y);
		(*Globals).Connection.SendShort(cast(short)Info.ID);

		short Reply = (*Globals).Connection.RecieveShort();

		if(Reply == Command.Server_NotEnoughResources)
		{
			writeln("\nNot enough resources to build '" ~ tile ~ "'!");
			return;
		}
		else
		{
			writeln("Server Acknowledged the ChangeTile request.\n");
		}

		// Changes the tile
		switch(Info.ID)
		{
			case 1:
				(*Globals).Tiles[y][x] = new Dirt(this.Textures[Info.TextureName]);
				break;

			case 2:
				(*Globals).Tiles[y][x] = new Farm(this.Textures[Info.TextureName]);
				break;

			case 4:
				(*Globals).Tiles[y][x] = new Lumberjack(this.Textures[Info.TextureName]);
				break;
		}

		// Set the Tile's position
		(*Globals).Tiles[y][x].SetPosition(sfVector2f(x * 32, y * 32));
	}

	/// Loops through the Global Data's Tiles, and draws them
	public void Draw()
	{
		for(int j = 0; j < (*Globals).MapY; j++)
		{
			for(int i = 0; i < (*Globals).MapX; i++)
			{
				(*Globals).Tiles[j][i].Draw(this.Globals);
			}
		}
	}

	/// Loops through the Global Data's Tiles and updates them
	public void Update()
	{
		for(int j = 0; j < (*Globals).MapY; j++)
		{
			for(int i = 0; i < (*Globals).MapX; i++)
			{
				(*Globals).Tiles[j][i].Update(this.Globals);
			}
		}
	}

	/// Clears up anything that needs to be closed/nullified
	public void Uninit()
	{
		Textures = null;
		Tiles = null;
		(*Globals).Connection.Shutdown();
		(*Globals).Connection.Close();
	}

	/// Registers a texture
	public void RegisterTexture(string filePath, string key, int width, int height)
	{
		// Create the rectangle
		const(sfIntRect) Rect = sfIntRect(width, height);

		// Get the texture
		Textures[key] =	sfTexture_createFromFile(cast(const(char*))filePath, &Rect);
	}
}

