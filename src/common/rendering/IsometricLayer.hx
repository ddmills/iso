package common.rendering;

import common.util.Projection;
import h2d.Object;
import haxe.exceptions.NotImplementedException;

class IsometricLayer extends Object
{
	public var objects:Array<IsometricObject>;

	public function new()
	{
		super();
		objects = new Array();
	}

	public function add(iso:IsometricObject)
	{
		var idx = children.length;
		objects.push(iso);
		addChildAt(iso.ob, idx);

		var px = Projection.worldToPx(iso.pos);
		iso.ob.x = px.x;
		iso.ob.y = px.y;
		iso.idx = idx;
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

	override function removeChild(s:Object)
	{
		throw new NotImplementedException();
	}

	public function sort()
	{
		var pivot = 0;
		while (pivot < children.length)
		{
			var newPivot = false;
			for (i in pivot...children.length)
			{
				var obj = objects[i];
				var parent = true;
				for (j in pivot...children.length)
				{
					if (j == i)
					{
						continue;
					}

					var obj2 = objects[j];
					if (isBehind(obj2, obj))
					{
						parent = false;
						break;
					}
				}

				if (parent)
				{
					objects[i] = objects[pivot];
					objects[pivot] = obj;
					var child = children[i];
					children[i] = children[pivot];
					children[pivot] = child;
					pivot++;
					newPivot = true;
				}
			}
			if (!newPivot)
			{
				pivot++;
			}
		}
	}
}
