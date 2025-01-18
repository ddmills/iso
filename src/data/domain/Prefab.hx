package data.domain;

import common.struct.FloatPoint3;
import ecs.Entity;

abstract class Prefab
{
	public function new() {};

	public abstract function Create(options:Dynamic, pos:FloatPoint3):Entity;

	public inline static function Spawn(type:PrefabType, ?pos:FloatPoint3, ?options:Dynamic):Entity
	{
		return Data.Prefabs.spawn(type, pos, options);
	}
}
