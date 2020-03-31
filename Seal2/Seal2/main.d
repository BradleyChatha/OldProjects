module main;

import std.stdio;
import parser;

void main(string[] args)
{
	Parser P = new Parser();
	P.StartParse("Test.seal");
}