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
			@param var wpos:Vec3;
			@param var heightTexture:Sampler2D;
			function fragment()
			{
				var uv_in = input.uv;
				var h = heightTexture.get(uv_in).r;

				var h_uv_offset = h - 0.34375;
				// var h_uv_offset = h - 0.33;

				var surface_x = uv_in.x;
				var surface_y = clamp(((((uv_in.y) - .25) * 1.5) + h_uv_offset) * 1.25, 0, 1);

				var local_x = clamp((surface_x + surface_y - .5), 0, 1);
				var local_y = clamp((surface_y - surface_x) + .5, 0, 1);

				var world_x = wpos.x + local_x;
				var world_y = wpos.y + local_y;

				var speed = 1;
				var vert_offset = .2;

				var x_factor = 1;
				var y_factor = 0;

				var wave_clamped = 1 - ((sin((time * speed) + (world_y * y_factor) + (world_x * x_factor)) + 1) / 2);

				var displacement = wave_clamped / 8;

				var uv = uv_in; // - vec2(0, displacement + vert_offset);

				var scaled_uv = uv * uvPos.zw + uvPos.xy;
				var tex = texture.get(scaled_uv);

				// pixelColor.rgba = tex.rgba;

				var waterline = clamp(wave_clamped, 0, 1);

				// if (tex.a > 0 && h < waterline)
				// {
				// 	pixelColor.a = 1;
				// 	pixelColor.r = h;
				// 	pixelColor.g = 0;
				// 	pixelColor.b = 0;
				// }
				// else
				// {
				// 	pixelColor.r = local_y;
				// 	pixelColor.g = 0;
				// 	pixelColor.b = local_x;
				// }

				var water = vec3(.137, .329, .396);
				pixelColor = tex;
				// pixelColor.r = h - displacement;
				// pixelColor.g = 0;
				// pixelColor.b = 0;

				if (h_uv_offset < displacement)
				{
					pixelColor.rgb = mix(water, tex.rgb, h_uv_offset - displacement);
					pixelColor.a = h_uv_offset - displacement;
				}
			}
		};
}
// WORKING FOR TILES!
// var uv_in = input.uv;
// var h = heightTexture.get(uv_in).r;
// var h_uv_offset = h - 0.34375;
// // var h_uv_offset = h - 0.33;
// var surface_x = uv_in.x;
// var surface_y = clamp(((((uv_in.y) - .25) * 1.5) + h_uv_offset) * 1.25, 0, 1);
// var local_x = clamp((surface_x + surface_y - .5), 0, 1);
// var local_y = clamp((surface_y - surface_x) + .5, 0, 1);
// var world_x = wpos.x + local_x;
// var world_y = wpos.y + local_y;
// var speed = 1;
// var vert_offset = .1;
// var x_factor = .2;
// var y_factor = 1;
// var wave_clamped = (sin((time * speed) + (world_y * y_factor) + (world_x * x_factor)) + 1) / 2;
// var displacement = wave_clamped / 10;
// var uv = uv_in; // - vec2(0, displacement + vert_offset);
// var scaled_uv = uv * uvPos.zw + uvPos.xy;
// var tex = texture.get(scaled_uv);
