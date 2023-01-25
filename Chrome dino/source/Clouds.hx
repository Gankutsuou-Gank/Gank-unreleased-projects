package;

import flixel.tile.FlxTileblock;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import haxe.Log;

class Clouds extends FlxSprite {
	public function new(x:Int):Void {
		super(x);
        loadGraphic("assets/images/cloud.png");
        velocity.x = -50;
        y = FlxG.random.float(76,173);
	}

    function onUpdate(elapsed:Float) {
       
        super.update(elapsed);
    }
}
