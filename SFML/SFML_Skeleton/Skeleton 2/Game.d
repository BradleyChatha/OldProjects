module Game;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicstypes;
import derelict.sfml2.graphicsfunctions;

import derelict.sfml2.systemtypes;
import derelict.sfml2.systemfunctions;

import std.file;
import std.string;
import std.conv;

import main;

public class Game
{
	// Holds the texture pointers
	public sfTexture*[string] Textures;

	// Pointer to the GlobalData, before I had any idea that static worked just like in C#
	public GlobalData* Globals;

	public void Init(GlobalData* globals)
	{
		// Store the pointer
		this.Globals = globals;
	}

	public void Draw()
	{
	}
	
	public void Update()
	{
	}
	
	public void Uninit()
	{
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