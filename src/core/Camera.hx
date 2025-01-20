package core;

import common.struct.FloatPoint;
import h2d.Object;

class Camera
{
	/**
	 * Width of the window
	 */
	public var width(get, null):Float;

	/**
	 * Height of the window
	 */
	public var height(get, null):Float;

	public var scale(get, set):Float;

	/**
	 * Position of the camera, in pixels, from the origin
	 */
	public var pos(get, set):FloatPoint;

	public var scroller(get, null):h2d.Object;

	public function new()
	{
		scale = 1;
	}

	inline function get_width():Float
	{
		return hxd.Window.getInstance().width;
	}

	inline function get_height():Float
	{
		return hxd.Window.getInstance().height;
	}

	inline function get_scroller():Object
	{
		return Game.instance.layers.scroller;
	}

	function set_pos(value:FloatPoint):FloatPoint
	{
		scroller.x = -(value.x * scale);
		scroller.y = -(value.y * scale);
		return value;
	}

	inline function get_pos():FloatPoint
	{
		return {
			x: -(scroller.x / scale),
			y: -(scroller.y / scale),
		};
	}

	inline function get_scale():Float
	{
		return scroller.scaleX;
	}

	function set_scale(value:Float):Float
	{
		scroller.setScale(value);

		return value;
	}

	public function focusToward(pxFocus:FloatPoint, scale:Float)
	{
		var ratio = 1 - (scale / this.scale);

		scroller.x += (pxFocus.x - scroller.x) * ratio;
		scroller.y += (pxFocus.y - scroller.y) * ratio;

		scroller.setScale(scale);
	}

	public function focus(pxFocus:FloatPoint):FloatPoint
	{
		pos = {
			x: (pxFocus.x - (width / 2)) + pos.x,
			y: (pxFocus.y - (height / 2)) + pos.y,
		};

		return pos;
	}
}
