module Entity;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import main;

public class Entity
{
	public sfSprite* Sprite;
	
	public abstract void Draw(GlobalData* globals);
	public abstract void Update(GlobalData* globals);
	
	public sfVector2f GetPosition()
	{
		return sfSprite_getPosition(this.Sprite);
	}
	
	public void SetPosition(sfVector2f position)
	{
		sfSprite_setPosition(this.Sprite, position);
	}
	
	public void Move(sfVector2f velocity)
	{
		sfSprite_move(this.Sprite, velocity);
	}
	
	public int GetTextureWidth()
	{
		return sfSprite_getTextureRect(this.Sprite).width;
	}
	
	public int GetTextureHeight()
	{
		return sfSprite_getTextureRect(this.Sprite).height;
	}
	
	public void SetTexture(sfTexture* texture)
	{
		Sprite = sfSprite_create();
		sfSprite_setTexture(this.Sprite, texture, true);
	}

	public bool IsTouchingEntity(Entity* entity)
	{
		sfVector2f EntityPos = (*entity).GetPosition();
		return (EntityPos.x >= this.GetPosition().x && EntityPos.x <= (this.GetPosition().x + this.GetTextureWidth()) && EntityPos.y >= this.GetPosition().y && EntityPos.y <= (this.GetPosition().y + this.GetTextureHeight()));
	}

	public bool IsMouseOver(sfRenderWindow* window)
	{
		sfVector2i Mouse = sfMouse_getPositionRenderWindow(window);
		return (Mouse.x >= this.GetPosition().x && Mouse.x <= (this.GetPosition().x + this.GetTextureWidth()) && Mouse.y >= this.GetPosition().y && Mouse.y <= (this.GetPosition().y + this.GetTextureHeight()));
	}
}

