module main;

import std.stdio;
import std.string;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import Game;
import Jaster.jsocket;
import Tile;
import Server;

pragma(lib, "DerelictSFML2.lib");
pragma(lib, "DerelictUtil.lib");

sfRenderWindow* Window;

public struct GlobalData
{
	public sfRenderWindow* Window;
	public Tile[25][19] Tiles;

	public int MapX = 25;
	public int MapY = 19;

	public JSocket Connection;

	public void delegate(int x, int y, string tile) ChangeTile;
}

void main(string[] args)
{
	DerelictSFML2Window.load();
	DerelictSFML2Graphics.load();
	DerelictSFML2System.load();

	if(args.length > 1)
	{
		ServerStart();
		return;
	}
	
	sfVideoMode Settings = { 800, 608, 32 };
	Window = sfRenderWindow_create(Settings, "Best Game Ever", sfClose, null);
	sfRenderWindow_setVerticalSyncEnabled(Window, true);
	
	sfEvent Event;

	GlobalData Data = GlobalData();
	Data.Window = Window;
	Data.Connection = new JSocket();

	write("Enter IP of server: ");
	Data.Connection.Connect(readln().chomp(), 7777);
	write("Enter name to join as: ");
	Data.Connection.SendString(readln().chomp());
	if(Data.Connection.RecieveShort() != Commands.Command.Server_OK)
	{
		Data.Connection.Shutdown();
		Data.Connection.Close();
		throw new Exception("Server didn't respond with SERVER_OK in 'main'");
	}
	
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

void ServerStart()
{
	Server Sev = new Server();
	Sev.Start();
}