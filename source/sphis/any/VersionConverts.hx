package sphis.any;

using StringTools;

class VersionConverts
{
	public static function convertToIntArray(version:String):Array<Int>
	{
		var int_version:Array<Int> = [];

		for (entry in version.split('.'))
		{
			if (Std.parseInt(entry) != null)
				int_version.push(Std.parseInt(entry));
		}

		return int_version;
	}

	public static function convertToSingleLetters(version:String):String
	{
		var version_split = version.split(".");
		var version_string = "";

		var i = 0;
		for (entry in version_split)
		{
			if (entry != "0")
			{
				if (i == 0)
					version_string += "x" + entry;
				else if (i == 1)
					version_string += "y" + entry;
				else if (i == 2)
					version_string += "z" + entry;
				else
					version_string += "-" + entry;
			}

			i++;
		}

		if (version_string == "")
			version_string = "_0";

		return version_string;
	}
}
