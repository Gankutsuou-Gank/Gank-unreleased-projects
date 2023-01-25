package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;


class Bird extends FlxSprite {
	public function new(x:Int, y:Int):Void {
		super(x, y);
        loadGraphic('assets/images/bird-flying.png',true,46,50);
        animation.add("fly1",[0,1],4);
        animation.play('fly1');
        velocity.x = -300;
        // y = 229;
        updateHitbox();
	}
}
