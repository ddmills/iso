package shaders;

import hxsl.Shader;

class WaterlineShader extends Shader
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
			@param var pos:Vec3;
			@param var size:Vec3;
			@param var origin:Vec2;
			@param var heightTexture:Sampler2D;
			@global var renderHeight:Int;
			function fragment()
			{
				var blockHeightPx = 10;
				var water1 = vec3(35, 84, 101) / 255;
				var foam = vec3(175, 226, 241) / 255;
				var uv_in = input.uv;
				var height_raw = heightTexture.get(uv_in).r;

				// normalize height to 1 = 1 block tall
				var height = pos.z + (height_raw / 0.0392156863);

				if (renderHeight == 1)
				{
					pixelColor.rgb = vec3(0, 0, height) / 5; // , pixelColor.a);
				}
				else
				{
					var shifted_uv = vec2(uv_in.x, uv_in.y + height);

					// local pixel coordinates x/y
					var surface_x = clamp(shifted_uv.x, 0, 1);
					var surface_y = clamp(((shifted_uv.y) * 4 - 3), 0, 1); // why 4 and 3?

					// isometric x/y
					var local_x = clamp((surface_x + surface_y - .5), 0, 1);
					var local_y = clamp((surface_y - surface_x) + .5, 0, 1);

					var local = vec2(local_x, local_y);
					var world = vec3(pos.x + local.x, pos.y + local.y, pos.z);

					var y_wave_factor = 1.2;
					var x_wave_factor = 2;
					var speed = 1;

					var s = (sin((time * speed) + (world.x * x_wave_factor) + (world.y * y_wave_factor)) + 1) / 2; // 0,1
					var nrm = s * .5; // between 0,0.1
					var waterline = 1.7 - nrm;
					var foamline = waterline + .1;

					if (height <= waterline)
					{
						var depth = 1 - (height / waterline);
						pixelColor.rgb = mix(pixelColor.rgb, water1, .45);
						pixelColor.rgb = mix(pixelColor.rgb, water1, min(1, depth * 1.25));
					}
					else if (height <= foamline)
					{
						pixelColor.rgb = mix(pixelColor.rgb, foam, .7);
					}
				}
			}
		};
}
