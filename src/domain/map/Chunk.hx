package domain.map;

import common.rand.Perlin;
import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import common.struct.Grid;
import common.struct.IntPoint;
import common.util.Projection;
import core.Game;
import data.Data;
import data.resources.TileKey;
import domain.components.Sprite;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import hxsl.Types.Vec;
import shaders.WaterShader;

typedef RenderCell =
{
	ob:Object,
	bm:Bitmap,
}

class Chunk
{
	public var chunkIdx(default, null):Int;
	public var isLoaded(default, null):Bool;
	public var map(default, null):MapData;
	public var worldPos(default, null):IntPoint;
	public var chunkPos(default, null):IntPoint;

	private var bitmaps:Array<Grid<RenderCell>>;
	private var size:Int;

	public function new(chunkIdx:Int, map:MapData)
	{
		this.chunkIdx = chunkIdx;
		this.map = map;
		this.size = map.chunkSize;

		chunkPos = {
			x: Math.floor(chunkIdx % map.chunkCountX),
			y: Math.floor(chunkIdx / map.chunkCountX),
		};
		worldPos = chunkPos.multiply(map.chunkSize);

		isLoaded = false;
		bitmaps = [];

		for (x in 0...map.depth)
		{
			var g = new Grid<RenderCell>(map.width, map.height);
			bitmaps.push(g);
		}
	}

	public function load()
	{
		if (isLoaded)
		{
			return;
		}

		trace('load', chunkIdx);

		var p = new Perlin(Game.instance.world.seed);

		for (x in 0...size)
		{
			for (y in 0...size)
			{
				var wx = worldPos.x + x;
				var wy = worldPos.y + y;
				updateTerrainBm(wx, wy);

				var tree = p.get(wx, wy, 5, 20) > .65;
				var cell = map.get(wx, wy);

				if ((cell.terrain == GRASS || cell.terrain == SAND) && tree)
				{
					var tk = Game.instance.world.rand.pick([TileKey.TK_TREE_PALM_1, TileKey.TK_TREE_PALM_2, TK_TREE_PALM_3]);
					var e = new Entity();
					var sprite = new Sprite(tk);
					sprite.origin = new FloatPoint(.5, .9);
					e.add(sprite);
					e.pos = new FloatPoint3(wx + .5, wy + .5, cell.tileHeight);
				}
			}
		}

		isLoaded = true;
	}

	public function unload()
	{
		for (layer in bitmaps)
		{
			for (bm in layer)
			{
				bm.value.ob.remove();
			}
		}
	}

	public function updateTerrainBm(wx:Int, wy:Int)
	{
		var t = map.get(wx, wy);

		if (t.terrain == EMPTY)
		{
			for (z in 0...map.depth)
			{
				bitmaps[z].get(wx, wy)?.ob.remove();
				bitmaps[z].set(wx, wy, null);
			}

			return;
		}

		for (z in 0...(t.tileHeight + 1))
		{
			var cell = bitmaps[z].get(wx, wy);

			if (cell == null)
			{
				var px = Projection.worldToPx(wx + .5, wy + .5);

				var ob = new Object();
				ob.x = px.x;
				ob.y = px.y;

				var bm = new Bitmap(ob);
				bm.width = MapData.TILE_W;
				bm.height = MapData.TILE_H;
				bm.x = -MapData.TILE_W_HALF;

				var originOffset = -(MapData.TILE_H / 2);
				var zOffset = -(z * MapData.BLOCK_H);

				bm.y = originOffset + zOffset;

				map.ob.add(ob, 0);

				cell = {
					bm: bm,
					ob: ob,
				};

				bitmaps[z].set(wx, wy, cell);
			}

			var tk = getTileKey(t.terrain);
			var tile = Data.Tiles.get(tk);
			cell.bm.tile = tile;

			if (t.terrain == WATER)
			{
				var shader = new WaterShader();
				shader.wpos = new Vec(wx, wy, 0);
				cell.bm.addShader(shader);
			}
			else
			{
				var shader = cell.bm.getShader(WaterShader);

				if (shader != null)
				{
					cell.bm.removeShader(shader);
				}
			}
		}
	}

	private function getTileKey(terrainType:TerrainType):TileKey
	{
		return switch terrainType
		{
			case EMPTY: null;
			case WATER: TK_WATER;
			case GRASS: TK_GRASS;
			case STONE: TK_STONE;
			case DIRT: TK_DIRT;
			case SAND: TK_SAND;
		}
	}
}
