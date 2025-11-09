package source.sphis.scema.compiling;

import haxe.Timer;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Postbuild
{
	static var time_path:String = ".dev/time.txt";

	static function main()
	{
		trace("Performing postbuild tasks...");

		#if sys
		var current_time:Float;
		current_time = Timer.stamp();
		if (FileSystem.exists(time_path))
		{
			trace("Found time path!");

			var previous_time:Float = Std.parseFloat(File.getContent(time_path));

			var difference:Float;
			difference = current_time - previous_time;
			difference = roundToTwoDecimals(difference);

			var timeString:String = difference + "s";

			if (difference > 60)
				timeString = roundToTwoDecimals(difference / 60) + "m";
			if (difference > (60 * 60))
				timeString = roundToTwoDecimals(difference / (60 * 60)) + "h";

			trace("Compilation time: " + timeString);
		}
		#end
	}

	static function roundToTwoDecimals(value:Float):Float
	{
		return Math.round(value * 100) / 100;
	}
}
