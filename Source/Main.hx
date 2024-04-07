package;

import lime.app.Application;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.Capabilities;

class Main extends Sprite
{
	var gameWidth:Int = 1368;
	var gameHeight:Int = 700;
	var framerate:Int = 90;
	var skipSplash:Bool = false;
	var startFullscreen:Bool = false;
	public static var fpsVar:FPS;
	var initialState:Class<FlxState> = LaunchState;

	public static function main():Void
		Lib.current.addChild(new Main());
	
	public function new()
	{
		super();
			
			addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));
	
			fpsVar = new FPS(10, 3, 0xFFFFFF);
			addChild(fpsVar);
			if (fpsVar != null)
				fpsVar.visible = true;
	
			#if html5
			FlxG.autoPause = false;
			FlxG.mouse.visible = false;
			#end
		}
}
