module Interpreter;

import std.stdio;
import std.string;
import std.conv;

import Jaster.IO.BinaryFile;

import JASM_DataTypes;

class Interpreter
{
	string FilePath;

	JASMMethod[string] Methods;
	string CurrentMethod = "";

	this(string file)
	{
		this.FilePath = file;

		Methods["Jasm:Write"] = JASMMethod(1);
		Methods["Jasm:WriteLine"] = JASMMethod(1);
	}

	public void Run()
	{
		BinaryFile BF = new BinaryFile(this.FilePath, "r");
		if(BF.ReadBytes(3) != MagicNumber)
		{
			writeln("Invalid Magic Number");
			return;
		}
		else if(BF.ReadBytes(1)[0] != Version)
		{
			writeln("Incompatible version");
			return;
		}

		long Entrypoint = BF.ReadLong();
		uint MethodCount = cast(uint)BF.ReadInt();

		for(int i = 0; i < MethodCount; i++)
		{
			JASMMethod Method;
			Method.Name = BF.ReadString();

			ubyte ParamCount = BF.ReadBytes(1)[0];

			for(int i2 = 0; i2 < ParamCount; i2++)
			{
				VariableType Type = cast(VariableType)BF.ReadBytes(1)[0];

				if(Type == VariableType.STRING)
				{
					Method.Parameters ~= Variable("Null", Type);
				}
				else if(Type == VariableType.INTEGER)
				{
					Method.Parameters ~= Variable("Null", Type);
				}
				else
				{
					Method.Parameters ~= Variable(BF.ReadString(), Type);
				}
			}

			Method.Size = BF.ReadInt();
			Method.Position = BF.ReadLong();
			Method.Stack = new JASMStack(short.max);

			Methods[Method.Name] = Method;
		}

		BF.SetPosition(Entrypoint);
		BF.SetPosition(Methods[BF.ReadString()].Position);

		JASMStack CallStack = new JASMStack(ushort.max);

		bool Run = true;

		string Temp = "";

		while(Run)
		{
			ubyte Opcode = BF.ReadBytes(1)[0];

			switch(Opcode)
			{
				case Opcodes.call:
					Temp = CurrentMethod;
					CurrentMethod = BF.ReadString();

					if(!CurrentMethod.startsWith("Jasm:"))
					{
						for(int i = 0; i < Methods[CurrentMethod].Parameters.length; i++)
						{
							if(Methods[CurrentMethod].Parameters[i].Type == VariableType.STRING)
							{
								Methods[CurrentMethod].Parameters[i].BuiltInValue = BF.ReadString();
							}
							else if(Methods[CurrentMethod].Parameters[i].Type == VariableType.INTEGER)
							{
								Methods[CurrentMethod].Parameters[i].BuiltInValue = BF.ReadString();
							}
							else
							{
								// TODO: Create support for structures, and ways of creating them.
								Methods[CurrentMethod].Parameters[i].StructValue = null;
							}
						}

						CallStack.Write(Variable(BF.GetPosition(), Temp));
						BF.SetPosition(Methods[CurrentMethod].Position);
					}
					else
					{
						ExecuteJASMMethod(CurrentMethod);
					}
					break;

				case Opcodes.calls:
					Temp = CurrentMethod;
					CurrentMethod = BF.ReadString();

					if(!CurrentMethod.startsWith("Jasm:"))
					{
						CallStack.Write(Variable(BF.GetPosition(), Temp));

						for(int i = 0; i < Methods[CurrentMethod].Parameters.length; i++)
						{
							if(Methods[CurrentMethod].Parameters[i].Type == VariableType.STRING)
							{
								Methods[CurrentMethod].Parameters[i].BuiltInValue = Methods[CallStack.Read(0).Name].Stack.Read(i).BuiltInValue;
							}
							else if(Methods[CurrentMethod].Parameters[i].Type == VariableType.INTEGER)
							{
								Methods[CurrentMethod].Parameters[i].BuiltInValue = Methods[CallStack.Read(0).Name].Stack.Read(i).BuiltInValue;
							}
							else
							{
								// TODO: Create support for structures, and ways of creating them.
								Methods[CurrentMethod].Parameters[i].StructValue = Methods[CallStack.Read(0).Name].Stack.Read(i).StructValue;
							}
						}

						BF.SetPosition(Methods[CurrentMethod].Position);
					}
					else
					{
						ExecuteJASMMethod(Temp);
					}
					break;

				case Opcodes.exit:
					Run = false;
					break;

				case Opcodes.ldparam:
					Methods[CurrentMethod].Stack.Write(Methods[CurrentMethod].Parameters[cast(int)BF.ReadBytes(1)[0]]);
					break;

				case Opcodes.ldstr:
					Methods[CurrentMethod].Stack.Write(Variable("Null", VariableType.STRING, BF.ReadString()));
					break;

				case Opcodes.ret:
					Variable Called = CallStack.Read(0);
					CallStack.Pop();

					CurrentMethod = Called.Name;
					BF.SetPosition(Called.Pointer);
					break;

				case Opcodes.pop:
					Methods[CurrentMethod].Stack.Pop();
					break;

				default:
					writefln("Inavlid opcode: 0x%X", Opcode);
					return;
			}
		}

		BF.Close();
	}

	void ExecuteJASMMethod(string method)
	{
		if(CurrentMethod == "Jasm:Write")
		{
			write(Methods[method].Parameters[0].BuiltInValue);
		}
		else if(CurrentMethod == "Jasm:WriteLine")
		{
			writeln(Methods[method].Parameters[0].BuiltInValue);
		}
	}
}

