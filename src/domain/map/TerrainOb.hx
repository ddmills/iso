package domain.map;

import common.struct.Grid;
import common.struct.IntPoint;
import data.Data;
import data.resources.TileKey;
import domain.map.Terrain.TerrainType;
import h2d.Bitmap;
import h2d.Layers;
import h2d.filter.Displacement;
import hxsl.Types.Vec;
import shaders.WaterShader;

typedef WorldPoint =
{
	x:Int,
	y:Int,
	z:Int,
}

class TerrainOb extends Layers
{
	public var bitmaps:Array<Grid<Bitmap>>;

	private var terrain:Terrain;

	public function new(terrain:Terrain)
	{
		super();
		this.terrain = terrain;
		bitmaps = [];
		for (x in 0...terrain.depth)
		{
			var g = new Grid<Bitmap>(terrain.width, terrain.height);
			bitmaps.push(g);
		}
	}

	public function worldToPx(x:Int, y:Int, z:Int):IntPoint
	{
		var px = (x - y) * Terrain.TILE_W_HALF;
		var py = (x + y - z) * Terrain.BLOCK_H;

		return new IntPoint(px.floor(), py.floor());
	}

	public function worldToTilePx(x:Int, y:Int, z:Int):IntPoint
	{
		var px = (x - y) * Terrain.TILE_W_HALF;
		var py = (x + y - z) * Terrain.BLOCK_H;

		return new IntPoint(px.floor() - Terrain.TILE_W_HALF, py.floor() - Terrain.BLOCK_H);
	}

	public function updateTile(x:Int, y:Int, z:Int)
	{
		var t = terrain.getTerrainAt(x, y, z);
		var bm = bitmaps[z].get(x, y);

		if (t == EMPTY)
		{
			bm?.remove();
			return;
		}

		if (bm == null)
		{
			var px = worldToTilePx(x, y, 0);

			bm = new Bitmap();
			bm.width = Terrain.TILE_W;
			bm.height = Terrain.TILE_H;
			bm.x = px.x;
			bm.y = px.y;
			add(bm, 0);
			bitmaps[z].set(x, y, bm);

			// if (t == WATER)
			// {

			// 	wat.mipMap = Nearest;
			// 	// wat.setCenterRatio(0, z / 4);
			// 	shader.texture = wat;
			// 	shader.wpos = new Vec(x, y, z);
			// 	// var f = new Displacement()
			// 	bm.addShader(shader);
			// }
		}

		if (t == WATER)
		{
			var shader = new WaterShader();
			var wat = hxd.Res.tiles.water.toTexture();
			shader.texture = wat;
			shader.wpos = new Vec(bm.x, bm.y, 0);
			bm.addShader(shader);
		}
		else
		{
			var tk = getTileKey(t);
			var tile = Data.Tiles.get(tk).clone();
			tile.setCenterRatio(0, z / 4);
			bm.tile = tile;
		}
	}

	public function init()
	{
		removeChildren();

		bitmaps = [];
		for (z in 0...terrain.depth)
		{
			var g = new Grid<Bitmap>(terrain.width, terrain.height);
			bitmaps.push(g);
		}

		for (z in 0...terrain.depth)
		{
			for (x in 0...terrain.width)
			{
				for (y in 0...terrain.height)
				{
					updateTile(x, y, z);
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
