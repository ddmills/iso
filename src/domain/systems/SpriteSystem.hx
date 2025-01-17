package domain.systems;

import domain.components.Drawable;
import domain.components.Sprite;
import ecs.Query;
import ecs.System;

class SpriteSytem extends System
{
	public var debug(default, set):Bool = false;

	var sprites:Query;

	public function new()
	{
		sprites = new Query({
			all: [Sprite]
		});

		sprites.onEntityAdded((e) -> renderDrawable(e.drawable));
		sprites.onEntityRemoved((e) -> removeDrawable(e.drawable));
	}

	private function renderDrawable(drawable:Drawable)
	{
		trace('render');
		if (drawable != null)
		{
			trace('here!');
			// game.render(drawable.layer, drawable.drawable);
			world.map.ob.add(drawable.ob, 0);
			drawable.debug = debug;
		}
	}

	private function removeDrawable(drawable:Drawable)
	{
		if (drawable != null)
		{
			drawable.ob.remove();
		}
	}

	function set_debug(value:Bool):Bool
	{
		debug = value;

		for (e in sprites)
		{
			if (e.drawable != null)
			{
				e.drawable.debug = value;
			}
		}

		return value;
	}
}
