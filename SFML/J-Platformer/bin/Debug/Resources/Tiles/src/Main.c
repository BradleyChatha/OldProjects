#include "JTile.h"

#define FALSE 0
#define TRUE 1

JTile Tiles[8];
Texture Textures[5];

JTile* GetTiles()
{
    // Normal wall
    Tiles[0] = CreateTile(Type_Wall(), 0, "Wall", FALSE, TRUE, " ", " ", 0, 0, 0, 'W', " ");

    // Spawn Point
    Tiles[1] = CreateTile(Type_Wall(), 1, "Wall", TRUE, FALSE, " ", "PLAYER:SETSPAWN\nPLAYER:RESET", 255, 0, 0, '#', " ");

    // Exit
    Tiles[2] = CreateTile(Type_Wall(), 2, "Wall", FALSE, TRUE, "LEVEL:NEXT", " ", 0, 0, 200, 'E', " ");

    // Spike
    Tiles[3] = CreateTile(Type_Wall(), 3, "Spike", FALSE, TRUE, "PLAYER:RESET", " ", 255, 255, 255, 'R', " ");

    // Key
    Tiles[4] = CreateTile(Type_Colored(), 4, "Key", FALSE, FALSE, "COLOR:DEACTIVATEBYCID:5\nTHIS:DEACTIVATE", " ", 255, 255, 255, 'I', " ");

    // Door
    Tiles[5] = CreateTile(Type_Colored(), 5, "Door", FALSE, TRUE, " ", " ", 255, 255, 255, 'O', " ");

    // Turret
    Tiles[6] = CreateTile(Type_Directional(), 6, "Turret", FALSE, TRUE, " ", "SPAWNER:SETENTITY:0\nSPAWNER:SETTIME:$Timer\nSPAWNER:SETTYPE:Directional", 255, 255, 255, 'T', "Number:Timer");

	// Debug
	Tiles[7] = CreateTile(Type_Wall(), 7, "Wall", TRUE, FALSE, "OUTPUT:$Test\nOUTPUT:$Timer", " ", 128, 128, 128, 'G', "Number:Timer\nNumber:Test");

    return Tiles;
}

Texture* GetTextures()
{
    Textures[0] = MakeTexture("Resources/Wall.png", "Wall", 32, 32);
    Textures[1] = MakeTexture("Resources/Spike.png", "Spike", 32, 32);
    Textures[2] = MakeTexture("Resources/Key.png", "Key", 32, 32);
    Textures[3] = MakeTexture("Resources/Door.png", "Door", 32, 32);
    Textures[4] = MakeTexture("Resources/Sheets/Shooter.png", "Turret", (32 * 4), 32);

    return Textures;
}

int GetTileCount()
{
    return 8;
}

int GetTextureCount()
{
    return 5;
}