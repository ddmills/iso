package data.input.groups;

import common.struct.FloatPoint;
import common.util.Projection;
import core.Game;
import ecs.Entity;

class CameraInputGroup
{
	var follow:Null<Entity>;

	public function new()
	{
		follow = null;
	}

	public function onMouseMove(screenPos:FloatPoint, previousScreenPos:FloatPoint)
	{
		var game = Game.instance;

		if (game.input.mmb)
		{
			var diff = previousScreenPos
				.sub(screenPos)
				.multiply(1);

			game.camera.scroller.x -= diff.x;
			game.camera.scroller.y -= diff.y;

			follow = null;
		}
	}

	public function onMouseWheelDown(wheelDelta:Float)
	{
		var game = Game.instance;
		var z = (game.camera.scale + .1).clamp(.1, 4);
		var p = Projection.screenToPx(game.input.mouse);
		game.camera.focusToward(p, z);
	}

	public function onMouseWheelUp(wheelDelta:Float)
	{
		var game = Game.instance;
		var z = (game.camera.scale - .1).clamp(.1, 4);
		var p = Projection.screenToPx(game.input.mouse);
		game.camera.focusToward(p, z);
	}

	public function followEntity(entity:Entity)
	{
		follow = entity;
	}

	public function update()
	{
		if (follow != null)
		{
			if (follow.isDestroyed)
			{
				follow = null;
			}
			else
			{
				// var pos = follow.drawable?.pos ?? follow.pos;
				// Game.instance.camera.focus = new FloatPoint(pos.x, pos.y);
			}
		}
	}
}
