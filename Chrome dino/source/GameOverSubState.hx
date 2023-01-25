package;

import openfl.display.Application;
import flixel.util.FlxGradient;
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

class GameOverSubState extends FlxSubState
{
	var grad:FlxSprite;
    var gameoverTxt:FlxText;
    var button:FlxSprite;
    var downBar:FlxSprite;
    var upperBar:FlxSprite;
	public override function create()
	{
        grad = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.BLACK], 1, 90, true);
		grad.alpha = 0.3;
		add(grad);


        gameoverTxt = new FlxText(234,-30); //120
        gameoverTxt.font = "assets/fonts/PressStart2P.ttf";
        gameoverTxt.text = "G A M E  O V E R";
        gameoverTxt.color = FlxColor.fromString("#535353");
        gameoverTxt.setBorderStyle(SHADOW, FlxColor.WHITE, 1, 1);
        gameoverTxt.scale.set(2,2);
        add(gameoverTxt);

        button = new FlxSprite(280,0);
        button.frames = FlxAtlasFrames.fromSparrow('assets/images/button.png', 'assets/images/button.xml');
        // button.scale.set(1.5,1.5);
        
        button.screenCenter(XY);
        button.animation.addByPrefix("idle","button-idle0",15);
        button.animation.addByPrefix("pressed","button-pressed0",8,false); //160
        button.y = -30;
        add(button);
        button.animation.play("idle");

       upperBar = new FlxSprite(0,-30);
       upperBar.makeGraphic(FlxG.width,30,FlxColor.fromString("#414141"));
       
       add(upperBar);


       downBar = new FlxSprite(0,300);
       downBar.makeGraphic(FlxG.width,30,FlxColor.fromString("#414141"));
       
       add(downBar);
                       
    
        // 414141
        FlxTween.tween(downBar,{y: 271},1,{ease: FlxEase.expoInOut});
        FlxTween.tween(gameoverTxt,{y: 120},1,{ease: FlxEase.expoInOut});
        FlxTween.tween(button,{y: 160},1,{ease: FlxEase.expoInOut}); 
        FlxTween.tween(upperBar,{y: 0},1,{ease: FlxEase.expoInOut});
		super.create();
	}

	override public function update(elapsed:Float)
	{
        if(FlxG.keys.anyJustPressed([SPACE,ENTER]))
            button.animation.play("pressed");

        if(button.animation.curAnim.name == "pressed" && button.animation.curAnim.finished)
            {
                FlxTween.tween(downBar,{y: 300},1,{ease: FlxEase.expoOut});
                FlxTween.tween(gameoverTxt,{y: -40},1,{ease: FlxEase.expoOut});
                FlxTween.tween(button,{y:-40},1,{ease: FlxEase.expoOut}); 
                FlxTween.tween(upperBar,{y: -30},1,{ease: FlxEase.expoOut});

                FlxTween.tween(FlxG.camera, {alpha: 0}, 1.5, {ease: FlxEase.smoothStepInOut,onComplete: function(shit:FlxTween)
                    {
                        Player.dead = false;
                        FlxG.resetState();
                    }});
            }
		super.update(elapsed);
	}
}
