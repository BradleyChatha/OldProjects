module GameEntity;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicsfunctions;
import derelict.sfml2.graphicstypes;

import std.exception;
import std.conv;
import std.string;
import std.stdio;
import std.array;

import Jaster.Entity : Animation;
import Entity;
import Game;
import NormalTiles;
import ITile;
import main;

class IEntity : Entity
{
	public ubyte ID;

	public string[] OnPlayerTouchCommands;

	protected void Setup(sfTexture* texture, sfVector2f position, ubyte id)
	{
		this.SetTexture(texture);
		this.SetPosition(position);
		this.ID = id;
	}

	public abstract IEntity Clone();

	public bool IsTouchingPlayer()
	{
		return(this.IsTouchingEntity(cast(Entity*)IEntity.PlayerPointer));
	}

	public void OnPlayerTouch()
	{
		for(int i = 0; i < this.OnPlayerTouchCommands.length; i++)
		{
			string[] Data = this.OnPlayerTouchCommands[i].splitLines();

			if(Data[0] == "PLAYER:")
			{
				if(Data[1] == "RESET")
				{
					Game.Game.PlayerObject.SetPosition(Game.Game.ResetPosition);
					TileInteraction.UndoEvents();
				}
			}
		}
	}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public static IEntity[] Entities;
	public static IEntity[] EntityInfo;

	public static Player* PlayerPointer;

	public static void RegisterEntity(IEntity entity)
	{
		IEntity.Entities[entity.ID] = entity;
	}

	public static IEntity GetEntity(int id)
	{
		return IEntity.Entities[id].Clone();
	}

	public static void SetPlayer(Player* player)
	{
		this.PlayerPointer = player;
	}

	public static void UpdateEntities(GlobalData* data)
	{
		for(int i = 0; i < IEntity.Entities.length; i++)
		{
			IEntity.Entities[i].Update(data);

			if(IEntity.Entities[i].IsTouchingPlayer())
			{
				IEntity.Entities[i].OnPlayerTouch();
			}
		}
	}
}

final class ProjectileEntity : IEntity
{

}