package domain.map;

import common.rendering.IsometricLayer;
import common.struct.Grid;

class MapData
{
	public var chunkSize(default, null):Int = 16;
	public var chunkCountX(default, null):Int = 64;
	public var chunkCountY(default, null):Int = 40;

	public var width(default, null):Int;
	public var height(default, null):Int;
	public var depth:Int = 4;
	public var raycast:Raycast;
	public var chunks:ChunkManager;

	public static var TILE_W = 40;
	public static var TILE_W_HALF = 20;
	public static var TILE_H = 40;
	public static var BLOCK_H = 10;
	public static var BLOCK_H_OFFSET = 20;

	public var data:Grid<MapTile>;

	public function new()
	{
		width = chunkCountX * chunkSize;
		height = chunkCountY * chunkSize;

		data = new Grid(width, height);
		data.fillFn(idx -> new MapTile(idx, this));

		raycast = new Raycast(this);
		chunks = new ChunkManager(this);
	}

	public function get(x:Int, y:Int):MapTile
	{
		if (isOutOfBounds(x, y))
		{
			return null;
		}

		return data.get(x, y);
	}

	public function getTerrain(x:Int, y:Int, z:Int):TerrainType
	{
		if (isOutOfBounds(x, y))
		{
			return EMPTY;
		}

		var tile = data.get(x, y);

		if (z > tile.height)
		{
			return EMPTY;
		}

		return tile.terrain;
	}

	public function setTerrain(x:Int, y:Int, type:TerrainType)
	{
		if (isOutOfBounds(x, y))
		{
			return;
		}

		data.get(x, y).terrain = type;
		chunks.updateTerrainBm(x, y);
	}

	public function isOutOfBounds(x:Int, y:Int):Bool
	{
		return x < 0 || y < 0 || x >= width || y >= height;
	}
}
