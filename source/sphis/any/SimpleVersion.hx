package sphis.any;

class SimpleVersion
{
	public static function convertToSingleLetters(version:String):String
	{
		var version_split = version.split(".");
		var version_string = "";

		var i = 0;
		for (entry in version_split)
		{
			var int_entry = (Std.parseInt(entry) ?? 0);

			if (int_entry < 1)
			{
				i++;
				continue;
			}

			if (i == 0)
				version_string += "x" + int_entry;
			else if (i == 1)
				version_string += "y" + int_entry;
			else if (i == 2)
				version_string += "z" + int_entry;
			else
				version_string += "-" + int_entry;

			i++;
		}

		if (version_string == "")
			version_string = "_0";

		return version_string;
	}
}
