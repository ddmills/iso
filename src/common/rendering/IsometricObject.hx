package common.rendering;

import common.struct.FloatPoint3;

class IsometricObject
{
	public var ob(default, null):h2d.Object;
	public var idx:Int;

	public var pos:FloatPoint3;
	public var size:FloatPoint3;

	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;

	public var xx(get, never):Float;
	public var yy(get, never):Float;
	public var zz(get, never):Float;

	public function new(ob:h2d.Object)
	{
		this.ob = ob;
	}

	inline function get_x():Float
	{
		return pos.x;
	}

	inline function get_y():Float
	{
		return pos.y;
	}

	inline function get_z():Float
	{
		return pos.z;
	}

	inline function get_xx():Float
	{
		return size.x;
	}

	inline function get_yy():Float
	{
		return size.y;
	}

	inline function get_zz():Float
	{
		return size.z;
	}
}
