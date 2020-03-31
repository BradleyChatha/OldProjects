#include "JTile.h"

// Leave these alone
#define FALSE 0
#define TRUE 1

// Update these as you add more Tiles/Textures
#define TEXTURE_COUNT 0
#define TILE_COUNT 0
#define ENTITY_COUNT 0

// Leave
JTile 	Tiles[TILE_COUNT];
Texture Textures[TEXTURE_COUNT];
Entity 	Entities[ENTITY_COUNT];

// Leave
int GetTileCount()
{
    return TILE_COUNT;
}

// Leave
int GetTextureCount()
{
	return TEXTURE_COUNT;
}

int GetEntityCount()
{
	return ENTITY_COUNT;
}

// Use Tiles[x] = CreateTile(params);
// params = TileType, TileID, TextureKey, DrawTileInDebugOnly, IsTileSolid, OnPlayerTouchActions, OnTileSpawnActions, RedTint, GreenTint, BlueTint
// Example = Tiles[0] = CreateTile(Type_Wall(), 0, "Wall", FALSE, TRUE, "LEVEL:NEXT", " ", 0, 0, 200);
JTile* GetTiles()
{

    return Tiles;
}

// Use Textures[x] = MakeTexture(params);
// params = TexturePath, TextureKey, Width, Height
// Example = Textures[0] = MakeTexture("Resources/Wall.png", "Wall", 32, 32);
Texture* GetTextures()
{
    return Textures;
}

Entity* GetEntities()
{
	return Entities;
}