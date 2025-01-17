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
import data.resources.TileKey;
import domain.components.Sprite;
import domain.map.MapData;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Graphics;
import screens.console.ConsoleScreen;
import screens.save.SaveScreen;

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

		var px = Projection.worldToPx(x, y);

		var ob = new h2d.Object();
		ob.x = px.x;
		ob.y = px.y;

		// var tk = world.rand.pick([TileKey.TK_TREE_PALM_1]);
		var tk = world.rand.pick([TileKey.TK_TREE_PALM_1, TileKey.TK_TREE_PALM_2, TK_TREE_PALM_3]);
		// var tk = TileKey.TK_CUBE;
		// var tile = Data.Tiles.get(tk);
		// var drawable = new Bitmap(tile, ob);

		// var originY = .9;

		// // var zOffset = -((z / world.map.depth) * (MapData.BLOCK_H));
		// var zOffset = -(z * MapData.BLOCK_H);
		// var originOffsetA = -(originY * tile.height);

		// trace(z, world.map.depth, zOffset);

		// drawable.x = -(tile.width / 2); // offset for height
		// drawable.y = zOffset + originOffsetA; // offset for height

		// world.map.ob.add(ob, 0);
		// var b = drawable.getBounds(ob);
		// debugGraphics.endFill();
		// debugGraphics.drawRect(ob.x + drawable.x, ob.y + drawable.y, b.width, b.height);
		// debugGraphics.beginFill(0xFF7300, 1);
		// debugGraphics.drawCircle(ob.x, ob.y, 2);
		// debugGraphics.beginFill(0x00B7FF, 1);
		// debugGraphics.drawCircle(ob.x + drawable.x, ob.y + drawable.y, 2);
		// debugGraphics.lineStyle(2, 0xFF00FF, .1);
		// debugGraphics.endFill();

		var e = new Entity();
		var sprite = new Sprite(tk);
		sprite.origin = new FloatPoint(.5, .9);
		e.add(sprite);
		e.pos = new FloatPoint3(x, y, z);
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
