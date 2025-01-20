package common.rendering;

import common.util.Projection;
import domain.map.MapData;
import h2d.Object;

class IsometricLayer extends Object
{
	private var isoObjects:Array<IsometricObject>;

	public function new(map:MapData)
	{
		super();
		isoObjects = new Array();
	}

	public function add(iso:IsometricObject)
	{
		isoObjects.push(iso);
		var idx = children.length;
		iso.idx = idx;

		var px = Projection.worldToPx(iso.pos);
		iso.ob.x = px.x;
		iso.ob.y = px.y;
		addChildAt(iso.ob, idx);
	}

	private function intervalOverlap(a1:Float, a2:Float, b1:Float, b2:Float):Bool
	{
		return a1 >= b1 && a1 < b2 || b1 >= a1 && b1 < a2;
	}

	public function overlap(a:IsometricObject, b:IsometricObject):Bool
	{
		return intervalOverlap(a.x - a.y - a.yy, a.x + a.xx - a.y, b.x - b.y - b.yy, b.x + b.xx - b.y)
			&& intervalOverlap(a.x - a.z - a.zz, a.x + a.xx - a.z, b.x - b.z - b.zz, b.x + b.xx - b.z)
			&& intervalOverlap(-a.y - a.yy + a.z, -a.y + a.z + a.zz, -b.y - b.yy + b.z, -b.y + b.z + b.zz);
	}

	public function isBehind(a:IsometricObject, b:IsometricObject)
	{
		return overlap(a, b) && (a.x + a.xx <= b.x || a.y + a.yy <= b.y || a.z + a.zz <= b.z);
	}

	public function sort()
	{
		var startIdx = 0;
		var maxIdx = isoObjects.length;

		if (startIdx == maxIdx)
		{
			return;
		}

		var idx = startIdx;
		var ymax = isoObjects[idx++];

		while (idx < maxIdx)
		{
			var o1 = isoObjects[idx];
			if (isBehind(o1, ymax))
			{
				var p = idx - 1;

				while (p >= startIdx)
				{
					var o2 = isoObjects[p];

					if (isBehind(o2, o1))
					{
						break;
					}

					isoObjects[p + 1] = o2;
					children[p + 1] = o2.ob;
					p--;
				}

				isoObjects[p + 1] = o1;
				children[p + 1] = o1.ob;

				if (o1.ob.allocated)
				{
					o1.ob.onHierarchyMoved(false);
				}
			}
			else
			{
				ymax = o1;
			}
			idx++;
		}
	}
}
