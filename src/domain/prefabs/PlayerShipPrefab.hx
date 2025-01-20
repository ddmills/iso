package domain.prefabs;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import data.domain.Prefab;
import domain.components.Sprite;
import ecs.Entity;

class PlayerShipPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:FloatPoint3):Entity
	{
		var e = new Entity();

		var sprite = new Sprite(TK_SHIP, new FloatPoint(.5, .8));
		e.add(sprite);

		return e;
	}
}
