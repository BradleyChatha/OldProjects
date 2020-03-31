module Game;

private
{
import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicstypes;
import derelict.sfml2.graphicsfunctions;

import derelict.sfml2.systemtypes;
import derelict.sfml2.systemfunctions;
}

import std.stdio;
import std.file;
import std.string;
import std.conv;

import Jaster.library.loader;
import Jaster.GUI.Keyboard;
import Jaster.IO.BinaryFile;
import Jaster.Entity : Animation;
import Jaster.GUI.Keyboard;
import Jaster.GUI.Controls;

import main;
import Entity;
import ITile;
import NormalTiles;
import GameEntity;

alias extern(C) __gshared nothrow TileRaw* function() GetT;
GetT GetTiles;

// TODO: Implement Tiles, custom tile data and moving entities for Tiles to spawn
public class Game
{
	// Holds the texture pointers
	public sfTexture*[string] Textures;

	// Pointer to the GlobalData, before I had any idea that static worked just like in C#
	public GlobalData* Globals;

	// PlayerObject! (Much Comment, very describe)
	public static Player PlayerObject;

	// List of Level file paths
	public string[] Levels;

	// Which level to load in next
	public int LevelIndex;

	// Position to move the player to when we reset, either by dying or by the player pressing "R"
	public static sfVector2f ResetPosition;

	// Bool determining if the game is in debug mode
	public static bool Debug = false;

	sfFont* DebugFont;

	public void Init(GlobalData* globals)
	{
		// Store the pointer
		this.Globals = globals;

		//	this.RegisterTexture("Resources/Wall.png", "Wall", 32, 32);
		this.RegisterTexture("Resources/Player.png", "Player", 16, 16);
		//		this.RegisterTexture("Resources/Gem.png", "Gem", 32, 32);
		//		this.RegisterTexture("Resources/Spike.png", "Spike", 32, 32);
		//		this.RegisterTexture("Resources/Key.png", "Key", 32, 32);
		//		this.RegisterTexture("Resources/Door.png", "Door", 32, 32);
		//		this.RegisterTexture("Resources/Sheets/Shooter.png", "Shooter", 128, 32);
		//		this.RegisterTexture("Resources/Sheets/ShooterProjectile.png", "Bullet", 64, 16);
		
		// Create the player object
		this.PlayerObject = new Player(this.Textures["Player"]);
		this.LoadTileExtention("Resources/Tiles/Tiles.dll");

		// Everything SEEMS to be loading in correctly...

		// Get the levels to load in, relative to the path "Resources/Levels/{Current path to level to load}"
		this.Levels = readText("Resources/Levels/Levels.txt").splitLines();

		// Load in the first level
		this.LoadLevel();

		this.DebugFont = sfFont_createFromFile("Resources/arial.ttf".toStringz());

		IEntity.SetPlayer(&this.PlayerObject);
	}

	public void LoadTileExtention(string path)
	{
		writeln("Loading Tile Extention ", path.split("/")[$ - 1], "...");
		SharedLibrary Lib = LoadLibrary(path);
		
		// Register the textures
		writeln("Registering Textures...");
		TextureRaw* Texts = (cast(TextureRaw* function())Lib.LoadSymbol("GetTextures"))();
		int TextureCount = (cast(int function())Lib.LoadSymbol("GetTextureCount"))();
		writeln("Number of Textures: " ~ to!string(TextureCount));
		
		for(int i = 0; i < TextureCount; i++)
		{
			string tPath = Lib.ConvertCharPointer(Texts[i].Path);
			string tKey = Lib.ConvertCharPointer(Texts[i].Key);
			int tWidth = Texts[i].Width;
			int tHeight = Texts[i].Height;
			
			writeln("\nTexture Info:\n\tAssociating '", tPath, "' as ", tKey);
			writeln("\tWidth: ", tWidth, "\n\tHeight: ", tHeight);
			
			this.RegisterTexture(tPath, tKey, tWidth, tHeight);
		}
		
		// Register the tiles
		Lib.BindFunction(cast(void**)&GetTiles, "GetTiles");
		
		TileRaw* Tiles = GetTiles();
		int TileCount = (cast(int function())Lib.LoadSymbol("GetTileCount"))();
		writeln("\nNumber of Tiles: ", TileCount);
		
		for(int i = 0; i < TileCount; i++)
		{
			Tile T;
			
			// Wall
			if(Tiles[i].Type == 0)
			{
				T = new Wall(this.Textures[Lib.ConvertCharPointer(Tiles[i].Texture)], sfVector2f(0, 0), Tiles[i].ID);
			}
			// Colored Tile
			else if(Tiles[i].Type == 1)
			{
				T = new ColorTile(this.Textures[Lib.ConvertCharPointer(Tiles[i].Texture)], sfVector2f(0, 0), Tiles[i].ID);
			}
			// Directional Tile
			else if(Tiles[i].Type == 2)
			{
				T = new DirectionTile(this.Textures[Lib.ConvertCharPointer(Tiles[i].Texture)], sfVector2f(0, 0), Tiles[i].ID);
			}
			
			T.isSolid = cast(bool)Tiles[i].IsSolid;
			T.DrawInDebugOnly = cast(bool)Tiles[i].DrawInDebugOnly;
			
			T.OnPlayerTouchCommands = Lib.ConvertCharPointer(Tiles[i].OnPlayerTouchCommands).splitLines();
			T.OnTileSpawnCommands = Lib.ConvertCharPointer(Tiles[i].OnTileSpawn).splitLines();
			T.ExtraData = Lib.ConvertCharPointer(Tiles[i].ExtraData).splitLines();

			for(int i2 = 0; i2 < T.ExtraData.length; i2++)
			{
				Property ToAdd = Property();
				string[] Data2 = T.ExtraData[i2].split(":");

				if(Data2.length == 1)
				{
					continue;
				}
				
				if(Data2[0] == "Number")
				{
					ToAdd.Type = PropertyType.NUMBER;
				}

				T.Properties[Data2[1]] = ToAdd;
			}
			
			sfSprite_setColor(T.Sprite, sfColor_fromRGB(cast(ubyte)Tiles[i].R, cast(ubyte)Tiles[i].G, cast(ubyte)Tiles[i].B));
			
			writeln(
			"\nTileInfo:\n\tType:\t\t\t", Tiles[i].Type, 
			"\n\tTexture:\t\t", Lib.ConvertCharPointer(Tiles[i].Texture), 
			"\n\tIs Solid:\t\t", T.isSolid, 
			"\n\tDraw In Debug Only:\t", T.DrawInDebugOnly, 
			"\n\tOnPlayerTouch:\t\t", T.OnPlayerTouchCommands, 
			"\n\tOnTileSpawn:\t\t", T.OnTileSpawnCommands,
			"\n\tColor:\t\t\t", sfSprite_getColor(T.Sprite),
			"\n\tSpawnKey:\t\t", Tiles[i].SpawnKey
			);
			
			Tile.RegisterTile(T);
			Tile.KeyID[toLower(cast(string)[ Tiles[i].SpawnKey ])[0]] = T.ID;
		}

		Texts = null;
		Tiles = null;
		Lib.Unload();
	}

	// Sets each Tile in the Tile.Tiles array to null
	public void ClearLevel()
	{
		for(int i = 0; i < Tile.Y; i++)
		{
			for(int j = 0; j < Tile.X; j++)
			{
				Tile.Tiles[i][j] = null;
			}
		}
	}

	// Loads the next level
	public void LoadLevel()
	{
		// Clear the current level
		this.ClearLevel();

		// Reset events
		TileInteraction.Events.length = 0;

		// Open the next level file in Read mode
		BinaryFile Input = new BinaryFile("Resources/Levels/" ~ Levels[LevelIndex++], "r");

		// Get how many tiles are in the level
		int TileCount = Input.ReadInt();

		// Loop for TileCount
		for(int i = 0; i < TileCount; i++)
		{
			// Get the next tile
			Tile T = Tile.GetTile(cast(int)Input.ReadBytes(1)[0]);

			// Get it's position
			int X = Input.ReadShort();
			int Y = Input.ReadShort();

			// Set the position of the current Tile object
			T.SetPosition(sfVector2f(X * (this.Globals).TileSize, Y * (this.Globals).TileSize));
			T.OnTileSpawn(this.Globals);

			if(T.IsColored)
			{
				ubyte R = Input.ReadBytes(1)[0];
				ubyte G = Input.ReadBytes(1)[0];
				ubyte B = Input.ReadBytes(1)[0];

				(cast(ColoredTile)T).SetColor(sfColor_fromRGB(R, G, B));
			}

			if(T.IsDirectional)
			{
				(cast(DirectionalTile)T).Direction = Input.ReadBytes(1)[0];

				for(int i2 = 0; i2 < (cast(DirectionalTile)T).Direction; i2++)
				{
					(cast(DirectionalTile)T).Ani.NextFrame();
				}
			}

			for(int i2 = 0; i2 < T.Properties.length; i2++)
			{
				if(T.Properties[T.Properties.keys[i2]].Type == PropertyType.NUMBER)
				{
					T.Properties[T.Properties.keys[i2]].NumberValue = cast(ushort)Input.ReadShort();
					T.Properties[T.Properties.keys[i2]].ToDraw = (T.Properties.keys[i2] ~ ": " ~ to!string(T.Properties[T.Properties.keys[i2]].NumberValue));
				}

//				if(T.IsDirectional)
//				{
//					continue;
//				}

				T.Properties[T.Properties.keys[i2]].Position = sfVector2f(T.GetPosition().x, T.GetPosition().y + T.GetTextureHeight() + 4 + (20 * i2));
			}

			// Put the tile into the level
			Tile.Tiles[Y][X] = T;
		}

		// Close the File
		Input.Close();
	}

	// Save the current level into "Level.dat"
	public void SaveLevel()
	{
		// HACK: I could probably make this more cleaner by making a pointer to the current tile we're saving
		write("Enter file name: ");

		// Open Level.dat in Write mode
		BinaryFile Output = new BinaryFile("Resources/Levels/" ~ readln().chomp(), "w");

		// Number of tiles
		int Count = 0;

		// Reserve space for the TileCount
		Output.WriteInt(0); // Position 0

		// Loop through the level's array
		for(int i = 0; i < Tile.Y; i++)
		{
			for(int j = 0; j < Tile.X; j++)
			{
				// Don't write null tiles
				if(Tile.Tiles[i][j] is null || !Tile.Tiles[i][j].Active)
				{
					continue;
				}
				else
				{
					// Increment the Tile count
					Count++;

					// Write the current Tile's ID
					Output.WriteBytes([ cast(ubyte)Tile.Tiles[i][j].ID ]);

					// Write the current Tiles Cell Position
					Output.WriteShort(cast(short)(Tile.Tiles[i][j].GetPosition().x / 32));
					Output.WriteShort(cast(short)(Tile.Tiles[i][j].GetPosition().y / 32));

					if(Tile.Tiles[i][j].IsColored)
					{
						sfColor Col = sfSprite_getColor(Tile.Tiles[i][j].Sprite);
						Output.WriteBytes([ Col.r, Col.g, Col.b ]);
					}

					if(Tile.Tiles[i][j].IsDirectional)
					{
						Output.WriteBytes([ (cast(DirectionalTile)Tile.Tiles[i][j]).Direction ]);
					}

					for(int i2 = 0; i2 < Tile.Tiles[i][j].Properties.length; i2++)
					{
						if(Tile.Tiles[i][j].Properties[Tile.Tiles[i][j].Properties.keys[i2]].Type == PropertyType.NUMBER)
						{
							Output.WriteShort(Tile.Tiles[i][j].Properties[Tile.Tiles[i][j].Properties.keys[i2]].NumberValue);
						}
					}
				}
			}
		}

		// Go back to the TileCount space
		Output.SetPosition(0);

		// And write how many tiles there are
		Output.WriteInt(Count);

		// Then finally close the File
		Output.Close();
	}
	
	public void Draw()
	{
		// Draw any non-null Tile in the level's array
		for(int i = 0; i < Tile.Y; i++)
		{
			for(int j = 0; j < Tile.X; j++)
			{
				if(Tile.Tiles[i][j] is null || !Tile.Tiles[i][j].Active)
				{
					continue;
				}

				Tile.Tiles[i][j].Draw(this.Globals);
			}
		}

		// Draw the Player
		this.PlayerObject.Draw(this.Globals);
	}
	
	public void Update()
	{
		// Update any non-null Tile
		for(int i = 0; i < Tile.Y; i++)
		{
			for(int j = 0; j < Tile.X; j++)
			{
				if(Tile.Tiles[i][j] is null || !Tile.Tiles[i][j].Active)
				{
					continue;
				}

				Tile.Tiles[i][j].Update(this.Globals);
			}
		}

		// Update the Player
		this.PlayerObject.Update(this.Globals);

// TILE FLAG CHECK

		// Player has hit the End Tile
		if((this.Globals).NextLevel)
		{
			this.LoadLevel();
			(this.Globals).NextLevel = false;
		}

		if((this.Globals).RespawnPlayer)
		{
			this.Respawn();
			(this.Globals).RespawnPlayer = false;
		}

// TILE FLAG CHECK END

		// Activate Debug mode
		if(sfKeyboard_isKeyPressed(sfKeyTab))
		{
			// Set the game into Debug mode, and confirm we're in Debug mode
			Game.Debug = true;
			writeln("DEBUG MODE ACTIVATE");
		}

		// Restart
		if(sfKeyboard_isKeyPressed(sfKeyR))
		{
			// Reset the position of the player to the last read in spawn point
			this.Respawn();
		}

		// IF we're in debug mode, call the debug update method
		if(Game.Debug)
		{
			DebugUpdate();
		}
	}

	public void DebugUpdate()
	{
		// Get the mouse's X and Y cells
		int X = (sfMouse_getPositionRenderWindow((this.Globals).Window).x / (this.Globals).TileSize);
		int Y = (sfMouse_getPositionRenderWindow((this.Globals).Window).y / (this.Globals).TileSize);

		char[] Pressed = Keyboard.GetPressedKeys();

		// Make sure the cell is in bounds for Tile.Tiles, stopping the RangeError
		if((X < 0 || X >= Tile.X) || (Y < 0 || Y >= Tile.Y))
		{
			return;
		}

		for(int i = 0; i < Pressed.length; i++)
		{
			if (Tile.KeyID.keys.indexOf(Pressed[i]) != -1)
			{
				this.SetTile(X, Y, Tile.KeyID[Pressed[i]]);
			}
		}

		// Move Player
		if(sfMouse_isButtonPressed(sfMouseLeft))
		{
			this.PlayerObject.SetPosition(sfVector2f(sfMouse_getPositionRenderWindow((this.Globals).Window).x, sfMouse_getPositionRenderWindow((this.Globals).Window).y));
			// Keep the player's position even
			this.PlayerObject.Move(sfVector2f(this.PlayerObject.GetPosition().x % 2, this.PlayerObject.GetPosition().y % 2));
		}

		// Spawn point
		if(sfMouse_isButtonPressed(sfMouseMiddle))
		{
			this.SetTile(X, Y, 1);
		}

		// Delete Tile
		if(sfMouse_isButtonPressed(sfMouseRight))
		{
			// Set the Mouse Tile to null
			Tile.Tiles[Y][X] = null;
		}

		// Save
		if(sfKeyboard_isKeyPressed(sfKeyS))
		{
			// Save the level
			this.SaveLevel();
		}

		// Color ColoredTiles
		if(Tile.Tiles[Y][X] !is null && Tile.Tiles[Y][X].IsColored)
		{
			if(sfKeyboard_isKeyPressed(sfKeyNum1))
			{
				(cast(ColoredTile)Tile.Tiles[Y][X]).SetColor(sfYellow);
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum2))
			{
				(cast(ColoredTile)Tile.Tiles[Y][X]).SetColor(sfCyan);
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum3))
			{
				(cast(ColoredTile)Tile.Tiles[Y][X]).SetColor(sfRed);
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum4))
			{
				(cast(ColoredTile)Tile.Tiles[Y][X]).SetColor(sfBlack);
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum5))
			{
				// Gray
				(cast(ColoredTile)Tile.Tiles[Y][X]).SetColor(sfColor_fromRGB(128, 128, 128));
			}
		}

		// Set direction of DirectionalTiles
		if(Tile.Tiles[Y][X] !is null && Tile.Tiles[Y][X].IsDirectional)
		{
			if(sfKeyboard_isKeyPressed(sfKeyNum1))
			{
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.CurrentFrame = 0;
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.UpdateFrame();
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum2))
			{
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.CurrentFrame = 1;
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.UpdateFrame();
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum3))
			{
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.CurrentFrame = 2;
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.UpdateFrame();
			}
			else if(sfKeyboard_isKeyPressed(sfKeyNum4))
			{
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.CurrentFrame = 3;
				(cast(DirectionTile)Tile.Tiles[Y][X]).Ani.UpdateFrame();
			}
		}
	}

	public void Respawn()
	{
		this.PlayerObject.SetPosition(this.ResetPosition);
		TileInteraction.UndoEvents();
	}

	public void SetTile(int x, int y, int id)
	{
		Tile.Tiles[y][x] = Tile.GetTile(id).Clone();
		Tile.Tiles[y][x].SetPosition(sfVector2f(x * (this.Globals).TileSize, y * (this.Globals).TileSize));

		for(int i = 0; i < Tile.Tiles[y][x].Properties.length; i++)
		{			
			if(Tile.Tiles[y][x].IsDirectional)
			{
				continue;
			}
			
			Tile.Tiles[y][x].Properties[Tile.Tiles[y][x].Properties.keys[i]].Position = sfVector2f(Tile.Tiles[y][x].GetPosition().x, Tile.Tiles[y][x].GetPosition().y + Tile.Tiles[y][x].GetTextureHeight() + 4 + (20 * i));
		}
	}
	
	public void Uninit()
	{
		// Nullify the level, TileInfo array, Texture Array and Global data pointer
		Tile.Tiles = null;
		Tile.TileInfo = null;
		this.Textures = null;
		this.Globals = null;
	}
	
	public void RegisterTexture(string filePath, string key, int width, int height)
	{
		// Create a rectangle from the given Width and height
		const(sfIntRect) Rect = sfIntRect(width, height);

		// Associate "key" with the texture read in
		Textures[key] =	sfTexture_createFromFile(cast(const(char*))filePath, &Rect);
	}
}

public class Player : Entity
{
	// Player's Move speed
	public float Speed = 2f;

	// Gravity's power
	public float Gravity = 4f;

	// Collision flags
	public bool OnGround, LeftCollision, RightCollision, TopCollison = false;

	// Timer for jumping
	public sfClock* JumpTimer;

	// Bool that dictates whether the player is jumping
	public bool Jumping = false;

	this(sfTexture* texture)
	{
		this.SetTexture(texture);
		JumpTimer = sfClock_create();
	}

	// Drawing. Strings. Is. Hitler. Satan. Hell. Everything bad.
	public void DRAWTHESTUPIDSTRING(string toDraw, GlobalData* globals, int x, int y)
	{
		// Death
		sfText_setPosition((*globals).DebugText, sfVector2f(x, y));

		// Shini
		sfText_setString((*globals).DebugText, toDraw.toStringz());

		// La
		sfRenderWindow_drawText((*globals).Window, (*globals).DebugText, null);
	}

	override public void Draw(GlobalData* globals) 
	{
		// Draw the player Sprite
		sfRenderWindow_drawSprite((globals).Window, this.Sprite, null);

		// Draw debug info
		if(Game.Debug)
		{
			sfText_setColor((globals).DebugText, sfColor(64, 64, 64, 255));
			DRAWTHESTUPIDSTRING(format("X: %1.0f", this.GetPosition().x), globals, 0, 0);
			DRAWTHESTUPIDSTRING(format("Y: %1.0f", this.GetPosition().y), globals, 0, 24);
		}
	}

	override public void Update(GlobalData* globals) 
	{
		// Check for collisions
		CollisionCheck(globals);

		// Move the character
		MoveLogic();

		// Keep the character in the window
		KeepInBounds(globals);
	}

	private void CollisionCheck(GlobalData* globals)
	{
		// It looks so ugly, but it makes Debugging so much easier
		this.OnGround = (
			Tile.IsTileSolid( cast(int)(this.GetPosition().x / 32), cast(int)((this.GetPosition().y + this.GetTextureHeight()) / 32), globals ) ||
			Tile.IsTileSolid( cast(int)((this.GetPosition().x + this.GetTextureWidth() - 1) / 32), cast(int)((this.GetPosition().y + this.GetTextureHeight()) / 32), globals )
			);

		this.LeftCollision = (
			Tile.IsTileSolid( cast(int)((this.GetPosition().x - 2) / 32), cast(int)(this.GetPosition().y / 32), globals ) ||
			(Tile.IsTileSolid( cast(int)((this.GetPosition().x - 2)  / 32), cast(int)((this.GetPosition().y + this.GetTextureHeight()) / 32), globals ) &&
		 		!OnGround
		 	)
			);

		this.RightCollision = (
			Tile.IsTileSolid( cast(int)((this.GetPosition().x + this.GetTextureWidth()) / 32), cast(int)(this.GetPosition().y / 32), globals ) ||
			(Tile.IsTileSolid( cast(int)((this.GetPosition().x + this.GetTextureWidth()) / 32), cast(int)((this.GetPosition().y + this.GetTextureHeight()) / 32), globals ) &&
		 		!OnGround
		 	)
			);

		this.TopCollison = (
			Tile.IsTileSolid( cast(int)(this.GetPosition().x / 32), cast(int)((this.GetPosition().y - 2) / 32), globals ) ||
			(Tile.IsTileSolid( cast(int)((this.GetPosition().x + this.GetTextureWidth()) / 32), cast(int)((this.GetPosition().y - 2) / 32), globals ) &&
		 		!RightCollision
		 	)
			);
	}

	private void MoveLogic()
	{
		if(!OnGround && !Jumping)
		{
			this.Move(sfVector2f(0, Gravity));
		}

		if(!this.LeftCollision && sfKeyboard_isKeyPressed(sfKeyLeft))
		{
			this.Move(sfVector2f(-Speed, 0));
		}

		if(!this.RightCollision && sfKeyboard_isKeyPressed(sfKeyRight))
		{
			this.Move(sfVector2f(Speed, 0));
		}

		if(!this.TopCollison && sfKeyboard_isKeyPressed(sfKeyUp) && this.OnGround && !this.Jumping)
		{
			this.Jumping = true;
			sfClock_restart(this.JumpTimer);
		}

		if(this.Jumping)
		{
			if(this.TopCollison || sfTime_asSeconds(sfClock_getElapsedTime(this.JumpTimer)) >= 0.6f || !sfKeyboard_isKeyPressed(sfKeyUp))
			{
				this.Jumping = false;
			}

			if(this.Jumping)
			{
				this.Move(sfVector2f(0, -Gravity));
			}
		}
	}

	private void KeepInBounds(GlobalData* globals)
	{
		sfVector2f Position = this.GetPosition();

		// If the player goes too far down, put him at the top
		if(Position.y > (globals).WindowHeight)
		{
			this.SetPosition(sfVector2f(Position.x, -16));
		}

		// If the player goes too far left, put him to the very right
		if(Position.x <= -16)
		{
			this.SetPosition(sfVector2f((globals).WindowWidth - 2, Position.y));
		}

		// If the player goes too far right, put him to the very left
		if(Position.x >= (globals).WindowWidth)
		{
			this.SetPosition(sfVector2f(0, Position.y));
		}
	}
}