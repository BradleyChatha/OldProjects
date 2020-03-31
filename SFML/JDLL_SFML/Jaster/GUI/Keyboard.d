module Jaster.GUI.Keyboard;

import derelict.sfml2.window;
import derelict.sfml2.graphics;
import derelict.sfml2.system;

public class Keyboard
{
	private static char[] Buffer;

	// TODO: Allow selection between Amerian and British keyboard layouts
	public static char[] GetPressedKeys()
	{
		Buffer.length = 0;

		AddToBuffer(sfKeyA, 'a');
		AddToBuffer(sfKeyB, 'b');
		AddToBuffer(sfKeyC, 'c');
		AddToBuffer(sfKeyD, 'd');
		AddToBuffer(sfKeyE, 'e');
		AddToBuffer(sfKeyF, 'f');
		AddToBuffer(sfKeyG, 'g');
		AddToBuffer(sfKeyH, 'h');
		AddToBuffer(sfKeyI, 'i');
		AddToBuffer(sfKeyJ, 'j');
		AddToBuffer(sfKeyK, 'k');
		AddToBuffer(sfKeyL, 'l');
		AddToBuffer(sfKeyM, 'm');
		AddToBuffer(sfKeyN, 'n');
		AddToBuffer(sfKeyO, 'o');
		AddToBuffer(sfKeyP, 'p');
		AddToBuffer(sfKeyQ, 'q');
		AddToBuffer(sfKeyR, 'r');
		AddToBuffer(sfKeyS, 's');
		AddToBuffer(sfKeyT, 't');
		AddToBuffer(sfKeyU, 'u');
		AddToBuffer(sfKeyV, 'v');
		AddToBuffer(sfKeyW, 'w');
		AddToBuffer(sfKeyX, 'x');
		AddToBuffer(sfKeyY, 'y');
		AddToBuffer(sfKeyZ, 'z');

		if(sfKeyboard_isKeyPressed(sfKeyLShift) || sfKeyboard_isKeyPressed(sfKeyRShift))
		{
			AddToBuffer(sfKeyNum0, ')');
			AddToBuffer(sfKeyNum1, '!');
			AddToBuffer(sfKeyNum2, '"');

			// FIXME: The British Pound sign seems to be special.... as a wchar it's some kind of Arabic/Punjabi Character, and it's not allowed as a normal char
			AddToBuffer(sfKeyNum3, '3');

			AddToBuffer(sfKeyNum4, '$');
			AddToBuffer(sfKeyNum5, '%');
			AddToBuffer(sfKeyNum6, '^');
			AddToBuffer(sfKeyNum7, '&');
			AddToBuffer(sfKeyNum8, '*');
			AddToBuffer(sfKeyNum9, '(');

			AddToBuffer(sfKeySlash, '?');
		}
		else
		{
			AddToBuffer(sfKeyNum0, '0');
			AddToBuffer(sfKeyNum1, '1');
			AddToBuffer(sfKeyNum2, '2');
			AddToBuffer(sfKeyNum3, '3');
			AddToBuffer(sfKeyNum4, '4');
			AddToBuffer(sfKeyNum5, '5');
			AddToBuffer(sfKeyNum6, '6');
			AddToBuffer(sfKeyNum7, '7');
			AddToBuffer(sfKeyNum8, '8');
			AddToBuffer(sfKeyNum9, '9');

			AddToBuffer(sfKeySlash, '/');
		}

		AddToBuffer(sfKeySpace, ' ');
		AddToBuffer(sfKeyComma, ',');
		AddToBuffer(sfKeyPeriod, '.');

		// FIXME: Doesn't register the Quote on a British Keyboard, try to find a way around
		AddToBuffer(sfKeyQuote, '\'');

		return Buffer;
	}

	private static void AddToBuffer(int keyCode, char toAdd)
	{
		if(sfKeyboard_isKeyPressed(keyCode))
		{
			Keyboard.Buffer.length += 1;
			Keyboard.Buffer[$ - 1] = toAdd;
		}
	}
}

