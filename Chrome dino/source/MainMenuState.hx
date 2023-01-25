package;

import flixel.group.FlxSpriteGroup;
import flixel.effects.particles.FlxParticle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxGradient;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.api.FlxGameJolt;
import flixel.math.FlxMath;
import lime.app.Application;
import flixel.system.FlxSound;
import flixel.effects.FlxFlicker;
import flixel.addons.ui.FlxButtonPlus;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxCollision;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxTiledSprite;
import flixel.FlxState;

class MainMenuState extends FlxState
{
	
	var background:FlxTiledSprite;
    public static var bgVelo:Float = 0.39;
	public static var player:FlxSprite; 
    var cloud:Clouds; 
	var canSpawnCloud:Bool = true;
	var	backgroundGroup:FlxSpriteGroup;
    var topBar:FlxSprite; 
    var bottomBar:FlxSprite; 
    var grad:FlxSprite;
    var logo:FlxText;
    var press_enter:FlxText;
    var flashSpr:FlxSprite;
    var started = false;
    var hit_sfx:FlxSound;
    var slide_sfx:FlxSound;
    var particle:Particles;
	override public function create()
	{
        


        hit_sfx = FlxG.sound.load("assets/sounds/hit.ogg",0.6,false);
        slide_sfx = FlxG.sound.load("assets/sounds/slide.ogg",0.6,false);

		FlxG.autoPause = true;
		backgroundGroup = new FlxSpriteGroup();
		add(backgroundGroup);
       
		background = new FlxTiledSprite("assets/images/bg.png",FlxG.width,12);
		background.y = 255;
		background.scrollFactor.set(0,0);
		backgroundGroup.add(background);
		bgColor = FlxColor.fromString("#f2f2f2");
		Application.current.window.resizable = false;

    
		player = new FlxSprite(25,218);
        player.frames = FlxAtlasFrames.fromSparrow('assets/images/dino.png', 'assets/images/dino.xml');
        player.animation.addByPrefix("run1","dino-running0",15);
        player.animation.play("run1");
        player.alpha = 0;
        background.alpha = 0;
        backgroundGroup.add(player);
        grad = FlxGradient.createGradientFlxSprite(FlxG.width * 2, FlxG.height * 2, [FlxColor.BLACK], 1, 90, true);
		grad.alpha = 0.3;
		add(grad);
        topBar = new FlxSprite(600,0);
        topBar.makeGraphic(FlxG.width,30,FlxColor.fromString("#414141"));
        add(topBar);
        
        bottomBar = new FlxSprite(-600,271);
        bottomBar.makeGraphic(FlxG.width,30,FlxColor.fromString("#414141"));
        add(bottomBar);

        logo = new FlxText(275,-50);
        logo.scale.set(4,4);
        logo.color = FlxColor.fromString("#535353");
        logo.text = "CHROME DINO";
		logo.font = "assets/fonts/PressStart2P.ttf";
		logo.alignment = FlxTextAlign.CENTER;
		logo.setBorderStyle(SHADOW, FlxColor.WHITE, 1, 1);
        logo.screenCenter(X);
        add(logo);

        press_enter = new FlxText(223,-30);
        press_enter.scale.set(2,2);
        press_enter.color = FlxColor.fromString("#535353");
        press_enter.text = "P R E S S  E N T E R";
		press_enter.font = "assets/fonts/PressStart2P.ttf";
		press_enter.alignment = FlxTextAlign.CENTER;
		press_enter.setBorderStyle(SHADOW, FlxColor.WHITE, 1, 1);
        add(press_enter);

        //282,144
        FlxG.watch.add(logo,"y");
        FlxG.watch.add(press_enter,"x");
        flashSpr = new FlxSprite(0,0);
        flashSpr.makeGraphic(FlxG.width,FlxG.height,FlxColor.WHITE);
        // add(flashSpr);

        // FlxTween.tween(flashSpr, {alpha: 0}, 1, {ease: FlxEase.quartInOut,onComplete: function(shit:FlxTween)
        //     {
                FlxTween.tween(bottomBar, {x: 0}, 0.75, {ease: FlxEase.quartInOut,onComplete: function(shit:FlxTween)
                    {
                        FlxG.camera.shake(0.05,0.1);
                        hit_sfx.play();
                        FlxTween.tween(topBar, {x: 0}, 0.75, {ease: FlxEase.quartInOut,onComplete: function(shit:FlxTween)
                            {
                                FlxG.camera.shake(0.05,0.1);
                                hit_sfx.play();
                                FlxTween.tween(logo, {y: 92}, 0.75, {ease: FlxEase.quartInOut,onComplete: function(shit:FlxTween)
                                    {
                                       started = true;
                                       slide_sfx.play();
                                       backgroundGroup.forEach(function(spr:FlxSprite)
                                        {
                                           FlxTween.tween(spr,{alpha: 1},1);
                                           FlxG.camera.flash();
                                           particle = new Particles(0,0,FlxColor.WHITE);
                                           add(particle);
                                           FlxG.watch.add(particle,"x");
                                        });
                                }});
                        }});
                }});
        // }});
       
		super.create();
	}


	
	var thingy:Float = 7;
	override public function update(elapsed:Float)
	{
		spawnCloud();
		var scrollShit:Float = FlxG.width * 1 * bgVelo * FlxG.elapsed;
        background.scrollX -= scrollShit;

        if(FlxG.keys.justPressed.ESCAPE)
            FlxG.resetState();
        if(started)
        {
            if (!press_enter.visible)
                {
                    new FlxTimer().start(0.7, function(tmr:FlxTimer)
                    {
                        press_enter.visible = true;
                    }, 0);
                }
            else if (press_enter.visible)
                {
                    new FlxTimer().start(0.7, function(tmr2:FlxTimer)
                    {
                        press_enter.visible = false;
                    }, 0);
                }
            if(FlxG.keys.anyJustPressed([SPACE,ENTER]))
                FlxG.camera.fade(FlxColor.BLACK,1.5,false,function() {
                    FlxG.switchState(new PlayState());
                });
           
        
                press_enter.y = logo.y + 70;
        }
        
		super.update(elapsed);
	}

	var cloudVelo = -50;
	function spawnCloud() {
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
				
				cloud.scrollFactor.set(0.5,0.5);
				cloud.velocity.x = cloudVelo;


				new FlxTimer().start(0.01, function(tmr2:FlxTimer)
				{
					canSpawnCloud = false;
				}, 0);
			}	
	}
} 
