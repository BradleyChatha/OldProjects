module Jaster.Maths;

private import std.stdio;

/////////////////////////////////
/// This Module isn't needed, it's just for fun
////////////////////////////////

/// Rounds "number" <b>down</b> to the closest whole number
public float Floor(float number)
{
	// Get the Decimal value of the number
	float Remainder = cast(float)(number % 1f);

	// Return the number with it's decimal value subtracted from it
	return (number - Remainder);

	// Above in one line
	// return (number - (number % 1f));

	// Example
	/*
	 * number = 1.40
	 * Remainder = 0.40
	 * return value = 1.40 - 0.40 = 1
	 * 
	 * */
}

/// Rounds "number" <b>up</b> to the closest whole number
public float Ceiling(float number)
{
	// Get the Decimal value of the number
	float Remainder = cast(float)(number % 1f);

	// If there's no remainder, don't perform anything else
	if(Remainder == 0f)
	{
		return number;
	}

	// Get the Difference between 1.0 and Remainder
	float Difference = (1f - Remainder);

	// Add the Difference to "number" and return it's new value
	return (number + Difference);

	// Above in One line
	// return (number + (1f - (number % 1f)));

	// Example
	/*
	 * number = 1.40
	 * Remainder = 0.40
	 * Difference = 1.0 - 0.40 = 0.60
	 * 
	 * return value = 1.40 + 0.60 = 2
	 * 
	 * */
}

unittest
{
	assert(Floor(1.54) == 1);
	assert(Ceiling(4.21) == 5);
}