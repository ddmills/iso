package domain;

import common.struct.FloatPoint3;
import data.domain.Prefab;
import ecs.Entity;

typedef PlayerSave =
{
	ship:EntitySaveData,
}

class PlayerManager
{
	public var ship(default, default):Entity;
	public var ship_x(get, set):Float;
	public var ship_y(get, set):Float;
	public var ship_z(get, set):Float;
	public var ship_pos(get, set):FloatPoint3;

	public function new() {}

	public function create(pos:FloatPoint3)
	{
		ship = Prefab.Spawn(PLAYER_SHIP, pos);
	}

	public function load(data:PlayerSave)
	{
		ship = Entity.Load(data.ship);
	}

	public function save(teardown:Bool = false):PlayerSave
	{
		var shipSave = ship.save();

		return {
			ship: shipSave
		};
	}

	inline function set_ship_x(value:Float):Float
	{
		return ship.x = value;
	}

	function get_ship_x():Float
	{
		return ship.x;
	}

	inline function set_ship_y(value:Float):Float
	{
		return ship.y = value;
	}

	function get_ship_y():Float
	{
		return ship.y;
	}

	inline function set_ship_z(value:Float):Float
	{
		return ship.z = value;
	}

	function get_ship_z():Float
	{
		return ship.z;
	}

	inline function set_ship_pos(value:FloatPoint3):FloatPoint3
	{
		return ship.pos = value;
	}

	function get_ship_pos():FloatPoint3
	{
		return ship.pos;
	}
}
