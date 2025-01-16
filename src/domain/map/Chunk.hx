package domain.map;

import common.struct.Grid;
import common.struct.IntPoint;
import data.Data;
import data.resources.TileKey;
import h2d.Bitmap;
import hxsl.Types.Vec;
import shaders.WaterShader;

class Chunk
{
	public var chunkIdx(default, null):Int;
	public var isLoaded(default, null):Bool;
	public var map(default, null):MapData;
	public var worldPos(default, null):IntPoint;
	public var chunkPos(default, null):IntPoint;

	private var bitmaps:Array<Grid<Bitmap>>;
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
			var g = new Grid<Bitmap>(map.width, map.height);
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

		for (x in 0...size)
		{
			for (y in 0...size)
			{
				updateTerrainBm(worldPos.x + x, worldPos.y + y);
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
				bm.value.remove();
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
				bitmaps[z].get(wx, wy)?.remove();
			}

			return;
		}

		for (z in 0...(t.tileHeight + 1))
		{
			var bm = bitmaps[z].get(wx, wy);

			if (bm == null)
			{
				var px = map.worldToTilePx(wx, wy, 0);

				bm = new Bitmap();
				bm.width = MapData.TILE_W;
				bm.height = MapData.TILE_H;
				bm.x = px.x;
				bm.y = px.y;
				map.ob.add(bm, 0);
				bitmaps[z].set(wx, wy, bm);
			}

			var tk = getTileKey(t.terrain);
			var tile = Data.Tiles.get(tk).clone();
			tile.setCenterRatio(0, z / 4);
			bm.tile = tile;

			if (t.terrain == WATER)
			{
				var shader = new WaterShader();
				shader.wpos = new Vec(bm.x, bm.y, 0);
				bm.addShader(shader);
			}
			else
			{
				var shader = bm.getShader(WaterShader);

				if (shader != null)
				{
					bm.removeShader(shader);
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
