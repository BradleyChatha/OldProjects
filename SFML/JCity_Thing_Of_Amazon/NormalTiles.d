module NormalTiles;

import std.stdio;
import std.string;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicsfunctions;
import derelict.sfml2.graphicstypes;

import main;
import Entity;
import Tile;
import Commands;
import Jaster.Maths;

public class Dirt : Tile
{
	this()
	{
		this.ID = 1;
	}

	this(sfTexture* texture)
	{
		this.SetTexture(texture);
		this();
	}

	public override void OnMouseClick(GlobalData* globals) 
	{
		string Option;

		writeln("\nEmpty space, what do you want to build?");
		writeln("1. Farm  (3 Food per second)  [300 Food needed]");
		writeln("2. Lumberjack (2 Wood per second) [300 Wood needed(Ask Tarn for some)]");

		Option = readln().chomp();
		int X = cast(int)Floor((this.GetPosition().x / 32));
		int Y = cast(int)Floor(this.GetPosition().y / 32);

		if(Option == "1")
		{
			(*globals).ChangeTile(X, Y, "Farm");
		}
		else if(Option == "2")
		{
			(*globals).ChangeTile(X, Y, "Lumberjack");
		}
	}

	public override void Draw( GlobalData* globals) {
		super.Draw(globals);
	}

	public override void Update( GlobalData* globals) {
		super.Update(globals);
	}
}

public class Shed : Tile
{
	this()
	{
		this.ID = 3;
	}
	
	this(sfTexture* texture)
	{
		this.SetTexture(texture);
		this();
	}
	
	public override void OnMouseClick(GlobalData* globals) 
	{
		(*globals).Connection.SendShort(Command.RequestResourceInfo);
		writeln((*globals).Connection.RecieveString());
		sfSleep(sfSeconds(1.2f));

		return;
	}
	
	public override void Draw( GlobalData* globals) {
		super.Draw(globals);
	}
	
	public override void Update( GlobalData* globals) {
		super.Update(globals);
	}
}

public class Farm : Tile
{
	this()
	{
		this.ID = 2;
		this.FoodIncome = 3;
	}
	
	this(sfTexture* texture)
	{
		this.SetTexture(texture);
		this();
	}
	
	public override void OnMouseClick(GlobalData* globals) 
	{
		return;
	}
	
	public override void Draw( GlobalData* globals) {
		super.Draw(globals);
	}
	
	public override void Update( GlobalData* globals) {
		super.Update(globals);
	}
}

public class Lumberjack : Tile
{
	this()
	{
		this.ID = 4;
		this.WoodIncome = 2;
	}
	
	this(sfTexture* texture)
	{
		this.SetTexture(texture);
		this();
	}
	
	public override void OnMouseClick(GlobalData* globals) 
	{
		return;
	}
	
	public override void Draw( GlobalData* globals) {
		super.Draw(globals);
	}
	
	public override void Update( GlobalData* globals) {
		super.Update(globals);
	}
}
