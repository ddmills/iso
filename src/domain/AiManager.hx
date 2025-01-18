package domain;

import domain.systems.EnergySystem;
import ecs.Entity;

class AIManager
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		trace('Enemy turn [ACT_WAIT]');
		EnergySystem.ConsumeEnergy(entity, ACT_WAIT);

		// var behaviour = Behaviours.Get(actor.behaviour);
		// behaviour.takeAction(entity);
	}
}
