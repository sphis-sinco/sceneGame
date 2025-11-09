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
			var int_entry = (Std.parseInt(entry) ?? null);

			if (int_entry < 1 && int_entry != null)
			{
				i++;
				continue;
			}

			if (i == 0)
				version_string += "x" + entry;
			else if (i == 1)
				version_string += "y" + entry;
			else if (i == 2)
				version_string += "z" + entry;
			else
				version_string += "-" + entry;

			i++;
		}

		if (version_string == "")
			version_string = "_0";

		return version_string;
	}
}
