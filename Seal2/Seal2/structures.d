module structures;

import Jaster.IO.stringstream;

/+++++++++++++++++++++
 + 
 + Enumerations
 + 
 + +/
enum DecType
{
	METHOD,
	VARIABLE,
	TYPE
}

enum TypeType
{
	CLASS,
	RAW
}

/+++++++++++++++++++++
 + 
 + Structures
 + 
 + +/

/// Structure contaning the data for a Declaration ("declare")
struct Declaration
{
	DecType		Type;
	DecData 	Data;
}

/// Structure containing the data for a Type
struct Type
{
	TypeType 	Type;
	string		TypeName;
	string		Name;
	string		PushData;
	string		StringData; // For TypeType.RAW, TypeName "String" only
	int			IntData; // RAW, "int"
}

struct MethodCall
{
	string	Name;
	Type[]	Parameters;
}

/+++++++++++++++++++++
 + 
 + Classes
 + 
 + +/
class DecData
{
	
}

/// Class that holds the Data for methods ("declare [extern] method/entrypoint $name($parameters)")
class MethodData : DecData
{
	/// Name of the method
	public string 	MethodName;

	/// Is the method from an external source?
	public bool 	Extern;

	/// Is the method the program's entrypoint?
	public bool 	Entrypoint;

	public Type		ReturnValue;

	/// The method's parameters
	public Type[]	Parameters;

	public string[] AsmData;

	public MethodCall[] MethodData;
}