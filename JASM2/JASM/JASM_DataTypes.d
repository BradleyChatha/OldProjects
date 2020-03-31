module JASM_DataTypes;

private import std.stdio;

const ubyte Version = 1;
const ubyte[3] MagicNumber = [ 'J', 'A', 'S' ];

public struct JASMClass
{
	public string			Name;
	public JASMMethod[] 	Methods;
}

public struct JASMMethod
{
	public string 	Name;
	public int		Size;
	public long		Position;
	public Variable[] Parameters;
	public JASMStack Stack;

	// Empty Method constructor
	this(int parameterCount)
	{
		this.Parameters.length = parameterCount;
	}
}

public enum VariableType : ubyte
{
	STRING = 0x00,
	INTEGER = 0x01,
	STRUCT = 0x02
}

public struct Variable
{
	public string		Name;
	public VariableType Type;

	public string		BuiltInValue;
	public JASMStruct	StructValue;

	public long Pointer;

	// Compiler constructor
	this(string name, VariableType type)
	{
		this.Name = name;
	}

	// Interpreter Constructor 1
	this(long pointer, string previousMethod)
	{
		this.Pointer = pointer;
		this.Name = previousMethod;
	}

	// Interpreter Constructor 2
	this(string name, VariableType type, string value)
	{
		this.Name = name;
		this.Type = type;
		this.BuiltInValue = value;
	}
}

public class JASMStruct
{
	public string		Name;
	public Variable[]	Fields;
}

public enum Opcodes : ubyte
{
	call = 0,
	calls = 1,

	ldparam = 2,
	ldstr = 3,
	pop = 11,

	exit = 4,
	ret = 5,

	add = 6,
	mod = 7,
	div = 8,
	mul = 9,
	sub = 10
}

public class JASMStack
{
	public Variable[] Data;
	public int Index = 0;

	// Life-Hack to store a Method's size, easier to use the Stack setup
	public int Size = 0;

	this(int stackSize)
	{
		this.Data.length = stackSize;
	}

	public void Write(Variable data)
	{
		if(Index == Data.length)
		{
			throw new Exception("\nStack size exceeded! ToWrite: ", data.BuiltInValue);
		}

		Data[Index] = data;
		Index += 1;
	}

	public Variable Read(int index)
	{
		if(Index == 0)
		{
			throw new Exception("\nCannot read beyond the bottom of the stack!");
		}

		return Data[Index - (1 + index)];
	}

	public void Pop()
	{
		if(Index == 0)
		{
			return;
			//throw new Exception("\nNothing to pop!");
		}

		Index -= 1;
		Data[Index] = Variable("Null", VariableType.INTEGER);
	}
}