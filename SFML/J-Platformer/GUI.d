module GUI;

import std.string;
import std.stdio;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import derelict.sfml2.windowtypes;
import derelict.sfml2.windowfunctions;

import derelict.sfml2.graphicstypes;
import derelict.sfml2.graphicsfunctions;

import Jaster.GUI.Controls;

class GUI
{
	Button PlayButton;
	Button ExitButton;

	sfTexture* 		ButtonTexture;
	sfTexture*		BackgroundTexture;
	sfFont* 		Font;
	sfRenderWindow* Window;

	sfSprite* 		Background;

	bool Show = true;
	bool Exit = false;

	this(sfRenderWindow* window)
	{
		this.Window = window;

		sfIntRect Bleh = sfIntRect(240, 60);
		this.ButtonTexture = sfTexture_createFromFile(cast(const(char*))"Resources/GUI/Box.png".toStringz(), &Bleh);
		Bleh = sfIntRect(750, 700);
		this.BackgroundTexture = sfTexture_createFromFile(cast(const(char*))"Resources/GUI/Background.png".toStringz(), &Bleh);
		this.Font = sfFont_createFromFile("Resources/arial.ttf".toStringz());

		this.PlayButton = new Button(this.Window, this.ButtonTexture, (1248 / 2) - (sfTexture_getSize(ButtonTexture).x / 2), (800 / 2) - (sfTexture_getSize(ButtonTexture).y));
		this.PlayButton.SetupText(this.Font, 20, sfBlack);
		this.PlayButton.SetTextString("Play game");

		this.ExitButton = new Button(this.Window, this.ButtonTexture, (1248 / 2) - (sfTexture_getSize(ButtonTexture).x / 2), (800 / 2) + (sfTexture_getSize(ButtonTexture).y));
		this.ExitButton.SetupText(this.Font, 20, sfBlack);
		this.ExitButton.SetTextString("Exit game");

		this.Background = sfSprite_create();
		sfSprite_setTexture(this.Background, this.BackgroundTexture, true);
		sfSprite_setPosition(this.Background, sfVector2f((1248 / 2) - (750 / 2.4), -100));
		sfSprite_setScale(this.Background, sfVector2f(0.8, 0.8));

		sfFont* Bleh2 = sfFont_createFromFile("Resources/arial.ttf");
		ControlGenerator.SetupLabelTemplate(Bleh2, 20, sfColor(128, 128, 128));
	}

	void Draw()
	{
		sfRenderWindow_drawSprite(this.Window, this.Background, null);
		this.PlayButton.DrawControl();
		this.ExitButton.DrawControl();
	}

	void Update()
	{
		this.PlayButton.UpdateControl();
		this.ExitButton.UpdateControl();

		this.Show = !this.PlayButton.IsClicked;
		this.Exit = this.ExitButton.IsClicked;
	}
}

