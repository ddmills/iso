package data.domain;

import common.struct.DataRegistry;
import common.struct.FloatPoint3;

class PrefabRegistry extends DataRegistry<PrefabType, Prefab>
{
	public function new()
	{
		super();
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
