package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import lime.utils.Assets;

class SoundTestState extends FlxState
{
	var red:Bool = false;
	var flashSpr:FlxSprite;
	var blackSpr:FlxSprite;
	var the:Bool = true;
	var the2:Bool = false;
	var the3:Bool = false;
	var elCooldown:Bool = true;
	var dumbassCooldown:Bool = true;
	var daValue:Int = 0;
	var fm = new FlxText(28, 154, 0, 'FM  NO .', 20);
	var fmNum = new FlxText(140, 155, 0, '0', 20);
	var fmValue:Int = 0;
	var pcmNum = new FlxText(0, 155, 0, '0', 20);
	var pcm = new FlxText(0, 154, 0, 'PCM  NO .', 20);
	var pcmValue:Int = 0;
	var daNum = new FlxText(0, 155, 0, '0', 20);
	var da = new FlxText(0, 154, 0, 'DA  NO .', 20);
	var thing:Array<String> = ['a'];
	var soundtesttext = new FlxText(0, 0, 0, 'SOUND TEST', 25);

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-100).loadGraphic('assets/images/soundTestBG.png');

		bg.scale.set(2.2, 2.2);
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		// bg
		fm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
		fm.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

		fm.scale.set(0.7, 0.7);
		fmNum.alignment = "right";
		fmNum.scale.set(0.7, 0.7);
		add(fm);
		add(fmNum);
		// fm
		pcm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
		pcm.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);
		pcm.scale.set(0.7, 0.7);
		pcm.x = fm.x + 180;
		pcmNum.scale.set(0.7, 0.7);
		pcmNum.x = fmNum.x + 205;
		pcmNum.alignment = "right";
		add(pcm);
		add(pcmNum);

		daNum.x = pcmNum.x + 180;
		daNum.alignment = "right";

		da.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
		da.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);
		da.x = pcm.x + 205;

		da.scale.set(0.7, 0.7);
		daNum.scale.set(0.7, 0.7);
		add(daNum);
		add(da);
		// da

		soundtesttext.screenCenter();
		soundtesttext.y -= 150;
		soundtesttext.x -= 33;
		soundtesttext.scale.x = 0.7;
		soundtesttext.scale.y = 0.7;
		soundtesttext.setFormat("Sonic CD Menu Font Regular", 25, FlxColor.fromString("#00a3ff"));
		soundtesttext.setBorderStyle(SHADOW, FlxColor.BLACK, 4, 1);
		add(soundtesttext);

		flashSpr = new FlxSprite();
		flashSpr.makeGraphic(1280, 720, FlxColor.WHITE);
		flashSpr.alpha = 0;
		add(flashSpr);
		// flash
	}

	function flash()
	{
		FlxTween.tween(flashSpr, {alpha: 1}, 0.4);
	}

	function switchNum(selection:Int)
	{
		if (the)
		{
			//
			fmValue += selection;
			if (fmValue < 0)
				fmValue = 99;
			if (fmValue > 99)
				fmValue = 0;
		}
		else if (the2)
		{
			//
			pcmValue += selection;
			if (pcmValue < 0)
				pcmValue = 99;
			if (pcmValue > 99)
				pcmValue = 0;
		}
		else if (the3)
		{
			daValue += selection;
			if (daValue < 0)
				daValue = 99;
			if (daValue > 99)
				daValue = 0;
		}
	}

	function transitionThingy(firstNum:Int, secondNum:Int, thirdNum:Int)
	{
		if (firstNum == 46 && secondNum == 12 && thirdNum == 25)
		{
			elCooldown = false;
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			flash();
			FlxG.sound.playMusic(AssetPaths.sound__ogg, 1, false);
			new FlxTimer().start(2, function(the:FlxTimer)
			{
				FlxG.switchState(new Majin());
			});
		}
		else if (firstNum == 1 && secondNum == 99 && thirdNum == 7)
		{
			elCooldown = false;
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			flash();
			FlxG.sound.playMusic(AssetPaths.sound__ogg, 1, false);
			new FlxTimer().start(2, function(the:FlxTimer)
			{
				FlxG.switchState(new Spamton());
			});
		}
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			MainMenu.selectedSomethin = false;
			FlxG.switchState(new MainMenu());
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			if (elCooldown)
			{
				if (the)
				{
					the = !the;
					the2 = true;
				}
				else if (the2)
				{
					the2 = !the2;
					the3 = true;
				}
				else if (the3)
				{
					the3 = !the3;
					the = true;
				}
			}
		}
		//
		if (FlxG.keys.justPressed.LEFT)
		{
			if (elCooldown)
			{
				if (the)
				{
					the = !the;
					the3 = true;
				}
				else if (the2)
				{
					the2 = !the2;
					the = true;
				}
				else if (the3)
				{
					the3 = !the3;
					the2 = true;
				}
			}
		}

		fmNum.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
		fmNum.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

		daNum.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
		daNum.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

		pcmNum.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
		pcmNum.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

		if (FlxG.keys.justPressed.ENTER && elCooldown)
			transitionThingy(fmValue, pcmValue, daValue);

		if (fmValue < 10)
			fmNum.text = '0' + Std.string(fmValue);
		else
			fmNum.text = Std.string(fmValue);

		if (pcmValue < 10)
			pcmNum.text = '0' + Std.string(pcmValue);
		else
			pcmNum.text = Std.string(pcmValue);

		if (daValue < 10)
			daNum.text = '0' + Std.string(daValue);
		else
			daNum.text = Std.string(daValue);

		if (FlxG.keys.justPressed.UP)
		{
			if (elCooldown)
			{
				switchNum(1);
			}
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			if (elCooldown)
			{
				switchNum(-1);
			}
		}

		if (the)
		{
			fm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#feae00"));
			fm.setBorderStyle(SHADOW, FlxColor.fromString("#fd2403"), 4, 1);

			pcm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
			pcm.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

			da.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
			da.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);
		}
		else if (the2)
		{
			fm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
			fm.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

			pcm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#feae00"));
			pcm.setBorderStyle(SHADOW, FlxColor.fromString("#fd2403"), 4, 1);

			da.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
			da.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);
		}
		else if (the3)
		{
			fm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
			fm.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);

			da.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#feae00"));
			da.setBorderStyle(SHADOW, FlxColor.fromString("#fd2403"), 4, 1);

			pcm.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromString("#aeb3fb"));
			pcm.setBorderStyle(SHADOW, FlxColor.fromString("#6a6e9f"), 4, 1);
		}

		super.update(elapsed);
	}
}
