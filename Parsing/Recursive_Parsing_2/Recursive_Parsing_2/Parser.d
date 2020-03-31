module Parser;

import std.stdio;

import Jaster.IO.stringstream;

/++ Base classes ++/

/// The base class for all of our Productions
class Production
{
	public abstract double GetValue();
}

/++ Base Classes End ++/


/++ Implementation classes ++/

/// A class to parse a number from the StringStream
class Number : Production
{
	private double Value;

	this(ref StringStream stream)
	{
		stream.SkipBlanks();
		this.Value = stream.ReadDouble();
		stream.SkipBlanks();
	}

	public nothrow override double GetValue()
	{
		return Value;
	}
}

/// Parses ( a [+ - / *] b )
class Factor : Production
{
	private Production _Expression;

	this(ref StringStream stream)
	{
		stream.SkipBlanks();

		if(stream.Peek() == '(')
		{
			stream.ReadChar();
			this._Expression = new Expression(stream);
			stream.SkipBlanks();

			if(stream.Peek() != ')')
			{
				writeln("At Line: ", stream.Line);
				ThrowParseException();
			}
			else
			{
				stream.ReadChar();
			}
		}
		else
		{
			this._Expression = new Number(stream);
		}
	}

	~this()
	{
		this._Expression = null;
	}

	public override double GetValue()
	{
		return this._Expression.GetValue();
	}
}

/// A class to parse unary operators and operands from the StringStream
class Unary : Production
{
	/// Used to decide whether to make Value's value negative or not
	private int Sign;
	private Factor Value;

	this(ref StringStream stream)
	{
		this.Sign = 1;
		stream.SkipBlanks();

		while(stream.Peek() == '-' || stream.Peek() == '+')
		{
			if(stream.ReadChar == '-')
			{
				this.Sign = -this.Sign;
			}
		}

		this.Value = new Factor(stream);
	}

	~this()
	{
		this.Value = null;
	}

	public override double GetValue()
	{
		return this.Sign * this.Value.GetValue();
	}
}

/// A class to parse Binary Operators (* and /) and operands from the StringStream
class Term : Production
{
	Unary[] Values;
	char[] Operators;

	this(ref StringStream stream)
	{
		this.Values ~= new Unary(stream);
		stream.SkipBlanks();

		while(stream.Peek() == '*' || stream.Peek() == '/')
		{
			this.Operators ~= stream.ReadChar();
			this.Values ~= new Unary(stream);
		}
	}

	~this()
	{
		this.Values.length = 0;
	}

	public override double GetValue()
	{
		double ToReturn = this.Values[0].GetValue();

		for(uint i = 1; i < this.Values.length; i++)
		{
			if(this.Operators[i - 1] == '*')
			{
				ToReturn *= this.Values[i].GetValue();
			}
			else
			{
				ToReturn /= this.Values[i].GetValue();
			}
		}

		return ToReturn;
	}
}

class Expression : Production
{
	private Term[] Values;
	private char[] Operators;

	this(ref StringStream stream)
	{
		stream.SkipBlanks();
		this.Values ~= new Term(stream);

		while(stream.Peek() == '+' || stream.Peek() == '-')
		{
			this.Operators ~= stream.ReadChar();
			this.Values ~= new Term(stream);
		}
	}

	~this()
	{
		this.Values.length = 0;
	}

	public override double GetValue()
	{
		double ToReturn = this.Values[0].GetValue();
		
		for(uint i = 1; i < this.Values.length; i++)
		{
			if(this.Operators[i - 1] == '+')
			{
				ToReturn += this.Values[i].GetValue();
			}
			else
			{
				ToReturn -= this.Values[i].GetValue();
			}
		}
		
		return ToReturn;
	}
}

/++ Implementation classes end ++/

public pure void ThrowParseException()
{
	throw new Exception("A parsing error occured");
}