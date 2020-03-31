module Tile;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicsfunctions;
import derelict.sfml2.graphicstypes;

import main;
import Entity;

public struct TileInfo
{
	string TextureName;
	ubyte ID;

	/// Used for server
	Tile oTile;

	uint FoodNeeded;
	uint WoodNeeded;
}

public class Tile : Entity
{
	public ubyte ID;

	public ubyte FoodIncome = 0;
	public ubyte WoodIncome = 0;

	public override abstract void Draw(GlobalData* globals) 
	{
		// Draw the Tile
		sfRenderWindow_drawSprite((*globals).Window, this.Sprite, null);
	}

	public override abstract void Update(GlobalData* globals) 
	{
		// Get the mouse's position, relative to the window
		sfVector2i MousePos = sfMouse_getPositionRenderWindow((*globals).Window);

		// Get the tile's position
		sfVector2f TilePos = this.GetPosition();

		// If the Mouse is over the tile
		if(MousePos.x >= TilePos.x && MousePos.x <= (TilePos.x + this.GetTextureWidth()) && MousePos.y >= TilePos.y && MousePos.y <= (TilePos.y + GetTextureHeight()))
		{
			// If the left mouse button is down
			if(sfMouse_isButtonPressed(sfMouseLeft))
			{
				// Call the OnMouseClick event
				OnMouseClick(globals);
			}

			// Always color the tile the mouse is over
			sfSprite_setColor(this.Sprite, sfColor(128, 40, 50, 255));
			// Click doesn't register multiple times if we check for input, which is perfect ^.^
		}
		else
		{
			// Reset the color if the mouse is no longer over the tile
			sfSprite_setColor(this.Sprite, sfWhite);
		}
	}

	public abstract void OnMouseClick(GlobalData* globals);
}

