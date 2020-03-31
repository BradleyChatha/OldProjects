module main;

import std.stdio;
import std.process;
import std.string;
import std.conv;
import std.file;

import Jaster.IO.stringstream;

string OutputText;
string InputFile;

string[2] CompileCommands;

Method[string] Methods;
string[] Externs;

StringStream SS;

enum ReturnType
{
	Int,
	Void
}

struct Method
{
	string Name;
	string[] Text;
	ReturnType Type;

	int LabelCount = 0;
}

struct ExpressionData
{
	string StringData;
	int NumberData;
}

void main(string[] args)
{
	Loop();
}

void Loop()
{
	while(true)
	{
		OutputText = "";
		
		write("Enter file to compile: ");
		InputFile = readln().chomp;
		
		if(!exists(InputFile))
		{
			writeln("ERROR: File doesn't exist!\n");
		}
		else
		{
			if(InputFile[$ - 4..$] != ".sea")
			{
				writeln("ERROR: Unknown file extension!\n");
				continue;
			}
			SS = new StringStream(readText(InputFile));
			CompileCommands[0] = "nasm -f win32 -o a.obj Temp.asm";
			CompileCommands[1] = "gcc a.obj -o" ~ InputFile[0.. $ - 4] ~ ".exe";
			OutputText = "section .text\nglobal _WinMain@16\n\n";
			Compile();
		}
		
		writeln("\n");
	}
}

string GetIdentifier()
{
	SS.SkipBlanks();
	return SS.ReadToAny(cast(char[])"()\n., ;\r");
}

// Confirms the next character is "delimeter"
bool Confirm(char delimeter)
{
	SS.SkipBlanks();
	return SS.Peek() == delimeter;
}

void Compile()
{
	while(true)
	{
		string ID = GetIdentifier();
		//writeln("Here? ", ID, " ", SS.GetPosition(), " ", SS.GetLine());
		//readln();

		if(ID == "extern")
		{
			Externs ~= "_" ~ GetIdentifier();

			if(!Confirm(';'))
			{
				writeln("ERROR: Line ", SS.Line(), ", missing ';' for extern declaration");
				Loop();
			}
			SS.ReadChar();
		}
		else if(ID == "method")
		{
			ParseMethod();
		}
		else if(ID == "eof")
		{
			break;
		}
	}

	for(int i = 0; i < Externs.length; i++)
	{
		OutputText ~= "extern " ~ Externs[i] ~ "\n";
	}

	OutputText ~= "\n";

	void AddMethod(string key)
	{
		OutputText ~= "_" ~ key ~ ":\n";

		for(int i = 0; i < Methods[key].Text.length; i++)
		{
			OutputText ~= "\t" ~ Methods[key].Text[i];
		}
	}

	for(int i = 0; i < Methods.length; i++)
	{
		AddMethod(Methods.keys[i]);
	}

	std.file.write("Temp.asm", OutputText);
	auto Status = executeShell(CompileCommands[0]);
	writeln(Status.output);

	Status = executeShell(CompileCommands[1]);
	writeln(Status.output);
}

void ParseMethod()
{
	Method M;
	M.Name = GetIdentifier();

	if(M.Name == "main")
	{
		M.Name = "WinMain@16";
	}

	if(!Confirm('('))
	{
		writeln("ERROR: Line ", SS.Line(), ", missing '(' for method declaration");
		Loop();
	}
	SS.ReadChar();

	// Parameter stuff can go here

	SS.SkipBlanks();
	if(!Confirm(')'))
	{
		writeln("ERROR: Line ", SS.Line(), ", missing ')' for method declaration");
		Loop();
	}
	SS.ReadChar();

	if(GetIdentifier() == "returns")
	{
		string Meh = GetIdentifier();
		switch(Meh)
		{
			case "int": M.Type = ReturnType.Int; break;

			default:
				writeln("ERROR: Line ", SS.Line(), ", invalid return type: '", Meh, "'");
				Loop();
				break;
		}
	}
	else
	{
		writeln("ERROR: Line ", SS.Line(), ", missing return type for method declaration");
		Loop();
	}

	SS.SkipBlanks();
	if(!Confirm('{'))
	{
		writeln("ERROR: Line ", SS.Line(), ", missing '{' for method declaration");
		Loop();
	}
	SS.ReadChar();

	Methods[M.Name] = M;

	while(true)
	{
		string ID = GetIdentifier();

		if(ID == "}")
		{
			break;
		}
		else if(ID == "return")
		{
			if(M.Type == ReturnType.Int)
			{
				Methods[M.Name].Text ~= "mov eax, " ~ GetIdentifier() ~ "\n\tret";
				if(!Confirm(';'))
				{
					writeln("ERROR: Line ", SS.Line(), ", missing ';' for return statement");
					Loop();
				}
				SS.ReadChar();
				break;
			}
		}
		else
		{
			AddMethodCall(M.Name, ID);
		}
	}
}

string GetExpression()
{
	SS.SkipBlanks();
	if(SS.Peek() == '"')
	{
		SS.ReadChar();
		SS.SkipBlanks();

		string ToReturn = SS.ReadToAny(cast(char[])"\n\"\r;)");

		if(SS.Peek() == '"')
		{
			SS.ReadChar();
			return ToReturn;
		}
		else
		{
			writeln("ERROR: Line ", SS.Line(), ", invalid string literal: '", ToReturn, "' Expecting '\"', Recieved: '", SS.Peek(), "'");
			Loop();
			return "";
		}
	}
	else if(SS.Peek() > (cast(ubyte)'0') - 1 && SS.Peek() < (cast(ubyte)'9') + 1)
	{
		return to!string(SS.ReadInt());
	}
	else
	{
		writeln("ERROR: Line ", SS.Line(), ", Invalid Expression");
		Loop();
		return "";
	}
}

string[] GetMultipleExpressions()
{
	string[] ToReturn;

	while(true)
	{
		ToReturn ~= GetExpression();
		SS.SkipBlanks();

		if(SS.Peek == ',')
		{
			SS.ReadChar();
		}
		else
		{
			return ToReturn;
		}
	}
}

void AddMethodCall(string methodToAddTo, string methodToAdd)
{
	// TODO: Make sure the method to add is valid
	if(!Confirm('('))
	{
		writeln("ERROR: Line ", SS.Line(), ", missing '(' for method usage");
		Loop();
	}
	SS.ReadChar();

	string[] Params = GetMultipleExpressions();
	Methods[methodToAddTo].Text ~= 
		"push ebp\n\t"
		"mov ebp, esp\n\n\t"
		"jmp .L" ~ to!string(Methods[methodToAddTo].LabelCount + Params.length) ~ "\n";

	for(int i = 0 ; i < Params.length; i++)
	{
		Methods[methodToAddTo].Text ~= ".L" ~ to!string(Methods[methodToAddTo].LabelCount++) ~ ": db `" ~ Params[i] ~ "`, 0\n";
	}
	Methods[methodToAddTo].Text ~= ".L" ~ to!string(Methods[methodToAddTo].LabelCount++) ~ ":\n\n";

	for(int i = 0 ; i < Params.length; i++)
	{
		Methods[methodToAddTo].Text ~= "push dword .L" ~ to!string((Methods[methodToAddTo].LabelCount - 2) - i) ~ "\n";
	}
	Methods[methodToAddTo].Text ~= "call _" ~ methodToAdd ~ "\n\tadd esp, " ~ to!string(4 * Params.length) ~ "\n\n\tleave\n";

	SS.SkipBlanks();
	if(!Confirm(')'))
	{
		writeln("ERROR: Line ", SS.Line(), ", missing ')' for method usage");
		Loop();
	}
	SS.ReadChar();

	if(!Confirm(';'))
	{
		writeln("ERROR: Line ", SS.Line(), ", missing ';' for method usage");
		Loop();
	}
	SS.ReadChar();
}