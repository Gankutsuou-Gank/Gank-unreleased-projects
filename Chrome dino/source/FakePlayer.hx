package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import haxe.Log;

class FakePlayer extends FlxSprite {

	private var fc:Float;
	private var ft:Float;
	private var my:Float;
	public static var acc:Float = 10;

	public function new(x:Int, y:Int):Void {
		super(x, y);

		acceleration.x = 1;
		acceleration.y = 1200;
		maxVelocity.x = 1000;
		velocity.x = 50;
		fc = 0;
		my = 0;
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void {

		if (acceleration.x <= 0)
			return super.update(elapsed);

		if (velocity.x > 600)
			acceleration.x = acc - 5;

		
		
			// // Running
			// ft = (1 - velocity.x / maxVelocity.x) * 0.35;
			// if (ft < 0.15)
			// 	ft = 0.15;
			// fc += FlxG.elapsed;
			// if (fc > ft) {
			// 	fc = 0;
			// }
		
		super.update(elapsed);

			my += FlxG.elapsed;
	}

}
