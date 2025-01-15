package domain.map;

import common.rand.Perlin;
import common.struct.Grid;

enum TerrainType
{
	EMPTY;
	WATER;
	SAND;
	GRASS;
	STONE;
	DIRT;
}

class Terrain
{
	public var width:Int = 64;
	public var height:Int = 64;
	public var depth:Int = 4;
	public var raycast:Raycast;
	public var ob:TerrainOb;

	public static var TILE_W = 40;
	public static var TILE_W_HALF = 20;
	public static var TILE_H = 40;
	public static var BLOCK_H = 10;
	public static var BLOCK_H_OFFSET = 20;

	public var grids:Array<Grid<TerrainType>>;

	public function new()
	{
		grids = [];
		for (x in 0...depth)
		{
			var g = new Grid<TerrainType>(width, height);
			g.fill(EMPTY);
			grids.push(g);
		}
		ob = new TerrainOb(this);
		raycast = new Raycast(this);
	}

	public function get(x:Int, y:Int, z:Int):TerrainType
	{
		if (isOutOfBounds(x, y, z))
		{
			return EMPTY;
		}

		return grids[z].get(x, y);
	}

	public function set(x:Int, y:Int, z:Int, type:TerrainType)
	{
		if (isOutOfBounds(x, y, z))
		{
			return;
		}

		grids[z].set(x, y, type);
		ob.updateTile(x, y, z);
	}

	public function isOutOfBounds(x:Int, y:Int, z:Int):Bool
	{
		return x < 0 || y < 0 || z < 0 || x >= width || y >= height || z >= depth;
	}

	public function generate(seed:Int)
	{
		var p = new Perlin(seed);

		for (g in grids)
		{
			g.fill(EMPTY);
		}

		grids[0].fill(WATER);

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				var h = p.get(x, y, 12, 8);

				if (h > .5)
				{
					grids[0].set(x, y, SAND);
				}

				if (h > .55)
				{
					grids[0].set(x, y, STONE);
					grids[1].set(x, y, STONE);
				}

				if (h > .6)
				{
					grids[1].set(x, y, STONE);
					grids[2].set(x, y, GRASS);
				}

				if (h > .7)
				{
					grids[1].set(x, y, STONE);
					grids[2].set(x, y, STONE);
					grids[3].set(x, y, GRASS);
				}
			}
		}

		ob.init();
	}
}
