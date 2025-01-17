package domain;

import core.Frame;
import domain.systems.DebugInfoSystem;
import domain.systems.SpriteSystem.SpriteSytem;

class SystemManager
{
	public var debugInfo(default, null):DebugInfoSystem;
	public var sprites(default, null):SpriteSytem;

	public function new() {}

	public function initialize()
	{
		debugInfo = new DebugInfoSystem();
		sprites = new SpriteSytem();
	}

	public function update(frame:Frame)
	{
		debugInfo.update(frame);
		sprites.update(frame);
	}

	public function teardown()
	{
		debugInfo.teardown();
		sprites.teardown();
	}
}
