package data.input.groups;

import common.struct.Coordinate;
import core.Game;
import ecs.Entity;

class CameraInputGroup
{
	var follow:Null<Entity>;

	public function new()
	{
		follow = null;
	}

	public function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		var game = Game.instance;

		if (game.input.mmb)
		{
			var diff = previous
				.sub(pos)
				.toFloatPoint()
				.multiply(1);

			game.camera.scroller.x -= diff.x;
			game.camera.scroller.y -= diff.y;

			follow = null;
		}
	}

	public function onMouseWheelDown(wheelDelta:Float)
	{
		var game = Game.instance;
		var z = (game.camera.zoom + .1).clamp(.1, 4);
		game.camera.zoomTo(game.input.mouse, z);
	}

	public function onMouseWheelUp(wheelDelta:Float)
	{
		var game = Game.instance;
		var z = (game.camera.zoom - .1).clamp(.1, 4);
		game.camera.zoomTo(game.input.mouse, z);
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
				var pos = follow.drawable?.pos ?? follow.pos;
				Game.instance.camera.focus = new Coordinate(pos.x, pos.y, WORLD);
			}
		}
	}
}
