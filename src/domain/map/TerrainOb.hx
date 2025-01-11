package domain.map;

import common.struct.IntPoint;
import common.util.Projection;
import data.Data;
import data.resources.TileKey;
import domain.map.Terrain.TerrainType;
import h2d.Bitmap;

typedef WorldPoint =
{
	x:Int,
	y:Int,
	z:Int,
}

class TerrainOb extends h2d.Object
{
	public function new()
	{
		super();
	}

	private function worldToPx(x:Int, y:Int, z:Int):IntPoint
	{
		var px = (x - y) * Terrain.TILE_W_HALF;
		var py = (x + y - z) * Terrain.BLOCK_H;

		return new IntPoint(px.floor(), py.floor());
	}

	public function init(terrain:Terrain)
	{
		removeChildren();

		for (z in 0...terrain.depth)
		{
			for (x in 0...terrain.width)
			{
				for (y in 0...terrain.height)
				{
					var t = terrain.getTerrainAt(x, y, z);

					if (t == EMPTY)
					{
						continue;
					}

					var tk = getTileKey(t);
					var tile = Data.Tiles.get(tk);

					var bm = new Bitmap(tile, this);
					bm.width = Terrain.TILE_W;
					bm.height = Terrain.TILE_H;

					var px = worldToPx(x, y, z);

					bm.x = px.x - Terrain.TILE_W_HALF;
					bm.y = px.y - 9; // Terrain.BLOCK_H_OFFSET;
				}
			}
		}
	}

	private function getTileKey(terrainType:TerrainType):TileKey
	{
		return switch terrainType
		{
			case EMPTY: null;
			case WATER: TK_WATER;
			case GRASS: TK_GRASS;
			case STONE: TK_STONE;
			case DIRT: TK_DIRT;
			case SAND: TK_SAND;
		}
	}
}
