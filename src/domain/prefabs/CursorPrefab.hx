package domain.prefabs;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import data.domain.Prefab;
import domain.components.Sprite;
import ecs.Entity;

class CursorPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:FloatPoint3):Entity
	{
		var e = new Entity();

		e.add(new Sprite(TK_CURSOR, new FloatPoint(.5, .75)));

		return e;
	}
}
