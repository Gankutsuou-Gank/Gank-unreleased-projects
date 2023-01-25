package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxTiledSprite;
import flixel.effects.FlxFlicker;
import flixel.system.FlxSound;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TitleState extends FlxState
{
	var canEnter:Bool = false;
	var sonic:FlxSprite;
	var bg:FlxSprite;
	var pressStart:FlxSprite;
	var wotah:FlxSprite;
	var shader:ScrollingShader;
	var shader2:ShaderLmao;
	var clouds:FlxSprite;
	var appearing = false;

	var elSound:FlxSound;

	override public function create()
	{
		FlxG.save.bind("gank.FlxSCD");
		elSound = FlxG.sound.load("assets/sounds/sndTitleScreen.mp3", 1);
		shader = new ScrollingShader();
		shader2 = new ShaderLmao();
		// FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
		wotah = new FlxSprite(191, 398);
		wotah.loadGraphic("assets/images/Water.png", false, FlxG.width, 200);
		wotah.shader = shader;
		wotah.visible = false;
		wotah.scale.set(2.5, 2.5);

		// wotah.scrollX = 5;
		// wotah.scrollY = 5;

		var scalemode = new FillScaleMode();

		scalemode.gameSize.set(740, 550);
		FlxG.scaleMode = scalemode;
		#if desktop
		FlxG.resizeWindow(740, 550);
		#end
		// }
		sonic = new FlxSprite(0, 0);
		sonic.loadGraphic("assets/images/title2.png", true, 250, 195);

		sonic.animation.add("appear", [0, 1, 2, 3, 4], 12, false);
		sonic.animation.add("stay2", [0, 0, 0, 0, 0], 6, false);
		sonic.animation.add("stay", [5], 1, false);
		sonic.animation.add("idle", [5], 1, false);
		sonic.animation.add("point", [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 15, false);

		sonic.animation.play("stay2", false);
		sonic.scale.set(2, 2);
		sonic.x = 195;
		sonic.y = 132;
		bg = new FlxSprite(0, 0);
		bg.loadGraphic("assets/images/BG.png", false, 0, -100);
		bg.scale.set(2.5, 2.5);

		bg.screenCenter(XY);

		bg.alpha = 0;

		add(bg);
		add(wotah);

		add(sonic);

		pressStart = new FlxSprite(sonic.x, sonic.y + 50);
		pressStart.loadGraphic("assets/images/pressStart.png", false);
		pressStart.scale.set(1.7, 1.7);
		pressStart.antialiasing = false;
		pressStart.screenCenter(X);

		pressStart.y = sonic.y + 270;
		pressStart.visible = false;

		add(pressStart);
		if (sonic.animation.curAnim.name == 'appear' && sonic.animation.curAnim.finished) {}
		FlxG.autoPause = true;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		shader.update(elapsed);

		if (canEnter)
		{
			if (FlxG.keys.anyJustPressed([SPACE, ENTER, Z]))
			{
				FlxG.sound.play(Paths.sound('confirm'));
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.sound.music.fadeOut(1, 0);

					new FlxTimer().start(2, function(elTimer:FlxTimer)
					{
						FlxG.switchState(new MainMenu());
					});
				});
			}
			if (!pressStart.visible)
			{
				new FlxTimer().start(0.7, function(tmr:FlxTimer)
				{
					pressStart.visible = true;
				}, 0);
			}
			else if (pressStart.visible)
			{
				new FlxTimer().start(0.7, function(tmr2:FlxTimer)
				{
					pressStart.visible = false;
				}, 0);
			}
		}
		// var scrollShit:Float = FlxG.height * 0.3 * 0.25 *;
		if (sonic.animation.curAnim.name == 'stay2' && sonic.animation.curAnim.finished)
		{
			FlxG.sound.playMusic("assets/music/titleScreen.ogg", 1, false);
			sonic.animation.play("appear", false);
		}
		else if (sonic.animation.curAnim.name == 'appear' && sonic.animation.curAnim.finished)
		{
			appearing = true;
			FlxG.camera.flash(FlxColor.WHITE, 0.5, function()
			{
				bg.alpha = 1;
				wotah.visible = true;

				sonic.animation.play("stay", false);
			});
		}
		else if (sonic.animation.curAnim.name == 'stay' && sonic.animation.curAnim.finished)
		{
			sonic.animation.play("point", false);
		}
		else if (sonic.animation.curAnim.name == 'point' && sonic.animation.curAnim.finished)
		{
			sonic.animation.play("idle", true);
			canEnter = true;
			pressStart.visible = true;
			// FlxFlicker.flicker(pressStart, 1, 0.06, false, false);
		}
	}
}
