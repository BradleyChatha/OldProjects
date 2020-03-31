module TextIO;

import std.stdio;
import std.string;
import std.file;
import std.conv;

class TextIO
{
	string Text;
	public int Cursor = 0;

	this(string file)
	{
		if(!exists(file))
		{
			writeln("ERROR: File doesn't exist!\n");
		}

		this.Text = readText(file);
	}

	public bool EOF()
	{
		return Cursor >= Text.length;
	}

	public char GetChar()
	{
		SkipBlanks();
		return Text[Cursor++];
	}

	public double GetDouble()
	{
		string ToReturn = "";

		while(IsNumber(Peek) || Peek == '.')
		{
			ToReturn ~= GetChar();
		}

		return to!double(ToReturn);
	}

	public char Peek()
	{
		return Text[Cursor];
	}

	public void SkipBlanks()
	{
		while(Text[Cursor] == ' ' || Text[Cursor] == '\t')
		{
			Cursor += 1;
		}
	}
}

nothrow bool IsNumber(char compare)
{
	switch(compare)
	{
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return true;
			
		default:
			return false;
	}
}