module main;

import std.stdio;
import std.string;
import std.file;
import std.exception;
import std.conv;

import TextIO;

TextIO Parser;

void main(string[] args)
{
	debug
	{
		Parser = new TextIO("Parse.txt");
		writeln(ExpressionValue());

		return;
	}

	while(true)
	{
		string ToParse;

		write("Enter file to parse: ");
		ToParse = readln().chomp();

		Parser = new TextIO(ToParse);
		writeln(ExpressionValue());
	}
}

// <Operator> ::= "+" | "-" | "/" | "*"
char GetOperator()
{
	Parser.SkipBlanks();
	char Op = Parser.Peek();

	if((Op == '+') | (Op == '-') | (Op == '/') | (Op == '*'))
	{
		Parser.GetChar();
		return Op;
	}
	else if(Op == '\n')
	{
		throw new Exception("Missing operator at end of line");
	}
	else
	{
		throw new Exception("Missing operator. Found \"" ~ Op ~ "\" instead of +, -, * or /");
	}
}

// <Expression> ::= <Number> | "(" <Expression> <Operator> <Expression> ")"
double ExpressionValue()
{
	Parser.SkipBlanks();

	if(IsNumber(Parser.Peek)) // <Number>
	{
		return Parser.GetDouble();
	}
	else if(Parser.Peek() == '(') // "(" <Expression> <Operator> <Expression> ")"
	{
		Parser.GetChar();

		double LeftValue = ExpressionValue();
		char Operator = Parser.GetChar();
		double RightValue = ExpressionValue();

		if(Parser.Peek() != ')')
		{
			throw new Exception("Missing ')'. Recieved '" ~ Parser.Peek ~ "'");
		}

		switch(Operator)
		{
			case '+':
				return LeftValue + RightValue;

			case '-':
				return LeftValue - RightValue;

			case '*':
				return LeftValue * RightValue;

			case '/':
				return LeftValue / RightValue;

			default:
				throw new Exception("Missing <Expression>.");
		}
	}
	else
	{
		writeln(Parser.Peek);
		throw new Exception("Missing <Expression>.");
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