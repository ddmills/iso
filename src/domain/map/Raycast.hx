package domain.map;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import common.util.Projection;
import common.util.ReverseIntIterator;

typedef RaycastResult =
{
	success:Bool,
	pos:FloatPoint3,
	terrain:TerrainType,
}

class Raycast
{
	private var terrain:MapData;

	public function new(terrain:MapData)
	{
		this.terrain = terrain;
	}

	public function Get(screen:FloatPoint):RaycastResult
	{
		for (z in new ReverseIntIterator(3, -1))
		{
			var r = tryRay(screen, z);

			if (r != null)
			{
				return r;
			}
		}

		return {
			success: false,
			pos: FloatPoint3.Zero(),
			terrain: EMPTY,
		};
	}

	private function tryRay(screen:FloatPoint, z:Int):Null<RaycastResult>
	{
		var w = Projection.screenToWorld(screen, z + 1);
		var t = terrain.getTerrain(w.x.floor(), w.y.floor(), z);

		if (t == EMPTY)
		{
			return null;
		}

		if (t == WATER)
		{
			return {
				success: true,
				pos: Projection.screenToWorld(screen, z),
				terrain: t,
			};
		}

		return {
			success: true,
			pos: Projection.screenToWorld(screen, z + 1),
			terrain: t,
		};
	}
}
