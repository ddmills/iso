package data.resources;

import common.struct.DataRegistry;
import h2d.Tile;

class TileRegistry extends DataRegistry<TileKey, Tile>
{
	public function new()
	{
		super();

		var tiles = hxd.Res.tiles.tiles_png.toTile().divide(4, 6);

		register(TK_CUBE, tiles[0][3]);
		register(TK_CURSOR, tiles[0][2]);
		register(TK_WATER, tiles[0][0]);
		register(TK_GRASS, tiles[1][0]);
		register(TK_STONE, tiles[2][0]);
		register(TK_DIRT, tiles[3][0]);
		register(TK_SAND, tiles[4][0]);
		register(TK_TREE_1, tiles[1][1]);
		register(TK_TREE_2, tiles[1][2]);
		register(TK_TREE_PALM_1, tiles[2][1]);
		register(TK_TREE_PALM_2, tiles[2][2]);
		register(TK_TREE_PALM_3, tiles[2][3]);

		var terrain = hxd.Res.tiles.terrain.toTile().divide(8, 4);

		register(TK_GRASS_H1, terrain[0][0]);
		register(TK_GRASS_H2, terrain[0][1]);
		register(TK_GRASS_H3, terrain[0][2]);
		register(TK_GRASS_H4, terrain[0][3]);
		register(TK_STONE_H1, terrain[0][4]);
		register(TK_STONE_H2, terrain[0][5]);
		register(TK_STONE_H3, terrain[0][6]);
		register(TK_STONE_H4, terrain[0][7]);
		register(TK_SAND_H1, terrain[1][0]);
		register(TK_SAND_H2, terrain[1][1]);
		register(TK_SAND_H3, terrain[1][2]);
		register(TK_SAND_H4, terrain[1][3]);
		register(TK_DIRT_H1, terrain[1][4]);
		register(TK_DIRT_H2, terrain[1][5]);
		register(TK_DIRT_H3, terrain[1][6]);
		register(TK_DIRT_H4, terrain[1][7]);
		register(TK_WATER_H1, terrain[2][0]);
		register(TK_WATER_H2, terrain[2][1]);
		register(TK_WATER_H3, terrain[2][2]);
		register(TK_WATER_H4, terrain[2][3]);

		register(TK_SHIP, hxd.Res.tiles.ship.toTile());
		register(TK_SHARK_FINS, hxd.Res.tiles.sharks.toTile());
	}
}
