package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

class Extras extends FlxSubState
{
	var selected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var extrasStuff:Array<String> = ['da-garden', 'visual-mode', 'sound-test', 'stage-select'];
	var back:FlxSprite;
	var star:FlxSprite;
	var starStuff:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		starStuff = new FlxTypedGroup<FlxSprite>();
		add(starStuff);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/Extras-stuff.png', 'assets/images/Extras-stuff.xml');

		for (i in 0...extrasStuff.length)
		{
			var menuItem:FlxSprite = new FlxSprite(105, 80 + (i * 75));
			star = new FlxSprite(menuItem.x - 60, 80 + (i * 75));
			star.loadGraphic('assets/images/star-thingy.png', false);
			star.scale.set(2, 2);
			starStuff.add(star);
			menuItem.frames = tex;
			menuItem.scale.set(2, 2);
			menuItem.antialiasing = false;
			menuItem.animation.addByPrefix('idle', extrasStuff[i] + "-idle", 24);
			menuItem.animation.addByPrefix('selected', extrasStuff[i] + "-selected", 24);
			menuItem.animation.play('idle');

			menuItem.ID = i;
			FlxG.watch.add(menuItem, "x");
			FlxG.watch.add(menuItem, "y");
			menuItems.add(menuItem);

			menuItem.scrollFactor.set();
		}
		changeItem();
		back = new FlxSprite(500, 400);
		back.loadGraphic("assets/images/back.png", true, 64, 24);
		back.animation.add('idle', [0], 1);
		back.animation.add('selected', [1], 1);
		back.animation.play("idle");
		back.scale.set(2, 2);
		FlxTween.tween(back, {y: back.y - 5}, 2, {type: PINGPONG});
		add(back);
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (FlxG.keys.anyJustPressed([UP]))
			{
				changeItem(-1);
			}

			if (FlxG.keys.anyJustPressed([DOWN]))
			{
				changeItem(1);
			}
			if (FlxG.keys.anyJustPressed([ENTER]))
			{
				selectedSomethin = true;

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (selected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = extrasStuff[selected];

							switch (daChoice)
							{
								// case 'story mode':
								// 	FlxG.switchState(new StoryMenuState());
								// 	trace("Story Menu Selected");
								// case 'freeplay':
								// 	FlxG.switchState(new FreeplayState());

								// 	trace("Freeplay Menu Selected");

								case 'sound-test':
									FlxG.switchState(new SoundTestState());
							}
						});
					}
				});
			}
		}
		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			FlxFlicker.flicker(back, 0.5, 0.06, true, false, function(flick:FlxFlicker)
			{
				FlxTween.tween(back, {alpha: 0}, 0.5, {
					ease: FlxEase.expoInOut
				});

				menuItems.forEach(function(sprite:FlxSprite)
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.5, {
						ease: FlxEase.expoInOut
					});
				});

				starStuff.forEach(function(sprite:FlxSprite)
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
		super.update(elapsed);
	}

	function closeLmao()
	{
		MainMenu.stuff(false);

		FlxTween.tween(MainMenu.extrasImg, {x: MainMenu.extrasImg.x - 275}, 1, {
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

	function changeItem(thing:Int = 0)
	{
		selected += thing;

		if (selected >= menuItems.length)
			selected = 0;
		if (selected < 0)
			selected = menuItems.length - 1;

		menuItems.forEach(function(sprite:FlxSprite)
		{
			sprite.animation.play('idle');

			if (sprite.ID == selected)
			{
				sprite.animation.play('selected');
			}

			sprite.updateHitbox();
		});
	}
}
