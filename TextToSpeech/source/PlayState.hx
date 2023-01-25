package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.app.Application;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.net.FileReference;
#if (cpp && desktop)
import Discord.DiscordClient;
#end

class PlayState extends FlxState
{
	var topBox:FlxInputText;

	var sped:Float = 1;

	var spdTxt:FlxText;

	var plusButton:FlxButton;

	var minusButton:FlxButton;

	var speakButton:FlxButton;

	var text:String = 'text';
	var checkBox:FlxUICheckBox;

	var fileName:FlxInputText;

	var exportBtn:FlxButton;
	var fileNameTxt = 'filename';

	override public function create()
	{
		super.create();
		FlxG.camera.bgColor = FlxColor.fromString("#404040");

		topBox = new FlxInputText(0, 50, 500, text, 36, FlxColor.BLACK, FlxColor.WHITE, true);
		topBox.antialiasing = false;
		topBox.screenCenter(X);
		add(topBox);

		spdTxt = new FlxText(topBox.x, topBox.y + 50, 0, '1', 24);
		// spdTxt.color = FlxColor.BLACK;
		spdTxt.antialiasing = false;
		spdTxt.screenCenter(X);
		add(spdTxt);

		plusButton = new FlxButton(spdTxt.x + 50, spdTxt.y + 35, '+', function()
		{
			if (sped < 10)
				sped += 1;
		});
		plusButton.loadGraphic(AssetPaths.button__png, true, 20, 20);
		add(plusButton);

		minusButton = new FlxButton(spdTxt.x - 55, spdTxt.y + 35, '-', function()
		{
			if (sped > 1)
				sped -= 1;
		});
		minusButton.loadGraphic(AssetPaths.button__png, true, 20, 20);
		add(minusButton);

		speakButton = new FlxButton(spdTxt.x + 50, spdTxt.y + 35, 'speak', speak);
		// speakButton.loadGraphic(AssetPaths.button__png, true, 20, 20);
		speakButton.screenCenter(X);
		add(speakButton);

		checkBox = new FlxUICheckBox(75, 300, null, null, 'export file');
		add(checkBox);

		fileName = new FlxInputText(0, 325, 500, fileNameTxt, 24, FlxColor.BLACK, FlxColor.WHITE, true);
		fileName.antialiasing = false;
		fileName.screenCenter(X);
		add(fileName);
		//

		exportBtn = new FlxButton(0, 375, 'export', export);
		exportBtn.screenCenter(X);
		// speakButton.loadGraphic(AssetPaths.button__png, true, 20, 20);
		exportBtn.screenCenter(X);
		add(exportBtn);
	}

	override public function update(elapsed:Float)
	{
		spdTxt.updateHitbox();
		spdTxt.screenCenter(X);
		text = topBox.text;
		fileNameTxt = fileName.text;
		spdTxt.text = '${sped}';
		super.update(elapsed);
	}

	function export()
	{
		if (checkBox.checked)
		{
			// haven't implemented that yet but it's supposed to export a text file, read it then export it as audio
			// as an example "speak file "c:\temp\speak1.txt" 0 100 "c:\temp\speak.wav" 48kHz16BitStereo" - from the nircmd wiki
		}
	}

	function speak()
	{
		#if desktop
		Sys.command('nircmd speak text "${text}" ${sped}');
		#end
	}
}
