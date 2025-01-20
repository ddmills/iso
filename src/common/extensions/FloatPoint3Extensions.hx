package common.extensions;

import common.algorithm.Distance;
import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import common.util.Easing;

class FloatPoint3Extensions
{
	static public overload extern inline function add(a:FloatPoint3, v:Float):FloatPoint3
	{
		return new FloatPoint3(a.x + v, a.y + v, a.z + v);
	}

	static public overload extern inline function add(a:FloatPoint3, x:Float, y:Float, z:Float):FloatPoint3
	{
		return new FloatPoint3(a.x + x, a.y + y, a.z + z);
	}

	static public overload extern inline function add(a:FloatPoint3, b:FloatPoint3):FloatPoint3
	{
		return new FloatPoint3(a.x + b.x, a.y + b.y, a.z + b.z);
	}

	static public overload extern inline function sub(a:FloatPoint3, v:Float):FloatPoint3
	{
		return new FloatPoint3(a.x - v, a.y - v, a.z - v);
	}

	static public overload extern inline function sub(a:FloatPoint3, x:Float, y:Float, z:Float):FloatPoint3
	{
		return new FloatPoint3(a.x - x, a.y - y, a.z - z);
	}

	static public overload extern inline function sub(a:FloatPoint3, b:FloatPoint3):FloatPoint3
	{
		return new FloatPoint3(a.x - b.x, a.y - b.y, a.z - b.z);
	}

	static public overload extern inline function multiply(a:FloatPoint3, v:Float):FloatPoint3
	{
		return new FloatPoint3(a.x * v, a.y * v, a.z * v);
	}

	static public overload extern inline function multiply(a:FloatPoint3, x:Float, y:Float, z:Float):FloatPoint3
	{
		return new FloatPoint3(a.x * x, a.y * y, a.z * z);
	}

	static public overload extern inline function multiply(a:FloatPoint3, b:FloatPoint3):FloatPoint3
	{
		return new FloatPoint3(a.x * b.x, a.y * b.y, a.z * b.z);
	}

	static public overload extern inline function xy(a:FloatPoint3):FloatPoint
	{
		return new FloatPoint(a.x, a.y);
	}

	static public overload extern inline function floor(a:FloatPoint3):FloatPoint3
	{
		return new FloatPoint3(a.x.floor(), a.y.floor(), a.z.floor());
	}

	/**
	 * Returns FloatPoint3 eased from a to b
	**/
	static public function ease(a:FloatPoint3, b:FloatPoint3, x:Float, easing:EasingType):FloatPoint3
	{
		var progress = Easing.apply(x, easing);
		var direction = a.direction(b);
		var distance = a.distance(b, EUCLIDEAN);

		var newPx = direction.multiply(progress * distance);

		return newPx.add(a);
	}

	static public inline function lerp(a:FloatPoint3, b:FloatPoint3, t:Float):FloatPoint3
	{
		return {
			x: a.x.lerp(b.x, t),
			y: a.y.lerp(b.y, t),
			z: a.z.lerp(b.z, t),
		};
	}

	static public inline function distance(a:FloatPoint3, b:FloatPoint3, formula:DistanceFormula = EUCLIDEAN):Float
	{
		return Distance.Get(a, b, formula);
	}

	public static inline function lengthSq(a:FloatPoint3):Float
	{
		return a.x * a.x + a.y * a.y + a.z * a.z;
	}

	/**
	 * Returns length (distance to `0,0,0`) of this FloatPoint3.
	**/
	public inline function length(a:FloatPoint3):Float
	{
		return Math.sqrt(lengthSq(a));
	}

	static public inline function normalized(a:FloatPoint3):FloatPoint3
	{
		var k = lengthSq(a);

		if (k < hxd.Math.EPSILON)
		{
			k = 0;
		}
		else
		{
			k = hxd.Math.invSqrt(k);
		}

		return {
			x: a.x * k,
			y: a.y * k,
			z: a.z * k,
		};
	}

	/**
	 * Returns normalized vector from a to b
	**/
	static public inline function direction(a:FloatPoint3, b:FloatPoint3):FloatPoint3
	{
		return b.sub(a).normalized();
	}

	static public inline function format(p:FloatPoint3, decimals:Int):String
	{
		return '(${p.x.format(decimals)}, ${p.y.format(decimals)}, ${p.z.format(decimals)})';
	}
}
