module main;

import std.stdio;
import std.socket;

void main(string[] args)
{
	if(args.length > 1 && args[1] == "server")
	{
		Server();
	}
	else
	{
		Client();
	}
}

struct ConnectingPacket
{
	align(1)
	char[24] Name;
}

void Server()
{
	Socket Bleh;
}

void Client()
{
}