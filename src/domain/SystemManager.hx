package domain;

import core.Frame;
import domain.systems.DebugInfoSystem;
import domain.systems.EnergySystem;
import domain.systems.MovementSystem;
import domain.systems.SpriteSystem.SpriteSytem;

class SystemManager
{
	public var debugInfo(default, null):DebugInfoSystem;
	public var sprites(default, null):SpriteSytem;
	public var energy(default, null):EnergySystem;
	public var movement(default, null):MovementSystem;

	public function new() {}

	public function initialize()
	{
		debugInfo = new DebugInfoSystem();
		sprites = new SpriteSytem();
		energy = new EnergySystem();
		movement = new MovementSystem();
	}

	public function update(frame:Frame)
	{
		debugInfo.update(frame);
		sprites.update(frame);
		energy.update(frame);
		movement.update(frame);
	}

	public function teardown()
	{
		debugInfo.teardown();
		sprites.teardown();
		energy.teardown();
		movement.teardown();
	}
}
