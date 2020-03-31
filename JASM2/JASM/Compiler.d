module Compiler;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import Jaster.IO.BinaryFile;

import JASM_DataTypes;

class Compiler
{
	string Input, Output;

	this(string inputPath, string outputPath)
	{
		this.Input = inputPath;
		this.Output = outputPath;
	}

	public void Compile()
	{
		JASMClass[] Classes;
		string[] FileData = readText(this.Input).splitLines();

		BinaryFile BF = new BinaryFile(this.Output, "w");
		BF.WriteBytes(cast(ubyte[])(MagicNumber ~ Version));
		BF.WriteLong(0); // Entrypoint pointer, index 4
		BF.WriteInt(0); // Method count

		int MethodCount = 0;
		bool MethodCountPass = true;

		long EntrypointPointer = 0;

		string CurrentClass = "";
		string CurrentMethod = "";

		long MethodStartLength = 0;

		Variable[] Parameters;
		long[string] MethodHeaderPointers;

		for(int i = 0; i < FileData.length; i++)
		{
			try
			{
				// Remove formatting
				while(FileData[i][0] == '\t' || FileData[i][0] == ' ')
				{
					// Remove Tabs
					FileData[i] = FileData[i].chompPrefix("\t");
					
					// Remove Spaces
					FileData[i] = FileData[i].chompPrefix(" ");
					
					// Debug
					//writeln("Check 2: ", InFile[i], " ", i);
				}
			}
			// If we read in an empty line, don't crash
			catch
			{
				continue;
			}

			string s = FileData[i];
			string[] Data = this.Parse(s);

			if(Data.length == 0)
			{
				continue;
			}

			if(MethodCountPass)
			{
				switch(Data[0])
				{
					case ".class":
						CurrentClass = Data[1];
						break;

					case ".entrypoint":
						EntrypointPointer = BF.GetPosition();
						break;

					case ".parameters":
						Parameters.length = 0;
						for(int i2 = 1; i2 < Data.length; i2++)
						{
							Parameters.length += 1;
							if(Data[i2] == "string")
							{
								Parameters[$ - 1] = Variable("Null", VariableType.STRING);
							}
							else if(Data[i2] == "int")
							{
								Parameters[$ - 1] = Variable("Null", VariableType.INTEGER);
							}
							else
							{
								Parameters[$ - 1] = Variable(Data[i2], VariableType.STRUCT);
							}
						}
						break;
				
					case ".method":
						MethodCount++;
				
						// Write the name, prefixed by it's class
						BF.WriteString(CurrentClass ~ ":" ~ Data[1]);
						BF.WriteBytes([ cast(ubyte)Parameters.length ]); // Write Parameter length
				
						for(int i2 = 0; i2 < Parameters.length; i2++)
						{
							BF.WriteBytes([ cast(ubyte)Parameters[i2].Type ]);
					
							if(Parameters[i2].Type == VariableType.STRUCT)
							{
								BF.WriteString(Parameters[i2].Name);
							}
						}
						Parameters.length = 0;
						MethodHeaderPointers[CurrentClass ~ ":" ~ Data[1]] = BF.GetPosition();
						BF.WriteInt(0); // Size
						BF.WriteLong(0); // Pointer
						break;

					default:
						break;
				}
			}
			else
			{
				switch(Data[0])
				{
					case ".class":
						CurrentClass = Data[1];
						break;

					case ".method":
						CurrentMethod = Data[1];
						break;

					case "{":
						MethodStartLength = BF.GetPosition();
						break;

					case "call":
						BF.WriteByte(Opcodes.call);

						for(int i2 = 1; i2 < Data.length; i2++)
						{
							if(Data[i2].indexOf(':') == -1 && i2 == 1)
							{
								Data[i2] = CurrentClass ~ ":" ~ Data[i2];
							}

							BF.WriteString(Data[i2]);
						}
						break;

					case "calls":
						BF.WriteByte(Opcodes.calls);
						BF.WriteString(Data[1]);
						break;

					case "ldstr":
						BF.WriteByte(Opcodes.ldstr);
						BF.WriteString(Data[1]);
						break;

					case "ldparam":
						BF.WriteByte(Opcodes.ldparam);
						BF.WriteByte(to!ubyte(Data[1]));
						break;

					case "exit":
						BF.WriteByte(Opcodes.exit);
						break;
					case "ret":
						BF.WriteByte(Opcodes.ret);
						break;
					case "pop":
						BF.WriteByte(Opcodes.pop);
						break;

					case "}":
						long Temp = BF.GetPosition();
						BF.SetPosition(MethodHeaderPointers[CurrentClass ~ ":" ~ CurrentMethod]);
						BF.WriteInt(cast(int)(Temp - MethodStartLength));
						BF.WriteLong(MethodStartLength);
						BF.SetPosition(Temp);
						break;
					
					default:
						break;
				}
			}

			if(i == FileData.length - 1 && MethodCountPass)
			{
				i = 0;
				MethodCountPass = false;
				long Temp = BF.GetPosition();
				
				BF.SetPosition(4);
				BF.WriteLong(EntrypointPointer);
				BF.WriteInt(MethodCount);
				BF.SetPosition(Temp);
			}
		}

		BF.Close();
		FileData = null;
		Classes = null;
	}

	string[] Parse(string line)
	{
		string[] ToReturn;
		string Buffer = "";
		
		// ToReturn Index
		int Index = 0;
		
		bool InString = false;
		
		for(int i = 0; i < line.length; i++)
		{
			char Character = line[i];
			
			// Sometimes it keeps the speech marks
			if(Buffer.length != 0)
			{
				if(Buffer[Buffer.length - 1] == '"')
				{
					Buffer.length -= 1;
				}
			}
			
			if(!InString)
			{
				if(Character == ' ')
				{
					ToReturn.length += 1;
					ToReturn[Index] = Buffer;
					Index += 1;
					Buffer = "";
					
					continue;
				}
				
				if(Character == '"')
				{
					if(InString)
					{
						ToReturn.length += 1;
						ToReturn[Index] = Buffer;
						Index += 1;
						Buffer = "";
					}
					
					InString = !InString;
					
					continue;
				}
				
				Buffer ~= Character;
			}
			else
			{
				if(Character == '"')
				{
					if(InString)
					{
						ToReturn.length += 1;
						ToReturn[Index] = Buffer;
						Index += 1;
						Buffer = "";
					}
					
					InString = !InString;
					
					continue;
				}
				
				// Escape characters
				if(Character == '\\')
				{
					char Escape = line[++i];
					
					if(Escape == 'n')
					{
						Buffer ~= "\n";
					}
					
					continue;
				}
				
				Buffer ~= Character;
			}
		}
		
		if(Buffer != "")
		{
			ToReturn.length += 1;
			ToReturn[Index] = Buffer;
			Index += 1;
			Buffer = "";
		}

		return ToReturn;
	}
}