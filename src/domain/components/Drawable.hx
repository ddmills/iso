package domain.components;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import common.util.Projection;
import domain.map.MapData;
import ecs.Component;
import h2d.Graphics;
import shaders.SpriteShader;

abstract class Drawable extends Component
{
	@save public var isVisible(default, set):Bool = true;
	@save public var width(get, set):Float;
	@save public var height(get, set):Float;
	@save public var origin(default, set):FloatPoint = new FloatPoint(.5, .5);
	@save public var worldPos(default, set):FloatPoint3;

	public var ob(default, null):h2d.Object;
	public var shader(default, null):SpriteShader;
	public var drawable(get, never):h2d.Drawable;

	public var debug(default, set):Bool;

	private var debugGraphics:Graphics;

	public function new(origin:FloatPoint)
	{
		shader = new SpriteShader();
		this.ob = new h2d.Object();
		worldPos = new FloatPoint3(0, 0, 0);

		this.origin = origin;
	}

	abstract function getDrawable():h2d.Drawable;

	abstract function setWidth(v:Float):Float;

	abstract function setHeight(v:Float):Float;

	abstract function getWidth():Float;

	abstract function getHeight():Float;

	public function updatePos()
	{
		var px = Projection.worldToPx(worldPos.x, worldPos.y);

		ob.x = px.x;
		ob.y = px.y;

		if (drawable != null)
		{
			var originOffsetX = -(origin.x * getWidth());
			var originOffsetY = -(origin.y * getHeight());
			var zOffset = -(worldPos.z * MapData.BLOCK_H);

			drawable.x = originOffsetX;
			drawable.y = originOffsetY + zOffset;
		}
	}

	inline function set_isVisible(value:Bool):Bool
	{
		isVisible = value;
		return drawable.visible = value;
	}

	override function onRemove()
	{
		drawable.remove();
	}

	inline function get_drawable():h2d.Drawable
	{
		return getDrawable();
	}

	inline function get_width():Float
	{
		return getWidth();
	}

	inline function get_height():Float
	{
		return getHeight();
	}

	inline function set_width(value:Float):Float
	{
		return setWidth(value);
	}

	inline function set_height(value:Float):Float
	{
		return setHeight(value);
	}

	inline function set_origin(value:FloatPoint):FloatPoint
	{
		origin = value;
		updatePos();
		return value;
	}

	function set_debug(value:Bool):Bool
	{
		if (value)
		{
			var b = drawable.getBounds(ob);

			var zOffset = -(worldPos.z * MapData.BLOCK_H);

			debugGraphics = new Graphics(ob);
			debugGraphics.lineStyle(1, 0xFF00FF, .1);
			debugGraphics.drawRect(drawable.x, drawable.y, b.width, b.height);
			debugGraphics.beginFill(0xFF7300, 1);
			debugGraphics.lineStyle(2, 0xFF00FF, 0);
			debugGraphics.drawCircle(0, 0, 3);
			debugGraphics.beginFill(0x00B7FF, 1);
			debugGraphics.drawCircle(0, zOffset, 2);
		}
		else
		{
			debugGraphics?.remove();
			debugGraphics = null;
		}

		return debug = value;
	}

	function set_worldPos(value:FloatPoint3):FloatPoint3
	{
		worldPos = value;
		updatePos();
		return value;
	}
}
