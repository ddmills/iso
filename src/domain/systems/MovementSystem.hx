package domain.systems;

import common.algorithm.Distance;
import core.Frame;
import domain.components.Move;
import domain.components.MoveCompleted;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class MovementSystem extends System
{
	var movers:Query;
	var moved:Query;
	var completed:Query;

	public function new()
	{
		movers = new Query({
			all: [Move],
			none: [MoveCompleted]
		});

		movers.onEntityAdded((e) ->
		{
			var move = e.get(Move);

			move.start = e.drawable.pos ?? e.pos;
			move.startTime = game.frame.elapsed;

			if (e.drawable.pos == null)
			{
				e.drawable.pos = e.pos;
			}

			e.pos = move.goal;
		});

		completed = new Query({
			all: [MoveCompleted],
			none: [],
		});
	}

	public override function update(frame:Frame)
	{
		for (entity in completed)
		{
			entity.remove(MoveCompleted);
		}

		for (entity in movers)
		{
			var move = entity.get(Move);

			if (entity.drawable.pos == null)
			{
				entity.drawable.pos = move.start;
			}

			var current = entity.drawable.pos;
			var distanceSq = Distance.EuclideanSq(current, move.goal);

			var currentDuration = frame.elapsed - move.startTime;
			var progress = (currentDuration / move.duration).clamp(0, 1);

			var newPos = move.start.ease(move.goal, progress, move.ease);

			entity.drawable.pos = newPos;

			if (distanceSq < (move.epsilon * move.epsilon))
			{
				entity.drawable.pos = null;
				entity.remove(move);
				entity.add(new MoveCompleted());
			}
		}
	}
}
