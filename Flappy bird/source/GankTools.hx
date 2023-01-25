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

class GankTools{
    inline public static function watch(obj:FlxObject,?move:Bool)
        {
            FlxG.watch.add(obj,"x");
            FlxG.watch.add(obj,"y");
            if(move)
                {
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
        }
     public static function initBtn(spr:FlxSprite,?callBack:Void->Void) {
            var overlap = false;
            var canPress = true;
                    if(FlxG.mouse.overlaps(spr))
                        overlap = true;
                    else
                        overlap = false;
    
                    if(FlxG.mouse.pressed && overlap)
                        {
                            
                            if(canPress)
                                {
                                    
                                    FlxTween.tween(spr,{y: spr.y += 2},0.2,{
                                        onComplete: function(twn:FlxTween) {
                                            if(canPress)
                                                canPress = false;
                                                callBack();
                                                spr.y -= 2;
                                        }
                                    });
                                }
                        }
            if(!canPress)
                return;
                    
        }
    inline public static function boundTo(value:Float, min:Float, max:Float):Float {
            return Math.max(min, Math.min(max, value));
        } // stolen from ninjamuffin lol.

}