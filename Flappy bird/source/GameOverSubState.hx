package;

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

class GameOverSubState extends FlxSubState {
    var gameOverSpr:FlxSprite;
    var card:FlxSprite;
    var okBtn:FlxSprite;
    var shareBtn:FlxSprite;
    var scoreText:FlxText;
    var scoreTextHigh:FlxText;
	override public function create() {
        gameOverSpr = new FlxSprite(168,228).loadGraphic("assets/images/gameOver.png");
        gameOverSpr.scale.set(3,3);
        gameOverSpr.alpha = 0;
        add(gameOverSpr);

        card = new FlxSprite(164,843).loadGraphic("assets/images/card.png");
        card.scale.set(3,3);
        // card.alpha = 0;
        add(card);
//164 
        FlxTween.tween(gameOverSpr,{alpha: 1},0.5,{
            onComplete: function(twn:FlxTween) {
                FlxTween.tween(card,{y: 344},0.7,{
                    onComplete: function(twn:FlxTween) {
                    okBtn.alpha = 1;
                    shareBtn.alpha = 1;
                    scoreText.alpha = 1;
                    scoreTextHigh.alpha = 1;
                },ease: FlxEase.expoInOut});
        }});
        

        okBtn = new FlxSprite(50,496).loadGraphic("assets/images/ok.png");
        okBtn.scale.set(3,3);
        okBtn.alpha = 0;
        okBtn.updateHitbox();
        add(okBtn);

        shareBtn = new FlxSprite(275,496).loadGraphic("assets/images/share.png");
        shareBtn.scale.set(3,3);
        shareBtn.alpha = 0;
        shareBtn.updateHitbox();
        add(shareBtn);
        
        scoreText = new FlxText(333,336).setFormat("assets/fonts/04B_19__.ttf",30,FlxColor.WHITE,CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,true);
		scoreText.borderSize = 3;
        scoreText.alpha = 0;
		scoreText.antialiasing = false;
        scoreText.text = Std.string(PlayState.score);
		add(scoreText);

        scoreTextHigh = new FlxText(333,402).setFormat("assets/fonts/04B_19__.ttf",30,FlxColor.WHITE,CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,true);
		scoreTextHigh.borderSize = 3;
        scoreTextHigh.alpha = 0;
		scoreTextHigh.antialiasing = false;
        scoreTextHigh.text = Std.string(FlxG.save.data.highscore);
		add(scoreTextHigh);

		super.create();
	} 
    // 
    override public function update(elapsed:Float) {
        super.update(elapsed);
        watch(scoreTextHigh);
   
     
                initBtn(okBtn,function()
                    {
                        pressed = true;
                        Player.dead = false;
                        PlayState.BGstuff = 0.5;
                        PlayState.pipeVelo = -171;
                        // P;
                        PlayState.inGameOver = false;
                        PlayState.firstTap = false;
                        PlayState.score = 0;
                        FlxG.camera.flash(FlxColor.WHITE,0.7,function(){
                            FlxG.resetGame();
                        });
                    });
           
          
            initBtn(shareBtn,function()
                {
                    FlxG.openURL('https://twitter.com/intent/tweet?text=I%20scored%20${PlayState.score}%20in%20Flappy-Bird!');
                });
    }
    var pressed:Bool = true;
    var pressedTwo:Bool = false;
    function watch(obj:FlxObject)
        {
            FlxG.watch.add(obj,"x");
            FlxG.watch.add(obj,"y");
            var up:Bool = false;
            var down:Bool = false;
            var left:Bool = false;
            var right:Bool = false;
    
            #if FLX_KEYBOARD
            up = FlxG.keys.anyPressed([UP, W]);
            down = FlxG.keys.anyPressed([DOWN, S]);
            left = FlxG.keys.anyPressed([LEFT, A]);
            right = FlxG.keys.anyPressed([RIGHT, D]);
            #end
            if(up)
                obj.y -= 2;
            if(down)
                obj.y += 2;
            if(right)
                obj.x += 2;
            if(left)
                obj.x -= 2;
            // if(FlxG.mouse.)
        }
       
    function initBtn(spr:FlxSprite,?callBack:Void->Void):Void {
        var overlap = false;
        var canPress = false;
        if(canPress)
            {
                return;
            }

                if(FlxG.mouse.overlaps(spr))
                   {
                        overlap = true;
                        // spr.alpha = 0.9;
                }
                else
                    {
                    overlap = false;
                    // spr.alpha = 1;
                    }
                   
                     
                if(FlxG.mouse.pressed && overlap && !canPress)
                    {
                        if(!canPress)
                            {
                                canPress = true;
                                FlxTween.tween(spr,{y: spr.y += 2},0.2,{
                                    onComplete: function(twn:FlxTween) {
                                        callBack();
                                        if(!canPress)
                                            spr.y -= 2;
                                            canPress = true;
                                        // trace(canPress);
                                    }
                                });

                            }
                    }
            
    }
}