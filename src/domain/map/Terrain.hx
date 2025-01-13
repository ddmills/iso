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
	public var width:Int = 64;
	public var height:Int = 64;
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
		ob = new TerrainOb(this);
	}

	function screenToWorld(sx:Int, sy:Int, z:Int):FloatPoint
	{
		var camera = Game.instance.camera;
		var camPx = Projection.worldToPx(camera.x, camera.y).toIntPoint();
		var px = (camPx.x + (sx / camera.zoom)).floor();
		var py = (camPx.y + (sy / camera.zoom)).floor() + (z * Terrain.BLOCK_H); // SUBTRACTING HEIGHT FOR Z

		var wx = (px / Terrain.TILE_W_HALF + py / Terrain.BLOCK_H) / 2;
		var wy = (py / Terrain.BLOCK_H - px / Terrain.TILE_W_HALF) / 2;

		return {
			x: wx,
			y: wy,
			z: z,
		};
	}

	public function raycast(sx:Int, sy:Int):RaycastResult
	{
		var d3 = screenToWorld(sx, sy, 3);
		var t3 = getTerrainAt(d3.x.floor(), d3.y.floor(), d3.z.floor());

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

		var d2 = screenToWorld(sx, sy, 2);
		var t2 = getTerrainAt(d2.x.floor(), d2.y.floor(), d2.z.floor());

		if (t2 != EMPTY)
		{
			var above = getTerrainAt(d2.x.floor(), d2.y.floor(), (d2.z + 1).floor());
			if (above != EMPTY)
			{
				return {
					success: true,
					x: d2.x.round(),
					y: d2.y.round(),
					z: d2.z,
					terrain: above,
				};
			}
			return {
				success: true,
				x: d2.x,
				y: d2.y,
				z: d2.z,
				terrain: t2,
			};
		}

		var d1 = screenToWorld(sx, sy, 1);
		var t1 = getTerrainAt(d1.x.floor(), d1.y.floor(), d1.z.floor());

		if (t1 != EMPTY)
		{
			var above = getTerrainAt(d1.x.floor(), d1.y.floor(), (d1.z + 1).floor());
			if (above != EMPTY)
			{
				return {
					success: true,
					x: d1.x.round(),
					y: d1.y.round(),
					z: d1.z,
					terrain: above,
				};
			}

			return {
				success: true,
				x: d1.x,
				y: d1.y,
				z: d1.z,
				terrain: t1,
			};
		}

		var d0 = screenToWorld(sx, sy, 0);
		var t0 = getTerrainAt(d0.x.floor(), d0.y.floor(), d0.z.floor());

		if (t0 != EMPTY)
		{
			var above = getTerrainAt(d0.x.floor(), d0.y.floor(), (d0.z + 1).floor());
			if (above != EMPTY)
			{
				return {
					success: true,
					x: d0.x.round(),
					y: d0.y.round(),
					z: d0.z,
					terrain: above,
				};
			}

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

	public function setTerrainAt(x:Int, y:Int, z:Int, type:TerrainType)
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
		var rocks = new Perlin(seed + 5);
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
				var h = p.get(x, y, 12, 8);

				if (h > .5)
				{
					grids[0].set(x, y, SAND);
				}

				if (h > .55)
				{
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
