package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import haxe.Log;

class Player extends FlxSprite
{
	private var jump_sfx:FlxSound;
	var GRAVITY = 600;

	public static var dead:Bool = false;

	public function new(x:Int, y:Int):Void
	{
		super(x, y);

		frames = FlxAtlasFrames.fromSparrow('assets/images/dino.png', 'assets/images/dino.xml');

		animation.addByPrefix("run1", "dino-running0", 15);
		animation.addByPrefix("jump1", "dino-jump0", 15);
		animation.addByPrefix("duck1", "dino-duck0", 15);
		animation.addByPrefix("dead1", "dino-dead0", 15);

		if (!dead)
		{
			maxVelocity.y = 550;
			acceleration.y = 725;
			// drag.y = 1000;
		}

		jump_sfx = FlxG.sound.load("assets/sounds/jump.ogg", 1, false);
		updateHitbox();
	}

	var ducking = false;
	var up:Bool = false;
	var down:Bool = false;

	override public function update(elapsed:Float):Void
	{
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		updateHitbox();
		if (!dead)
		{
			if (up && isTouching(FLOOR) && !down)
			{
				jump_sfx.play();
				velocity.y = (-maxVelocity.y / 1.6);
				animation.play("jump1");
			}
			// c8c8c8
			else if (down && !up)
			{
				animation.play("duck1");
				ducking = true;
				velocity.y = maxVelocity.y / 2;
			}
			if (FlxG.keys.anyJustReleased([DOWN, SPACE, UP]))
			{
				ducking = false;
				animation.play("run1");
			}

			if (!ducking)
				if (PlayState.onEarth)
					animation.play("run1");
				else
					animation.play("jump1");
		}
		else
		{
			velocity.x = 0;
			velocity.y = 0;
			animation.play("dead1");
		}

		super.update(elapsed);
	}
}
