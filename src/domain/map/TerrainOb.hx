package domain.map;

import h2d.Layers;

class TerrainOb extends Layers
{
	private var map:MapData;

	public function new(map:MapData)
	{
		super();
		this.map = map;
	}
}
