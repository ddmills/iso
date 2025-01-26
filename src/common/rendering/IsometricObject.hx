package common.rendering;

import common.struct.FloatPoint3;

class IsometricObject
{
	public var ob(default, null):h2d.Object;
	public var idx:Int;

	public var pos(get, set):FloatPoint3;
	public var size(get, set):FloatPoint3;

	public var x(default, default):Float;
	public var y(default, default):Float;
	public var z(default, default):Float;

	public var xx(default, default):Float;
	public var yy(default, default):Float;
	public var zz(default, default):Float;

	public function new(ob:h2d.Object)
	{
		this.ob = ob;
	}

	inline function get_pos():FloatPoint3
	{
		return new FloatPoint3(x, y, z);
	}

	inline function set_pos(v:FloatPoint3)
	{
		x = v.x;
		y = v.y;
		z = v.z;

		return v;
	}

	inline function set_size(v:FloatPoint3):FloatPoint3
	{
		xx = v.x;
		yy = v.y;
		zz = v.z;

		return v;
	}

	inline function get_size():FloatPoint3
	{
		return new FloatPoint3(xx, yy, zz);
	}
}
