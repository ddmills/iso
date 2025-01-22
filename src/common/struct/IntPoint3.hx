package common.struct;

@:structInit class IntPoint3
{
	public final x:Int;
	public final y:Int;
	public final z:Int;

	public inline function new(x:Int = 0, y:Int = 0, z:Int = 0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function equals(other:IntPoint3)
	{
		return Equals(this, other);
	}

	public static function Equals(point:IntPoint3, other:IntPoint3)
	{
		return other.x == point.x && other.y == point.y && other.z == point.z;
	}

	public function toString()
	{
		return '(${x},${y},${z})';
	}

	public overload extern inline function sub(other:IntPoint3):IntPoint3
	{
		return new IntPoint3(x - other.x, y - other.y, z - other.z);
	}

	public overload extern inline function sub(x:Int, y:Int):IntPoint3
	{
		return new IntPoint3(this.x - x, this.y - y, this.z - z);
	}

	public overload extern inline function add(other:IntPoint3):IntPoint3
	{
		return new IntPoint3(x + other.x, y + other.y, z + other.z);
	}

	public overload extern inline function add(x:Int, y:Int):IntPoint3
	{
		return new IntPoint3(this.x + x, this.y + y, this.z + z);
	}

	public overload extern inline function multiply(v:Int):IntPoint3
	{
		return new IntPoint3(x * v, y * v, z * v);
	}

	public overload extern inline function divide(v:Float):FloatPoint3
	{
		return new FloatPoint3(x / v, y / v, z / v);
	}
}
