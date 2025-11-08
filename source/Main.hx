package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsCounter = new FPS(0, 0);

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, sphis.scema.InitState));

		fpsCounter.visible = false;
		addChild(fpsCounter);
	}
}
