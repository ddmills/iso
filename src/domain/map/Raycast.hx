package domain.map;

import common.struct.FloatPoint3;
import common.util.Projection;
import core.Game;
import domain.map.Terrain.TerrainType;

typedef RaycastResult =
{
	success:Bool,
	x:Float,
	y:Float,
	z:Float,
	terrain:TerrainType,
}

class Raycast
{
	private var terrain:Terrain;

	public function new(terrain:Terrain)
	{
		this.terrain = terrain;
	}

	function screenToWorld(sx:Int, sy:Int, z:Int):FloatPoint3
	{
		var camera = Game.instance.camera;
		var camPx = Projection.worldToPx(camera.x, camera.y).toIntPoint();
		var px = (camPx.x + (sx / camera.zoom)).floor();
		var py = (camPx.y + (sy / camera.zoom)).floor() + (z * Terrain.BLOCK_H);

		var wx = (px / Terrain.TILE_W_HALF + py / Terrain.BLOCK_H) / 2;
		var wy = (py / Terrain.BLOCK_H - px / Terrain.TILE_W_HALF) / 2;

		return {
			x: wx,
			y: wy,
			z: z,
		};
	}

	public function Get(sx:Int, sy:Int):RaycastResult
	{
		var d3 = screenToWorld(sx, sy, 3);
		var t3 = terrain.get(d3.x.floor(), d3.y.floor(), d3.z.floor());

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
		var t2 = terrain.get(d2.x.floor(), d2.y.floor(), d2.z.floor());

		if (t2 != EMPTY)
		{
			var above = terrain.get(d2.x.floor(), d2.y.floor(), (d2.z + 1).floor());
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
		var t1 = terrain.get(d1.x.floor(), d1.y.floor(), d1.z.floor());

		if (t1 != EMPTY)
		{
			var above = terrain.get(d1.x.floor(), d1.y.floor(), (d1.z + 1).floor());
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
		var t0 = terrain.get(d0.x.floor(), d0.y.floor(), d0.z.floor());

		if (t0 != EMPTY)
		{
			var above = terrain.get(d0.x.floor(), d0.y.floor(), (d0.z + 1).floor());
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
}
