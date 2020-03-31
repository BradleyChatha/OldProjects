module main;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import Jaster.GameState;
import Jaster.System;

import Game;

pragma(lib, "DerelictSFML2.lib");
pragma(lib, "DerelictUtil.lib");

sfRenderWindow* Window;

void main(string[] args)
{
	DerelictSFML2Window.load();
	DerelictSFML2Graphics.load();
	DerelictSFML2System.load();
	
	sfVideoMode Settings = { 800, 600, 32 };
	Window = sfRenderWindow_create(Settings, "Test", sfResize | sfClose, null);
	sfRenderWindow_setVerticalSyncEnabled(Window, true);
	
	sfEvent Event;

	GameTime.Create();
	GameStateManager Manager = new GameStateManager();
	Manager.RegisterGameState(new MainGS(Window, &Manager), "Main");
	Manager.SwitchGameState("Main");

	while(sfRenderWindow_isOpen(Window))
	{
		GameTime.Restart();
		sfRenderWindow_clear(Window, sfBlack);

		while(sfRenderWindow_pollEvent(Window, &Event))
		{
			if(Event.type == sfEvtClosed)
			{
				sfRenderWindow_close(Window);
			}
		}

		Manager.Draw();
		Manager.Update();

		sfRenderWindow_display(Window);
	}

	Manager.UninitGameState("Main");
	sfRenderWindow_destroy(Window);

	DerelictSFML2Window.unload();
	DerelictSFML2Graphics.unload();
	DerelictSFML2System.unload();
}