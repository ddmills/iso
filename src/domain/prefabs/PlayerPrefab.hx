package domain.prefabs;

import common.struct.FloatPoint3;
import data.domain.Prefab;
import domain.components.Energy;
import ecs.Entity;

class PlayerPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:FloatPoint3):Entity
	{
		var e = new Entity();

		e.add(new Energy(10));

		return e;
	}
}
