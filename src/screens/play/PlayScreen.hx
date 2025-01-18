package screens.play;

import common.struct.Coordinate;
import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import common.util.Projection;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.Data;
import data.domain.Prefab;
import data.resources.TileKey;
import domain.components.Sprite;
import domain.map.MapData;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Graphics;
import hxsl.Types.Vec;
import screens.console.ConsoleScreen;
import screens.save.SaveScreen;
import shaders.WaterlineShader;

class PlayScreen extends Screen
{
	var cursor:Bitmap;

	private var cursor_x:Int;
	private var cursor_y:Int;
	private var cursor_z:Int;
	private var debugGraphics:Graphics;

	public function new() {}

	override function onEnter()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		cursor = new Bitmap(Data.Tiles.get(TK_CURSOR));
		cursor.color = 0xff00ff.toHxdColor();
		cursor.visible = false;
		debugGraphics = new Graphics();
		world.map.ob.add(debugGraphics, 2);
		debugGraphics.beginFill(0xFF7300, 1);
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

				var p = Projection.worldToPx(x, y);

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

		Prefab.Spawn(TREE_PALM, pos);
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
