module ITile;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicsfunctions;
import derelict.sfml2.graphicstypes;

import std.exception;
import std.conv;
import std.string;
import std.stdio;
import std.array;

import Jaster.GUI.Controls;

import Jaster.Entity : Animation;
import Entity;
import NormalTiles;
import main;

public struct TileRaw
{
	int 			Type;
	int				ID;
	const(char*)	Texture;

	char			DrawInDebugOnly;
	char			IsSolid;

	const(char*) 	OnPlayerTouchCommands;
	const(char*) 	OnTileSpawn;

	char			R;
	char			G;
	char			B;

	char			SpawnKey;

	const(char*)	ExtraData;
}

public struct TextureRaw
{
	const(char*)	Path;
	const(char*)	Key;

	int				Width;
	int				Height;
}

public enum PropertyType
{
	STRING,
	NUMBER
}

public struct Property
{
	PropertyType 	Type;

	string			StringValue;
	ushort			NumberValue;

	string			ToDraw = "";
	bool			Selected = false;
	sfVector2f		Position;
}

public class Tile : Entity
{
	// Pointer to the texture
	sfTexture* Texture;

	// Tile's ID
	public int ID;

	public bool isSolid = true;
	public bool Active = true;
	public bool IsColored = false;
	public bool IsDirectional = false;

	public bool DrawInDebugOnly = false;

	public string[] OnPlayerTouchCommands;
	public string[] OnTileSpawnCommands;
	public string[] ExtraData;

	public Property[string] Properties;

	// Used when extra data is required for TileInteraction
	public string InteractionData = "";

	public int SelectedProperty = 0;

	protected bool canDraw = true;

	// Debug
	private string ConvertCharPointer(const(char*) pointer)
	{
		string ToReturn = "";
		
		for(int i = 0; i < int.max; i++)
		{
			if(pointer[i] == '\0')
			{
				break;
			}
			else
			{
				ToReturn ~= pointer[i];
			}
		}
		
		return ToReturn;
	}

	// Draw the tile
	override public void Draw(GlobalData* globals) 
	{
		if(!DrawInDebugOnly && !Game.Game.Debug && canDraw)
		{
			sfRenderWindow_drawSprite((*globals).Window, this.Sprite, null);
		}
		else
		{
			if(Game.Game.Debug)
			{
				if(canDraw)
				{
					sfRenderWindow_drawSprite((*globals).Window, this.Sprite, null);
				}

				if(IsMouseOver((*globals).Window))
				{
					for(int i = 0; i < this.Properties.keys.length; i++)
					{
						if(this.Properties[this.Properties.keys[i]].Selected)
						{
							sfText_setColor((globals).DebugText, sfColor(0, 0, 0, 255));
						}
						else
						{
							sfText_setColor((globals).DebugText, sfColor(128, 128, 128, 255));
						}

						sfText_setPosition((globals).DebugText, this.Properties[this.Properties.keys[i]].Position);
						sfText_setString((*globals).DebugText, this.Properties[this.Properties.keys[i]].ToDraw.toStringz());
						sfRenderWindow_drawText((globals).Window, (globals).DebugText, null);
					}
				}
			}
		}
	}

	bool PressFlag = false;
	override public void Update(GlobalData* globals) 
	{
		if(Game.Game.Debug)
		{
			if(IsMouseOver((*globals).Window) && this.Properties.length != 0)
			{
				this.Properties[this.Properties.keys[this.SelectedProperty]].Selected = false;

				if(!PressFlag)
				{
					if(sfKeyboard_isKeyPressed(sfKeyUp))
					{
						this.SelectedProperty += 1;

						if(this.SelectedProperty == this.Properties.length)
						{
							this.SelectedProperty = 0;
						}
					}

					if(sfKeyboard_isKeyPressed(sfKeyDown))
					{
						this.SelectedProperty -= 1;

						if(this.SelectedProperty == -1)
						{
							this.SelectedProperty = (this.Properties.length - 1);
						}
					}

					if(sfKeyboard_isKeyPressed(sfKeyLeft))
					{
						if(this.Properties[this.Properties.keys[this.SelectedProperty]].Type == PropertyType.NUMBER)
						{
							this.Properties[this.Properties.keys[this.SelectedProperty]].NumberValue -= 1;
						}
					}

					if(sfKeyboard_isKeyPressed(sfKeyRight))
					{
						if(this.Properties[this.Properties.keys[this.SelectedProperty]].Type == PropertyType.NUMBER)
						{
							this.Properties[this.Properties.keys[this.SelectedProperty]].NumberValue += 1;
						}
					}

					if(sfKeyboard_isKeyPressed(sfKeyReturn))
					{
						if(this.Properties[this.Properties.keys[this.SelectedProperty]].Type == PropertyType.NUMBER)
						{
							try
							{
								write("\n\nEnter number to set the property's value to: ");
								this.Properties[this.Properties.keys[this.SelectedProperty]].NumberValue = to!ushort(readln().chomp());
							}
							catch(ConvOverflowException)
							{
								writeln("Number is too high! Max: ", ushort.max, "\n");
							}
							catch(ConvException)
							{
								writeln("Please etner a number, not a string <3\n");
							}
						}
					}
				}

				if(this.Properties[this.Properties.keys[this.SelectedProperty]].Type == PropertyType.NUMBER)
				{
					//this.Properties[this.Properties.keys[this.SelectedProperty]].Drawer.SetString(this.Properties.keys[this.SelectedProperty] ~ ": " ~ to!string(this.Properties[this.Properties.keys[this.SelectedProperty]].NumberValue));
					this.Properties[this.Properties.keys[this.SelectedProperty]].ToDraw = (this.Properties.keys[this.SelectedProperty] ~ ": " ~ to!string(this.Properties[this.Properties.keys[this.SelectedProperty]].NumberValue));
				}

				this.Properties[this.Properties.keys[this.SelectedProperty]].Selected = true;
				PressFlag = (sfKeyboard_isKeyPressed(sfKeyDown) || sfKeyboard_isKeyPressed(sfKeyUp) || sfKeyboard_isKeyPressed(sfKeyLeft) || sfKeyboard_isKeyPressed(sfKeyRight));
			}
		}
	}

	public void OnPlayerTouch(GlobalData* globals)
	{
		for(int i = 0; i < OnPlayerTouchCommands.length; i++)
		{
			string Current = OnPlayerTouchCommands[i];

			if(Current.startsWith("PLAYER:"))
			{
				if(Current.endsWith(":RESET"))
				{
					Game.Game.PlayerObject.SetPosition(Game.Game.ResetPosition);
					TileInteraction.UndoEvents();
				}

				if(Current.endsWith(":SETSPAWN"))
				{
					Game.Game.ResetPosition = (sfVector2f( ((this.GetPosition().x + (32 / 2)) - (Game.Game.PlayerObject.GetTextureWidth() / 2)), ((this.GetPosition().y + (32 / 2)) - (Game.Game.PlayerObject.GetTextureHeight() / 2)) ));
				}
			}
			else if(Current.startsWith("LEVEL:"))
			{
				if(Current.endsWith(":NEXT"))
				{
					(*globals).NextLevel = true;
				}
			}
			else if(Current.startsWith("COLOR:"))
			{
				string[] Data = Current.split(":");

				if(Data[1] == "DEACTIVATEBYCID")
				{
					// The Tile ID to look out for
					this.InteractionData = Data[2];
					TileInteraction.Interact(TileInteraction.TileEvent.CID_DEACTIVATE, cast(int)(this.GetPosition().x / 32), cast(int)(this.GetPosition().y / 32));
				}
			}
			else if(Current.startsWith("THIS:"))
			{
				if(Current.endsWith(":DEACTIVATE"))
				{
					this.Active = false;
				}
			}
			else if(Current.startsWith("OUTPUT:"))
			{
				string Data = Current.split(":")[1];

				writeln(ParseTileData(Data));
			}
		}
	}

	public string ParseTileData(string thing)
	{
		if(thing[0] != '$')
		{
			return thing;
		}
		else
		{
			if(auto key = thing[1..$] in this.Properties)
			{
				Property* Bleh = &this.Properties[thing[1..$]];

				if((*Bleh).Type == PropertyType.NUMBER)
				{
					return to!string((*Bleh).NumberValue);
				}
			}

			return thing;
		}
	}

	public ushort ParseTileDataNumber(string thing)
	{
		if(thing[0] != '$')
		{
			return to!ushort(thing);
		}
		else
		{
			if(auto key = thing[1..$] in this.Properties)
			{
				Property* Bleh = &this.Properties[thing[1..$]];
				
				if((*Bleh).Type == PropertyType.NUMBER)
				{
					return (*Bleh).NumberValue;
				}
			}
			
			return to!ushort(thing);
		}
	}

	public void OnTileSpawn(GlobalData* globals)
	{
		for(int i = 0; i < OnTileSpawnCommands.length; i++)
		{
			string Current = OnTileSpawnCommands[i];
			
			if(Current.startsWith("PLAYER:"))
			{
				if(Current.endsWith(":RESET"))
				{
					Game.Game.PlayerObject.SetPosition(Game.Game.ResetPosition);
					TileInteraction.UndoEvents();
				}
				
				if(Current.endsWith(":SETSPAWN"))
				{
					Game.Game.ResetPosition = (sfVector2f( ((this.GetPosition().x + (32 / 2)) - (Game.Game.PlayerObject.GetTextureWidth() / 2)), ((this.GetPosition().y + (32 / 2)) - (Game.Game.PlayerObject.GetTextureHeight() / 2)) ));
				}
			}
			else if(Current.startsWith("COLOR:"))
			{
				string[] Data = Current.split(":");
				
				if(Data[1] == "DEACTIVATEBYCID")
				{
					// The Tile ID to look out for
					this.InteractionData = Data[2];
					TileInteraction.Interact(TileInteraction.TileEvent.CID_DEACTIVATE, cast(int)(this.GetPosition().x / 32), cast(int)(this.GetPosition().y / 32));
				}
			}
			else if(Current.startsWith("THIS:"))
			{
				if(Current.endsWith(":DEACTIVATE"))
				{
					this.Active = false;
				}
			}
		}
	}

	// Creates a copy of the tile
	public abstract Tile Clone();

	// Sets up the Texture pointer, position and ID
	protected void Setup(sfTexture* texture, sfVector2f position, int id)
	{
		this.Texture = texture;
		this.SetTexture(texture);
		this.SetPosition(position);
		this.ID = id;
	}

	protected void CopyProperties(Property[string] properties)
	{
		for(int i = 0; i < properties.length; i++)
		{
			this.Properties[properties.keys[i]] = Property();
			this.Properties[properties.keys[i]].Type = properties[properties.keys[i]].Type;
			this.Properties[properties.keys[i]].StringValue = properties[properties.keys[i]].StringValue.dup;
			this.Properties[properties.keys[i]].NumberValue = properties[properties.keys[i]].NumberValue;
			this.Properties[properties.keys[i]].Type = properties[properties.keys[i]].Type;
			this.Properties[properties.keys[i]].ToDraw = properties[properties.keys[i]].ToDraw.dup;
			this.Properties[properties.keys[i]].Position = properties[properties.keys[i]].Position;
			this.Properties[properties.keys[i]].ToDraw = (properties.keys[i] ~ ": " ~ to!string(this.Properties[properties.keys[i]].NumberValue));
		}
	}

	// EVERYTHING down here is related to the level's Tile data

	/// Current tiles for the level

	// Number of X cells
	public static int X = 39;

	// Number of Y cells
	public static int Y = 25;

	// Tile Data for the level
	public static Tile[][] Tiles = new Tile[39][25];

	// Contains the Character-to-tile association data, for placing tiles in Debug mode
	public static int[char] KeyID;

	/// Array where Tiles get associated with ints
	public static Tile[int] TileInfo;

	/// Registers the given tile with the given id
	public static void RegisterTile(Tile tile)
	{
		Tile.TileInfo[tile.ID] = tile;
	}

	/// Returns a clone of the tile associated with "id"
	public static Tile GetTile(int id)
	{
		return Tile.TileInfo[id].Clone();
	}

	// Gets the tile at [y][x] and returns it's isSolid bool
	public static bool IsTileSolid(int x, int y, GlobalData* globals)
	{
		try
		{
			// Make sure we're requesting a cell inside the window, it's not null and the tile is active
			if((x > X || x < 0) || (y > Y || y < 0) || Tile.Tiles[y][x] is null || !Tile.Tiles[y][x].Active)
			{			
				return false;
			}
			else
			{
				Tile.Tiles[y][x].OnPlayerTouch(globals);

				// Return the Tile's isSolid bool
				return Tile.Tiles[y][x].isSolid;
			}
		}
		// I know I shouldn't catch Error's, but RangeError's should be an EXCEPTION to this standard
		catch(Error ex)
		{
			return false;
		}
	}
}

public class ColoredTile : Tile
{
	sfColor CID;

	public void SetColor(sfColor color)
	{
		this.CID = color;
		sfSprite_setColor(this.Sprite, this.CID);
	}
}

public class DirectionalTile : Tile
{
	ubyte Direction;
	public Animation Ani;

	public override void Draw(GlobalData* globals)
	{
		this.canDraw = false;
		Ani.Draw((*globals).Window);
		super.Draw(globals);
	}

	public override void Update(GlobalData* globals)
	{
		Ani.SetPosition(this.GetPosition());
		super.Update(globals);
	}

	protected void Setup2(ubyte direction, sfTexture* texture)
	{
		this.Direction = direction;
		this.Ani = new Animation(texture, 32, 32, 4, 0);
		sfSprite_setTextureRect(this.Sprite, sfIntRect(0, 0, 32, 32));
	}
}

public class TileInteraction
{
	/// Event occured on the tile(s)
	public enum TileEvent
	{
		/// Called by the Key Tile, used when opening the door
		CID_DEACTIVATE
	}

	/// Struct containing the info of an event
	public struct TileInteractionEvent
	{
		/// Event describing what the interaction was about
		public TileEvent Event;

		// Tile that was acted apon
		public sfVector2i Tile;
	}

	/// Holds the events that have currently occured
	public static TileInteractionEvent[] Events;

	/// Interacts with Tile[Y][X] using the given event
	public static void Interact(TileEvent event, int tileX, int tileY)
	{
		switch(event)
		{
			case TileEvent.CID_DEACTIVATE:
				TileInteraction.CID_DEACTIVATE_HANDLER(tileX, tileY, false);
				break;

			default:
				break;
		}

		// Register the event that occured
		TileInteraction.Events ~= TileInteractionEvent(event, sfVector2i(tileX, tileY));
	}

	private static void CID_DEACTIVATE_HANDLER(int tileX, int tileY, bool activate)
	{
		int ID = to!int(Tile.Tiles[tileY][tileX].InteractionData);
		sfColor CID = (cast(ColorTile)Tile.Tiles[tileY][tileX]).CID;

		for(int i = 0; i < Tile.Y; i++)
		{
			for(int j = 0; j < Tile.X; j++)
			{
				if(Tile.Tiles[i][j] is null || Tile.Tiles[i][j].ID != ID)
				{
					continue;
				}

				if(Tile.Tiles[i][j].ID == ID && (cast(ColorTile)Tile.Tiles[i][j]).CID == CID)
				{
					Tile.Tiles[i][j].Active = activate;
				}
			}
		}
	}

	/// Interacts with Tile[Y][X] using the given event
	public static void Interact(TileEvent event, sfVector2i tilePos)
	{
		TileInteraction.Interact(event, tilePos.x, tilePos.y);
	}

	public static void UndoEvents()
	{
		for(int i = 0; i < TileInteraction.Events.length; i++)
		{
			switch(TileInteraction.Events[i].Event)
			{
				case TileEvent.CID_DEACTIVATE:
					TileInteraction.CID_DEACTIVATE_HANDLER(TileInteraction.Events[i].Tile.x, TileInteraction.Events[i].Tile.y, true);
					Tile.Tiles[TileInteraction.Events[i].Tile.y][TileInteraction.Events[i].Tile.x].Active = true;
					break;

				default:
					break;
			}
		}
	}
}