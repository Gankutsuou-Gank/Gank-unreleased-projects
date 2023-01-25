package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class Soundtrack extends FlxSubState
{
	var soundCooldown:Bool = true;

	var thingy:Bool = true;
	var US:FlxSprite;
	var JP:FlxSprite;
	var eggman:FlxSprite;

	var leftNote:FlxSprite;
	var rightNote:FlxSprite;

	var back:FlxSprite;

	var outline:FlxSprite;
	var stuff:FlxTypedGroup<FlxSprite>;

	public override function create()
	{
		stuff = new FlxTypedGroup<FlxSprite>();
		add(stuff);
		JP = new FlxSprite(165, 230);
		JP.antialiasing = false;
		JP.scale.set(2, 2);
		JP.frames = Paths.getSparrowAtlas("soundtrack-stuff");
		JP.animation.addByPrefix('idle', "JP-idle", 24);
		JP.animation.addByPrefix('selected', "JP-selected", 24);
		JP.animation.play('idle');
		stuff.add(JP);

		US = new FlxSprite(JP.x + 250, 230);
		US.antialiasing = false;
		US.scale.set(2, 2);
		US.frames = Paths.getSparrowAtlas("soundtrack-stuff");
		US.animation.addByPrefix('idle', "US-idle", 24);
		US.animation.addByPrefix('selected', "US-selected", 24);
		US.animation.play('idle');
		stuff.add(US);

		eggman = new FlxSprite(300, 140);
		eggman.loadGraphic("assets/images/DJ-eggman.png", true, 40, 40);
		eggman.scale.set(2, 2);
		eggman.animation.add("idle", [0, 1], 3, true);
		eggman.animation.play("idle");
		stuff.add(eggman);

		leftNote = new FlxSprite(eggman.x - 75, eggman.y + 20);
		leftNote.loadGraphic("assets/images/leftNote.png", false);
		leftNote.scale.set(2, 2);
		FlxTween.tween(leftNote, {y: leftNote.y + 10}, 1, {type: PINGPONG});
		stuff.add(leftNote);

		rightNote = new FlxSprite(eggman.x + 100, eggman.y - 20);
		rightNote.loadGraphic("assets/images/rightNote.png", false);
		rightNote.scale.set(2, 2);
		FlxTween.tween(rightNote, {y: rightNote.y - 10}, 1, {type: PINGPONG});
		stuff.add(rightNote);

		back = new FlxSprite(500, 400);
		back.loadGraphic("assets/images/back.png", true, 64, 24);
		back.animation.add('idle', [0], 1);
		back.animation.add('selected', [1], 1);
		back.animation.play("idle");
		back.scale.set(2, 2);
		FlxTween.tween(back, {y: back.y - 5}, 2, {type: PINGPONG});
		stuff.add(back);

		outline = new FlxSprite(JP.x - 3, JP.y - 3);
		outline.loadGraphic("assets/images/outline.png", false);
		outline.scale.set(2, 2);

		stuff.add(outline);

		super.create();
	}

	function confirm()
	{
		FlxG.sound.play(Paths.sound('confirm'));
		FlxG.save.flush();
		if (thingy)
		{
			FlxFlicker.flicker(US, 0.5, 0.06, true, false, function(flick:FlxFlicker)
			{
				FlxG.sound.playMusic("assets/music/mainmenuUS.ogg", 1, true);
				outline.x = US.x - 3;
				outline.y = US.y - 3;
			});
		}
		else
		{
			FlxFlicker.flicker(JP, 0.5, 0.06, true, false, function(flick:FlxFlicker)
			{
				outline.x = JP.x - 3;
				outline.y = JP.y - 3;
				FlxG.sound.playMusic("assets/music/mainmenuJP.ogg", 1, true);
			});
		}
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A || FlxG.keys.justPressed.D)
			thingy = !thingy;
		if (FlxG.keys.justPressed.ENTER)
			confirm();

		if (FlxG.keys.justPressed.ESCAPE)
		{
			back.animation.play('selected');
			FlxG.sound.play(Paths.sound('back'), 0.8);
			FlxFlicker.flicker(back, 0.5, 0.06, true, false, function(flick:FlxFlicker)
			{
				stuff.forEach(function(sprite:FlxSprite)
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.5, {
						ease: FlxEase.expoInOut
					});
				});
				FlxTween.tween(MainMenu.dull, {
					x: MainMenu.dull.x - 40,
					y: MainMenu.dull.y - 20,
					alpha: 0
				}, 0.5, {
					ease: FlxEase.expoInOut,
					onComplete: twn ->
					{
						MainMenu.dull.destroy();
						MainMenu.grad.destroy();
						closeSS();
					}
				});
			});
		}

		if (thingy)
		{
			US.animation.play('selected');
			JP.animation.play('idle');
			outline.x = US.x - 3;
			outline.y = US.y - 3;
		}
		else
		{
			JP.animation.play('selected');
			US.animation.play('idle');
			outline.x = JP.x - 3;
			outline.y = JP.y - 3;
		}
		super.update(elapsed);
	}

	function closeSS()
	{
		MainMenu.stuff(false);

		FlxTween.tween(MainMenu.soundTrackImg, {x: MainMenu.soundTrackImg.x - 275}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flxTween:FlxTween)
			{
				FlxTween.tween(MainMenu.mainMenuImg, {x: MainMenu.mainMenuImg.x + 250}, 1, {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						close();
					}
				});
			}
		});
	}
}
