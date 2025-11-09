package sphis.scema.plugins;

import flixel.FlxBasic;
import flixel.FlxG;
import sphis.scema.save.Save;

class VolumeManager extends FlxBasic
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.sound.volume = (cast Save.getSaveData(VOLUME) / 100) ?? 0.0;
	}
}
