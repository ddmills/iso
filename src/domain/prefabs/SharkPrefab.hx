package domain.prefabs;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import data.domain.Prefab;
import domain.components.Energy;
import domain.components.Sprite;
import ecs.Entity;

class SharkPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:FloatPoint3):Entity
	{
		var e = new Entity();

		var sprite = new Sprite(TK_SHARK_FINS, new FloatPoint(.5, .5));
		e.add(sprite);
		e.add(new Energy());

		return e;
	}
}
