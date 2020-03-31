module Jaster.IO.stringstream;

private import std.stdio;
private import std.conv;

private import Jaster.util;

/// Provides an interface to write and read strings using other Basic data types
class StringStream
{
	/// The stream's buffer
	private string Data;

	/// Used to check if a character is a digit
	private string Digits = "0123456789";
	private string DecimalDigits;

	/// Position the stream is at in it's buffer
	private uint _Position = 0;
	private uint _Line = 0;

	/// Constructs a StringStream with an empty buffer
	this()
	{
		this("");
	}

	/// Constructs a StringStream with the given string as a buffer
	this(string input)
	{
		this.Data = input;
		this.DecimalDigits = Digits ~ ".";
	}

	/// Returns the character at position: Position - offset; Defaults to: Position - 0
	public char Peek(int offset = 0)
	{
		if(this.EoF)
		{
			return '\0';
		}

		return Data[this._Position + offset];
	}

	/// Skips past any space, new line, and tab until the stream hits a not mentioned character
	public void SkipBlanks()
	{
		while(this._Position < this.Data.length && (this.Peek() == ' ' || this.Peek() == '\n' || this.Peek() == '\t' || this.Peek() == cast(char)0x0D || this.Peek() == '\r'))
		{
			this.ReadChar();
		}
	}

	public void SkipLine()
	{
		while(!this.EoF() && this.Peek() != '\n')
		{
			this.ReadChar();
		}
		this.ReadChar();
	}

	/// Returns the character the Stream is currently over and advances by 1
	public char ReadChar(bool parseEscapeCharacters = false)
	{
		if(this.EoF)
		{
			return '\0';
		}

		if(this.Peek() == '\n')
		{
			this._Line++;
		}

		if(this.Peek == '\\' && parseEscapeCharacters)
		{
			this._Position += 1;
			char Char = this.ReadChar();

			switch(Char)
			{
				case 'n': return '\n';
				case 't': return '\t';
				default: throw new Exception("Invalid escape character '" ~ Char ~ "'");
			}
		}

		return this.Data[this._Position++];
	}

	/// Returns 'length' character from the stream as a string and advances by 'length'
	// TODO: Make this use "ReadChar" so it can parse escape characters  
	public string ReadString(uint length)
	{
		this._Position += length;
		return this.Data[this._Position - length..this._Position];
	}

	/// Reads in characters(Also parsing escape characters) until the stream hits a new line marker
	public string ReadString()
	{
		string ToReturn = "";
		
		while(this.Peek() != '\n' && !this.EoF)
		{
			ToReturn ~= this.ReadChar(true);
		}
		
		return ToReturn;
	}

	/// Reads characters from the Stream until 'delimeter' or the end of the stream's buffer is hit, then returns those characters
	public string ReadTo(char delimeter, bool parseEscapeCharacters = false)
	{
		string Temp = "";

		while(this._Position < this.Data.length && this.Peek() != delimeter)
		{
			Temp ~= this.ReadChar(parseEscapeCharacters);
		}

		return Temp;
	}

	public string ReadToAny(char[] delimeters, bool parseEscapeCharacters = false)
	{
		string Temp = "";

		while(this._Position < this.Data.length && !Contains!char(delimeters, Peek))
		{
			Temp ~= this.ReadChar(parseEscapeCharacters);
		}

		return Temp;
	}

	/// Reads in digit characters until either a non-digit character is hit or the end of the Stream's buffer is hit, then converts those digit characters into an int before returning it
	public int ReadInt()
	{
		string Temp = "";

		while(this._Position < this.Data.length && this.IsDigit(this.Peek(), false))
		{
			Temp ~= this.ReadChar();
		}

		return to!int(Temp);
	}

	/// Reads in digit characters(Including '.') until either a non-digit character is hit or the end of the Stream's buffer is hit, then converts those digit characters into a double before returning it
	public double ReadDouble()
	{
		string Temp = "";
		
		while(this._Position < this.Data.length && this.IsDigit(this.Peek(), true))
		{
			Temp ~= this.ReadChar();
		}
		
		return to!double(Temp);
	}

	public real ReadReal()
	{
		string Temp = "";
		
		while(this._Position < this.Data.length && this.IsDigit(this.Peek(), true))
		{
			Temp ~= this.ReadChar();
		}
		
		return to!real(Temp);
	}

	public bool IsDigit(char toCheck, bool decimal)
	{
		if(decimal)
		{
			return this.DecimalDigits.StringContains(toCheck);
		}
		else
		{
			return this.Digits.StringContains(toCheck);
		}
	}

	public nothrow void Close()
	{
		this.Data = "";
		// TODO: Bleh things with closey things
	}

	/// Sets the stream's position in it's buffer
	@property
	public nothrow void Position(uint position) 
	{
		this._Position = position;
	}

	/// Gets the Stream's position that it's at for it's buffer
	@property
	public nothrow uint Position() 
	{
		return this._Position;
	}

	@property
	public nothrow uint Line() 
	{
		return this._Line;
	}

	@property
	public nothrow bool EoF() 
	{
		return this.Position >= this.Data.length;
	}
}

///
unittest
{
	StringStream SS = new StringStream("DIs30 70.50 240.4129 String\nSkip\nDon't Skip:");
	assert(SS.Peek() == 'D');
	assert(SS.ReadChar() == 'D');
	assert(SS.ReadString(2) == "Is");
	assert(SS.ReadInt() == 30);
	SS.ReadChar();
	assert(SS.ReadDouble() == 70.50);
	SS.ReadChar();
	assert(SS.ReadReal() == 240.4129);
	SS.ReadChar();
	assert(SS.ReadString() == "String");

	SS.Position = 20;
	assert(SS.Position == 20);
	SS.ReadTo('~');

	// TODO: FInish up the asserts

	assert(SS.EoF);
	SS.Close();
}