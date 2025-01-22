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
		var idx = children.length;
		isoObjects.push(iso);
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

	// override function removeChild(s:Object)
	// {
	// 	for (i in 0...isoObjects.length)
	// 	{
	// 		if (children[i] == s)
	// 		{
	// 			children.splice(i, 1);
	// 			if (s.allocated)
	// 				s.onRemove();
	// 			s.parent = null;
	// 			s.posChanged = true;
	// 			if (s.parentContainer != null)
	// 				s.setParentContainer(null);
	// 			var k = layerCount - 1;
	// 			while (k >= 0 && layersIndexes[k] > i)
	// 			{
	// 				layersIndexes[k]--;
	// 				k--;
	// 			}
	// 			#if domkit
	// 			if (s.dom != null)
	// 				s.dom.onParentChanged();
	// 			#end
	// 			onContentChanged();
	// 			break;
	// 		}
	// 	}
	// }

	public function sort()
	{
		var pivot = 0;
		while (pivot < children.length)
		{
			var newPivot = false;
			for (i in pivot...children.length)
			{
				var obj = isoObjects[i];
				var parent = true;
				for (j in pivot...children.length)
				{
					if (j == i)
					{
						continue;
					}

					var obj2 = isoObjects[j];
					if (isBehind(obj2, obj))
					{
						parent = false;
						break;
					}
				}

				if (parent)
				{
					isoObjects[i] = isoObjects[pivot];
					isoObjects[pivot] = obj;
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

	// public function sort()
	// {
	// 	var startIdx = 0;
	// 	var maxIdx = isoObjects.length;
	// 	if (startIdx == maxIdx)
	// 	{
	// 		return;
	// 	}
	// 	var idx = startIdx;
	// 	var ymax = isoObjects[idx++];
	// 	while (idx < maxIdx)
	// 	{
	// 		var o1 = isoObjects[idx];
	// 		if (isBehind(o1, ymax))
	// 		{
	// 			var p = idx - 1;
	// 			while (p >= startIdx)
	// 			{
	// 				var o2 = isoObjects[p];
	// 				if (isBehind(o2, o1))
	// 				{
	// 					break;
	// 				}
	// 				trace('swap?');
	// 				isoObjects[p + 1] = o2;
	// 				children[p + 1] = o2.ob;
	// 				p--;
	// 			}
	// 			isoObjects[p + 1] = o1;
	// 			children[p + 1] = o1.ob;
	// 			trace('swap');
	// 			if (o1.ob.allocated)
	// 			{
	// 				o1.ob.onHierarchyMoved(false);
	// 			}
	// 		}
	// 		else
	// 		{
	// 			ymax = o1;
	// 		}
	// 		idx++;
	// 	}
	// }
}
