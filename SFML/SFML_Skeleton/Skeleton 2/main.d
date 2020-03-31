module main;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicstypes;
import derelict.sfml2.graphicsfunctions;

import Game;

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

		// Pointer to the Render Window
		sfRenderWindow* Window;
	}
}

void main(string[] args)
{
	DerelictSFML2Window.load();
	DerelictSFML2Graphics.load();
	DerelictSFML2System.load();

	GlobalData Data = GlobalData();

	sfVideoMode Settings = { Data.WindowWidth, Data.WindowHeight, 32 };
	Window = sfRenderWindow_create(Settings, "Game", sfClose, null);
	sfRenderWindow_setVerticalSyncEnabled(Window, true);

	Data.Window = Window;
	
	sfEvent Event;
	
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
		
		oGame.Update();
		oGame.Draw();
		sfRenderWindow_display(Window);
	}
	
	oGame.Uninit();
	sfRenderWindow_destroy(Window);

	DerelictSFML2Window.unload();
	DerelictSFML2Graphics.unload();
	DerelictSFML2System.unload();
}