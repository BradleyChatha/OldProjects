/**
 * Author: <i>SealabJaster, Jaster Workshop</i>
 * License: <i>See "Jaster_Software_License.txt"</i>
 * */
module Jaster.IO.BitConverter;

private import std.stdio;
private import std.string;
private import std.conv;

// I hate everything related to Bitwise operators right now

/// Turns a short into a Ubyte array with 2 values
ubyte[2] ShortToBytes(short data)
{
	return [ (data & 0xFF00) >> 8, data & 0x00FF ];
}

/// Turns an int into a Ubyte array with 4 values
ubyte[4] IntToBytes(int data)
{
	return [ (data & 0xFF000000) >> 24, (data & 0x00FF0000) >> 16, (data & 0x0000FF00) >> 8, data & 0x000000FF ];
}

/// Turns a long into a Ubyte array with 8 values
ubyte[8] LongToBytes(long data)
{
	return [ (data & 0xFF00000000000000) >> 56, (data & 0x00FF000000000000) >> 48, (data & 0x0000FF0000000000) >> 40, (data & 0x000000FF00000000) >> 32, (data & 0x00000000FF000000) >> 24, (data & 0x0000000000FF0000) >> 16, (data & 0x000000000000FF00) >> 8, data & 0x00000000000000FF ];
}

/// Turns the given string into bytes, length-prefixed
ubyte[] StringToBytes(string data)
{
	// Create the array, make it big enough for the string and it's short length-prefix
	ubyte[] ToReturn = new ubyte[data.length + 2];
	
	// Write the length-prefix, as a short
	ToReturn[0..2] = ShortToBytes(cast(short)data.length);
	
	// Write the string
	ToReturn[2..$] = cast(ubyte[])data;
	
	// Return it
	return ToReturn;
}

/// Turns a byte array into a string, expecting a 2 byte length-prefix
string BytesToString(ubyte[] data)
{
	// Read the length
	short Length = BytesToShort(data[0..2]);
	
	// Create the variable to return
	string ToReturn = "";
	
	// Loop through each byte after the length-prefix, adding it to ToReturn
	for(int i = 0; i < Length; i++)
	{
		ToReturn ~= to!char(data[i + 2]);
	}
	
	// Return the string
	return ToReturn;
}

/// Converts the given bytes to a string, the bytes don't contain the STring's length
string BytesToStringNL(ubyte[] data)
{
	// Get the length
	int Length = data.length;
	
	// Create the variable to return
	string ToReturn = "";
	
	// Loop through each byte after the length-prefix, adding it to ToReturn
	for(int i = 0; i < Length; i++)
	{
		ToReturn ~= to!char(data[i]);
	}
	
	// Return the string
	return ToReturn;
}

/// Turns a Ubyte[2] array into a short
short BytesToShort(ubyte[2] data)
{
	return (data[0] << 8 | data[1]);
}

/// Turns a Ubyte[4] array into an int
int BytesToInt(ubyte[4] data)
{
	return (data[0] << 24 | data[1] << 16 | data[2] << 8 | data[3]);
}

/// Turns a Ubyte[8] array into a long
long BytesToLong(ubyte[8] data)
{
	long ToReturn = 0;
	ToReturn = data[0];
	
	// It literally appends bytes
	for(int i = 1; i < 8; i++)
	{
		ToReturn <<= 8;
		ToReturn |= data[i];
	}
	
	return ToReturn;
}

unittest
{
	assert(ShortToBytes(0x7369) == [ 0x73, 0x69 ]);
	assert(IntToBytes(0x12345678) == [ 0x12, 0x34, 0x56, 0x78 ]);
	assert(LongToBytes(0x123456789ABCDEFF) == [ 0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xFF ]);
	assert(StringToBytes("Hi") == [ 0x00, 0x02, 'H', 'i' ]);

	assert(BytesToShort([ 0x73, 0x69 ]) == 0x7369);
	assert(BytesToInt([ 0x12, 0x34, 0x56, 0x78 ]) == 0x12345678);
	assert(BytesToLong([ 0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xFF ]) == 0x123456789ABCDEFF);
	assert(BytesToString([ 0x00, 0x02, 'H', 'i' ]) == "Hi");
	assert(BytesToStringNL([ 'H', 'i' ]) == "Hi");
}