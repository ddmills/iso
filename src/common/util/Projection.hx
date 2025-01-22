package common.util;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import core.Game;
import domain.map.MapData;

class Projection
{
	static var game(get, null):Game;

	inline static function get_game():Game
	{
		return Game.instance;
	}

	/**
	 * Convert mouse/screen coordinates (zero to window size) to px coordinates from origin
	 * taking into account the camera scale.
	 */
	public static function screenToPx(mouse:FloatPoint):FloatPoint
	{
		var c = game.camera;

		return {
			x: c.pos.x + (mouse.x / c.scale),
			y: c.pos.y + (mouse.y / c.scale),
		};
	}

	public static function worldToPx(p:FloatPoint3):FloatPoint
	{
		var x = (p.x - p.y) * MapData.TILE_W_HALF;
		var y = (p.x + p.y - p.z) * MapData.BLOCK_H;

		return new FloatPoint(x, y);
	}

	public static function pxToWorld(p:FloatPoint, z:Float = 0):FloatPoint3
	{
		var x = ((p.y + (z * MapData.BLOCK_H)) / MapData.BLOCK_H + p.x / MapData.TILE_W_HALF) / 2;
		var y = ((p.y + (z * MapData.BLOCK_H)) / MapData.BLOCK_H - p.x / MapData.TILE_W_HALF) / 2;

		return new FloatPoint3(x, y, z);
	}

	public static function screenToWorld(p:FloatPoint, z:Float = 0):FloatPoint3
	{
		return pxToWorld(screenToPx(p), z);
	}
}
