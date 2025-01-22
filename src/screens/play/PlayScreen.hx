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
import data.domain.Prefab;
import domain.components.Move;
import domain.systems.EnergySystem;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import screens.console.ConsoleScreen;
import screens.save.SaveScreen;
import shaders.WaterlineShader;

class PlayScreen extends Screen
{
	var cursor:Entity;

	private var cursorPos:FloatPoint3;

	public function new() {}

	override function onEnter()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		cursor = Prefab.Spawn(CURSOR);
		// world.input.camera.followEntity(world.player.ship);
		var layer = world.map.ob;
		game.render(GROUND, layer);
	}

	function makeBlock(pos:FloatPoint3, layer:IsometricLayer):IsometricObject
	{
		// var tile = Data.Tiles.get(TK_GRASS_H1);
		var tile = hxd.Res.tiles.cy.toTile();
		var bm = new Bitmap(tile);
		var ob = new Object();

		var origin = new FloatPoint(.5, 35 / 40);

		bm.x = -(tile.width * origin.x);
		bm.y = -(tile.height * origin.y);

		ob.addChild(bm);

		var block = new IsometricObject(ob);
		block.size = new FloatPoint3(.6, .6, 3);
		block.pos = new FloatPoint3(pos.x + .5, pos.y + .5, pos.z);

		var shader = new WaterlineShader();
		shader.pos = block.pos.toHxdVec();
		shader.size = block.size.toHxdVec();
		shader.origin = origin.toHxdVec();

		var tex = hxd.Res.tiles.cy_height.toTexture();
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

		var ray = world.map.raycast.Get(game.input.mouse.floor());

		if (ray.success)
		{
			cursor.drawable.isVisible = true;
			var rayPos = ray.pos.floor();

			if (rayPos.x != cursor.x.floor() || rayPos.y != cursor.y.floor() || rayPos.z != cursor.z.floor())
			{
				cursorPos = rayPos;

				world.map.chunks.load(cursor.x.floor(), cursor.y.floor());

				cursor.pos = cursorPos.floor().add(.5, .5, 0);
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
		var p = Projection.screenToWorld(game.input.mouse).floor();

		if (game.input.lmb)
		{
			var r = world.map.raycast.Get(game.input.mouse);
			trace('raycast!', r.pos.floor());
			makeBlock(r.pos.floor(), world.map.ob);
		}

		if (game.input.rmb)
		{
			Performance.start('sort');
			world.map.ob.sort();
			Performance.stop('sort', true);
		}

		return;

		var ray = world.map.raycast.Get(game.input.mouse);

		if (!ray.success)
		{
			return;
		}

		var pos = ray.pos.floor().add(.5, .5, 1);

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
