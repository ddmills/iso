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
			@borrow(h3d.shader.Base2d) var texture:Sampler2D;
			@borrow(h3d.shader.Base2d) var uvPos:Vec4;
			@param var wpos:Vec3;
			function fragment()
			{
				var uv_in = input.uv;

				var surface_x = uv_in.x;
				var surface_y = clamp((((uv_in.y) - .25) * 1.5) * 1.25, 0, 1);

				var local_x = clamp((surface_x + surface_y - .5), 0, 1);
				var local_y = clamp((surface_y - surface_x) + .5, 0, 1);

				var world_x = wpos.x + local_x;
				var world_y = wpos.y + local_y;

				var speed = 1;
				var vert_offset = .04;

				var x_factor = 1;
				var y_factor = .5;

				var wave_clamped = (sin((time * speed) + (world_y * y_factor) + (world_x * x_factor)) + 1) / 2;

				var displacement = wave_clamped / 24;

				var uv = uv_in - vec2(0, displacement + vert_offset);

				var scaled_uv = uv * uvPos.zw + uvPos.xy;
				var tex = texture.get(scaled_uv);

				pixelColor.rgba = tex.rgba;
				// pixelColor.a = 0;//min(tex.a, .01);

				// pixelColor.rgba = texture.get((uv_in - vec2(0, .2)) * uvPos.zw + uvPos.xy);

				// pixelColor.r = (world_x / 16) % 1;
				// pixelColor.g = (world_y / 16) % 1;
				// pixelColor.b = 0;
			}
		};
}
