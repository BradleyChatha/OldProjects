module NormalTiles;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicsfunctions;
import derelict.sfml2.graphicstypes;

import ITile;
import main;
import Game;

import std.array;

public class Wall : Tile
{
	this(sfTexture* texture, sfVector2f position, int id)
	{
		this.Setup(texture, position, id);
	}

	this(sfTexture* texture, sfVector2f position, sfColor color, int id, string[] onPlayer, string[] onSpawn, bool solid, bool drawDebug, Property[string] properties)
	{
		this.Setup(texture, position, id);
		sfSprite_setColor(this.Sprite, color);
		this.OnPlayerTouchCommands = onPlayer;
		this.OnTileSpawnCommands = onSpawn;
		this.isSolid = solid;
		this.DrawInDebugOnly = drawDebug;
		this.CopyProperties(properties);
	}
	
	override public void Draw( GlobalData* globals) {
		super.Draw(globals);
	}
	
	override public void Update( GlobalData* globals) {
		super.Update(globals);
	}
	
	override public Tile Clone()
	{
		return new Wall(this.Texture, this.GetPosition(), sfSprite_getColor(this.Sprite), ID, this.OnPlayerTouchCommands, this.OnTileSpawnCommands, this.isSolid, this.DrawInDebugOnly, this.Properties);
	}
}

public class ColorTile : ColoredTile
{	
	this(sfTexture* texture, sfVector2f position, int id)
	{
		this.Setup(texture, position, id);
		this.IsColored = true;
		this.SetColor(sfYellow);
	}
	
	this(sfTexture* texture, sfVector2f position, sfColor cid, int id, string[] onPlayer, string[] onSpawn, bool solid, bool drawDebug, Property[string] properties)
	{
		this.Setup(texture, position, id);
		this.SetColor(cid);
		this.IsColored = true;
		this.OnPlayerTouchCommands = onPlayer;
		this.OnTileSpawnCommands = onSpawn;
		this.isSolid = solid;
		this.DrawInDebugOnly = drawDebug;
		this.CopyProperties(properties);
	}
	
	override public void Draw( GlobalData* globals) {
		super.Draw(globals);
	}
	
	override public void Update( GlobalData* globals) {
		super.Update(globals);
	}
	
	override public Tile Clone()
	{
		return new ColorTile(this.Texture, this.GetPosition(), this.CID, ID, this.OnPlayerTouchCommands, this.OnTileSpawnCommands, this.isSolid, this.DrawInDebugOnly, this.Properties);
	}
}

public class DirectionTile : DirectionalTile
{	
	this(sfTexture* texture, sfVector2f position, int id)
	{
		this.Setup(texture, position, id);
		this.IsDirectional = true;
	}
	
	this(sfTexture* texture, sfVector2f position, int id, string[] onPlayer, string[] onSpawn, bool solid, bool drawDebug, ubyte direction, Property[string] properties)
	{
		this.Setup(texture, position, id);
		this.IsDirectional = true;
		this.OnPlayerTouchCommands = onPlayer;
		this.OnTileSpawnCommands = onSpawn;
		this.isSolid = solid;
		this.DrawInDebugOnly = drawDebug;
		this.CopyProperties(properties);

		this.Setup2(direction, texture);
	}
	
	override public void Draw( GlobalData* globals) {
		super.Draw(globals);
	}
	
	override public void Update( GlobalData* globals) {
		super.Update(globals);
	}
	
	override public Tile Clone()
	{
		return new DirectionTile(this.Texture, this.GetPosition(), ID, this.OnPlayerTouchCommands, this.OnTileSpawnCommands, this.isSolid, this.DrawInDebugOnly, this.Direction, this.Properties);
	}
}