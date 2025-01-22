package domain.map;

import common.rand.Perlin;
import common.rendering.IsometricObject;
import common.struct.FloatPoint3;
import common.struct.Grid;
import common.struct.IntPoint;
import core.Game;
import data.Data;
import data.resources.TileKey;
import h2d.Bitmap;
import h2d.Object;
import hxsl.Types.Texture;
import hxsl.Types.Vec;
import shaders.WaterShader;
import shaders.WaterlineShader;

typedef RenderCell =
{
	iso:IsometricObject,
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

	private var texH1:Texture;
	private var texH2:Texture;
	private var texH3:Texture;
	private var texH4:Texture;

	public function new(chunkIdx:Int, map:MapData)
	{
		this.chunkIdx = chunkIdx;
		this.map = map;
		this.size = map.chunkSize;
		texH1 = hxd.Res.tiles.terrain_depth_1.toTexture();
		texH1.filter = Nearest;
		texH2 = hxd.Res.tiles.terrain_depth_2.toTexture();
		texH2.filter = Nearest;
		texH3 = hxd.Res.tiles.terrain_depth_3.toTexture();
		texH3.filter = Nearest;
		texH4 = hxd.Res.tiles.terrain_depth_4.toTexture();
		texH4.filter = Nearest;

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

				// var tree = p.get(wx, wy, 8, 20) > .5;
				// var cell = map.get(wx, wy);
				// var chance = Game.instance.world.rand.bool(.5);

				// if ((cell.terrain == GRASS || cell.terrain == SAND) && chance && tree)
				// {
				// 	var pos = new FloatPoint3(wx + .5, wy + .5, cell.height + 1);
				// 	Prefab.Spawn(TREE_PALM, pos);
				// }
			}
		}

		isLoaded = true;
	}

	public function unload()
	{
		// for (layer in bitmaps)
		// {
		// 	for (bm in layer)
		// 	{
		// 		bm.value.iso.ob.remove();
		// 	}
		// }
	}

	public function updateTerrainBm(wx:Int, wy:Int)
	{
		var t = map.get(wx, wy);

		if (t.terrain == EMPTY)
		{
			for (z in 0...map.depth)
			{
				// bitmaps[z].get(wx, wy)?.iso.ob.remove();
				// bitmaps[z].set(wx, wy, null);
			}

			return;
		}

		if (t.terrain == WATER)
		{
			return;
		}

		// for (z in 0...(t.height + 1))
		// {
		var cell = bitmaps[0].get(wx, wy);

		if (cell == null)
		{
			var tk = getTileKeyH(t.terrain, t.height + 1);
			var tile = Data.Tiles.get(tk);
			var bm = new Bitmap(tile);
			var ob = new Object();
			bm.x = -(tile.width * .5);
			// bm.y = -(MapData.TILE_H * .75);
			bm.y = -(tile.height * .8625);
			ob.addChild(bm);

			var block = new IsometricObject(ob);
			block.pos = new FloatPoint3(wx + .5, wy + .5, 0);
			block.size = new FloatPoint3(1, 1, t.height + 1);

			cell = {
				iso: block,
				bm: bm,
			};

			map.ob.add(block);

			bitmaps[0].set(wx, wy, cell);
		}

		// var tk = getTileKey(t.terrain);
		// var tile = Data.Tiles.get(tk);
		// cell.bm.tile = tile;

		if (t.terrain == WATER)
		{
			// var shader = new WaterShader();
			// shader.wpos = new Vec(wx, wy, z);
			// cell.bm.addShader(shader);
		}
		else
		{
			var shader = cell.bm.getShader(WaterShader);

			if (shader != null)
			{
				cell.bm.removeShader(shader);
			}

			var shader = new WaterlineShader();
			shader.pos = new Vec(wx + .5, wy + .5, 0);
			shader.size = new Vec(1, 1, t.height + 1);
			shader.heightTexture = getHeightTexture(t.height + 1);
			cell.bm.addShader(shader);
		}
		// }
	}

	private function getHeightTexture(height:Int):Texture
	{
		return switch height
		{
			case 1:
				texH1;
			case 2:
				texH2;
			case 3:
				texH3;
			default:
				texH4;
		};
	}

	private function getTileKeyH(terrainType:TerrainType, height:Int):TileKey
	{
		return switch terrainType
		{
			case EMPTY: null;
			case WATER: switch height
				{
					case 1: TK_WATER_H1;
					case 2: TK_WATER_H2;
					case 3: TK_WATER_H3;
					default: TK_WATER_H4;
				};
			case GRASS: switch height
				{
					case 1: TK_GRASS_H1;
					case 2: TK_GRASS_H2;
					case 3: TK_GRASS_H3;
					default: TK_GRASS_H4;
				};
			case STONE: switch height
				{
					case 1: TK_STONE_H1;
					case 2: TK_STONE_H2;
					case 3: TK_STONE_H3;
					default: TK_STONE_H4;
				};
			case DIRT: switch height
				{
					case 1: TK_DIRT_H1;
					case 2: TK_DIRT_H2;
					case 3: TK_DIRT_H3;
					default: TK_DIRT_H4;
				};
			case SAND: switch height
				{
					case 1: TK_SAND_H1;
					case 2: TK_SAND_H2;
					case 3: TK_SAND_H3;
					default: TK_SAND_H4;
				};
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
