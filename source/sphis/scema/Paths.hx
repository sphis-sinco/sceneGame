package sphis.scema;

import lime.utils.Assets;

class Paths
{
	public static function getImageFile(image:String):String
	{
		return 'assets/images/' + image + '.png';
	}

	public static function exists(path:String):Bool
	{
		return Assets.exists(path);
	}

	public static function getDataFile(datafile:String):String
	{
		return 'assets/data/' + datafile;
	}

	public static function getSlideFile(slidefile:String):String
	{
		return getDataFile('slides/' + slidefile + ".json");
	}

	public static function getScriptFile(scriptfile:String):String
	{
		return 'assets/scripts/' + scriptfile + ".txt";
	}
}
