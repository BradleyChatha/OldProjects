module Jaster.library.types;

version(Windows)
{
	/// Generic Handle
	alias void* HANDLE;

	/// Library Handle
	alias HANDLE HMODULE;

	/// Symbol Handle
	alias int function() FARPROC;

	/// C-Style(Null terminated) string
	alias const(char*) LPCSTR;

	extern(Windows)
	{
		/// Loads the given Library, and creates a Handle
		HMODULE LoadLibraryA(LPCSTR);

		/// Releases the given Handle
		void FreeLibrary(HMODULE);

		/// Attempts to find the given symbol in the given handle, and tries to create a handle for it
		FARPROC GetProcAddress(HMODULE, LPCSTR);
	}
}
else
{
	static assert(false, "Currently, only Windows is supported");
}