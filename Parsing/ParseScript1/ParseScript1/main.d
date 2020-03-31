module main;

import std.stdio;
import std.file;
import std.conv;
import std.string;

import Jaster.IO.stringstream;
import Jaster.util;

/// Reasons
alias void function() ScriptFunction;

/// Stream used to parse the Script's data
StringStream SS;

/// Function table
ScriptFunction[string] Functions;

/// Legal function names
string[] StringFunctions = [ "Print", "EndScript", "Input" ];

/// Variables
Variable[string] Variables;

/// Used to skip certain checks in the execution loop
string NaN = "INTERNAL:!No_Function";

void main(string[] args)
{
	// Setup the function table
	Functions["Print"] = &Print;
	Functions["Input"] = &Input;

	while(true)
	{
		// Clear out the variables
		for(int i = 0; i < Variables.length; i++)
		{
			Variables.remove(Variables.keys[i]);
		}

		// Get user input, execute the given script, then reset
		write("Enter Script to run: ");
		SS = new StringStream(readText(readln().chomp()));
		Execute();
		SS.Close();
		writeln("");
	}
}

/// The type of the expression parsed in
enum Type
{
	/// The expression is a string
	String,

	/// The expression is a number
	Number,

	/// The expression is a variable
	Variable
}

/// Used to handle the parsed data of an Expression
struct ExpressionValue
{
	/// The type of expression
	Type    ValueType;

	/// The Expression's string value(if is has one)
	string	StringValue;

	/// The Expression's Number value(if it has one)
	real	NumberValue;

	/// The Expression's Variable value(if it has one)
	Variable* VariableValue;
}

/// Used to store data on a variable
struct Variable
{
	/// Name of the variable
	string Name;

	/// String value of the variable
	string StringValue;

	/// Number value of the variable
	real   NumberValue;
}

/// Parses through the name of a function, making sure it's also legal
string GetCommand()
{
	/// Get the name
	SS.SkipBlanks();
	string Command = SS.ReadToAny([ '(', ' ', '=' ]);
	SS.SkipBlanks();

	/// Check to see if it's an assignment, or a function
	if(SS.Peek == '=')
	{
		/// If it's an assignment, Parse it and register it, returning NaN so the execution loop doesn't crash
		SS.ReadChar();
		AddVariable(Command);
		return NaN;
	}

	/// Make sure '(' starts off the function
	if(SS.Peek() != '(')
	{
		GenerateException("Missing ')', recieved '" ~ SS.Peek() ~ "'");
	}
	SS.ReadChar();

	/// Make sure the function is legal
	if(ArrayContains!string(StringFunctions, Command))
	{
		return Command;
	}
	else
	{
		GenerateException("Invalid Command: '" ~ Command ~ "'");
		return null;
	}
}

/// Parses and returns a Escape-character enabled string
string GetStringExpression()
{
	/// Skip the unwanted characters(The unpopulars, *gasp*)
	SS.SkipBlanks();

	/// Check to make sure it's a string literal
	if(SS.Peek() == '"')
	{
		/// Read in the inner string(Inbetween the Bumchums - '"')
		SS.ReadChar();
		string ToReturn = SS.ReadTo('"', true);
		SS.ReadChar();

		/// And return it
		return ToReturn;
	}
	else
	{
		/// Otherwise crash
		GenerateException("Expecting '\"'. Recieved '" ~ SS.Peek() ~ "'");
		return null;
	}
}

/// Parses and returns a decimal/integer number
real GetNumberExpression()
{
	/// NO UNWANTEDS ALLOWED
	SS.SkipBlanks();

	/// Make sure the first character is a digit
	if(SS.IsDigit(SS.Peek(), true))
	{
		/// If it is, return it
		return SS.ReadReal();
	}
	else
	{
		/// Otherwise, throw an exception...(We really shouldn't throw exceptions)
		GenerateException("Expecting a digit number(0-9, '.'). Recieved '" ~ SS.Peek() ~ "'");
		return real.nan;
	}
}

/// Parses and returns a pointer to a variable
Variable* GetVariableExpression()
{
	/// SHOO
	SS.SkipBlanks();

	/// Get the name of the Variable
	string Meh = SS.ReadToAny([ ';', '\n', cast(char)0x0D, ')', ',' ]);

	/// Return a pointer to it(TODO: Maybe add some check to make sure the variable exists?)
	return &Variables[Meh];
}

/// Parses an expression and returns it's data
ExpressionValue GetExpression()
{
	/// Mummyyyyy, It's touching my fileeeee
	SS.SkipBlanks();

	/// If it's a string, assign it's StringValue and return
	if(SS.Peek() == '"')
	{
		return ExpressionValue(Type.String, GetStringExpression());
	}
	/// If it's a nmumber, assign it's NumberVAlue and return
	else if(SS.IsDigit(SS.Peek(), true))
	{
		return ExpressionValue(Type.Number, "", GetNumberExpression());
	}
	/// If it'sa variable, assign it's VariableValue and return
	else
	{
		return ExpressionValue(Type.Variable, "", real.nan, GetVariableExpression());
	}
}

/// Reads multiple expressions that are seperated with a ","(Aka. Parameters)
ExpressionValue[] GetMultpleExpressions()
{
	ExpressionValue[] ToReturn;

	/// Go through it once, just to get the initial parameter
	do
	{
		/// Jump past any comma
		if(SS.Peek == ',')
		{
			SS.ReadChar();
		}

		/// Add the parameter to the array
		ToReturn ~= GetExpression();
		SS.SkipBlanks();
	} while(SS.Peek() == ',');

	return ToReturn;
}

/// Main execution loop(It's amazing how small it can be, - anyone who sees Tahn)
void Execute()
{
	while(true)
	{
		/// Get the function name
		string Command = GetCommand();
		
		/// If it's NaN, continue
		if(Command == NaN)
		{
			continue;
		}

		/// If it's "EndScript", stop running the script
		if(Command == "EndScript")
		{
			return;
		}

		/// Run it's function
		Functions[Command]();
	}
}

/// Make sure the diva and her pimp(')') are there
void CheckDiva()
{
	SS.SkipBlanks();
	if(SS.Peek != ')')
	{
		GenerateException("Missing ')', Recieved '" ~ SS.Peek() ~ "'");
	}
	SS.ReadChar();
	
	if(SS.Peek() != ';')
	{
		GenerateException("WE'RE MISSING DIVA, MAYDAY, MAYDAY, DIVA IS NOT IN THE BUILDING!");
	}
	SS.ReadChar();
}

/* Outdated but I want it here(It doesn't even have "EndScript", which was put in BEFORE the very first run of it)
<Line> ::= <Command> "(" [ <Expression> ] ");"
<Expression> ::= <StringExpression>
<StringExpression> ::= '"' [ <Character> ] '"' 
<Command> ::= "Print"
*/

/// Print function
void Print()
{
	/// Get it's parameters
	ExpressionValue[] Data = GetMultpleExpressions();

	/// Then print them out
	for(int i = 0; i < Data.length; i++)
	{
		ExpressionValue ExpData = Data[i];

		switch(ExpData.ValueType)
		{
			/// If it's a string, write it's StringValue
			case Type.String:
				write(ExpData.StringValue);
				break;
			
			/// If it's a number, write it's NumberValue
			case Type.Number:
				write(ExpData.NumberValue);
				break;

			/// If it's a variable, write out it's StringValue
			default:
				Variable* Bleh = ExpData.VariableValue;
				write((Bleh).StringValue);
				break;
		}
	}

	/// Make sure Diva is getting attention
	CheckDiva();
}

/// Variable description stuff here please I need words to put here now ok diva;;;;; pimp)
void AddVariable(string name)
{
	/// Make the Variable struct, and set the name
	SS.SkipBlanks();
	Variable NewVar;
	NewVar.Name = name;

	// String
	if(SS.Peek() == '"')
	{
		/// Parse it's string expression and set it's StringValue to it
		NewVar.StringValue = GetStringExpression();
	}
	// Number
	else if(SS.IsDigit(SS.Peek, true))
	{
		/// Parse it's number expression and set it's Numbervalue to it, as well as converting it into a string for printing reasons
		NewVar.NumberValue = GetNumberExpression();
		NewVar.StringValue = to!string(NewVar.NumberValue);
	}
	// Another Variable
	else
	{
		/// Used if it's not a function
		uint Position = SS.GetPosition();

		/// Make an exception because the assignment function is ilegal
		bool Throw = false;

		/// Function name, it's out here because exceptiony throwy messagy reasons
		string Command;

		try // Function
		{
			/// Get the function's name
			Command = GetCommand();

			/// Call the appropriate Assignment function, or flag to make an exception if the name isn't legal
			switch(Command)
			{
				/// Get Console input and store it into "name"
				case "Input": InputAssign(name); break;

				/// Ilegal Assignment function, throw
				default: Throw = true; break;
			}

			/// Jump to the diva checking, because the function called has already registered the variable
			goto _Jump;
		}
		catch // Variable
		{
			/// If an exception(That we didn't ask for) was thrown, then it's a variable
			SS.SetPosition(Position);

			/// Get the pointer to the variable, and set the New variable's data to 
			Variable* Var = GetVariableExpression();
			NewVar.StringValue = (Var).StringValue;
			NewVar.NumberValue = (Var).NumberValue;
		}

		if(Throw)
		{
			GenerateException("Invalid assignment command: '" ~ Command ~ "'");
		}
	}

	/// Register the variable
	Variables[name] = NewVar;

_Jump:
	/// Make sure Diva is there, we can't use CheckDiva because it also checks for Diva's pimp ')'
	if(SS.Peek() != ';')
	{
		GenerateException("Expected ';' when creating variable '" ~ name ~ "'. Recieved '" ~ SS.Peek() ~ "'");
	}
	SS.ReadChar();
}


/////////////////////////////////
/// Assignment methods + Their non-assignment counter parts
/// These are methods that have a version for registering variables, but also need one for general use(Input for setting a variable, as well as pausing the program)
/////////////////////////////////

/// Gets user input and puts it into "Variable"
void InputAssign(string variable, bool assign = true)
{
	/// Check for diva
	CheckDiva();

	/// Set the position back one(Just onto diva, so the AddVariable function doesn't crash
	SS.SetPosition(SS.GetPosition() - 1);

	/// Make the variable, with the user input as it's StringValue
	Variable Var = Variable(variable, readln.chomp(), 0);

	/// If we're actually assigning it(Not called from Input) then register the variable
	if(assign)
	{
		Variables[variable] = Var;
	}
}
/// Simply used to pause the program
void Input() { InputAssign("", false);  SS.SetPosition(SS.GetPosition() - 1); CheckDiva(); }

/// Meooaofsognaosngpasonfpoasnfpoasfpnopaonspfoasndo
void GenerateException(string message)
{
	throw new Exception("\n\nPosition = " ~ to!string(SS.GetPosition()) ~ "\nLine = " ~ to!string(SS.GetLine()) ~ "\n" ~ message ~ "\n");
}