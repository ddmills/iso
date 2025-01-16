package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.Data;
import h2d.Bitmap;
import screens.console.ConsoleScreen;
import screens.save.SaveScreen;

class PlayScreen extends Screen
{
	var cursor:Bitmap;

	private var cursor_x:Int;
	private var cursor_y:Int;
	private var cursor_z:Int;

	public function new() {}

	override function onEnter()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		cursor = new Bitmap(Data.Tiles.get(TK_CURSOR));
		cursor.color = 0xff00ff.toHxdColor();
		cursor.visible = false;
	}

	override function onDestroy()
	{
		cursor.remove();
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
			var z = ray.z.floor() + 1;

			cursor.visible = true;

			if (x != cursor_x || y != cursor_y || z != cursor_z)
			{
				cursor_x = x;
				cursor_y = y;
				cursor_z = z;

				cursor.remove();

				cursor.tile.setCenterRatio(0, (z / 4));

				var p = world.map.worldToTilePx(x, y, 0);

				cursor.x = p.x;
				cursor.y = p.y;

				world.map.chunks.load(x, y);

				world.map.ob.add(cursor, 0);
				world.map.ob.ysort(0);
			}
		}
		else
		{
			cursor.visible = false;
		}

		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_R)
		{
			world.seed++;
			world.generateMap();
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
		world.input.camera.onMouseMove(pos, previous);
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
