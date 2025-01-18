package domain.prefabs;

import common.struct.FloatPoint3;
import common.struct.FloatPoint;
import core.Game;
import data.domain.Prefab;
import data.resources.TileKey;
import domain.components.Sprite;
import ecs.Entity;

class TreePalmPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:FloatPoint3):Entity
	{
		var e = new Entity();
		var tk = Game.instance.world.rand.pick([TileKey.TK_TREE_PALM_1, TileKey.TK_TREE_PALM_2, TK_TREE_PALM_3]);

		var sprite = new Sprite(tk);
		sprite.origin = new FloatPoint(.5, .9);
		e.add(sprite);

		return e;
	}
}
