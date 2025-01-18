package data.resources;

import common.struct.DataRegistry;
import h2d.Tile;

class TileRegistry extends DataRegistry<TileKey, Tile>
{
	public function new()
	{
		super();

		var terrain = hxd.Res.tiles.tiles_png.toTile().divide(4, 6);

		register(TK_CUBE, terrain[0][3]);
		register(TK_CURSOR, terrain[0][2]);
		register(TK_WATER, terrain[0][0]);
		register(TK_GRASS, terrain[1][0]);
		register(TK_STONE, terrain[2][0]);
		register(TK_DIRT, terrain[3][0]);
		register(TK_SAND, terrain[4][0]);
		register(TK_TREE_1, terrain[1][1]);
		register(TK_TREE_2, terrain[1][2]);
		register(TK_TREE_PALM_1, terrain[2][1]);
		register(TK_TREE_PALM_2, terrain[2][2]);
		register(TK_TREE_PALM_3, terrain[2][3]);
		register(TK_CY, terrain[4][2]);
	}
}
