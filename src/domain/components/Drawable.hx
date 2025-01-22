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
	@save public var pos(default, set):FloatPoint3;

	public var ob(default, null):h2d.Object;
	public var shader(default, null):SpriteShader;
	public var drawable(get, never):h2d.Drawable;

	public var debug(default, set):Bool;

	private var debugGraphics:Graphics;

	public function new(origin:FloatPoint)
	{
		shader = new SpriteShader();
		this.ob = new h2d.Object();
		pos = null;

		this.origin = origin;
	}

	abstract function getDrawable():h2d.Drawable;

	abstract function setWidth(v:Float):Float;

	abstract function setHeight(v:Float):Float;

	abstract function getWidth():Float;

	abstract function getHeight():Float;

	public function updatePos()
	{
		var p = pos ?? entity?.pos ?? FloatPoint3.Zero();
		var px = Projection.worldToPx(p);

		var buffer = .001 * p.z;

		ob.x = px.x + buffer;
		ob.y = px.y + buffer;

		if (drawable != null)
		{
			var originOffsetX = -(origin.x * getWidth());
			var originOffsetY = -(origin.y * getHeight());
			var zOffset = -(p.z * MapData.BLOCK_H);

			drawable.x = originOffsetX - buffer;
			drawable.y = originOffsetY + zOffset - buffer;
			redrawDebug();
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
		debug = value;
		redrawDebug();
		return value;
	}

	function redrawDebug()
	{
		if (debug)
		{
			if (debugGraphics != null)
			{
				debugGraphics.clear();
			}

			var b = drawable.getBounds(ob);

			var p = pos ?? entity.pos ?? FloatPoint3.Zero();
			var zOffset = -(p.z * MapData.BLOCK_H);

			debugGraphics = new Graphics();
			// Game.instance.world.map.ob.add(debugGraphics, -1);
			debugGraphics.lineStyle(1, 0xFF00FF, .4);
			debugGraphics.drawRect(ob.x + drawable.x, ob.y + drawable.y, b.width, b.height);
			debugGraphics.beginFill(0xFF7300, 1);
			debugGraphics.lineStyle(2, 0xFF00FF, 0);
			debugGraphics.drawCircle(ob.x, ob.y, 3);
			debugGraphics.beginFill(0x00B7FF, 1);
			debugGraphics.drawCircle(ob.x, ob.y + zOffset, 2);
		}
		else
		{
			debugGraphics?.remove();
			debugGraphics = null;
		}
	}

	function set_pos(value:FloatPoint3):FloatPoint3
	{
		pos = value;
		updatePos();
		return value;
	}
}
