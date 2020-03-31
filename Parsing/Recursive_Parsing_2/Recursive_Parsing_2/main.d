module main;

import std.stdio;

import Jaster.IO.stringstream;

import Parser;

void main(string[] args)
{
	StringStream Stream = new StringStream(" (3 + 5) * 4");
	Expression Expr = new Expression(Stream);
	writeln("Test 1: ", Expr.GetValue());

	Stream.Close();

	/*
	 *   try {
09	        std::stringstream ss(" (- 3 +  5 ) * - 4 "); //a simple expresion to test
10	        Expr expr(ss); //construct the parse tree
11	        std::cout<<expr.getValue()<<std::endl;
12	    } catch (std::exception& e) {
13	        std::cerr<<e.what()<<std::endl;
14	    }
15	    try {
16	        std::stringstream ss(" - 3 +  5 * - 4 "); //a simple expresion to test
17	        Expr expr(ss); //construct the parse tree
18	        std::cout<<expr.getValue()<<std::endl;
19	    } catch (std::exception& e) {
20	        std::cerr<<e.what()<<std::endl;
21	    }
22	    try {
23	        std::stringstream ss(" 3 +  5 * 4  "); //a simple expresion to test
24	        Expr expr(ss); //construct the parse tree
25	        std::cout<<expr.getValue()<<std::endl;
26	    } catch (std::exception& e) {
27	        std::cerr<<e.what()<<std::endl;
28	    }
29	    try {
30	        std::stringstream ss(" (- 3 +  5  * - 4 "); //a simple expresion to test with an error
31	        Expr expr(ss); //construct the parse tree
32	        std::cout<<expr.getValue()<<std::endl;
33	    } catch (std::exception& e) {
34	        std::cerr<<e.what()<<std::endl;
35	    }
36	    try {
37	        std::stringstream ss(" (- a +  5  * - 4 "); //a simple expresion to test with an error
38	        Expr expr(ss); //construct the parse tree
39	        std::cout<<expr.getValue()<<std::endl;
40	    } catch (std::exception& e) {
41	        std::cerr<<e.what()<<std::endl;
42	    }
	 * */
}

