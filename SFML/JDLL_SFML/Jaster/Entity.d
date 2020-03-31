module Jaster.Entity;

import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

public class Entity
{
	public sfSprite* Sprite;
	
	public abstract void Draw(sfRenderWindow* window);
	public abstract void Update(sfRenderWindow* window);
	
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
}

public class Animation : Entity
{
	int 	FrameWidth, FrameHeight, FrameCount, CurrentFrame, CurrentYFrame;
	float 	FrameInterval;
	sfClock* Timer;

	this(sfTexture* texture, int frameWidth, int frameHeight, int frameCount, float frameInterval)
	{
		this.Sprite = sfSprite_create();
		this.SetTexture(texture);
		this.FrameWidth = frameWidth;
		this.FrameHeight = frameHeight;
		this.FrameCount = frameCount;
		this.FrameInterval = frameInterval;
		this.CurrentFrame = 0;
		this.CurrentYFrame = 0;
		this.Timer = sfClock_create();
		sfSprite_setTextureRect(this.Sprite, sfIntRect(0, 0, frameWidth, frameHeight));
	}

	override public void Draw(sfRenderWindow* window)
	{
		sfRenderWindow_drawSprite(window, this.Sprite, null);
	}

	override public void Update(sfRenderWindow* window)
	{
		if(sfTime_asSeconds(sfClock_getElapsedTime(this.Timer)) > this.FrameInterval)
		{
			this.NextFrame();
			sfClock_restart(this.Timer);
		}
	}

	public void NextFrame()
	{
		(this.CurrentFrame == this.FrameCount - 1) ? this.CurrentFrame -= (this.FrameCount - 1) : this.CurrentFrame += 1;

		this.UpdateFrame();
	}

	public void UpdateFrame()
	{
		sfIntRect Rect = sfIntRect(this.FrameWidth * this.CurrentFrame, this.FrameHeight * this.CurrentYFrame, this.FrameWidth, this.FrameHeight);
		sfSprite_setTextureRect(this.Sprite, Rect);
	}
}