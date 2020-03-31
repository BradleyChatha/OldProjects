module parser;

import std.stdio;
import std.string;
import std.file;
import std.c.stdlib;
import std.conv;

import structures;

import Jaster.IO.stringstream;

class FileData
{
	Declaration[] Declarations;
}

class Parser
{
	private FileData 		Data;
	private StringStream 	Stream;

	const string			DeclareKeyword = "declare";
	const string			ExternKeyword = "extern";
	const string			MethodKeyword = "method";
	const string			EntrypointKeyword = "entrypoint";

	uint					ParameterNameCount;

	public void StartParse(string fileToParse)
	{
		Data = new FileData();
		ParameterNameCount = 0;

		this.Stream = new StringStream(readText(fileToParse));

		while(true)
		{
			Stream.SkipBlanks();

			// Declare
			if(Stream.Peek() == 'd')
			{
				Data.Declarations ~= ReadDeclaration();

				for(int i = 0; i < Data.Declarations.length; i++)
				{
					writeln((cast(MethodData)(Data.Declarations[i].Data)).MethodName, " ", 
					        (cast(MethodData)(Data.Declarations[i].Data)).Entrypoint, " ", 
					        (cast(MethodData)(Data.Declarations[i].Data)).Extern, " ", 
					        (cast(MethodData)(Data.Declarations[i].Data)).Parameters);
				}
			}
			else
			{
				Stream.ReadChar();
			}
		}
	}

	private Declaration ReadDeclaration()
	{
		// Used to store the next read in keyword
		string Temp = ReadToSpace();

		// To return
		Declaration NewDec;

		// Data to use if NewDec is a method declaration
		MethodData MData = new MethodData();

		// Make sure it's a declaration
		if(Temp != DeclareKeyword)
		{
			ThrowError(format("ERROR: Expecting '%s', recieved '%s'", DeclareKeyword, Temp));
		}
		Stream.ReadChar();

		// Check to see if it's a method declaration
		Temp = ReadToSpace();
		if(Temp == ExternKeyword || Temp == MethodKeyword || Temp == EntrypointKeyword)
		{
			ParseMethod(Temp, NewDec, MData);
		}

		// Set the Declaration's data accordingly
		switch(NewDec.Type)
		{
			case DecType.METHOD:
				NewDec.Data = MData;
				break;
		}

		return NewDec;
	}

	private void ParseMethod(ref string Temp, ref Declaration dec, ref MethodData data)
	{
		// If it's external
		if(Temp == ExternKeyword)
		{
			// Flag it as such
			data.Extern = true;

			// And make sure it contains "method"
			Stream.ReadChar();
			Temp = ReadToSpace();
			if(Temp != MethodKeyword)
			{
				ThrowError(format("ERROR: Expecting '%s', recieved '%s' for External Method Declaration", MethodKeyword, Temp));
			}
		}
		
		// If it's the entrypoint, flag it
		data.Entrypoint = (Temp == EntrypointKeyword);
		// Set the Declaration type
		dec.Type = DecType.METHOD;

		// Get the Method's name
		Stream.SkipBlanks();
		data.MethodName = ReadMethodName();
		Stream.SkipBlanks();

		// Make sure there's Parenthesies
		if(Stream.Peek() != '(')
		{
			ThrowError(format("ERROR: Invalid Method name '%s'!", data.MethodName));
		}
		Stream.ReadChar();

		// Write the nearly found method
		writeln("Discovered Method: ", data.MethodName);

		// Read in the parameters
		do
		{
			if(Stream.Peek() == ')')
			{
				break;
			}

			if(Stream.Peek() == ',')
			{
				Stream.ReadChar();
			}

			data.Parameters ~= PassType();
		} while(Stream.Peek() == ',');
		Stream.SkipBlanks();

		// Make sure there's an ending Parenthesis
		if(Stream.Peek() != ')')
		{
			ThrowError(format("ERROR: Expecting ')', Recieved '%s'", Stream.Peek()));
		}
		Stream.ReadChar();
		Stream.SkipBlanks();

		// If it's an external method, make sure it ends in a Diva
		if(data.Extern)
		{
			if(Stream.Peek() == ';')
			{
				Stream.ReadChar();
				return;
			}
			else
			{
				ThrowError(format("ERROR: Expecting ';', Recieved '%s'", Stream.Peek()));
			}
		}
		// Otherwise, parse the method and it's instructions
		else
		{
			Stream.SkipBlanks();

			if(Stream.Peek() != ':')
			{
				ThrowError(format("ERROR: Expecting ':', Recieved '%s'", Stream.Peek()));
			}
			Stream.ReadChar();

			Stream.SkipBlanks();
			data.ReturnValue = PassType(false);
			Stream.SkipBlanks();

			writeln(data.ReturnValue);

			if(Stream.Peek() != '{')
			{
				ThrowError(format("ERROR: Expecting '{', Recieved '%s'", Stream.Peek()));
			}
			Stream.ReadChar();
			Stream.SkipBlanks();

			while(Stream.Peek() != '}')
			{
				if(Stream.Peek() == '\0')
				{
					ThrowError("ERROR: Expected '}', Recieved 'EoF'");
				}

				if(Stream.Peek() == 'r')
				{
					if(ReadMethodName() == "return")
					{
						Stream.SkipBlanks();
						if(Stream.Peek() == '(')
						{
							ThrowError("ERROR: Illegal method name 'return'");
						}
						else
						{
							MethodCall Call;
							Call.Name = "return";
							Call.Parameters.length = 1;
							Call.Parameters[0] = PassType();

							Stream.SkipBlanks();
							if(Stream.Peek() != ';')
							{
								ThrowError("ERROR: DIVA IS NOT IN THE BUILDING");
							}
							Stream.ReadChar();
							Stream.SkipBlanks();
						}
					}
				}
				else
				{
					Stream.SkipBlanks();

					MethodCall Call;
					Call.Name = ReadMethodName();

					Stream.SkipBlanks();
					if(Stream.Peek() != '(')
					{
						ThrowError(format("ERROR: Expecting '(', Recieved '%s'", Stream.Peek()));
					}
					Stream.ReadChar();
					Stream.SkipBlanks();

					do
					{						
						if(Stream.Peek() == ',')
						{
							Stream.ReadChar();
						}
						
						Call.Parameters ~= PassType();
					} while(Stream.Peek() == ',');

					if(Stream.Peek() == ')')
					{
						Stream.ReadChar();
						
						Stream.SkipBlanks();
						if(Stream.Peek() != ';')
						{
							ThrowError("ERROR: DIVA IS NOT IN THE BUILDING");
						}					
						Stream.ReadChar();
						Stream.SkipBlanks();
					}
					else
					{
						ThrowError(format("ERROR: Expecting ')', Recieved '%s'", Stream.Peek()));
					}

					data.MethodData ~= Call;
					// TODO: Run the program to make sure this section works.
				}
			}
		}
	}

	private Type PassType(bool Parameter = true)
	{
		Stream.SkipBlanks();
		Type ToReturn;
		ToReturn.Name = NextParameterName();

		// String
		if(Stream.Peek() == '"' || Stream.Peek() == '_')
		{
			if(Stream.Peek(1) == 'C' && Stream.Peek() == '_')
			{
				ToReturn.TypeName = "CString";
				Stream.ReadChar();
				Stream.ReadChar();
			}
			else
			{
				ToReturn.TypeName = "String";
			}

			Stream.ReadChar();
			ToReturn.Type = TypeType.RAW;
			ToReturn.StringData = Stream.ReadTo('"');
			Stream.ReadChar();
		}
		// Integer
		else if(Stream.IsDigit(Stream.Peek(), false))
		{
			ToReturn.Type = TypeType.RAW;
			ToReturn.TypeName = "int";
			ToReturn.IntData = Stream.ReadInt();
		}
		else
		{
			ToReturn.TypeName = ReadToSpace();
			Stream.SkipBlanks();

			if(Parameter)
			{
				ToReturn.Name = ReadParameterName();
			}

			if(ToReturn.TypeName == "String" || ToReturn.TypeName == "..." || ToReturn.TypeName == "int")
			{
				ToReturn.Type = TypeType.RAW;
			}
		}

		return ToReturn;
	}

	private string NextParameterName()
	{
		return "P" ~ to!string(this.ParameterNameCount++);
	}

	private string ReadToSpace()
	{
		return this.Stream.ReadToAny([' ', '\n', '\r']);
	}

	private string ReadParameterName()
	{
		return this.Stream.ReadToAny([ ' ', ',', ')' ]);
	}

	private string ReadMethodName()
	{
		return this.Stream.ReadToAny([ ' ', '(' ]);
	}

	private void ThrowError(string message)
	{
		writeln("On line: ", this.Stream.Line + 1, "| Position: ", Stream.Position, "\n", message);
		exit(0);
	}
}