package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;


class Cactus extends FlxSprite {
    public var big:Bool = false;
	public function new(x:Int, y:Int):Void {
		super(x, y);

        if(FlxG.random.int(1, 2) == 1)
            big = false;
        else
            big = true;

        if(big)
            {
                frames = FlxAtlasFrames.fromSparrow('assets/images/big.png', 'assets/images/big.xml');
                animation.addByPrefix('big','big00${FlxG.random.int(1, 5)}', 4);
                animation.play('big');
                y =237;
            }
        else
            {
                frames = FlxAtlasFrames.fromSparrow('assets/images/small.png', 'assets/images/small.xml');
                animation.addByPrefix('small','small00${FlxG.random.int(1, 5)}', 4);
                animation.play('small');
                y = 250;
            }
       
            velocity.x = -200;
        updateHitbox();
	}
}
