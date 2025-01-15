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
				var speed = 1;
				var intensity1 = .025;
				var intensity2 = .025;
				var frequency1 = 1;
				var frequency2 = 7;
				var vert_offset = .04;

				var disp1 = ((sin((time * speed) + ((wpos.y + input.uv.y) * frequency1)) + 1) * intensity1) + vert_offset;
				var disp2 = ((sin((time * speed * 2) + ((wpos.y + input.uv.y) * frequency2)) + 1) * intensity2);

				var uv = input.uv - vec2(0, disp1 + disp2);

				var scaled_uv = uv * uvPos.zw + uvPos.xy;
				var tex = texture.get(scaled_uv);

				pixelColor.rgba = tex.rgba;
			}
		};
}
