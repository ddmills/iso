package common.extensions;

import common.struct.FloatPoint;
import common.struct.IntPoint;

class FloatPointExtensions
{
	static public inline function lerp(a:FloatPoint, b:FloatPoint, t:Float):FloatPoint
	{
		return {
			x: a.x.lerp(b.x, t),
			y: a.y.lerp(b.y, t),
		};
	}

	static public inline function multiply(p:FloatPoint, v:Float):FloatPoint
	{
		return {
			x: p.x * v,
			y: p.y * v,
		};
	}

	static public inline function ciel(p:FloatPoint):IntPoint
	{
		return {
			x: p.x.ciel(),
			y: p.y.ciel(),
		};
	}

	static public overload extern inline function sub(a:FloatPoint, v:Float):FloatPoint
	{
		return new FloatPoint(a.x - v, a.y - v);
	}

	static public overload extern inline function sub(a:FloatPoint, x:Float, y:Float):FloatPoint
	{
		return new FloatPoint(a.x - x, a.y - y);
	}

	static public overload extern inline function sub(a:FloatPoint, b:FloatPoint):FloatPoint
	{
		return new FloatPoint(a.x - b.x, a.y - b.y);
	}

	static public overload extern inline function add(a:FloatPoint, v:Float):FloatPoint
	{
		return new FloatPoint(a.x + v, a.y + v);
	}

	static public overload extern inline function add(a:FloatPoint, x:Float, y:Float):FloatPoint
	{
		return new FloatPoint(a.x + x, a.y + y);
	}

	static public overload extern inline function add(a:FloatPoint, b:FloatPoint):FloatPoint
	{
		return new FloatPoint(a.x + b.x, a.y + b.y);
	}

	static public inline function floor(p:FloatPoint):FloatPoint
	{
		return {
			x: p.x.floor(),
			y: p.y.floor(),
		};
	}

	static public inline function round(p:FloatPoint):IntPoint
	{
		return {
			x: p.x.round(),
			y: p.y.round(),
		};
	}

	static public inline function toIntPoint(p:FloatPoint)
	{
		return new IntPoint(p.x.floor(), p.y.floor());
	}

	static public inline function format(p:FloatPoint, decimals:Int):String
	{
		return '(${p.x.format(decimals)}, ${p.y.format(decimals)})';
	}
}
