package common.rendering;

import common.struct.FloatPoint3;

class IsometricObject
{
	public function new() {}

	public var ob:h2d.Object;
	public var idx:Int;

	public var pos:FloatPoint3;

	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;

	public var xx:Float;
	public var yy:Float;
	public var zz:Float;

	public var xmin(get, never):Float;
	public var xmax(get, never):Float;
	public var ymin(get, never):Float;
	public var ymax(get, never):Float;
	public var zmin(get, never):Float;
	public var zmax(get, never):Float;

	inline function get_xmin():Float
	{
		return pos.x;
	}

	inline function get_xmax():Float
	{
		return pos.x + xx;
	}

	inline function get_ymin():Float
	{
		return pos.y;
	}

	inline function get_ymax():Float
	{
		return pos.y + yy;
	}

	inline function get_zmin():Float
	{
		return pos.z;
	}

	inline function get_zmax():Float
	{
		return pos.z + zz;
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
}
