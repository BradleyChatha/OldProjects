module Game;

import std.stdio;
import std.conv;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import Jaster.GameState;
import Jaster.GUI.Controls;
import Jaster.System;

import main;

public class MainGS : GameState
{
	public static sfRenderWindow* Window;
	public static GameStateManager* Manager;

	this(sfRenderWindow* window, GameStateManager* manager)
	{
		MainGS.Window = window;
		MainGS.Manager = manager;
	}

	public override void Init()
	{
	}

	public override void Reset()
	{

	}

	public override void Draw()
	{
	}

	public override void Update()
	{
	}

	public override void Uninit()
	{
		Window = null;
		Manager = null;
		this.Textures = null;
		this.Fonts = null;
	}
}

