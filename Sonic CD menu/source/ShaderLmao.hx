import flixel.system.FlxAssets.FlxShader;

typedef ParSplit =
{
	SpltY:Float,
	Spd:Float
}

class ShaderLmao extends FlxShader
{
	@:glFragmentSource("
	#pragma header
	// x : 0 = false, 1 = true
	// y : position of SpltY on y axis
	// z : amount to scroll by
	uniform vec3 splitA;
	uniform vec3 splitB;
	uniform vec3 splitC;
	uniform vec3 splitD;
	float wrap(float toWrap){
		return mod(toWrap, 1.0);
	}
	
	float when_eq(float a, float b) {
		return 1.0 - abs(sign(a - b));
	}
	float when_lt(float a, float b) {
		return max(sign(b - a), 0.0);
	}
	float when_gt(float a, float b) {
		return max(sign(a - b), 0.0);
	}
	void main()
	{
		float x = openfl_TextureCoordv.x;
		x += (splitA.z / openfl_TextureSize.y) * when_lt(openfl_TextureCoordv.x, splitA.x) * when_eq(splitA.y, 1.0);
		x += (splitB.z / openfl_TextureSize.y) * when_lt(openfl_TextureCoordv.x, splitB.x) * when_eq(splitB.y, 1.0) * when_gt(openfl_TextureCoordv.y, splitA.y);
		x += (splitC.z / openfl_TextureSize.y) * when_lt(openfl_TextureCoordv.x, splitC.x) * when_eq(splitC.y, 1.0) * when_gt(openfl_TextureCoordv.y, splitB.y);
		x += (splitD.z / openfl_TextureSize.y) * when_lt(openfl_TextureCoordv.x, splitD.x) * when_eq(splitD.y, 1.0) * when_gt(openfl_TextureCoordv.y, splitC.y);
		gl_FragColor = flixel_texture2D(bitmap, vec2(wrap(x), openfl_TextureCoordv.y));
	}
	")
	var splitDefinitions:Array<ParSplit>;

	public function new()
	{
		super();
		var imageHeight = 512;

		splitDefinitions = [
			{SpltY: calculateShaderCoord(72, imageHeight), Spd: 0.5},
			{SpltY: calculateShaderCoord(103, imageHeight), Spd: 3.0},
			{SpltY: calculateShaderCoord(191, imageHeight), Spd: 10.0},
			{SpltY: calculateShaderCoord(399, imageHeight), Spd: 30.0}
		];

		splitA.value = [0, 0, 0];
		splitA.value[0] = 1;
		splitA.value[1] = splitDefinitions[0].SpltY;
		splitA.value[2] = splitDefinitions[0].Spd;

		splitB.value = [0, 0, 0];
		splitB.value[0] = 1;
		splitB.value[1] = splitDefinitions[1].SpltY;
		splitB.value[2] = splitDefinitions[1].Spd;

		splitC.value = [0, 0, 0];
		splitC.value[0] = 1;
		splitC.value[1] = splitDefinitions[2].SpltY;
		splitC.value[2] = splitDefinitions[2].Spd;

		splitD.value = [0, 0, 0];
		splitD.value[0] = 1;
		splitD.value[1] = splitDefinitions[3].SpltY;
		splitD.value[2] = splitDefinitions[3].Spd;
	}

	function calculateShaderCoord(pixelPosition:Int, imageSize:Int):Float
	{
		return pixelPosition / imageSize;
	}

	public function update(elapsed:Float)
	{
		splitA.value[2] += (elapsed * splitDefinitions[0].Spd);
		splitB.value[2] += (elapsed * splitDefinitions[1].Spd);
		splitC.value[2] += (elapsed * splitDefinitions[2].Spd);
		splitD.value[2] += (elapsed * splitDefinitions[3].Spd);
	}
}
