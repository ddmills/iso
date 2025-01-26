package domain.systems;

import common.struct.FloatPoint3;
import common.tools.Performance;
import common.util.Projection;
import core.Frame;
import data.Data;
import data.core.ColorKey;
import ecs.System;
import h2d.Graphics;
import h2d.Object;
import h2d.Text;
import haxe.EnumTools.EnumValueTools;

typedef DebugInfo =
{
	ob:Object,
	fps:Text,
	screenPos:Text,
	pixelPos:Text,
	worldPos:Text,
	clock:Text,
	entities:Text,
	drawCalls:Text,
	grid:h2d.Graphics,
}

class DebugInfoSystem extends System
{
	public var debugInfo:DebugInfo;

	public function new()
	{
		renderDebugInfo();
	}

	override function update(frame:Frame)
	{
		var screen = game.input.mouse;
		var pixel = Projection.screenToPx(screen);
		var wpos = Projection.screenToWorld(screen, 0);
		var worldToPx = Projection.worldToPx(wpos);

		// var w = game.input.screen.toIntPoint();
		// var px = game.input.screen;
		// var wtext = w.toString();
		var fps = frame.fps.floor();

		// var sx = game.input.screen.x.floor();
		// var sy = game.input.screen.y.floor();

		var ray = world.map.raycast.Get(screen);
		// var rayText = '[${ray.x.floor()}, ${ray.y.floor()}, ${ray.z.floor()}]';
		// var terrainText = EnumValueTools.getName(ray.terrain);

		// var w = Projection.screenToPx(game.input.screen);

		var sort = Performance.toString('sort');

		debugInfo.fps.text = game.app.engine.fps.floor().toString() + ' ' + frame.fps.floor().toString();
		debugInfo.fps.color = getFpsColor(fps).toHxdColor();

		debugInfo.screenPos.text = 'screen=${screen} scale=${game.camera.scale}';
		debugInfo.pixelPos.text = 'pixel=${pixel.format(0)}. ${worldToPx.format(0)}';
		debugInfo.worldPos.text = 'world=${wpos.format(1)}';

		debugInfo.entities.text = 'entities ${game.registry.size.toString()}, iso ${world.ob.objects.length} ${sort} ';
		debugInfo.clock.text = '${ray.pos.format(1)} [${EnumValueTools.getName(ray.terrain)}])';
		// debugInfo.clock.text = '${world.clock.friendlyString()} [${world.clock.tick}])';
		debugInfo.drawCalls.text = 'draw ${game.app.engine.drawCalls}';
	}

	function getFpsColor(fps:Int):Int
	{
		if (fps < 60)
		{
			return 0xbe7474;
		}

		if (fps < 100)
		{
			return 0xe0de62;
		}

		return 0x92e08b;
	}

	override function teardown()
	{
		debugInfo.ob.remove();
	}

	private function renderDebugInfo()
	{
		var h = 0;

		var ob = new Object();
		ob.x = 16;
		ob.y = 16;

		var fps = Data.Fonts.text(FNT_BIZCAT, ob);
		fps.y = h;

		var screenPos = Data.Fonts.text(FNT_BIZCAT, ob);
		screenPos.color = ColorKey.C_WHITE.toHxdColor();
		screenPos.y = h += 16;

		var pixelPos = Data.Fonts.text(FNT_BIZCAT, ob);
		pixelPos.color = ColorKey.C_WHITE.toHxdColor();
		pixelPos.y = h += 16;

		var worldPos = Data.Fonts.text(FNT_BIZCAT, ob);
		worldPos.color = ColorKey.C_WHITE.toHxdColor();
		worldPos.y = h += 16;

		var pos = Data.Fonts.text(FNT_BIZCAT, ob);
		pos.color = ColorKey.C_WHITE.toHxdColor();
		pos.y = h += 16;

		var entities = Data.Fonts.text(FNT_BIZCAT, ob);
		entities.color = ColorKey.C_WHITE.toHxdColor();
		entities.y = h += 16;

		var clock = Data.Fonts.text(FNT_BIZCAT, ob);
		clock.color = ColorKey.C_WHITE.toHxdColor();
		clock.y = h += 16;

		var drawCalls = Data.Fonts.text(FNT_BIZCAT, ob);
		drawCalls.color = ColorKey.C_WHITE.toHxdColor();
		drawCalls.y = h += 16;

		var grid = new Graphics();
		grid.beginFill(0x00FF00, 0);

		for (x in 0...world.map.width)
		{
			if (x % 8 == 0)
			{
				grid.lineStyle(2, 0x4373D1, .6);
			}
			else if (x % 4 == 0)
			{
				grid.lineStyle(2, 0xFFFFFF, .3);
			}
			else
			{
				grid.lineStyle(1, 0xFFFFFF, .1);
			}

			var start = new FloatPoint3(x, 0, 0);
			var end = new FloatPoint3(x, world.map.height, 0);

			var startPx = Projection.worldToPx(start);
			var endPx = Projection.worldToPx(end);

			grid.moveTo(startPx.x, startPx.y);
			grid.lineTo(endPx.x, endPx.y);
		}

		for (y in 0...world.map.height)
		{
			if (y % 8 == 0)
			{
				grid.lineStyle(2, 0x4373D1, .6);
			}
			else if (y % 4 == 0)
			{
				grid.lineStyle(2, 0xFFFFFF, .3);
			}
			else
			{
				grid.lineStyle(1, 0xFFFFFF, .1);
			}

			var start = new FloatPoint3(0, y, 0);
			var end = new FloatPoint3(world.map.width, y, 0);

			var startPx = Projection.worldToPx(start);
			var endPx = Projection.worldToPx(end);

			grid.moveTo(startPx.x, startPx.y);
			grid.lineTo(endPx.x, endPx.y);
		}

		// game.render(GROUND, grid);

		debugInfo = {
			ob: ob,
			fps: fps,
			screenPos: screenPos,
			pixelPos: pixelPos,
			worldPos: worldPos,
			entities: entities,
			clock: clock,
			drawCalls: drawCalls,
			grid: grid,
		};

		game.render(HUD, ob);
	}
}
