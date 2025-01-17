package domain.components;

import core.rendering.RenderLayerManager.RenderLayerType;
import data.Data;
import data.resources.TileKey;
import h2d.Bitmap;
import h2d.Tile;

class Sprite extends Drawable
{
	@save public var tileKey(default, set):TileKey;
	@save public var tileKeyOverride(default, set):TileKey;

	public var bm(default, null):Bitmap;
	public var tile(get, never):Tile;

	@save private var _width:Float = 32;
	@save private var _height:Float = 32;

	public function new(tileKey:TileKey, layer = OBJECTS)
	{
		this.tileKey = tileKey;
		super(layer);
		_width = tile.width;
		_height = tile.height;
		bm = new Bitmap(tile, ob);
		// bm.addShader(shader);
		updatePos();
	}

	public function getBitmapClone():Bitmap
	{
		var bm = new Bitmap(tile);
		return bm;
	}

	function get_tile():Tile
	{
		if (tileKeyOverride != null)
		{
			return Data.Tiles.get(tileKeyOverride);
		}

		return Data.Tiles.get(tileKey);
	}

	public function set_tileKey(value:TileKey):TileKey
	{
		tileKey = value;
		if (bm != null)
		{
			bm.tile = tile;
			width = _width;
			height = _height;
		}
		return value;
	}

	function set_tileKeyOverride(value:TileKey):TileKey
	{
		tileKeyOverride = value;
		bm.tile = tile;

		return value;
	}

	inline function getDrawable():h2d.Drawable
	{
		return bm;
	}

	inline function setWidth(value:Float):Float
	{
		_width = value;

		if (bm.tile != null)
		{
			bm.scaleX = value / bm.tile.width;
			updatePos();
		}

		return value;
	}

	inline function setHeight(value:Float):Float
	{
		_height = value;

		if (bm.tile != null)
		{
			bm.scaleY = value / bm.tile.height;
			updatePos();
		}

		return value;
	}

	inline function getWidth():Float
	{
		return _width;
	}

	inline function getHeight():Float
	{
		return _height;
	}
}
