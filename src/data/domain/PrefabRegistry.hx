package data.domain;

import common.struct.DataRegistry;
import common.struct.FloatPoint3;
import domain.prefabs.CursorPrefab;
import domain.prefabs.PlayerPrefab;
import domain.prefabs.PlayerShipPrefab;
import domain.prefabs.SharkPrefab;
import domain.prefabs.TreePalmPrefab;

class PrefabRegistry extends DataRegistry<PrefabType, Prefab>
{
	public function new()
	{
		super();

		register(TREE_PALM, new TreePalmPrefab());
		register(PLAYER, new PlayerPrefab());
		register(PLAYER_SHIP, new PlayerShipPrefab());
		register(CURSOR, new CursorPrefab());
		register(SHARK, new SharkPrefab());
	}

	public function spawn(type:PrefabType, ?pos:FloatPoint3, ?options:Dynamic)
	{
		var p = pos ?? new FloatPoint3(0, 0, 0);

		var o = options == null ? {} : options;
		var entity = Data.Prefabs.get(type).Create(o, p);

		entity.pos = p;

		return entity;
	}
}
