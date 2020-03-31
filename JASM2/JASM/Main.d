module Main;

import std.string;

import Compiler;
import Interpreter;

string Input = "";
string Output = "";

// Flags
// -c [Input File]
// -o [Output File]
void main(string[] args)
{
	if(args.length == 1)
	{
		NoArgsStart();
		return;
	}
	else if(args[1].toLower() == "compile")
	{
		for(int i = 0; i < args.length; i++)
		{
			if(args[i] == "-c")
			{
				Input = args[++i];
			}
			else if(args[i] == "-o")
			{
				Output = args[++i];
			}
		}

		Compiler Comp = new Compiler(Input, Output);
		Comp.Compile();
	}
	else if(args[1].toLower() == "run")
	{
		Interpreter Runner = new Interpreter(args[2]);
		Runner.Run();
	}
}

void NoArgsStart()
{

}