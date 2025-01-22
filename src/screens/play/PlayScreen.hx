package screens.play;

import common.rendering.IsometricLayer;
import common.rendering.IsometricObject;
import common.struct.Cardinal;
import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import common.tools.Performance;
import common.util.Projection;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.Data;
import data.domain.Prefab;
import domain.components.Move;
import domain.systems.EnergySystem;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import hxsl.Types.Vec;
import screens.console.ConsoleScreen;
import screens.save.SaveScreen;
import shaders.WaterlineShader;

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
		// world.input.camera.followEntity(world.player.ship);
		var layer = world.map.ob;
		game.render(GROUND, layer);

		// var b1 = makeBlock(2, 2, 1, layer);
		// var b2 = makeBlock(2, 2, 0, layer);
		// var b3 = makeBlock(1, 2, 0, layer);

		// var b4 = makeBlock(4, 5, 0, layer);
		// var b5 = makeBlock(5, 6, 0, layer);

		// trace(layer.isBehind(b2, b1));
		// trace(layer.isBehind(b1, b2));

		// // Performance.start('sort');
		// layer.sort();
		// // Performance.stop('sort', true);
	}

	function makeBlock(x:Float, y:Float, z:Float, layer:IsometricLayer):IsometricObject
	{
		// var tile = Data.Tiles.get(TK_GRASS_H1);
		var tile = hxd.Res.tiles.rock.toTile();
		var bm = new Bitmap(tile);
		var ob = new Object();
		bm.x = -(tile.width * .5);
		bm.y = -(tile.height * .75);
		ob.addChild(bm);

		var block = new IsometricObject(ob);
		block.size = new FloatPoint3(1, 1, 1);
		block.pos = new FloatPoint3(x, y, 0);

		var shader = new WaterlineShader();
		shader.pos = new Vec(x, y, 0);
		shader.size = new Vec(1, 1, 1);

		var tex = hxd.Res.tiles.rock_height.toTexture();
		tex.filter = Nearest;
		shader.heightTexture = tex;

		bm.addShader(shader);

		layer.add(block);

		return block;
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

		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}
	}

	override function onMouseDown(screenPos:FloatPoint)
	{
		var sx = game.input.mouse.x.floor();
		var sy = game.input.mouse.y.floor();

		var p = Projection.screenToWorld(game.input.mouse).floor();

		if (game.input.lmb)
		{
			makeBlock(p.x, p.y, p.z, world.map.ob);
		}
		if (game.input.rmb)
		{
			Performance.start('sort');
			world.map.ob.sort();
			Performance.stop('sort', true);
		}
		return;

		var ray = world.map.raycast.Get(sx, sy);

		// trace('ray!', ray.success, ray.x, ray.y, ray.z);

		if (!ray.success)
		{
			return;
		}

		var x = ray.x.floor() + .5;
		var y = ray.y.floor() + .5;
		var z = ray.z.floor() + 1;
		var pos = new FloatPoint3(x, y, z);

		if (game.input.lmb)
		{
			world.player.ship_pos = pos;
			EnergySystem.ConsumeEnergy(world.player.entity, ACT_MOVE);
		}

		if (game.input.rmb)
		{
			// Prefab.Spawn(SHARK, pos);
			Prefab.Spawn(TREE_PALM, pos);
		}
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_F1)
		{
			world.seed++;
			world.generateMap();
		}

		if (key == KEY_F2)
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
			case CMD_MOVE_NW:
				move(WEST);
			case CMD_MOVE_N:
				move(NORTH_WEST);
			case CMD_MOVE_NE:
				move(NORTH);
			case CMD_MOVE_E:
				move(NORTH_EAST);
			case CMD_MOVE_W:
				move(SOUTH_WEST);
			case CMD_MOVE_SW:
				move(SOUTH);
			case CMD_MOVE_S:
				move(SOUTH_EAST);
			case CMD_MOVE_SE:
				move(EAST);
			case CMD_WAIT:
				EnergySystem.ConsumeEnergy(world.player.entity, ACT_WAIT);
			case _:
		}
	}

	private function move(dir:Cardinal)
	{
		var offset = dir.toOffset();
		var target = world.player.ship_pos.add(offset.x, offset.y, 0);

		if (world.map.isOutOfBounds(target.x.floor(), target.y.floor()))
		{
			return;
		}

		var speed = .2 * (!dir.isDiagonal() ? 1.59 : 1);
		world.player.ship.add(new Move(target, speed, EASE_LINEAR));
		EnergySystem.ConsumeEnergy(world.player.entity, ACT_MOVE);
		trace('move to ${target.toString()}');
	}

	public override function onMouseMove(mousePos:FloatPoint, previousMousePos:FloatPoint)
	{
		world.input.camera.onMouseMove(mousePos, previousMousePos);
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
