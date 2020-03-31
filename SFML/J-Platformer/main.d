module main;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicstypes;
import derelict.sfml2.graphicsfunctions;

import GUI;
import Game;
import ITile;

pragma(lib, "DerelictSFML2.lib");
pragma(lib, "DerelictUtil.lib");

sfRenderWindow* Window;

public struct GlobalData
{
	public
	{
		// Window variables
		int 			WindowWidth = 1248;
		int 			WindowHeight = 800;

		// Image size of tiles
		int 			TileSize = 32;

		// Pointer to the Render Window
		sfRenderWindow* Window;

		// Hitler
		derelict.sfml2.graphicstypes.sfFont* DebugFont;
		sfText* DebugText;

		// Bool set if the player has hit the End tile
		bool 			NextLevel = false;

		// Bool set if the player has hit a spike tile
		bool			RespawnPlayer = false;
	}
}

void main(string[] args)
{
	DerelictSFML2Window.load();
	DerelictSFML2Graphics.load();
	DerelictSFML2System.load();

	GlobalData Data = GlobalData();

	sfVideoMode Settings = { Data.WindowWidth, Data.WindowHeight, 32 };
	Window = sfRenderWindow_create(Settings, "J-Platformer", sfClose, null);
	sfRenderWindow_setVerticalSyncEnabled(Window, true);

	Data.Window = Window;

	// Here lies: Death by 1000000Million lines just for the ability to write strings <3
////////////////////////////////////////////////////////////////////////
	Data.DebugFont = sfFont_createFromFile("Resources/arial.ttf");
	Data.DebugText = sfText_create();
	sfText_setFont(Data.DebugText, Data.DebugFont);
	sfText_setColor(Data.DebugText, sfColor_fromRGB(64, 64, 64));
	sfText_setCharacterSize(Data.DebugText, 24);
	sfText_setPosition(Data.DebugText, sfVector2f(0, 0));
////////////////////////////////////////////////////////////////////////
	
	sfEvent Event;

	GUI Menu = new GUI(Window);

	Game oGame = new Game();
	oGame.Init(&Data);
	
	while(sfRenderWindow_isOpen(Window))
	{
		sfRenderWindow_clear(Window, sfWhite);

		while(sfRenderWindow_pollEvent(Window, &Event))
		{
			if(Event.type == sfEvtClosed)
			{
				sfRenderWindow_close(Window);
			}
		}

		if(Menu.Show)
		{
			Menu.Update();
			Menu.Draw();

			if(Menu.Exit)
			{
				sfRenderWindow_close(Window);
			}
		}
		else
		{
			oGame.Update();
			oGame.Draw();
		}

		sfRenderWindow_display(Window);
	}
	
	oGame.Uninit();
	sfRenderWindow_destroy(Window);

	DerelictSFML2Window.unload();
	DerelictSFML2Graphics.unload();
	DerelictSFML2System.unload();
}