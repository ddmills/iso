package domain.map;

import common.rand.Perlin;
import common.struct.Grid;
import common.struct.IntPoint;
import common.util.Projection;
import core.Game;
import domain.map.TerrainOb.WorldPoint;
import hxd.Rand;

enum TerrainType
{
	EMPTY;
	WATER;
	SAND;
	GRASS;
	STONE;
	DIRT;
}

typedef RaycastResult =
{
	success:Bool,
	x:Float,
	y:Float,
	z:Float,
	terrain:TerrainType,
}

typedef FloatPoint =
{
	x:Float,
	y:Float,
	z:Float,
}

typedef IntPointThree =
{
	x:Int,
	y:Int,
	z:Int,
}

class Terrain
{
	public var width:Int = 100;
	public var height:Int = 100;
	public var depth:Int = 4;
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
		ob = new TerrainOb();
	}

	function screenToWorld(sx:Int, sy:Int, z:Int):IntPointThree
	{
		// first, get the camera world position
		var camera = Game.instance.camera;
		var camPx = Projection.worldToPx(camera.x, camera.y).toIntPoint();
		var px = (camPx.x + (sx / camera.zoom)).floor();
		var py = (camPx.y + (sy / camera.zoom)).floor() + (z * Terrain.BLOCK_H); // SUBTRACTING HEIGHT FOR Z

		var wx = (px / Terrain.TILE_W_HALF + py / Terrain.BLOCK_H) / 2;
		var wy = (py / Terrain.BLOCK_H - px / Terrain.TILE_W_HALF) / 2;

		return {
			x: wx.floor(),
			y: wy.floor(),
			z: z,
		};
	}

	public function raycast(sx:Int, sy:Int):RaycastResult
	{
		var d0 = screenToWorld(sx, sy, 0);
		var d1 = screenToWorld(sx, sy, 1);
		var d2 = screenToWorld(sx, sy, 2);
		var d3 = screenToWorld(sx, sy, 3);

		var t0 = getTerrainAt(d0.x, d0.y, d0.z);
		var t1 = getTerrainAt(d1.x, d1.y, d1.z);
		var t2 = getTerrainAt(d2.x, d2.y, d2.z);
		var t3 = getTerrainAt(d3.x, d3.y, d3.z);

		if (t3 != EMPTY)
		{
			return {
				success: true,
				x: d3.x,
				y: d3.y,
				z: d3.z,
				terrain: t3,
			};
		}

		if (t2 != EMPTY)
		{
			return {
				success: true,
				x: d2.x,
				y: d2.y,
				z: d2.z,
				terrain: t2,
			};
		}

		if (t1 != EMPTY)
		{
			return {
				success: true,
				x: d1.x,
				y: d1.y,
				z: d1.z,
				terrain: t1,
			};
		}

		if (t0 != EMPTY)
		{
			return {
				success: true,
				x: d0.x,
				y: d0.y,
				z: d0.z,
				terrain: t0,
			};
		}

		return {
			success: false,
			x: d0.x,
			y: d0.y,
			z: d0.z,
			terrain: EMPTY,
		};
	}

	public function getTerrainAt(x:Int, y:Int, z:Int):TerrainType
	{
		if (isOutOfBounds(x, y, z))
		{
			return EMPTY;
		}

		return grids[z].get(x, y);
	}

	public function isOutOfBounds(x:Int, y:Int, z:Int):Bool
	{
		return x < 0 || y < 0 || z < 0 || x >= width || y >= height || z >= depth;
	}

	public function generate(seed:Int)
	{
		var p = new Perlin(seed);
		var r = new Rand(seed);

		for (g in grids)
		{
			g.fill(EMPTY);
		}

		grids[0].fill(WATER);

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				var h = p.get(new IntPoint(x, y), 24, 3);

				trace(x, y, h);

				if (h > .475)
				{
					grids[0].set(x, y, SAND);
				}

				if (h > .5)
				{
					grids[1].set(x, y, r.pick([DIRT, STONE]));
				}

				if (h > .54)
				{
					grids[2].set(x, y, r.pick([GRASS, DIRT]));
				}

				if (h > .58)
				{
					grids[3].set(x, y, r.pick([GRASS]));
				}
			}
		}

		ob.init(this);
	}
}
