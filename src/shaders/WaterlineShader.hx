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
			function fragment()
			{
				var blockHeightPx = 10;
				var water1 = vec3(66, 119, 135) / 255;
				var foam = vec3(175, 226, 241) / 255;
				var uv_in = input.uv;
				var height_raw = heightTexture.get(uv_in).r;
				var height = height_raw / 0.3137254902; // 0 to 80px high
				// var height = height_raw / (); // 0 to 40px high

				var shifted_uv = vec2(uv_in.x, uv_in.y + height);

				// local pixel coordinates x/y
				var surface_x = clamp(shifted_uv.x, 0, 1);
				var surface_y = clamp(((shifted_uv.y) * 4 - 3), 0, 1); // why 4 and 3?

				// isometric x/y
				var local_x = clamp((surface_x + surface_y - .5), 0, 1);
				var local_y = clamp((surface_y - surface_x) + .5, 0, 1);

				var local = vec2(local_x, local_y);
				var world = vec3(pos.x + local.x, pos.y + local.y, pos.z);

				// pixelColor.g = local_x;
				// pixelColor.r = local_y;
				// pixelColor.b = height;

				var y_wave_factor = 1.2;
				var x_wave_factor = 0;
				var speed = 1;

				var s = (sin((time * speed) + (world.x * x_wave_factor) + (world.y * y_wave_factor)) + 1) / 2; // 0,1
				var nrm = s * .02; // between 0,0.1
				var waterline = .21 - (s * .06);
				// var foamline = waterline + .015;
				var foamline = waterline + .0175;

				if (height <= waterline)
				{
					var depth = 1 - (height / waterline);
					pixelColor.rgb = mix(pixelColor.rgb, water1, .85);
					pixelColor.rgb = mix(pixelColor.rgb, water1, min(1, depth * 1.25));
				}
				else if (height <= foamline)
				{
					var depth = 1 - (height / foamline);
					var x = (pos.x + uv_in.x);
					var y = (pos.y + uv_in.y);
					var speed = 1;
					// var s = (sin(time * speed + world.x + world.y) + 1) / 2; // 0,1

					// pixelColor.rgb = mix(pixelColor.rgb, foam, .25);
					pixelColor.rgb = mix(pixelColor.rgb, foam, (1 - s) * .4);
				}

				// pixelColor.rgb = vec3(0, 0, 0);

				var origin = vec2(0.5, 0.8625);
				var tileSize = vec2(40, 20);
				var size = uvPos.zw * texture.size();

				// var surface_x = uv_in.x;
				// var surface_y = clamp(((((uv_in.y) - .25) * 1.5) + h_uv_offset) * 1.25, 0, 1);

				// var blockSize = vec2(40)
				// var size = vec2(40, 80);
				// var px = uv_in * size;

				// var iso_x = (px.y / 10 + (px.x / 20)) / 2;
				// var iso_y = (px.y / 10 - (px.x / 20)) / 2;

				// pixelColor.a = 1;

				// var world_x = pos.x + local_x;
				// var world_y = pos.y + local_y;

				// var speed = 1;
				// var vert_offset = .2;

				// var x_factor = 1;
				// var y_factor = 0;

				// var wave_clamped = 1 - ((sin((time * speed) + (world_y * y_factor) + (world_x * x_factor)) + 1) / 2);

				// var displacement = wave_clamped / 8;

				// var uv = uv_in; // - vec2(0, displacement + vert_offset);

				// var scaled_uv = uv * uvPos.zw + uvPos.xy;
				// var tex = texture.get(scaled_uv);

				// // pixelColor.rgba = tex.rgba;

				// var waterline = clamp(wave_clamped, 0, 1);

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

				// var water = vec3(.137, .329, .396);
				// pixelColor = tex;
				// // pixelColor.r = h - displacement;
				// // pixelColor.g = 0;
				// // pixelColor.b = 0;

				// if (h_uv_offset < displacement)
				// {
				// 	pixelColor.rgb = mix(water, tex.rgb, h_uv_offset - displacement);
				// 	pixelColor.a = h_uv_offset - displacement;
				// }
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
