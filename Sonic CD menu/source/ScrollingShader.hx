import flixel.system.FlxAssets.FlxShader;

typedef ParallaxSplit =
{
	SplitY:Float,
	Speed:Float
}

class ScrollingShader extends FlxShader
{
	@:glFragmentSource("
	#pragma header
	// x : 0 = false, 1 = true
	// y : position of splity on y axis
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
		x -= (splitA.z / openfl_TextureSize.x) * when_lt(openfl_TextureCoordv.y, splitA.y) * when_eq(splitA.x, 1.0);
		x -= (splitB.z / openfl_TextureSize.x) * when_lt(openfl_TextureCoordv.y, splitB.y) * when_eq(splitB.x, 1.0) * when_gt(openfl_TextureCoordv.y, splitA.y);
		x -= (splitC.z / openfl_TextureSize.x) * when_lt(openfl_TextureCoordv.y, splitC.y) * when_eq(splitC.x, 1.0) * when_gt(openfl_TextureCoordv.y, splitB.y);
		x -= (splitD.z / openfl_TextureSize.x) * when_lt(openfl_TextureCoordv.y, splitD.y) * when_eq(splitD.x, 1.0) * when_gt(openfl_TextureCoordv.y, splitC.y);
		gl_FragColor = flixel_texture2D(bitmap, vec2(wrap(x), openfl_TextureCoordv.y));
	}
	")
	var splitDefinitions:Array<ParallaxSplit>;

	public function new()
	{
		super();
		var imageHeight = 256;

		splitDefinitions = [
			{SplitY: calculateShaderCoord(52, imageHeight), Speed: 15.0},
			{SplitY: calculateShaderCoord(93, imageHeight), Speed: 20.0},
			{SplitY: calculateShaderCoord(134, imageHeight), Speed: 25.0},
			{SplitY: calculateShaderCoord(175, imageHeight), Speed: 30.0},
			{SplitY: calculateShaderCoord(216, imageHeight), Speed: 35.0},
			{SplitY: calculateShaderCoord(257, imageHeight), Speed: 40.0}
		];

		splitA.value = [0, 0, 0];
		splitA.value[0] = 1;
		splitA.value[1] = splitDefinitions[0].SplitY;
		splitA.value[2] = splitDefinitions[0].Speed;

		splitB.value = [0, 0, 0];
		splitB.value[0] = 1;
		splitB.value[1] = splitDefinitions[1].SplitY;
		splitB.value[2] = splitDefinitions[1].Speed;

		splitC.value = [0, 0, 0];
		splitC.value[0] = 1;
		splitC.value[1] = splitDefinitions[2].SplitY;
		splitC.value[2] = splitDefinitions[2].Speed;

		splitD.value = [0, 0, 0];
		splitD.value[0] = 1;
		splitD.value[1] = splitDefinitions[3].SplitY;
		splitD.value[2] = splitDefinitions[3].Speed;
	}

	function calculateShaderCoord(pixelPosition:Int, imageSize:Int):Float
	{
		return pixelPosition / imageSize;
	}

	public function update(elapsed:Float)
	{
		splitA.value[2] += (elapsed * splitDefinitions[0].Speed);
		splitB.value[2] += (elapsed * splitDefinitions[1].Speed);
		splitC.value[2] += (elapsed * splitDefinitions[2].Speed);
		splitD.value[2] += (elapsed * splitDefinitions[3].Speed);
	}
}
