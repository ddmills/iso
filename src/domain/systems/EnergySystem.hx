package domain.systems;

import core.Frame;
import data.domain.EnergyActionType;
import domain.components.Energy;
import domain.events.ConsumeEnergyEvent;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class EnergySystem extends System
{
	public var isPlayersTurn(default, null):Bool;

	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Energy],
		});
	}

	override function update(frame:Frame)
	{
		world.clock.clearDeltas();

		if (isPlayersTurn && world.player.entity.get(Energy).hasEnergy)
		{
			return;
		}

		while (true)
		{
			var entity = getNext();

			if (entity.isNull())
			{
				trace('no entity with energy!');
				break;
			}

			if (entity.id == world.player.entity.id)
			{
				trace('players turn');
				isPlayersTurn = true;
				break;
			}
			else
			{
				isPlayersTurn = false;
				world.ai.takeAction(entity);
			}
		}
	}

	function getNext():Entity
	{
		var entity = query.max((e) -> e.get(Energy).value);

		if (entity == null)
		{
			return null;
		}

		var energy = entity.get(Energy);

		if (!energy.hasEnergy)
		{
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		return entity;
	}

	public static function ConsumeEnergy(entity:Entity, type:EnergyActionType):Int
	{
		var cost = GetEnergyCost(entity, type);
		entity.fireEvent(new ConsumeEnergyEvent(cost));
		return cost;
	}

	public static function GetEnergyCost(entity:Entity, type:EnergyActionType):Int
	{
		if (type == ACT_MOVE)
		{
			return 100;
		}

		if (type == ACT_WAIT)
		{
			return 250;
		}

		return 50;
	}
}
