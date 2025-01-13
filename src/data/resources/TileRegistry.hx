package data.resources;

import common.struct.DataRegistry;
import h2d.Tile;

class TileRegistry extends DataRegistry<TileKey, Tile>
{
	public function new()
	{
		super();

		var terrain = hxd.Res.tiles.tiles2.toTile().divide(4, 6);

		// register(TK_CURSOR, terrain[0][1]);
		// register(TK_WATER, terrain[0][0]);
		// register(TK_GRASS, terrain[1][0]);
		// register(TK_STONE, terrain[2][0]);
		// register(TK_DIRT, terrain[3][0]);
		// register(TK_SAND, terrain[4][0]);
		register(TK_CURSOR, terrain[0][2]);
		register(TK_WATER, terrain[2][1]);
		register(TK_GRASS, terrain[4][0]);
		register(TK_STONE, terrain[2][0]);
		register(TK_DIRT, terrain[4][0]);
		register(TK_SAND, terrain[3][0]);
	}
}
