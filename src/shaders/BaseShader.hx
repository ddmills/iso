package shaders;

import h3d.shader.Base2d;

class BaseShader extends Base2d
{
	static var SRC =
		{
			@global var renderHeight:Int;
			function fragment()
			{
				if (renderHeight == 1)
				{
					output.color = vec4(0, 0, 0, 0);
				}
				else
				{
					output.color = pixelColor;
				}
			}
		};
}
