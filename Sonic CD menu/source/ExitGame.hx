package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
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
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class ExitGame extends FlxSubState
{
	var thingy:Bool = true;
	var no:FlxSprite;
	var yes:FlxSprite;
	var sonic:FlxSprite;

	var back:FlxSprite;
	var outline:FlxSprite;
	var stuff:FlxTypedGroup<FlxSprite>;

	public override function create()
	{
		stuff = new FlxTypedGroup<FlxSprite>();
		add(stuff);
		yes = new FlxSprite(165, 230);
		yes.antialiasing = false;
		yes.scale.set(2, 2);
		yes.frames = Paths.getSparrowAtlas("yes-no");
		yes.animation.addByPrefix('idle', "yes-idle", 24);
		yes.animation.addByPrefix('selected', "yes-selected", 24);
		yes.animation.play('idle');
		stuff.add(yes);

		no = new FlxSprite(yes.x + 250, 230);
		no.antialiasing = false;
		no.scale.set(2, 2);
		no.frames = Paths.getSparrowAtlas("yes-no");
		no.animation.addByPrefix('idle', "no-idle", 24);
		no.animation.addByPrefix('selected', "no-selected", 24);
		no.animation.play('idle');
		stuff.add(no);

		sonic = new FlxSprite(300, 145);
		sonic.loadGraphic("assets/images/sonic.png", true, 30, 38);
		sonic.scale.set(2.3, 2.3);
		sonic.animation.add("idle", [0, 1, 2], 3, true);
		sonic.animation.play("idle");
		stuff.add(sonic);

		back = new FlxSprite(500, 400);
		back.loadGraphic("assets/images/back.png", true, 64, 24);
		back.animation.add('idle', [0], 1);
		back.animation.add('selected', [1], 1);
		back.animation.play("idle");
		back.scale.set(2, 2);
		FlxTween.tween(back, {y: back.y - 5}, 2, {type: PINGPONG});
		stuff.add(back);
		outline = new FlxSprite(yes.x - 3, yes.y - 3);
		outline.loadGraphic("assets/images/outline.png", false);
		outline.scale.set(2, 2);

		stuff.add(outline);

		super.create();
	}

	function doTheThing()
	{
		FlxG.sound.play(Paths.sound('confirm'));
		FlxG.save.flush();
		if (thingy)
		{
			returnBack();
		}
		else
		{
			#if desktop
			Sys.exit(0);
			#end
		}
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A || FlxG.keys.justPressed.D)
			thingy = !thingy;
		if (FlxG.keys.justPressed.ENTER)
			doTheThing();

		if (FlxG.keys.justPressed.ESCAPE)
		{
			returnBack();
		}

		if (thingy)
		{
			no.animation.play('selected');
			yes.animation.play('idle');
			outline.x = no.x - 3;
			outline.y = no.y - 3;
		}
		else
		{
			yes.animation.play('selected');
			no.animation.play('idle');
			outline.x = yes.x - 3;
			outline.y = yes.y - 3;
		}
		super.update(elapsed);
	}

	function closeLmao()
	{
		MainMenu.stuff(false);
		new FlxTimer().start(0.1, (_) -> close());
	}

	function returnBack()
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
					closeLmao();
				}
			});
		});
	}
}
