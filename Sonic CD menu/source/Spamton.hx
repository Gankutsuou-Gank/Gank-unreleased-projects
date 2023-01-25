package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;

class Spamton extends FlxState
{
	var spamtonBG = new FlxSprite(159, 49);

	override public function create()
	{
		var spamton = new FlxBackdrop("assets/images/spamton.png", 1, 1, true, true, 2, 2);

		spamton.scale.set(2, 2);
		spamton.cameras = [FlxG.camera];
		spamton.velocity.set(75, 75);
		add(spamton);

		spamtonBG.loadGraphic("assets/images/bgSpamton.png", false, 150, 67);
		spamtonBG.scale.set(2, 2);
		spamtonBG.antialiasing = false;
		add(spamtonBG);

		FlxG.sound.playMusic(AssetPaths.spam__ogg, 1, true);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
