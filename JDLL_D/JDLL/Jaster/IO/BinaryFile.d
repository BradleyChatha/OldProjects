/**
 * Author: <i>SealabJaster, Jaster Workshop</i>
 * License: <i>See "Jaster_Software_License.txt"</i>
 * */
module Jaster.IO.BinaryFile;

private import std.stdio;
private import std.file;

private import Jaster.IO.BitConverter;

/// Enum containing values, which tells the BinaryFile class how many bytes to read in for Length-Prefixed strings
public enum StringPrefixType
{
	Byte,
	Short,
	Int
}

/**
 * Provides an interface to interact with Binary file
 * */
public class BinaryFile
{
	/// File stream used to access the file
	private File Stream;

	/// The number of bytes to use in a length-prefixed string
	public StringPrefixType Type;

	/// The stream's current position in the file
	private long Position = 0;

	/// Constructor
	this(string filePath, string openMode, StringPrefixType lengthSize = StringPrefixType.Short)
	{
		this.Open(filePath, openMode, lengthSize);
	}

	public void Open(string filePath, string openMode, StringPrefixType lengthSize = StringPrefixType.Short)
	{
		this.Stream = File(filePath, openMode);
		this.Type = lengthSize;
	}

	/// Closes the Stream
	public void Close()
	{
		this.Stream.close();
	}

	/// Returns if the file is at the end
	public bool EOF()
	{
		return (this.GetPosition() >= this.GetFileSize());
	}

	/// Returns the size of the file
	public ulong GetFileSize()
	{
		long Temp = this.GetPosition();
		ulong Answer;

		// Goto the end of the file, store the stream's position and then go back to our old position
		this.Stream.seek(0, SEEK_END);
		Answer = this.Stream.tell();
		this.Stream.seek(Temp, SEEK_SET);

		// Return the File Size
		return Answer;
	}

	/// Rewinds the Stream
	public void Rewind()
	{
		this.Stream.rewind();
		this.Position = 0;
	}

	/// Sets the Files position to "position"
	public void SetPosition(long position)
	{
		this.Stream.seek(position);
		this.Position = position;
	}

	public long GetPosition()
	{
		return this.Position;
	}

	public void WriteByte(ubyte data)
	{
		this.WriteBytes([ data ]);
	}

	/// Writes a Ubyte array to the file
	public void WriteBytes(ubyte[] data)
	{
		this.Position += data.length;
		this.Stream.rawWrite(data);
	}

	/// Writes a short to the file
	public void WriteShort(short toWrite)
	{
		this.WriteBytes(ShortToBytes(toWrite));
	}

	/// Writes an int to the file
	public void WriteInt(int toWrite)
	{
		this.WriteBytes(IntToBytes(toWrite));
	}

	/// Writes a long to the file
	public void WriteLong(long toWrite)
	{
		this.WriteBytes(LongToBytes(toWrite));
	}

	/// Writes a length-prefixed string to the file
	public void WriteString(string toWrite)
	{
		switch(this.Type)
		{
			case StringPrefixType.Byte:
				ubyte[1] Buffer = [ cast(ubyte)toWrite.length ];
				this.Position += 1;
				this.Stream.rawWrite(Buffer);
				break;

			case StringPrefixType.Int:
				this.WriteInt(toWrite.length);
				break;

			case StringPrefixType.Short:
				this.WriteShort(cast(short)toWrite.length);
				break;

			default:
				throw new Exception("Invalid StringPrefixType");
		}

		this.Position += toWrite.length;
		this.Stream.rawWrite(toWrite);
	}

	// Reads X bytes from the file and returns it as a Ubyte array
	public ubyte[] ReadBytes(uint Count)
	{
		ubyte[] ToReturn;
		ToReturn.length = Count;

		this.Position += Count;
		this.Stream.rawRead(ToReturn);

		return ToReturn;
	}

	/// Reads a short from the file
	public short ReadShort()
	{
		ubyte[2] ToReturn;

		this.Position += 2;
		this.Stream.rawRead(ToReturn);

		return (BytesToShort(ToReturn));
	}

	/// Reads an int from the file
	public int ReadInt()
	{
		ubyte[4] ToReturn;

		this.Position += 4;
		this.Stream.rawRead(ToReturn);

		return (BytesToInt(ToReturn));
	}

	/// Reads a long from the file
	public long ReadLong()
	{
		ubyte[8] ToReturn;

		this.Position += 8;
		this.Stream.rawRead(ToReturn);

		return (BytesToLong(ToReturn));
	}

	/// Reads a length-prefixed String from the file
	public string ReadString()
	{
		char[] ToCast;

		switch(this.Type)
		{
			case StringPrefixType.Byte:
				ToCast.length = this.ReadBytes(1)[0];
				break;
				
			case StringPrefixType.Int:
				ToCast.length = this.ReadInt();
				break;
				
			case StringPrefixType.Short:
				ToCast.length = this.ReadShort();
				break;
				
			default:
				throw new Exception("Invalid StringPrefixType");
		}

		this.Position += ToCast.length;
		this.Stream.rawRead(ToCast);

		string ToReturn = cast(string)ToCast;

		return (ToReturn);
	}
}
