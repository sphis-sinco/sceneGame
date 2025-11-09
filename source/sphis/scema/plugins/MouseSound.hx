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

	public function playSound(sound:FlxSound)
	{
		if (sound.playing)
			sound.stop();

		sound.pitch = FlxG.random.int(-2, 2);
		sound.play();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
			playSound(left_down);
		if (FlxG.mouse.justReleased)
			playSound(left_up);

		if (FlxG.mouse.justPressedMiddle)
			playSound(middle);

		if (FlxG.mouse.justPressedRight)
			playSound(right_down);
		if (FlxG.mouse.justReleasedRight)
			playSound(right_up);
	}
}
