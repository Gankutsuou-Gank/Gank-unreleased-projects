package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Pipe extends FlxSprite
{
    var topPipe:FlxSprite;
    var bottomPipe:FlxSprite;
   	public function new()
	{
		super();
		var rnd = FlxG.random.int(0,5);
        var yValues = [
            [260,-260],[295,-225],[373,-147],[424,-96],[488,-32],[256,-264]
        ];    
        topPipe = new FlxSprite(435,yValues[rnd][1]).loadGraphic("assets/images/top-pipe.png");
        topPipe.scale.set(3,3);
        topPipe.updateHitbox();
        bottomPipe = new FlxSprite(435,yValues[rnd][0]).loadGraphic("assets/images/bottom-pipe.png");
        bottomPipe.scale.set(3,3);
        bottomPipe.updateHitbox();
	}
    override public function update(elapsed:Float) {
        super.update(elapsed);
		
    }
}