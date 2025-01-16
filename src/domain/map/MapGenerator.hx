package domain.map;

import common.rand.Perlin;
import common.tools.Performance;
import domain.map.TerrainType;

typedef MapGeneratorSettings =
{
	var seed:Int;
}

class MapGenerator
{
	public function new() {}

	public function generate(settings:MapGeneratorSettings):MapData
	{
		var map = new MapData();

		Performance.start('map');
		generateHeight(map, settings);
		generateTerrain(map, settings);
		Performance.stop('map', true);

		return map;
	}

	function generateHeight(map:MapData, settings:MapGeneratorSettings)
	{
		var p = new Perlin(settings.seed);

		for (tile in map.data)
		{
			tile.value.height = p.get(tile.x, tile.y, 30, 8);
		}
	}

	function generateTerrain(map:MapData, settings:MapGeneratorSettings)
	{
		for (tile in map.data)
		{
			var r = heightToTerrain(tile.value.height);
			tile.value.terrain = r.terrain;
			tile.value.tileHeight = r.tileHeight;
		}
	}

	private function heightToTerrain(h:Float):HeightMap
	{
		var waterline = .6;

		if (h < waterline)
		{
			return {
				terrain: WATER,
				tileHeight: 0,
			};
		}

		if (h < waterline + .01)
		{
			return {
				terrain: SAND,
				tileHeight: 0,
			};
		}

		if (h < waterline + .015)
		{
			return {
				terrain: SAND,
				tileHeight: 1,
			};
		}

		if (h < waterline + .02)
		{
			return {
				terrain: STONE,
				tileHeight: 1,
			};
		}

		if (h < waterline + .04)
		{
			return {
				terrain: GRASS,
				tileHeight: 1,
			};
		}

		if (h < waterline + .07)
		{
			return {
				terrain: GRASS,
				tileHeight: 2,
			};
		}

		return {
			terrain: GRASS,
			tileHeight: 3,
		};
	}
}

typedef HeightMap =
{
	terrain:TerrainType,
	tileHeight:Int,
}
