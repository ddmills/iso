package domain.components;

import common.struct.FloatPoint3;
import common.util.Easing;
import ecs.Component;

enum Tween
{
	LINEAR;
	LERP;
	INSTANT;
}

class Move extends Component
{
	@save public var start:FloatPoint3;
	@save public var goal:FloatPoint3;
	@save public var ease:EasingType;
	@save public var duration:Float;
	@save public var epsilon:Float;

	public var startTime:Float;

	public function new(goal:FloatPoint3, duration:Float = 1., ease:EasingType = EASE_LINEAR, epsilon:Float = .0025)
	{
		this.goal = goal;
		this.ease = ease;
		this.duration = duration;
		this.epsilon = epsilon;
	}
}
