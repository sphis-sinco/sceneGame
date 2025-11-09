package source.sphis.scema.compiling;

import haxe.Timer;
#if sys
import sys.io.File;
#end

class Prebuild
{
	static var time_path:String = ".dev/time.txt";

	static function main()
	{
		trace("Performing prebuild tasks...");

		#if sys
		trace("Saving time file...");
		File.saveContent(time_path, Std.string(Timer.stamp()));
		#end
	}
}
