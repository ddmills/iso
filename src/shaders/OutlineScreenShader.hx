package shaders;

import h3d.shader.ScreenShader;

class OutlineScreenShader extends ScreenShader
{
	static var SRC =
		{
			@param var texture:Sampler2D;
			@param var heightTexture:Sampler2D;
			@param var pad:Int;
			@global var cameraScale:Float;
			function fragment()
			{
				var raw = heightTexture.get(input.uv);
				var px = texture.get(input.uv);
				var window = heightTexture.size();
				var distX = cameraScale / float(window.x);
				var distY = cameraScale / float(window.y);

				var padX = distX * pad;
				var padY = distY * pad;

				var current = raw.b;
				var above = heightTexture.get(input.uv - vec2(0, padY)).b;
				var below = heightTexture.get(input.uv - vec2(0, -padY)).b;
				var left = heightTexture.get(input.uv - vec2(padX, 0)).b;
				var right = heightTexture.get(input.uv - vec2(-padX, 0)).b;

				var dif = .1;
				var outlineColor = vec4(.05, .075, .25, 1);

				if (above.r - current > dif || below.r - current > dif || left.r - current > dif || right.r - current > dif)
				{
					pixelColor.rgba = mix(px, outlineColor, outlineColor.a);
				}
				else
				{
					pixelColor = px;
				}
			}
		};
}
