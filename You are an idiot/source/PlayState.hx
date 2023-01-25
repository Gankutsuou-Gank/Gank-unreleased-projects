package;

// import js.html.Text;
import Random;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.util.FlxFSM.StatePool;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxRandom;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import lime.app.Application;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseButton;
import lime.ui.Window;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.utils.Assets;

class PlayState extends FlxState
{
	var disX:Int;
	var disY:Int;
	var idiot:FlxSprite = new FlxSprite(0, 0);

	var ogWinY:Int;
	var ogWinX:Int;
	var winSpd = 15;
	var winW:Int;
	var winH:Int;
	var winVelox:Int = 1;
	var winVeloy:Int = 1;
	var winX:Int;
	var winY:Int;
	var createdWindow:Bool = false;

	override public function create()
	{
		super.create();

		FlxG.sound.playMusic(AssetPaths.idiot__ogg, 1, true);
		idiot.frames = FlxAtlasFrames.fromSparrow('assets/images/idot.png', 'assets/images/idot.xml');
		idiot.animation.addByPrefix('idle', "idiot00", 4);
		idiot.animation.play('idle', false);
		idiot.scale.set(0.35, 0.35);
		idiot.antialiasing = true;
		idiot.screenCenter(XY);
		add(idiot);

		FlxG.resizeGame(428, 321);
		FlxG.resizeWindow(428, 321);
		FlxG.autoPause = false;
		Application.current.window.borderless = true;

		// init some variables.
		winW = Application.current.window.width;
		winH = Application.current.window.height;
		disX = Application.current.window.display.currentMode.width;
		disY = Application.current.window.display.currentMode.height;
		ogWinX = Lib.application.window.x;
		ogWinY = Lib.application.window.y;
		winX = Lib.application.window.x;
		winY = Lib.application.window.y;

		// dumb window creation method.
		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			#if sys
			Sys.command("start YouAreAnIdiot!.exe");
			createdWindow = true;
			#end
			winSpd = FlxG.random.int(10, 25);
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// update some variables.
		Lib.application.window.x = winX + Std.int((winSpd * winVelox));
		Lib.application.window.y = winY + Std.int((winSpd * winVeloy));
		winY = Lib.application.window.y;
		winX = Lib.application.window.x;

		if (winY > (disY - winH) || winY < 30)
		{
			winVeloy = winVeloy * (-1 * 1);
			if (winY < 30)
			{
				winY = winY + 5;
			}
			else if (winY > (disY - winH))
			{
				winY = winY - 5;
			}
		}

		if (winX > (disX - winW) || winX < 0)
		{
			winVelox = winVelox * (-1 * 1);
			if (winX < 0)
			{
				winX = winX + 5;
			}
			else if (winX > (disX - winW))
			{
				winX = winX - 5;
			}
		}
	}
}
