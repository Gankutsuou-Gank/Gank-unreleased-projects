package;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.addons.display.FlxTiledSprite;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxGame;
import openfl.display.Sprite;

class MainMenuState extends FlxState
{
	var background:FlxSprite;
	var platform:FlxTiledSprite;
	var logo:FlxSprite;
	var bird:FlxSprite;
	var copyright:FlxSprite;
	var scoreBtn:FlxSprite;
	var startBtn:FlxSprite;
	var obj : h2d.Object;
	public override function create() {
		// var font = hxd.Res.customFont.toFont();
		// var s2d = h2d.
		// // creates another text field with this font
		// var tf = new h2d.Text(font, s2d);
		// tf.textColor = 0xFFFFFF;
		// tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		// tf.text = "Héllò h2d !";
	
		// tf.y = 20;
		// tf.x = 20;
		// tf.scale(7);
        // // add(tf);
		background = new FlxSprite(144,256).loadGraphic("assets/images/background.png");
		background.scale.set(3,3);
		
		background.antialiasing = false;
		
		add(background);
		platform = new FlxTiledSprite("assets/images/platform.png", FlxG.width, 168);
		platform.y = 600;
		add(platform);
		logo = new FlxSprite(144,256).loadGraphic("assets/images/logo.png");
		logo.scale.set(3,3);
		logo.antialiasing = false;
		add(logo);

		bird = new FlxSprite(374,256);
		bird.scale.set(3,3);
		bird.antialiasing = false;
		bird.loadGraphic("assets/images/bird.png", true, 17, 12);
        bird.animation.add("flap",[0,1,2],7);
		bird.antialiasing = false;
        bird.animation.play("flap");
		add(bird);

		copyright = new FlxSprite(170,634).loadGraphic("assets/images/copyright.png");
		copyright.scale.set(3,3);
		copyright.antialiasing = false;
		add(copyright);

		startBtn = new FlxSprite(50,496).loadGraphic("assets/images/start.png");
        startBtn.scale.set(3,3);
        startBtn.updateHitbox();
        add(startBtn);

		scoreBtn = new FlxSprite(275,496).loadGraphic("assets/images/score.png");
		scoreBtn.scale.set(3,3);
		scoreBtn.updateHitbox();
		add(scoreBtn);
        
		FlxTween.tween(logo,{y: logo.y + 20},1,{type: PINGPONG});
		FlxTween.tween(bird,{y: logo.y + 20},1,{type: PINGPONG});
		super.create();
	}
	
	public override function update(elapsed:Float):Void {
		var scrollShit:Float = FlxG.width * 1 * 0.5 * FlxG.elapsed;

		platform.alpha = 0.1;
		platform.scrollX -= scrollShit;
		GankTools.watch(copyright,true);
		GankTools.initBtn(startBtn,function() {
			// FlxG.sound.play("assets/sounds/transation.ogg",1);
			new FlxTimer().start(0.1,function(tmr:FlxTimer) {
				FlxG.camera.fade(FlxColor.BLACK,0.75,false,function() {
					FlxG.switchState(new PlayState());
				});
			});
		});
		super.update(elapsed);
	}
}
