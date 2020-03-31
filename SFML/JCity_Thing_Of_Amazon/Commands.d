module Commands;

enum Command : short
{
	ChangeTile = 0x00,
	Server_OK = 0x01,
	RequestResourceInfo = 0x02,
	Server_NotEnoughResources = 0x03
}