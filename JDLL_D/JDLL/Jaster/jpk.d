module Jaster.jpk;

private import std.stdio;
private import Jaster.IO.BinaryFile;
private import std.file : exists, FileException;

/// File modes for using a JPK file
public enum JPKFileMode
{
	/// Opening an existing JPK file for reading
	Open,

	/// Creating a new JPK file(Or truncating an existing one) for writing
	Create
}

/// Structure containing data on files to pack
private struct FileToPack
{
	/// Processor the file uses
	string Processor;

	/// Path to the file
	string FilePath;

	/// Key to write to the JPK file
	string Key;

	long FilePointerLocation;
	long FilePointer;
	long FileSizeLocation;
	uint FileSize;
}

/// Structure containing enough data to sort the files that are packed
public struct PackedFile
{
	string 	Name;
	string 	ProcessorName;
}

/// Class that gives access to creating/reading from JPK files
public class JPKFile
{
	/// Path to the JPK File
	private string 						FilePath;

	/// JPK File mode
	private JPKFileMode 				Mode;

	/// BinaryFile used to write/read from the JPK file
	private BinaryFile 					FileIO;

	/* Used in Create mode */
	/// Processors to use
	private ContentProcessor[string] 	Processors;

	/// Files to pack
	private FileToPack[] 				Files;

	private ubyte[string]				ProcessorID;
	private ubyte 						IDCount = 0;

	private ubyte[]					 	MagicNumber = [ 'J', 'P', 'K' ];

	/* Used in Open mode */
	private string[ubyte]				OpenProcessorID;
	private FileToPack[string]			OpenFiles;

	/// Default constructor
	this()
	{
		this.AddProcessor(new FileProcessor());
	}

	/// Constructor that opens the file "jpkFilePath" in "mode"
	this(string jpkFilePath, JPKFileMode mode)
	{
		this.Open(jpkFilePath, mode);
		this();
	}

	/// Destructor
	~this()
	{
		if(this.FileIO !is null)
		{
			this.FileIO.Close();
		}
	}

	/// Adds a processor to be used
	public void AddProcessor(ContentProcessor processor)
	{
		this.Processors[processor.GetName()] = processor;
	}

	/// Adds a file to be packed by "processor"
	public void AddFile(string filePath, string key, string processor)
	{
		if(!exists(filePath))
		{
			throw new FileException(filePath, "Unable to find file");
		}

		this.Files ~= FileToPack(processor, filePath, key);
	}

	/// Adds a file to be packed, goes through the default processor(Writes the entire file to JPK with no processing)
	public void AddFileNoProcessor(string filePath, string key)
	{
		this.AddFile(filePath, key, "File");
	}

	/// Creates the JPK file and packs the files given
	public void Pack()
	{
		// Write the magic number
		FileIO.WriteBytes(this.MagicNumber);

		// Write the processors
		for(int i = 0; i < this.Processors.values.length; i++)
		{
			// Write the "Declaring Processor" byte
			FileIO.WriteBytes([ 0xF0 ]);

			// Write the processor's name
			FileIO.WriteString(this.Processors.values[i].GetName());

			// Write the processor's ID
			FileIO.WriteBytes([ this.IDCount ]);

			// Record the processor's ID
			this.ProcessorID[this.Processors.values[i].GetName()] = this.IDCount++;
		}

		// Write the files
		bool Processing = false;
		for(int i = 0; i < this.Files.length; i++)
		{
			// If we're writing the Header info
			if(!Processing)
			{
				// Write the "Declaring File" byte
				FileIO.WriteBytes([ 0xF1 ]);

				// Write the File's Key
				FileIO.WriteString(this.Files[i].Key);

				// Write the Processor ID that the file uses
				FileIO.WriteBytes([ this.ProcessorID[this.Files[i].Processor] ]);

				// Reserve space for the File size, and store a pointer to it
				this.Files[i].FileSizeLocation = FileIO.GetPosition();
				FileIO.WriteLong(0);

				// Reserve space for the File Location Pointer, and store a pointer to it
				this.Files[i].FilePointerLocation = FileIO.GetPosition();
				FileIO.WriteLong(0);

				// If we've written the last file header, reset the counter and start writing the processed information
				if(i == (this.Files.length - 1))
				{
					i = -1;
					Processing = true;

					// Write the EOS(End of Sections) byte
					FileIO.WriteBytes([ 0xFF ]);

					continue;
				}
			}
			else
			{
				// Get the current position
				long Temp = FileIO.GetPosition();

				// Open the current file
				BinaryFile BF = new BinaryFile(this.Files[i].FilePath, "r");

				// Set it's pointers up
				FileIO.SetPosition(this.Files[i].FilePointerLocation);
				FileIO.WriteLong(Temp);
				FileIO.SetPosition(this.Files[i].FileSizeLocation);
				FileIO.WriteLong(cast(long)BF.GetFileSize());
				FileIO.SetPosition(Temp);

				// PUsh it through the processor
				this.Processors[this.Files[i].Processor].Pack(FileIO, BF.ReadBytes(cast(uint)BF.GetFileSize()));

				BF.Close();
			}
		}

		FileIO.Rewind();
	}

	/// Runs the data "key" points to through the processor it's associated with, and returns the output
	public T Read(T)(string key)
	{
		FileIO.SetPosition(this.OpenFiles[key].FilePointer);
		return this.Processors[this.OpenFiles[key].Processor].Unpack!T(FileIO, this.OpenFiles[key].FileSize);
	}

	/// Moves the BinaryFile to "key"'s position and then returns a pointer to the BinaryFile for custom processing
	public BinaryFile* ExternRead(string key)
	{
		FileIO.SetPosition(this.OpenFiles[key].FilePointer);
		return &FileIO;
	}

	public PackedFile[] GetFilesPacked()
	{
		PackedFile[] ToReturn;

		for(int i = 0; i < this.OpenFiles.length; i++)
		{
			ToReturn ~= PackedFile(this.OpenFiles[this.OpenFiles.keys[i]].Key, this.OpenFiles[this.OpenFiles.keys[i]].Processor);
		}

		return ToReturn;
	}

	private void ParseFile()
	{
		assert(FileIO.ReadBytes(3)[0..3] == this.MagicNumber, "Magic number not found");

		ubyte SectionCode = 0;

		// While we haven't reached the EOS code
		while(SectionCode != 0xFF)
		{
			SectionCode = FileIO.ReadBytes(1)[0];

			// Declare Processor
			if(SectionCode == 0xF0)
			{
				string Name = FileIO.ReadString();
				this.OpenProcessorID[FileIO.ReadBytes(1)[0]] = Name;
			}
			// Declare File
			else if(SectionCode == 0xF1)
			{
				string Name = FileIO.ReadString();
				ubyte ID = FileIO.ReadBytes(1)[0];
				long Size = FileIO.ReadLong();
				long Position = FileIO.ReadLong();

				this.OpenFiles[Name] = FileToPack(this.OpenProcessorID[ID], null, Name, 0, Position, 0, cast(uint)Size);
			}
		}
	}

	/// Opens the file "jpkFilePath" in "mode"
	public void Open(string jpkFilePath, JPKFileMode mode)
	{
		this.FilePath = jpkFilePath;
		this.Mode = mode;
		
		// Open the file in the apropriate mode
		(mode == JPKFileMode.Open) ? (this.FileIO = new BinaryFile(jpkFilePath, "r", StringPrefixType.Byte)) : (this.FileIO = new BinaryFile(jpkFilePath, "w", StringPrefixType.Byte));

		if(this.Mode == JPKFileMode.Open)
		{
			this.ParseFile();
		}
	}

	/// Closes the JPK file
	public void Close()
	{
		this.FileIO.Close();
		this.FileIO = null;
		this.FilePath = null;
		this.Files = null;
		this.OpenFiles = null;
		this.ProcessorID = null;
		this.IDCount = 0;
		this.OpenProcessorID = null;
	}
}

// TODO: Make a class that handles the ability to read and write to the JPK, BinaryFile gives a bit too much control over the file
public interface ContentProcessor
{
	public abstract void Pack(BinaryFile file, const(void[]) data);
	public abstract T Unpack(T)(BinaryFile file, int fileSize);
	public abstract string GetName();
}

public class FileProcessor : ContentProcessor
{
	override public void Pack(BinaryFile file, const(void[]) data)
	{
		(file).WriteBytes(cast(ubyte[])data);
	}

	override public T Unpack(T)(BinaryFile file, int fileSize)
	{
		return (file).ReadBytes(fileSize);
	}

	override public string GetName()
	{
		return "File";
	}
}