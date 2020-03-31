module Jaster.GameState;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import std.string;

public class GameState
{
	public sfTexture*[string] Textures;
	public sfFont*[string] Fonts;

	/// When the Gamestate needs to be set up
	public abstract void Init();

	/// When the Gamestate needs to be reset
	public abstract void Reset();

	/// When the Gamestate needs to update
	public abstract void Update();

	/// When the Gamestate needs to draw
	public abstract void Draw();

	/// When the Gamestate needs to close
	public abstract void Uninit();

	public void RegisterTexture(string filePath, string key, int width, int height)
	{
		// Create a rectangle from the given Width and height
		const(sfIntRect) Rect = sfIntRect(width, height);
		
		// Associate "key" with the texture read in
		Textures[key] =	sfTexture_createFromFile(cast(const(char*))filePath, &Rect);
	}

	public void RegisterFont(string fontPath, string key)
	{
		Fonts[key] = sfFont_createFromFile(fontPath.toStringz);
	}
}

public class GameStateManager
{
	public GameState[string] GameStates;
	private string _CurrentGameState = "NOGS";

	~this()
	{
		foreach(GameState g; this.GameStates.values)
		{
			g.Uninit();
		}
	}

	public void RegisterGameState(GameState gameState, string name)
	{
		this.GameStates[name] = gameState;
	}

	public void ResetGameState(string name)
	{
		this.GameStates[name].Reset();
	}

	public void UninitGameState(string name)
	{
		this.GameStates[name].Uninit();
	}

	public void SwitchGameState(string name, bool initNewGameState = true, bool uninitLastGameState = true)
	{
		if(uninitLastGameState && this._CurrentGameState != "NOGS")
		{
			this.GameStates[this._CurrentGameState].Uninit();
		}

		this._CurrentGameState = name;

		if(initNewGameState)
		{
			this.GameStates[name].Init();
		}
	}

	public void Update()
	{
		this.GameStates[this._CurrentGameState].Update();
	}

	public void Draw()
	{
		this.GameStates[this._CurrentGameState].Draw();
	}
}