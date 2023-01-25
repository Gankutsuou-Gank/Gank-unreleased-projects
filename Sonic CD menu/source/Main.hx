package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	var fpsCounter:FPS;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		fpsCounter.visible = false;

		FlxG.save.data.jp = true;
		FlxG.save.data.us = false;
	}
}
