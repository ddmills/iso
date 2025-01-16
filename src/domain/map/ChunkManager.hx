package domain.map;

import common.struct.Grid;

class ChunkManager
{
	private var chunks(default, null):Grid<Chunk>;
	private var map:MapData;

	public function new(map:MapData)
	{
		this.map = map;
		chunks = new Grid(map.chunkCountX, map.chunkCountY);
		chunks.fillFn(idx -> new Chunk(idx, map));
	}

	private inline function getChunkByWorld(wx:Int, wy:Int):Chunk
	{
		var cx = (wx / map.chunkSize).floor();
		var cy = (wy / map.chunkSize).floor();

		return chunks.get(cx, cy);
	}

	public function updateTerrainBm(wx:Int, wy:Int)
	{
		var chunk = getChunkByWorld(wx, wy);
		chunk.updateTerrainBm(wx, wy);
	}

	public function load(wx:Int, wy:Int)
	{
		getChunkByWorld(wx, wy)?.load();
	}

	public function unload(wx:Int, wy:Int)
	{
		getChunkByWorld(wx, wy)?.unload();
	}
}
