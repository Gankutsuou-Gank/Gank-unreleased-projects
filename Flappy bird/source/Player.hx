package;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public static var dead:Bool = false;
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/bird.png", true, 17, 12);
        animation.add("flap",[0,1,2],7);
		antialiasing = false;
		maxVelocity.y = 500;
		drag.y = 1600;
        animation.play("flap");
		// setSize(16, 16);
		// offset.set(8, 8);
	}
    override public function update(elapsed:Float) {
        super.update(elapsed);
		updateHitbox();
	
        if(PlayState.firstTap && !dead && !PlayState.pauseBtnOverlap)
            updateMovement();
		if(dead)
			{
				animation.stop();
				if (velocity.y <= 1)
					{
						acceleration.y = 700;
					}
			
					if (velocity.y < 0 && angle > 90)
					{
						angle -= 1;
					}
					else if (angle < 90 && acceleration.y > 0)
					{
						angle += 3;
					}
					else if (angle > 0 && acceleration.y < 700)
					{
						angle -= 3;
					}
			}
			
    }
	public function updateMovement()
	{
		var jump:Bool = false;
		jump = FlxG.keys.anyJustPressed([SPACE]) || FlxG.mouse.justPressed;

		if (jump && !dead)
		{
			FlxG.sound.play("assets/sounds/flap.ogg");
			velocity.y = -250;
			!jump;
			if(angle != -45)
				angle = -45;
		}
		else if (velocity.y <= 1)
		{
			acceleration.y = 700;
		}

		if (velocity.y < 0 && angle > 45)
		{
			angle -= 1;
		}
		else if (angle < 90 && acceleration.y > 0)
		{
			angle += 3;
		}
		else if (angle > 45 && acceleration.y < 700)
		{
			angle -= 3;
		}
	}
}