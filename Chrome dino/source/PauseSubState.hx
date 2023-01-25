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

class PauseSubState extends FlxSubState
{
	var grad:FlxSprite;
    var pauseTxt:FlxText;
    var button:FlxSprite;
    var downBar:FlxSprite;
    var upperBar:FlxSprite;
	public override function create()
	{
        grad = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.BLACK], 1, 90, true);
		grad.alpha = 0.3;
		add(grad);
        
        pauseTxt = new FlxText(247,-30); //120
        pauseTxt.font = "assets/fonts/PressStart2P.ttf";
        pauseTxt.text = "Paused";
        pauseTxt.scale.set(3,3);
        pauseTxt.setBorderStyle(SHADOW, FlxColor.WHITE, 1, 1);
        pauseTxt.color = FlxColor.fromString("#535353");
        
        add(pauseTxt);

       upperBar = new FlxSprite(0,-30);
       upperBar.makeGraphic(FlxG.width,30,FlxColor.fromString("#414141"));
       add(upperBar);


       downBar = new FlxSprite(0,300);
       downBar.makeGraphic(FlxG.width,30,FlxColor.fromString("#414141"));
       
       add(downBar);
        // 414141
        FlxTween.tween(downBar,{y: 271},1,{ease: FlxEase.expoInOut});
        FlxTween.tween(pauseTxt,{y: 92},1,{ease: FlxEase.expoInOut});
        FlxTween.tween(upperBar,{y: 0},1,{ease: FlxEase.expoInOut});
		super.create();
	}

	override public function update(elapsed:Float)
	{
        if(FlxG.keys.anyJustPressed([ESCAPE]))
            {
                FlxTween.tween(downBar,{y: 300},1,{ease: FlxEase.expoInOut});
                FlxTween.tween(pauseTxt,{y: -30},1,{ease: FlxEase.expoInOut});
                FlxTween.tween(upperBar,{y: -30},1,{ease: FlxEase.expoInOut,onComplete: function(shit:FlxTween)
                    {
                        close();
                    }});
            }
		super.update(elapsed);
	}
}
