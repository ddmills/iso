package domain.map;

@:struct
class MapTile
{
	public var terrain:TerrainType;
	public var idx:Int;
	public var realHeight:Float;
	public var height:Int;

	public var map(default, null):MapData;
	public var x(get, never):Int;
	public var y(get, never):Int;

	public inline function new(idx:Int, map:MapData)
	{
		this.idx = idx;
		this.map = map;
	}

	inline function get_x():Int
	{
		return map.data.x(idx);
	}

	inline function get_y():Int
	{
		return map.data.y(idx);
	}
}
