package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.ui.FlxButtonPlus;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import lime.app.Application;

class PlayState extends FlxState
{
	var hud:HUD;
	var background:FlxTiledSprite;

	public static var bgVelo:Float = 0.39;
	public static var cactVelo:Float = -83;
	public static var player:Player;

	var cloud:Clouds;
	var bird:Bird;
	var fakeplayer:FakePlayer;

	public static var bounds:FlxSprite;

	var hudBG:FlxSprite;
	var cam:FlxCamera;
	var canSpawnCactus:Bool = true;
	var canSpawnCloud:Bool = true;
	var canSpawnBird:Bool = true;

	public static var cact:Cactus;

	var collisions:FlxSpriteGroup;
	var backgroundGroup:FlxGroup;
	var death_sfx:FlxSound;

	public static var hi_hud:HUD;

	public static var score:Int;
	public static var scoreHI:Int = 0;

	var bgc:FlxSprite;

	override public function create()
	{
		bgc = new FlxSprite(0, 0);
		bgc.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString("#f2f2f2"));
		add(bgc);

		if (FlxG.save.data.highscore == null)
			FlxG.save.data.highscore = scoreHI;
		FlxG.autoPause = true;
		backgroundGroup = new FlxGroup();
		add(backgroundGroup);

		var scalemode = new FixedScaleMode();
		scalemode.gameSize.set(600, 300);
		FlxG.scaleMode = scalemode;
		#if desktop
		FlxG.resizeWindow(600, 300);
		#end

		background = new FlxTiledSprite("assets/images/bg.png", FlxG.width, 12);
		background.y = 275;
		background.scrollFactor.set(0, 0);
		backgroundGroup.add(background);
		bounds = new FlxSprite(-3, 285);
		bounds.alpha = 0;
		bounds.immovable = true;
		bounds.makeGraphic(100000, 50, FlxColor.BLACK);

		bounds.scrollFactor.set(0, 0);
		add(bounds);
		bgColor = FlxColor.fromString("#f2f2f2");
		collisions = new FlxSpriteGroup();
		add(collisions);
		// Application.current.window.borderless = true;
		Application.current.window.resizable = false;

		player = new Player(25, 238);
		player.immovable = false;
		add(player);
		cact = new Cactus(600, 248);
		fakeplayer = new FakePlayer(25, 238);
		fakeplayer.scrollFactor.set(2, 2);
		fakeplayer.alpha = 0;
		add(fakeplayer);

		hudBG = new FlxSprite(0, 0);
		hudBG.makeGraphic(FlxG.width - 300, 30, FlxColor.BLACK);
		hudBG.alpha = 0.5;
		hudBG.screenCenter(X);
		// add(hudBG);

		FlxG.watch.add(hudBG, "x");

		hud = new HUD(271 + 80, 5);
		hud.scale.set(1.5, 1.5);
		hud.antialiasing = false;
		hud.color = FlxColor.fromString("#535353");
		hud.font = "assets/fonts/PressStart2P.ttf";
		hud.alignment = LEFT;
		hud.setBorderStyle(SHADOW, FlxColor.WHITE, 1, 1);
		add(hud);

		hi_hud = new HUD(Std.int(hud.x - 150), 5);
		hi_hud.scale.set(1.5, 1.5);
		hi_hud.antialiasing = false;

		hi_hud.color = FlxColor.fromString("#535353");
		hi_hud.font = "assets/fonts/PressStart2P.ttf";
		hi_hud.alignment = LEFT;
		hi_hud.setBorderStyle(SHADOW, FlxColor.WHITE, 1, 1);

		FlxG.watch.add(hud, "x");
		add(hi_hud);
		hundred_sfx = FlxG.sound.load("assets/sounds/hundred.ogg", 1, false);
		death_sfx = FlxG.sound.load("assets/sounds/gameover.ogg", 1, false);
		FlxG.watch.add(FlxG.mouse, "y");
		super.create();
	}

	var hundred_sfx:FlxSound;
	var thingy:Float = 7;

	var stop = false;

	public static var onEarth:Bool = true;

	override public function update(elapsed:Float)
	{
		spawnCloud();
		if (FlxG.keys.justPressed.C)
		{
			FlxTween.color(bgc, 1.5, bgc.color, FlxColor.fromString("#202125"));
			FlxTween.color(hud, 1.5, hud.color, FlxColor.fromString("#909291"));
			FlxTween.color(hi_hud, 1.5, hi_hud.color, FlxColor.fromString("#909291"));
		}
		var scrollShit:Float = FlxG.width * 1 * bgVelo * FlxG.elapsed;
		collisions.update(elapsed);

		if (!stop)
			score = Std.int(fakeplayer.x / thingy);

		if (score < 10)
			hud.text = "0000" + Std.string(score);
		else if (score < 100)
			hud.text = "000" + Std.string(score);
		else if (score < 1000)
			hud.text = "00" + Std.string(score);
		else
			hud.text = "0" + Std.string(score);

		if (FlxG.save.data.highscore < 10)
			hi_hud.text = "HI-" + "0000" + Std.string(FlxG.save.data.highscore);
		else if (FlxG.save.data.highscore < 100)
			hi_hud.text = "HI-" + "000" + Std.string(FlxG.save.data.highscore);
		else if (FlxG.save.data.highscore < 1000)
			hi_hud.text = "HI-" + "00" + Std.string(FlxG.save.data.highscore);
		else
			hi_hud.text = "HI-" + "0" + Std.string(FlxG.save.data.highscore);

		if (score % 100 == 0)
		{
			stop = true;
			FlxFlicker.flicker(hud, 0.5, 0.125, true, false, function(flick:FlxFlicker)
			{
				stop = false;
				if (score < 1000)
				{
					new FlxTimer().start(0.1, function(timer:FlxTimer)
					{
						thingy -= 0.01;
						bgVelo += 0.04;
						cact.velocity.x -= 12;
						cactVelo += 12;

						if (score < 400)
							cacTimer -= 0.25;
					});
				}
			});
		}

		if (score % 100 == 0)
		{
			hundred_sfx.play(false);
		}

		bounds.width = FlxG.width;

		background.alpha = 0.1;
		background.scrollX -= scrollShit;
		FlxG.collide(player, bounds);
		if (score > 50)
			spawnCactus();

		if (score > 300)
		{
			if (score % FlxG.random.int(50, 150) == 0)
			{
				if (canSpawnCactus)
				{
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						spawnBird();
					}, 0);
				}
				spawnBird();
				bird.updateHitbox();
			}
		}

		player.updateHitbox();
		super.update(elapsed);

		if (FlxG.collide(player, bounds))
		{
			onEarth = true;
		}
		else
		{
			onEarth = false;
		}

		cact.updateHitbox();
		player.updateHitbox();

		// bird.updateHitbox();
		if (FlxG.keys.anyJustPressed([ESCAPE]))
			openSubState(new PauseSubState());
	}

	public var cacTimer:Float = 2.2;

	// var num:Bool = 0;

	function spawnCactus()
	{
		if (!canSpawnCactus)
		{
			new FlxTimer().start(cacTimer, function(tmr:FlxTimer)
			{
				canSpawnCactus = true;
			}, 0);
		}
		else if (canSpawnCactus)
		{
			cact = new Cactus(600, 248);
			collisions.add(cact);

			cact.scrollFactor.set(0, 0);
			cact.velocity.x -= cactVelo;

			if (cact.animation.name == 'big')
				cact.y = 237;
			else
				cact.y = 250;

			new FlxTimer().start(0.01, function(tmr2:FlxTimer)
			{
				canSpawnCactus = false;
			}, 0);
		}

		// FlxG.overlap(player,collisions,gameOver);
		collisions.forEach(function(col:FlxSprite)
		{
			if (FlxG.pixelPerfectOverlap(player, col, 255, FlxG.camera))
			{
				gameOver();
			}
		});
	}

	var cloudVelo = -50;

	function spawnCloud()
	{
		if (!canSpawnCloud)
		{
			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				canSpawnCloud = true;
			}, 0);
		}
		else if (canSpawnCloud)
		{
			cloud = new Clouds(600);
			backgroundGroup.add(cloud);

			cloud.scrollFactor.set(0.5, 0.5);
			cloud.velocity.x = cloudVelo;

			new FlxTimer().start(0.01, function(tmr2:FlxTimer)
			{
				canSpawnCloud = false;
			}, 0);
		}
	}

	var bird_y = [208, 239, 180];

	function spawnBird()
	{
		if (!canSpawnBird)
		{
			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				canSpawnBird = true;
			}, 0);
		}
		else if (canSpawnBird)
		{
			bird = new Bird(600, bird_y[FlxG.random.int(0, 1)]);
			collisions.add(bird);

			bird.scrollFactor.set(0.5, 0.5);
			bird.velocity.x = -150;
			new FlxTimer().start(0.01, function(tmr2:FlxTimer)
			{
				canSpawnBird = false;
			}, 0);
		}
		FlxG.watch.add(bird, "y");
		collisions.forEach(function(col:FlxSprite)
		{
			if (FlxG.pixelPerfectOverlap(player, col, 255, FlxG.camera))
			{
				gameOver();
			}
		});
	}

	function gameOver()
	{
		Player.dead = true;
		death_sfx.play();
		trace(scoreHI);
		FlxG.save.flush();
		if (FlxG.save.data.highscore < score)
		{
			scoreHI = score;
			FlxG.save.data.highscore = scoreHI;
		}

		FlxG.camera.shake(0.01, 0.15);
		Application.current.window.move(Application.current.window.x + 1, Application.current.window.y + 1);
		openSubState(new GameOverSubState());
	}
}
