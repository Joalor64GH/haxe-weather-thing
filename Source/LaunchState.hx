package;

import settings.InitialSetup;
import flixel.util.FlxTimer;
import haxe.Http;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import openfl.system.Capabilities;
import lime.app.Application;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import SusUtil;
import util.ACSpinner;

using StringTools;

/**The launch state. This contains variables used throughout the application, such as the icon theme.
@since v0.0.1 (March 2022)*/
class LaunchState extends FlxState {
    public static var windUnits:String = '';
    public static var temperatureUnits:String = ''; // THIS GETS SET IN THE SAVE DATA AFTER INITIAL SETUP, THOUGH THERE'LL ALSO BE A SETTINGS STATE.
    var gameCamera:FlxCamera;
    var appVersionInfo:String = 'HaxeFlixel Weather App - Made by devin503 - v';
    var loadingText:FlxText;
    var spin:ACSpinner;

    public function new() {
        super();
        appVersionInfo += Application.current.meta.get('version');
        #if debug
        trace("sus");
        #end
        trace(appVersionInfo);
        if (APIKey.WeatherKey == '')
            SusUtil.API_Failure(0); // Crash if the API key is missing.
    }
    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.SEVEN) {
            BasicOptionMenu.returnTo = this;
            FlxG.switchState(new BasicOptionMenu());
        }

        #if debug
        if (FlxG.keys.justPressed.R) {
            FlxG.switchState(new InitialSetup());
        }
        #end

        #if (web && debug)
        if (FlxG.keys.justPressed.L) {
            openSubState(new web.WebError('amogus'));
        }
        #end

        super.update(elapsed);
    }
    override function create() {
        gameCamera = new FlxCamera();
        gameCamera.bgColor = 0xFF000000; // so it's not extremely bright.
        FlxG.cameras.reset(gameCamera);

        loadingText = new FlxText(0, FlxG.height - 18, 0, "Please wait...", 16);
        add(loadingText);

        spin = new ACSpinner(FlxG.width - 50, FlxG.height - 50);
        spin.spin();
        add(spin);

        persistentUpdate = true; //speen

        #if debug
        trace('among us');
        #end
        new FlxTimer().start(3, function(tmr:FlxTimer) {
            if (!FlxG.save.data.finishedSetup) FlxG.switchState(new InitialSetup()) else {
                if (FlxG.save.data.tempUnits != null) {
                    temperatureUnits = FlxG.save.data.tempUnits[0];
                    windUnits = FlxG.save.data.tempUnits[1];
                    openSubState(new WeatherSearch());
                } else {
                    SusUtil.API_Failure(-999);
                }
            }
        });
    }
}