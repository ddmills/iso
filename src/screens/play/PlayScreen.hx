package screens.play;

import common.struct.Coordinate;
import common.struct.FloatPoint3;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.domain.Prefab;
import ecs.Entity;
import screens.console.ConsoleScreen;
import screens.save.SaveScreen;

class PlayScreen extends Screen
{
	var cursor:Entity;

	private var cursor_x:Int;
	private var cursor_y:Int;
	private var cursor_z:Int;

	public function new() {}

	override function onEnter()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		cursor = Prefab.Spawn(CURSOR);
		world.input.camera.followEntity(world.player.ship);
	}

	override function onDestroy()
	{
		cursor.destroy();
	}

	override function update(frame:Frame)
	{
		world.updateSystems();

		world.input.camera.update();

		var sx = game.input.mouse.x.floor();
		var sy = game.input.mouse.y.floor();

		var ray = world.map.raycast.Get(sx, sy);

		if (ray.success)
		{
			var x = ray.x.floor();
			var y = ray.y.floor();
			var z = ray.z.floor();

			cursor.drawable.isVisible = true;

			if (x != cursor_x || y != cursor_y || z != cursor_z)
			{
				world.map.chunks.load(x, y);

				cursor_x = x;
				cursor_y = y;
				cursor_z = z;

				cursor.pos = new FloatPoint3(x + .5, y + .5, z);
			}
		}
		else
		{
			cursor.drawable.isVisible = false;
		}
		world.map.ob.ysort(0);

		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		var sx = game.input.mouse.x.floor();
		var sy = game.input.mouse.y.floor();

		var ray = world.map.raycast.Get(sx, sy);

		if (!ray.success)
		{
			return;
		}

		var x = ray.x.floor() + .5;
		var y = ray.y.floor() + .5;
		var z = ray.z.floor();

		var pos = new FloatPoint3(x, y, z);

		// Prefab.Spawn(TREE_PALM, pos);
		world.player.ship_pos = pos;
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_R)
		{
			world.seed++;
			world.generateMap();
		}

		if (key == KEY_D)
		{
			world.systems.sprites.debug = !world.systems.sprites.debug;
		}
	}

	function handle(command:Command)
	{
		switch (command.type)
		{
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_SAVE:
				game.screens.push(new SaveScreen(true));
			case _:
				world.input.camera.handle(command);
		}
	}

	public override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		// world.input.camera.onMouseMove(pos, previous);
	}

	public override function onMouseWheelDown(wheelDelta:Float)
	{
		world.input.camera.onMouseWheelDown(wheelDelta);
	}

	public override function onMouseWheelUp(wheelDelta:Float)
	{
		world.input.camera.onMouseWheelUp(wheelDelta);
	}
}
