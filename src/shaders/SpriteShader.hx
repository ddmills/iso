package shaders;

import hxsl.Shader;
import hxsl.Types.Texture;

class SpriteShader extends Shader
{
	static var SRC =
		{
			@borrow(BaseShader) var renderHeight:Int;
			@param var heightTexture:Sampler2D;
			@param var pos:Vec3;
			@input var input:
				{
					var position:Vec2;
					var uv:Vec2;
					var color:Vec4;
				};
			var output:
				{
					var position:Vec4;
					var color:Vec4;
				};
			var pixelColor:Vec4;
			function fragment()
			{
				var height_raw = heightTexture.get(input.uv);
				var height = pos.z + (height_raw.r / 0.0392156863);

				if (renderHeight == 1)
				{
					output.color.rgba = vec4(0, 0, height / 5, pixelColor.a);
				}
				else
				{
					output.color = pixelColor.rgba;
				}
			}
		};

	public function new()
	{
		super();
		heightTexture = Texture.fromColor(0, 0);
	}
}
