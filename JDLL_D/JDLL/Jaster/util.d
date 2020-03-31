module Jaster.util;

private import std.string;
private import std.stdio;

//version = DEBUG;

bool StringContains(string input, string toCheckFor)
{
	return (input.indexOf(toCheckFor) != -1);
}

bool StringContains(string input, dchar toCheckFor)
{
	return (input.indexOf(toCheckFor) != -1);
}

bool Contains(T, T2)(T2[] input, T2 toCheckFor)
{
	for(int i = 0; i < input.length; i++)
	{
		if(input[i] == toCheckFor)
		{
			return true;
		}
	}

	return false;
}

public string ReverseString(string input)
{
	string ToReturn;
	
	for(int i = 0; i < input.length; i++)
	{
		ToReturn ~= input[(input.length - 1) - i];
	}
	
	return ToReturn;
}

/// Bubble Sorts "input" using "sorter" to determine the order, sorter returns true when it's first paramter, and it's second paramter need to be swapped in "input", otherwise false.
/// 
/// Example:
/// 
/// bool IntSort(int one, int two)
/// {
/// 	return one > two;
/// }
/// 
/// int[] Test = [ 70, 60, 50 ];
/// assert(BubbleSort!int(Test, &IntSort) == [ 50, 60, 70 ]);
public T[] BubbleSort(T)(T[] input, bool delegate(T, T) sorter)
{
	// Make a copy of input's length, so we can decrease the value without harming the array
	int N = input.length;

	// Used to temporarily store "input[i + 1]" if there needs to be a swap at any point 
	T Var;

	// Loop through the array
	for(int i = 0; i < N; i++)
	{
		// When the sorter has finished it's work, or can't continue with the current value of "N", decrease N's value and reset "i"
		if(i == N || N == 1 || i + 1 == N)
		{
			N--;
			i = -1;
			continue;
		}

		// Debug data
		version(DEBUG)
		{
			version(unittest)
			{
				pragma(msg, "DEBUG");
				writeln("Comparing: ", input[i], " with ", input[i + 1], ". Winner is ", sorter(input[i], input[i + 1]));
			}
		}

		// If the T needs to be moved
		if(sorter(input[i], input[i + 1]))
		{
			// Store "input[i + 1]" into Var
			Var = input[i + 1];

			// Move "input[i]" up an index
			input[i + 1] = input[i];

			// Replace "input[i]" with Var
			input[i] = Var;
		}
	}

	// Probably no need to return this... Meh
	return input;
}

unittest
{
	// Variables used in the unittest
	string[] Test;
	int[] Test2;

	// Testing both version of StringContains
	assert(StringContains("SOAMAZINGMAN", "AMAZING"));
	assert(StringContains("ABC", 'B'));

	// Testing the Template for Contains
	Test = [ "Dan", "Fabulous", "Sensei" ];
	assert(Contains!string(Test, "Fabulous"));

	// Testing "ReverseString"
	assert("abcdefghijklmnopqrstuvwxyz".ReverseString() == "zyxwvutsrqponmlkjihgfedcba");

	// Sorter functions
	bool UnitSort(string one, string two)
	{
		return one > two;
	}

	bool UnitSort2(int one, int two)
	{
		return one > two;
	}

	// Tests the Bubble sorter
	Test = [ "Zebra", "Alien", "Bacon" ];
	Test2 = [ 90, 40, 30, 70, 80, 20, 10, 50, 100, 60 ];
	writeln(BubbleSort!string(Test, &UnitSort));
	assert(BubbleSort!string(Test, &UnitSort) == [ "Alien", "Bacon", "Zebra" ]);
	writeln(BubbleSort!int(Test2, &UnitSort2));
	assert(BubbleSort!int(Test2, &UnitSort2) == [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ]);
}