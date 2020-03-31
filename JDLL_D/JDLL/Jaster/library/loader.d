module Jaster.library.loader;

private import Jaster.library.types;
private import std.string : toStringz;

// HACK: Remember to make any function alias, extern(C) _gshared nothrow
// Example: extern(C) _gshared nothrow int function(int) MultiplyIntByTwo;

public SharedLibrary LoadLibrary(string filePath)
{
	return SharedLibrary(LoadLibraryA(filePath.toStringz()));
}

public struct SharedLibrary
{
	private HMODULE LibraryHandle;
	private bool 	Unloaded = false;

	this(HMODULE handle)
	{
		this.LibraryHandle = handle;
	}

	~this()
	{
		this.Unload();
	}

	public void* LoadSymbol(string symbol)
	{
		void* Symbol = GetProcAddress(this.LibraryHandle, symbol.toStringz());

		if(Symbol is null)
		{
			throw new Exception("Symbol '" ~ symbol ~ "' not found!");
		}

		return Symbol;
	}

	public void Unload()
	{
		if(!this.Unloaded)
		{
			this.Unloaded = true;
			FreeLibrary(this.LibraryHandle);
		}
	}

	public void BindFunction(void** pointer, string functionName)
	{
		void* Function = this.LoadSymbol(functionName);
		*pointer = Function;
	}

	public string ConvertCharPointer(const(char*) pointer)
	{
		string ToReturn = "";

		for(int i = 0; i < int.max; i++)
		{
			if(pointer[i] == '\0')
			{
				break;
			}
			else
			{
				ToReturn ~= pointer[i];
			}
		}

		return ToReturn;
	}
}