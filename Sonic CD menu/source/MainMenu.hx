package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.system.scaleModes.FillScaleMode;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.display.Graphics;

using StringTools;

class MainMenu extends FlxState
{
	public static var curSelected:Int = 0;

	public static var menuItems:FlxTypedGroup<FlxSprite>;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public static var balls:FlxObject;

	var menuStuff:Array<String> = [
		'startGame',
		// 'introMovie',
		'timeAttack',
		'Leaderboards',
		'Achievements',
		'helpAndoptions',
		'soundTrack',
		'Extras',
		'exitGame'
	];

	var elSonic:FlxSprite;
	var elSonic2:FlxSprite;
	var elSonic3:FlxSprite;
	var background:FlxSprite;
	var something:FlxSprite;

	var upArrow:FlxSprite;
	var downArrow:FlxSprite;
	var stick:FlxTiledSprite;
	var elGraphic:FlxSprite;

	public static var mainMenuImg:FlxSprite;
	public static var soundTrackImg:FlxSprite;
	public static var extrasImg:FlxSprite;
	public static var finishedFunnyMove:Bool = false;
	public static var firstStart:Bool = true;

	var camFollow:FlxObject;

	public static var dull:FlxSprite;
	public static var grad:FlxSprite;

	override public function create()
	{
		var scalemode = new FillScaleMode();

		scalemode.gameSize.set(640, 500);
		FlxG.scaleMode = scalemode;
		#if desktop
		FlxG.resizeWindow(640, 500);
		#end
		// }
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		bgColor = FlxColor.fromString("#7b79de");
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		balls = new FlxObject(0, 0, 1, 1);
		add(balls);
		persistentUpdate = persistentDraw = true;

		if (FlxG.save.data.jp)
		{
			FlxG.sound.playMusic("assets/music/mainmenuJP.ogg", 1, true);
		}
		else if (FlxG.save.data.us)
		{
			FlxG.sound.playMusic("assets/music/mainmenuUS.ogg", 1, true);
		}

		background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/menuShit.png", false);
		FlxTween.angle(background, background.angle, 360, 10, {type: LOOPING});
		background.scale.set(2.1, 2.1);
		background.scrollFactor.set(0, 0);

		add(background);
		elSonic = new FlxSprite(148, 109);
		elSonic.loadGraphic("assets/images/elSonic.png", false);
		elSonic.scale.set(2, 2);
		elSonic.alpha = 0.75;
		elSonic2 = new FlxSprite(elSonic.x + 10, 109);
		elSonic2.loadGraphic("assets/images/elSonic.png", false);
		elSonic2.scale.set(2, 2);
		elSonic2.alpha = 0.4;
		elSonic3 = new FlxSprite(elSonic.x - 10, 109);
		elSonic3.loadGraphic("assets/images/elSonic.png", false);
		elSonic3.scale.set(2, 2);
		elSonic3.alpha = 0.4;
		elSonic.scrollFactor.set(0, 0);
		elSonic2.scrollFactor.set(0, 0);
		elSonic3.scrollFactor.set(0, 0);

		something = new FlxSprite(433, 37);
		something.loadGraphic("assets/images/something.png", false);
		something.scale.set(2, 2);
		something.scrollFactor.set(0, 0);

		upArrow = new FlxSprite(570, 191);
		upArrow.loadGraphic("assets/images/downArrow.png", false);
		upArrow.scale.set(2, 2);
		upArrow.scrollFactor.set(0, 0);
		elGraphic = new FlxSprite(-169, 408);
		elGraphic.makeGraphic(500, 25, FlxColor.BLACK);
		elGraphic.scrollFactor.set(0, 0);

		FlxTween.tween(upArrow, {y: upArrow.y - 50}, 1, {type: PINGPONG});

		downArrow = new FlxSprite(50, 194); // I am a dumbass lmao
		downArrow.loadGraphic("assets/images/upArrow.png", false);
		downArrow.scale.set(2, 2);
		downArrow.scrollFactor.set(0, 0);
		FlxTween.tween(downArrow, {y: upArrow.y + 50}, 1, {type: PINGPONG});
		stick = new FlxTiledSprite("assets/images/stick.png", 24, FlxG.height);
		stick.x = 322;

		// stick.scale.y = 3;
		stick.scrollFactor.set(0, 0);

		mainMenuImg = new FlxSprite(115, 384);
		mainMenuImg.loadGraphic("assets/images/mainMenu.png", false);
		mainMenuImg.scale.set(2, 2);
		mainMenuImg.scrollFactor.set(0, 0);

		FlxG.watch.add(mainMenuImg, "x");
		FlxG.watch.add(mainMenuImg, "y");

		add(elSonic);
		add(elSonic2);
		add(elSonic3);
		add(stick);
		add(something);
		add(upArrow);
		add(downArrow);
		add(elGraphic);
		add(mainMenuImg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...menuStuff.length)
		{
			var offset:Float = 40 - (Math.max(menuStuff.length, 9) - 9);

			var menuItem:FlxSprite = new FlxSprite(FlxG.width, FlxG.height);
			// var menuItem:FlxSprite = new FlxSprite((i * 109) + 15, (i * 109) + offset);
			menuItem.antialiasing = false;
			menuItem.scale.set(2, 2);
			menuItem.frames = Paths.getSparrowAtlas("menuButtons");
			menuItem.animation.addByPrefix('idle', menuStuff[i] + "-idle", 24);
			menuItem.animation.addByPrefix('selected', menuStuff[i] + "-selected", 24);
			menuItem.animation.play('idle');
			menuItem.scrollFactor.set();
			menuItem.ID = i;
			menuItems.add(menuItem);
			// menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			if (firstStart)
				FlxTween.tween(menuItem, {y: (i * 109) + offset, x: (i * 109) + 15}, 2, {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						finishedFunnyMove = true;

						changeItem();
					}
				});
			else
				menuItem.y = 60 - (i * 160);

			// 912
			// 887
		}
		FlxG.camera.follow(camFollow, null, 0.60 * (60 / 120));

		firstStart = false;

		changeItem();

		super.create();
	}

	public static var selectedSomethin:Bool = false;

	var clearTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (FlxG.keys.anyJustPressed([UP]))
			{
				if (finishedFunnyMove)
				{
					FlxG.sound.play(Paths.sound('scroll'));
					menuItems.forEach(function(sprsprLMAO:FlxSprite)
					{
						if (finishedFunnyMove && curSelected == 4)
						{
							// finishedFunnyMove = false;
							FlxTween.tween(sprsprLMAO, {
								x: sprsprLMAO.x + 440,
								y: sprsprLMAO.y + 440
							}, 0.75, {
								onComplete: function(twn:FlxTween)
								{
									// finishedFunnyMove = true;
								}
							});
						}
						trace(sprsprLMAO.x, sprsprLMAO.y);
						// if (finishedFunnyMove && curSelected == 0)
						// {
						// 	FlxTween.tween(sprsprLMAO, {
						// 		x: sprsprLMAO.x - 440,
						// 		y: sprsprLMAO.y - 440
						// 	}, 0.3, {});
						// }
					});

					changeItem(-1);
				}
			}

			if (FlxG.keys.anyJustPressed([DOWN]))
			{
				if (finishedFunnyMove)
				{
					FlxG.sound.play(Paths.sound('scroll'));
					menuItems.forEach(function(sprsprLOL:FlxSprite)
					{
						if (finishedFunnyMove && curSelected == 3)
						{
							// finishedFunnyMove = false;
							FlxTween.tween(sprsprLOL, {
								x: sprsprLOL.x - 440,
								y: sprsprLOL.y - 440
							}, 0.75, {
								onComplete: function(twn:FlxTween)
								{
									// finishedFunnyMove = true;
								}
							});
						}
						// if (finishedFunnyMove && curSelected == 7)
						// {
						// 	FlxTween.tween(sprsprLOL, {
						// 		x: sprsprLOL.x + 440,
						// 		y: sprsprLOL.y + 440
						// 	}, 0.3, {});
						// }
					});
					changeItem(1);
				}
			}

			if (FlxG.keys.anyJustPressed([ESCAPE]))
			{
				// FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new TitleState());
			}

			if (FlxG.keys.anyJustPressed([SPACE, ENTER, Z]))
			{
				if (finishedFunnyMove)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirm'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: spr.x + FlxG.width, y: spr.y - FlxG.height}, 1, {
								ease: FlxEase.expoInOut,
								onComplete: function(twn:FlxTween)
								{
									// spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 0.5, 0.06, true, false, function(flick:FlxFlicker)
							{
								grad = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.BLACK], 1, 90, true);
								grad.alpha = 0.3;
								add(grad);

								dull = new FlxSprite(spr.x + 10, spr.y + 10);

								dull.scale.set(3.1, 3.1);
								dull.x = spr.x + 75;
								dull.y = spr.y + 10;
								dull.alpha = 0;
								dull.scrollFactor.set(0, 0);
								dull.loadGraphic("assets/images/dull-but-big.png", false);
								add(dull);
								balls.visible = false;
								spr.visible = balls.visible;

								upArrow.visible = false;
								downArrow.visible = false;
								var elChoice:String = menuStuff[curSelected];

								switch (elChoice)
								{
									case 'soundTrack':
										FlxG.save.flush();
										FlxTween.tween(dull, {x: dull.x + 40, y: dull.y + 20, alpha: 1}, 0.5, {
											ease: FlxEase.expoInOut,
											onComplete: function(shit:FlxTween)
											{
												openSubState(new Soundtrack());
											}
										});

										FlxTween.tween(mainMenuImg, {x: mainMenuImg.x - 250}, 1, {
											ease: FlxEase.expoInOut,
											onComplete: function(flxTween:FlxTween)
											{
												soundTrackImg = new FlxSprite(-165, 384).loadGraphic(Paths.image('soundtrack'));
												add(soundTrackImg);
												soundTrackImg.scale.set(2, 2);
												FlxTween.tween(soundTrackImg, {x: soundTrackImg.x + 275}, 1, {
													ease: FlxEase.expoInOut,
												});
											}
										});

									case 'exitGame':
										FlxG.save.flush();
										FlxTween.tween(dull, {x: dull.x - 175, y: dull.y - 200, alpha: 1}, 0.5, {
											ease: FlxEase.expoInOut,
											onComplete: function(balls:FlxTween)
											{
												openSubState(new ExitGame());
											}
										});

									case 'Extras':
										FlxG.save.flush();

										dull.scale.set(3.6, 3.6);
										FlxTween.tween(dull, {x: dull.x - 75, y: dull.y - 95, alpha: 1}, 0.5, {
											ease: FlxEase.expoInOut,
											onComplete: function(shit:FlxTween)
											{
												openSubState(new Extras());
											}
										});
										FlxTween.tween(mainMenuImg, {x: mainMenuImg.x - 250}, 1, {
											ease: FlxEase.expoInOut,
											onComplete: function(flxTween:FlxTween)
											{
												extrasImg = new FlxSprite(-165, 384).loadGraphic(Paths.image('extras'));
												add(extrasImg);
												extrasImg.scale.set(2, 2);
												FlxTween.tween(extrasImg, {x: extrasImg.x + 275}, 1, {
													ease: FlxEase.expoInOut,
												});
											}
										});
								} // dumbass coding™️
							});
						}
					});
				}
			}
		}
		var scrollShit:Float = FlxG.height * 1 * 0.25 * FlxG.elapsed;
		stick.alpha = 0.1;
		stick.scrollY += scrollShit;
		super.update(elapsed);
	}

	// public static var shit:Bool = false;

	public static function stuff(thing:Bool)
	{
		grad.destroy();
		selectedSomethin = false;
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.visible = true;
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {x: spr.x - FlxG.width, y: spr.y + FlxG.height}, 1, {
					ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween) {}
				});
			}
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 7;
		if (curSelected < 0)
			curSelected = 0;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}
