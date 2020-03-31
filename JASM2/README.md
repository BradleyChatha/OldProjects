# Overview

JASM is the name I give to every toy assembly language I've tried to create.

This particular version seems to the second ever version of JASM, and the first one I wrote in D.

The documentation inside of /docs/ is incomplete, but interestingly contains "Old Main.d" which is a single monolithic file, assumably
of the first attempt at the codebase for this version of JASM.

It seems that I was only partially through the reimplementation of the project, as the newer code doesn't support most of the opcodes that "Old Main" does.

This JASM was ran on a stack-based VM/interpreter, and the syntax seems inspired by ILASM.

The .exe inside of the bin folder is unsurprisingly of the newer code. Running `Run.bat` causes a RangeError. I don't know if this is an error
with the .exe, or of the .jexe it tries to execute.