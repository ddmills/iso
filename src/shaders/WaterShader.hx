package shaders;

import hxsl.Shader;

class WaterShader extends Shader
{
	static var SRC =
		{
			@input var input:
				{
					var position:Vec2;
					var uv:Vec2;
					var color:Vec4;
				};
			var pixelColor:Vec4;
			var calculatedUV:Vec2;
			@global var time:Float;
			@param var texture:Sampler2D;
			@param var wpos:Vec3;
			function fragment()
			{
				var speed = 2;

				var disp = ((sin((time * speed) + (((wpos.y - 10) + calculatedUV.y) * 7)) + 1) * .04) + .05;
				var uv = calculatedUV - vec2(0, disp);
				var tex = texture.get(uv);
				pixelColor.a = floor(tex.a);
				pixelColor.rgb = tex.rgb;
			}
		};
}
