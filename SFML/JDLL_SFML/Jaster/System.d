module Jaster.System;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

pragma(lib, "DerelictSFML2.lib");
pragma(lib, "DerelictUtil.lib");

public class GameTime
{
	static sfClock* Clock;

	public static void Create()
	{
		GameTime.Clock = sfClock_create();
	}

	public static void Restart()
	{
		sfClock_restart(GameTime.Clock);
	}

	public static float GetSeconds()
	{
		return sfTime_asSeconds(sfClock_getElapsedTime(GameTime.Clock));
	}
}