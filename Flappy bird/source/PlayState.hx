package;

import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxTiledSprite;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var background:FlxSprite;
	var platform:FlxTiledSprite;
	var colGrp:FlxSpriteGroup;
	public static var firstTap = false;
	var tap:FlxSprite;
	var getRdy:FlxSprite;
	var bird:Player;
	var floor:FlxSprite;
	public static var score:Int = 0;
	public static var highScore:Int = 0;
	var scoreTxt:FlxText;
	public static var pauseBtn:FlxSprite;
	var scoreDetectors:Array<FlxSprite> = new Array<FlxSprite>();
	var canSummonPipe:Bool = true;
	var bottomPipe:FlxSprite;


	override public function create()
	{
		
		if (FlxG.save.data.highscore == null)
			FlxG.save.data.highscore = highScore;

		background = new FlxSprite(144,256).loadGraphic("assets/images/background.png");
		background.scale.set(3,3);
		
		background.antialiasing = false;
		
		add(background);
		colGrp = new FlxSpriteGroup();
		add(colGrp);
		platform = new FlxTiledSprite("assets/images/platform.png", FlxG.width, 168);
		platform.y = 600;
		add(platform);

		floor = new FlxSprite(0,600).makeGraphic(FlxG.width,10,FlxColor.WHITE);
		// floor.visible = false;
		floor.immovable = true;
		floor.width = FlxG.width;
		colGrp.add(floor);

		tap = new FlxSprite(229,350).loadGraphic("assets/images/tap.png");
		tap.scale.set(3,3);
		tap.antialiasing = false;
		add(tap);

		getRdy = new FlxSprite(171,154).loadGraphic("assets/images/getReady.png");
		getRdy.scale.set(3,3);
		getRdy.antialiasing = false;
		add(getRdy);
	
		bird = new Player(120,264);
		bird.scale.set(3,3);
		bird.updateHitbox();
		add(bird);
		scoreTxt = new FlxText(200,32);
		scoreTxt.setFormat("assets/fonts/04B_19__.ttf",36,FlxColor.WHITE,CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,true);
		scoreTxt.borderSize = 3;
		scoreTxt.antialiasing = false;
		add(scoreTxt);
		pauseBtn = new FlxSprite(24,32).loadGraphic("assets/images/pause.png",true,13,14);
		pauseBtn.scale.set(3,3);
		pauseBtn.updateHitbox();
		pauseBtn.animation.add("idle",[0],1,true);
		pauseBtn.animation.add("paused",[1],1,true);
		pauseBtn.animation.play("idle");
		add(pauseBtn);
		// createPipe();
		super.create();
	}

	public static var BGstuff = 0.5;
	public static var pauseBtnOverlap = false;
	var summonedPipe = false;
	override public function update(elapsed:Float):Void
	{
		scoreTxt.text = Std.string(score);
	
		if(FlxG.mouse.overlaps(pauseBtn))
			{
				pauseBtnOverlap = true;
			}
		else
			{
				pauseBtnOverlap = false;
			}
			

		if(pauseBtnOverlap)
			{
				if(FlxG.mouse.pressed)
					{
						FlxTween.tween(pauseBtn,{y: pauseBtn.y + 2},0.2,{
							onComplete: function(twn:FlxTween) {
								pauseBtn.y = 32;
								pauseBtn.animation.play("paused");
								// FlxG.sound.play("assets/sounds/transation.ogg",1);
								
								new FlxTimer().start(0.1,function(tmr:FlxTimer) {
									// FlxG.sound.play("assets/sounds/transation.ogg",1);
								});
								openSubState(new PauseSubState());
							}
						});
					}	
			}
		
		FlxG.collide(bird,floor);
		super.update(elapsed);
		var scrollShit:Float = FlxG.width * 1 * BGstuff * FlxG.elapsed;

		platform.alpha = 0.1;
		platform.scrollX -= scrollShit;
		if(!firstTap && !pauseBtnOverlap)
			{
				if(FlxG.mouse.pressed || FlxG.keys.anyJustPressed([SPACE,ENTER]))
					{
						FlxTween.tween(getRdy,{alpha: 0},0.75,{onComplete: function(twn:FlxTween) {
							firstTap = true;
							canSummonPipe = true;
							tap.kill();
							getRdy.kill();
							BGstuff = 0.4;
						},ease: FlxEase.linear});
						FlxTween.tween(tap,{alpha: 0},0.75,{ease: FlxEase.linear});
					}
			}
			// if(FlxG.keys.justPressed.J)
			// 	gameOver();
			// checkPipes();
			if(!firstTap)
				canSummonPipe = false;
			if(summonedPipe)
				canSummonPipe = false;
		
			if(canSummonPipe && firstTap && !inGameOver)
				{
					for(i in 0...1)
						{
							if(i == 0)
								createPipe();
								summonedPipe = true;
								
									// if(!createdPipes)
									// 	new FlxTimer().start(2,function(tmr:FlxTimer) {
									// 		FlxG.sound.play("assets/sounds/score.ogg",1);
									// 		score += 1;
									// 	});
										

				
								new FlxTimer().start(1.75, function(tmr:FlxTimer)
									{
										summonedPipe = false;
									});
								
								new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										createdPipes = true;
									});
						}
				}
	// trace(canSummonPipe);
			if (!canSummonPipe && firstTap && !inGameOver)
				{
					new FlxTimer().start(1.75, function(tmr:FlxTimer)
						{
							canSummonPipe = true;
						}, 0);
				}
				// trace(bottomPipe.y - topPipe.y);
			
				if(!inGameOver)
					{
						colGrp.forEach(function(spr:FlxSprite) {
							// FlxG.collide(bird,spr);
							if(FlxG.pixelPerfectOverlap(bird,spr))
								{
									gameOver();
										
								}
						});
					}
					
					if(bird.overlaps(floor) && inGameOver)
						{
							openSubState(new GameOverSubState());	
						}

					
					

	}
	function watch(obj:FlxObject)
	{
		FlxG.watch.add(obj,"x");
		FlxG.watch.add(obj,"y");
		if(FlxG.keys.anyPressed([UP]))
			obj.y -= 1;
		if(FlxG.keys.anyPressed([DOWN]))
			obj.y += 1;
		if(FlxG.keys.anyPressed([RIGHT]))
			obj.x += 1;
		if(FlxG.keys.anyPressed([LEFT]))
			obj.x -= 1;
		// if(FlxG.mouse.)
	}
	public static var inGameOver = false;
	function gameOver() {
		var played_sound = false;
		inGameOver = true;
		if(!played_sound)
			{
				FlxG.camera.flash(FlxColor.WHITE,0.1);
				FlxG.camera.shake(0.05,0.1);
				FlxG.sound.play("assets/sounds/hit.ogg",1,false,null,true,function() {
					played_sound = true;
				});
			}
		Player.dead = true;
		// bgVelo
		BGstuff = 0;
		pipeVelo = 0;
		if (FlxG.save.data.highscore < score)
			{
				highScore = score;
				FlxG.save.data.highscore = highScore;
			}
	
		
	}
	// diff = 528
	var topPipe:FlxSprite;
	public static var pipeVelo:Float = -171;
	var createdPipes = false;
	function createPipe() {
		var yValues = [
			[260,-260],[295,-225],[373,-147],[424,-96],[488,-32],[256,-264]
		];
		var rnd = FlxG.random.int(0,5);
		if(createdPipes)
			{
				new FlxTimer().start(0.1,function(Timer:FlxTimer) {
					FlxG.sound.play("assets/sounds/score.ogg",1);
					score += 1;
				});
			
			}
			
	
		topPipe = new FlxSprite(435,yValues[rnd][1]).loadGraphic("assets/images/top-pipe.png");
		topPipe.scale.set(3,3);
		topPipe.updateHitbox();
		topPipe.velocity.x = pipeVelo;
		colGrp.add(topPipe);
		
		bottomPipe = new FlxSprite(435,yValues[rnd][0]).loadGraphic("assets/images/bottom-pipe.png");
		bottomPipe.scale.set(3,3);
		bottomPipe.updateHitbox();
		bottomPipe.velocity.x = pipeVelo;
		colGrp.add(bottomPipe);
		canSummonPipe = false;
		

			

		// if(FlxG.pixelPerfectOverlap(bird,topPipe))
		// 	gameOver();
		// else if(FlxG.pixelPerfectOverlap(bird,bottomPipe))
		// 	gameOver();

	}
}



class PauseSubState extends FlxSubState {
	override public function update(elapsed):Void {
		if(FlxG.mouse.overlaps(PlayState.pauseBtn) && FlxG.mouse.pressed)
			{
				FlxTween.tween(PlayState.pauseBtn,{y: PlayState.pauseBtn.y + 2},0.2,{
					onComplete: function(twn:FlxTween) {
						PlayState.pauseBtn.y = 32;
						PlayState.pauseBtn.animation.play("idle");
						new FlxTimer().start(0.1,function(tmr:FlxTimer) {
							// FlxG.sound.play("assets/sounds/transation.ogg",1);
						});
						close();
					}
				});
				
			}
			if(FlxG.mouse.overlaps(PlayState.pauseBtn))
				PlayState.pauseBtnOverlap = true;
			else
				PlayState.pauseBtnOverlap = false;
		super.update(elapsed);
	}
}
