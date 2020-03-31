module Jaster.GUI.Controls;

import std.stdio;
import std.string;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

import Jaster.Entity;

public class GUIControl : Entity
{
	protected sfRenderWindow* Window;

	protected void Setup(sfRenderWindow* window, sfVector2f position)
	{
		this.Window = window;
		this.SetPosition(position);
	}

	public abstract void DrawControl();
	public abstract void UpdateControl();

	protected bool IsMouseOver()
	{
		sfVector2i MousePos = sfMouse_getPositionRenderWindow(this.Window);
		sfVector2f ThisPos = this.GetPosition();
		
		return (MousePos.x > ThisPos.x && MousePos.x < (ThisPos.x + this.GetTextureWidth()) && MousePos.y > ThisPos.y && MousePos.y < (ThisPos.y + this.GetTextureHeight()));
	}
}

public alias OnClickHandler = void function();

public class Button : GUIControl
{
	sfText* 		Text;
	OnClickHandler 	OnClick;

	public bool 	IsClicked = false;

	this(sfRenderWindow* window, sfTexture* texture, int x, int y)
	{
		this(window, texture, sfVector2f(x, y));
	}

	override public void Draw(sfRenderWindow* window) { throw new Exception("Do not use this one"); }
	override public void Update(sfRenderWindow* window) { throw new Exception("Do not use this one"); }

	this(sfRenderWindow* window, sfTexture* texture, sfVector2f position)
	{
		this.SetTexture(texture);
		this.Setup(window, position);
	}

	public void SetOnClickEventHandler(OnClickHandler handler)
	{
		this.OnClick = handler;
	}

	public void SetTextPointer(sfText* text)
	{
		this.Text = text;
	}

	public void SetupText(sfFont* font, uint fontSize, sfColor fontColor)
	{
		this.Text = sfText_create();
		sfText_setColor(this.Text, fontColor);
		sfText_setFont(this.Text, font);
		sfText_setCharacterSize(this.Text, fontSize);
	}

	public void SetTextString(string text)
	{
		sfText_setString(this.Text, text.toStringz);
	}

	override public void DrawControl()
	{
		sfRenderWindow_drawSprite(this.Window, this.Sprite, null);

		if(Text !is null)
		{
			// YAYYYYY ONE LINERS.................. Death
			sfText_setPosition(this.Text, sfVector2f( (this.GetPosition().x + (this.GetTextureWidth() / 2)) - (sfText_getLocalBounds(this.Text).width / 2), (this.GetPosition().y + (this.GetTextureHeight() / 2)) - (sfText_getLocalBounds(this.Text).height / 2) ));
			sfRenderWindow_drawText(this.Window, this.Text, null);
		}
	}

	override public void UpdateControl()
	{
		if(this.IsMouseOver())
		{
			sfSprite_setColor(this.Sprite, sfColor_fromRGB(128, 128, 128));

			if(sfMouse_isButtonPressed(sfMouseLeft))
			{
				sfSprite_setColor(this.Sprite, sfWhite);

				if(this.OnClick !is null)
				{
					this.OnClick();
				}

				this.IsClicked = true;
			}
			else
			{
				this.IsClicked = false;
			}
		}
		else
		{
			sfSprite_setColor(this.Sprite, sfWhite);
		}
	}
}

public class Textbox : GUIControl
{
	public string 	InputText = "";
	public bool 	Active;
	sfText* 		Text;
	float			YOffset = 5;
	float			XOffset = 5;

	public bool 	CenterY = false;
	public bool		Password = false;
	public char		PassChar = '*';

	private string  PasswordText = "";

	int BackspaceCount;

	// Keeps track of keys that are being held down, so it doesn't spam the textbox with a single keypress
	bool[char]		Keys;

	this(sfRenderWindow* window, sfTexture* texture, int x, int y)
	{
		this(window, texture, sfVector2f(x, y));
	}
	
	this(sfRenderWindow* window, sfTexture* texture, sfVector2f position)
	{
		this.SetTexture(texture);
		this.Setup(window, position);
	}

	public void SetText(sfText* text)
	{
		this.Text = text;
	}

	override public void Draw(sfRenderWindow* window) { throw new Exception("Do not use this one"); }
	override public void Update(sfRenderWindow* window) { throw new Exception("Do not use this one"); }

	public void SetupText(sfFont* font, uint fontSize, sfColor fontColor)
	{
		this.Text = sfText_create();
		sfText_setColor(this.Text, fontColor);
		sfText_setFont(this.Text, font);
		sfText_setCharacterSize(this.Text, fontSize);
	}

	override public void DrawControl()
	{
		sfRenderWindow_drawSprite(this.Window, this.Sprite, null);

		if(Active)
		{
			if(this.Password)
			{
				sfText_setString(this.Text, (PasswordText ~ "|").toStringz());
			}
			else
			{
				sfText_setString(this.Text, (InputText ~ "|").toStringz());
			}
		}
		else
		{
			if(this.Password)
			{
				sfText_setString(this.Text, (this.PasswordText).toStringz());
			}
			else
			{
				sfText_setString(this.Text, (this.InputText).toStringz());
			}
		}

		if(this.Text !is null)
		{
			sfRenderWindow_drawText(this.Window, this.Text, null);
		}
	}

	/// Sets the Text's string's offset, relative the the X position of the Textbox's sprite
	public void SetTextOffset(int x, int y)
	{
		this.SetTextOffset(sfVector2f(x, y));
	}

	/// Sets the Text's string's offset, relative the the X position of the Textbox's sprite
	public void SetTextOffset(sfVector2f offset)
	{
		this.XOffset = offset.x;
		this.YOffset = offset.y;
	}

	override public void UpdateControl()
	{
		char[] Buffer = Jaster.GUI.Keyboard.Keyboard.GetPressedKeys();
		sfText_setString(this.Text, this.InputText.toStringz);
		sfText_setPosition(this.Text, sfVector2f( (this.GetPosition().x + this.XOffset), (this.GetPosition().y + this.YOffset) ));

		if(CenterY)
		{
			sfText_setPosition(this.Text, sfVector2f( sfText_getPosition(this.Text).x, ((this.GetPosition().y + this.GetTextureHeight()) - (this.GetTextureHeight() / 2)) - (sfText_getLocalBounds(this.Text).height / 1.5) ));
		}

		// Make sure the player has to click the text box to start typing
		if(sfMouse_isButtonPressed(sfMouseLeft))
		{
			Active = IsMouseOver();
		}

		if(!Active)
		{
			return;
		}

		// Backspace handler
		if(sfKeyboard_isKeyPressed(sfKeyBack))
		{
			BackspaceCount += 1;

			if((!Keys['\b'] || BackspaceCount >= 25) && this.InputText.length != 0)
			{
				this.InputText.length -= 1;
				this.PasswordText.length -= 1;
				Keys['\b'] = true;
			}
		}
		else
		{
			BackspaceCount = 0;
			Keys['\b'] = false;
		}

		// Escape key handler
		if(sfKeyboard_isKeyPressed(sfKeyEscape))
		{
			this.InputText.length = 0;
		}

		// Set the keys as pressed, and check if we need to write a single character for each key
		for(int i = 0; i < Buffer.length; i++)
		{
			if(this.Keys.keys.indexOf(Buffer[i]) == -1)
			{
				this.Keys[Buffer[i]] = false;
			}

			// If this is the first time the key has been registered for it's specific keypress, add it's character to the string
			if(!this.Keys[Buffer[i]])
			{
				if(this.Password)
				{
					this.PasswordText ~= PassChar;
				}
				else
				{
					this.PasswordText.length += 1;
				}

				if(sfKeyboard_isKeyPressed(sfKeyLShift) || sfKeyboard_isKeyPressed(sfKeyRShift))
				{
					// Append the upper-case character
					this.InputText ~= toUpper!string(cast(string)[ Buffer[i] ]);
				}
				else
				{
					// Append the lower-case character
					this.InputText ~= Buffer[i];
				}
			}

			this.Keys[Buffer[i]] = true;
		}

		// If the button isn't pressed, flag it as such
		for(int i = 0; i < Keys.keys.length; i++)
		{
			if(Buffer.indexOf(this.Keys.keys[i]) == -1 && Keys.keys[i] != '\b')
			{
				this.Keys[this.Keys.keys[i]] = false;
			}
		}

		// Try to keep the text inside the textbox
		if(sfText_getPosition(this.Text).x + sfText_getLocalBounds(this.Text).width > this.GetPosition().x + this.GetTextureWidth)
		{
			this.InputText.length -= 1;
			this.PasswordText.length -= 1;
		}
	}
}

public class Valuebox : GUIControl
{
	sfText* 	Text;
	string* 	Value;
	sfVector2f	CurrentPos;

	private int CharacterSize;

	override public void Draw(sfRenderWindow* window) { throw new Exception("Do not use this one"); }
	override public void Update(sfRenderWindow* window) { throw new Exception("Do not use this one"); }

	this(sfRenderWindow* window, sfTexture* texture, int x, int y)
	{
		this(window, texture, sfVector2f(x, y));
	}
	
	this(sfRenderWindow* window, sfTexture* texture, sfVector2f position)
	{
		this.SetTexture(texture);
		this.Setup(window, position);
	}
	
	public void SetTextPointer(sfText* text)
	{
		this.Text = text;
	}
	
	public void SetupText(sfFont* font, uint fontSize, sfColor fontColor)
	{
		this.CharacterSize = fontSize;
		this.Text = sfText_create();
		sfText_setColor(this.Text, fontColor);
		sfText_setFont(this.Text, font);
		sfText_setCharacterSize(this.Text, fontSize);
	}
	
	public void SetValuePointer(string* value)
	{
		this.Value = value;
	}

	override public void DrawControl()
	{
		sfRenderWindow_drawSprite(this.Window, this.Sprite, null);
		sfRenderWindow_drawText(this.Window, this.Text, null);
	}

	override public void UpdateControl()
	{
		assert(this.Value !is null);
		assert(this.Text !is null);

		sfText_setString(this.Text, (cast(const(char)[])(*this.Value)).toStringz());
		//sfText_setPosition(this.Text, sfVector2f( (((this.GetPosition().x + this.GetTextureWidth) - (this.GetTextureWidth() / 2))) - (sfText_getLocalBounds(this.Text).width / 2), ((this.GetPosition().y + this.GetTextureHeight()) - (this.GetTextureHeight() / 2)) - (CharacterSize / 1.5) ));
		sfText_setPosition(this.Text, sfVector2f( ((this.GetPosition().x + (this.GetTextureWidth() / 2)) - (sfText_getLocalBounds(this.Text).width / 2)), (this.GetPosition().y + (this.GetTextureHeight() / 2) - (sfText_getLocalBounds(this.Text).height / 2)) ));

		// Here lies, the wall of debug, may ye rest in peace
//		writeln("Box Y: ", this.GetPosition().y);
//		writeln("Box Texture Height: ", this.GetTextureHeight());
//		writeln("Box Y + Height: ", this.GetPosition().y + this.GetTextureHeight());
//		writeln("Box Y + Height - Height / 2: ", ((this.GetPosition().y + this.GetTextureHeight()) - (this.GetTextureHeight() / 2)));
//		writeln("Box X: ", this.GetPosition().x);
//		writeln("Box Texture Width: ", this.GetTextureWidth());
//		writeln("Box X + Width: ", this.GetPosition().x + this.GetTextureWidth());
//		writeln("Box X + Width - Width / 2: ", ((this.GetPosition().x + this.GetTextureWidth()) - (this.GetTextureWidth() / 2)));
//		writeln("Text X: ", sfText_getPosition(this.Text).x);
//		writeln("Test Y: ", sfText_getPosition(this.Text).y);
	}
}

public class Label : GUIControl
{
	override public void Draw(sfRenderWindow* window) { throw new Exception("Do not use this one"); }
	override public void Update(sfRenderWindow* window) { throw new Exception("Do not use this one"); }

	public sfVector2f 	Position;
	public sfText*		Text;

	this(sfRenderWindow* window, sfVector2f position)
	{
		this.Position = position;
		this.Window = window;
	}

	public void SetupText(sfFont* font, uint fontSize, sfColor fontColor)
	{
		this.Text = sfText_create();
		sfText_setColor(this.Text, fontColor);
		sfText_setFont(this.Text, font);
		sfText_setCharacterSize(this.Text, fontSize);
	}

	public void SetColor(sfColor color)
	{
		sfText_setColor(this.Text, color);
	}

	public void SetString(string value)
	{
		sfText_setString(this.Text, value.toStringz());
	}

	override public void DrawControl() {
		if(this.Window !is null && this.Text !is null)
		{
			sfRenderWindow_drawText(this.Window, this.Text, null);
		}
	}

	override public void UpdateControl() {
		sfText_setPosition(this.Text, this.Position);
//		writeln(sfText_getPosition(this.Text));
//		writeln(ConvertCharPointer(sfText_getString(this.Text)));
//		writeln(sfText_getColor(this.Text));
//		writeln(sfText_getCharacterSize(this.Text));
	}
}

public class ControlGenerator
{
	public static sfRenderWindow* GameWindow;

	private static sfFont*  LabelFont;
	private static uint		LabelFontSize;
	private static sfColor	LabelFontColor;

	public static void SetupLabelTemplate(sfFont* font, uint fontSize, sfColor fontColor)
	{
		this.LabelFont = font;
		this.LabelFontSize = fontSize;
		this.LabelFontColor = fontColor;
	}

	public static Label GenerateLabel(string text, sfVector2f position)
	{
		Label ToReturn = new Label(this.GameWindow, position);
		ToReturn.SetupText(this.LabelFont, this.LabelFontSize, this.LabelFontColor);
		ToReturn.SetString(text);

		return ToReturn;
	}
}