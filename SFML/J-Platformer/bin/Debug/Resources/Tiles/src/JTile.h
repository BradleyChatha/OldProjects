typedef struct
{
    /// General Info
    // What kind of Tile it is
	int         Type;

	// The ID of the tile
	int         ID;

	// The Texture Key that the tile uses
	char*       Texture;

	/// Bools
	// Only draw the tile in Debug mode
	char        DrawInDebugOnly;

	// Does the tile stop the player's movement
	char        IsSolid;

    /// Commands
    // Commands for when the player touches the tile
	char*       OnPlayerTouchCommands;

	// Comamnds for when the Tile is placed onto the map
	char*       OnTileSpawn;

	// Colors
	char        R;
	char        G;
    char        B;

	// What key you have to press in Debug mode to create the tile
	char		SpawnKey;
	
	// What other data this tile needs to store
	char*		ExtraData;
} JTile;

typedef struct
{
    // Path to the Texture
    char*   Path;

    // Key to associate with the Texture
    char*   Key;

    // Width of the Texture
    int     Width;

    // Height of the Texture
    int     Height;
} Texture;

/// NOTE: These are just for reference, you should write the commands yourself, and not use these ones
char* Action_ResetPlayerPosition()
{
    // Resets the player's position to their Spawn point
    return "PLAYER:RESET\n";
}

char* Action_SetPlayerSpawnPoint()
{
    // Sets the player's spawn point
    return "PLAYER:SETSPAWN\n";
}

char* Action_NextLevel()
{
    // Goes to the next level, can't be used as a Tile Spawn command
    return "LEVEL:NEXT\n";
}

char* Action_DeactivateByCID(int tileID)
{
    // Deactivates(Stops drawing and collision checking) any tile with the ID of {Tile ID} that also has the same CID(Color ID, aka any {tileID} Tile that has the same color as the calling tile) - Used by Colored Tiles
    return "COLOR:DEACTIVATEBYCID:{tileID}";
}

char* Action_DeactivateThis()
{
    // Deactivates(Stops drawing and collision checking) the calling tile
    return "THIS:DEACTIVATE";
}

char* Action_SetEntityForSpawner(int entityID)
{
    // Sets the entity that the tile can spawn
    return "SPAWNER:SETENTITY:{entityID}";
}

char* Action_SetSpawnerTimer(int timer)
{
    // Sets the time interval between the spawner spawning things
    return "SPAWNER:SETTIME:{timer}";
}

/// You can use these ones though ^^
int Type_Wall()
{
    // Wall = Normal Tile that doesn't have anything special(Q_Q)
    return 0;
}

int Type_Colored()
{
    // Colored = Tile that can change color(The Color gets stored and retrieved from the level file, as well as change color dynamically) that can do color based interactions with other Colored tiles(Think: Blue Key that unlocks Blue Doors, but not Gold Doors)
    return 1;
}

int Type_Directional()
{
    // Directional = Tile that can use a 4-sprited sprite sheet, it's Direction is stored and retrieved from the level file. The sprite to use from the sheet is dictated by the direction.
	// The sprites have to be in a certain order.
	// 0 = Up, 1 = Left, 2 = Right, 3 = Down
    return 2;
}

// Creates a Texture Structure with the given information
Texture MakeTexture(char* path, char* key, int width, int height)
{
    Texture Tex;
    Tex.Path = path;
    Tex.Key = key;
    Tex.Width = width;
    Tex.Height = height;

    return Tex;
}

// Creates a JTile structure with the given information
JTile CreateTile(int type, int id, char* Texture, char drawDebug, char isSolid, char* onPlayerTouch, char* onTileSpawn, char r, char g, char b, char spawnKey, char* extraData)
{
    JTile Tile;
    Tile.Type = type;
    Tile.ID = id;
    Tile.Texture = Texture;
    Tile.DrawInDebugOnly = drawDebug;
    Tile.OnPlayerTouchCommands = onPlayerTouch;
    Tile.OnTileSpawn = onTileSpawn;
    Tile.IsSolid = isSolid;
    Tile.R = r;
    Tile.G = g;
    Tile.B = b;
	Tile.SpawnKey = spawnKey;
	Tile.ExtraData = extraData;

    return Tile;
}