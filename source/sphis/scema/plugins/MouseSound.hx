package sphis.scema.plugins;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;

class MouseSound extends FlxBasic
{
	public var left_down:FlxSound = new FlxSound().loadStream(Paths.getMouseSoundFile("left_down"));
	public var left_up:FlxSound = new FlxSound().loadStream(Paths.getMouseSoundFile("left_up"));

	public var middle:FlxSound = new FlxSound().loadStream(Paths.getMouseSoundFile("middle"));

	public var right_down:FlxSound = new FlxSound().loadStream(Paths.getMouseSoundFile("right_down"));
	public var right_up:FlxSound = new FlxSound().loadStream(Paths.getMouseSoundFile("right_up"));

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
			left_down.play();
		if (FlxG.mouse.justReleased)
			left_up.play();

		if (FlxG.mouse.justPressedMiddle)
			middle.play();

		if (FlxG.mouse.justPressedRight)
			right_down.play();
		if (FlxG.mouse.justReleasedRight)
			right_up.play();
	}
}
