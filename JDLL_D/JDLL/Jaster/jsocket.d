/**
 * Author: <i>SealabJaster, Jaster Workshop</i>
 * License: <i>See "Jaster_Software_License.txt"</i>
 * */
module Jaster.jsocket;

private import std.stdio;
private import std.socket;

private import Jaster.IO.BitConverter;

/// Worthless
public class JSocket
{
	/// Inner socket used by JSocket
	Socket InnerSocket;

	/// Address given to the JSocket
	string Address;

	/// Port used by the JSocket
	ushort Port;

	/// Creates the JSocket and calls JSocket.SetUp()
	this()
	{
		this.SetUp();
	}

	this(Socket socket)
	{
		this.InnerSocket = socket;
	}

	~this()
	{
		this.Shutdown();
		this.Close();
		this.InnerSocket = null;
	}

	public bool isAlive()
	{
		return this.InnerSocket.isAlive();
	}

	/// Sets up the inner socket used by JSocket
	public void SetUp()
	{
		InnerSocket = new TcpSocket();
		InnerSocket.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
	}

	/// Connectes to the given address
	public void Connect(string address, ushort port)
	{
		this.InnerSocket.connect(new InternetAddress(address, port));
		this.Address = address;
		this.Port = port;
	}

	/// Listens on the given port, maximum pending requests is marked by backLog
	public void Listen(int backLog)
	{
		this.InnerSocket.listen(backLog);
	}

	/// Same as Socket.Recieve
	public int Recieve(ubyte[] buffer)
	{
		return this.InnerSocket.receive(buffer);
	}

	/// Same as Socket.send
	public int Send(ubyte[] buffer)
	{
		return this.InnerSocket.send(buffer);
	}

	/// Accepts a pending connect request
	public JSocket Accept()
	{
		return new JSocket(this.InnerSocket.accept());
	}

	/// Binds the InnerSocket to the given address and port
	public void Bind(string address, ushort port)
	{
		this.InnerSocket.bind(new InternetAddress(address, port));
		this.Address = address;
		this.Port = port;
	}

	/// Shuts down the InnerSocket
	public void Shutdown()
	{
		this.InnerSocket.shutdown(SocketShutdown.BOTH);
	}

	/// Closes the inner socket
	public void Close()
	{
		this.InnerSocket.close();
	}

// READ METHODS START
	/// Reads the next 2 bytes as a short
	public short RecieveShort()
	{
		ubyte[2] Data;
		this.Recieve(Data);

		return BytesToShort(Data);
	}

	/// Reads the next 4 bytes as an integer
	public int RecieveInt()
	{
		ubyte[4] Data;
		this.Recieve(Data);
		
		return BytesToInt(Data);
	}

	/// Reads the next 8 bytes as a long
	public long RecieveLong()
	{
		ubyte[8] Data;
		this.Recieve(Data);

		return BytesToLong(Data);
	}

	/// Reads the next short(X) and reads the next X bytes as a string
	public string RecieveString()
	{
		ubyte[] Data = new ubyte[this.RecieveShort()];
		this.Recieve(Data);

		return BytesToStringNL(Data);
	}
// READ METHODS END

// SEND METHODS START
	/// Sends a short over the current connection
	public void SendShort(short data)
	{
		ubyte[2] Data = ShortToBytes(data);
		this.Send(Data);
	}

	/// Sends an integer over the current connection
	public void SendInt(int data)
	{
		ubyte[4] Data = IntToBytes(data);
		this.Send(Data);
	}

	/// Sends a long over the current connection
	public void SendLong(long data)
	{
		ubyte[8] Data = LongToBytes(data);
		this.Send(Data);
	}

	/// Sends a length-prefixed string over the current connection
	public void SendString(string data)
	{
		ubyte[] Data = StringToBytes(data);
		this.Send(Data);
	}
// SEND METHODS END
}