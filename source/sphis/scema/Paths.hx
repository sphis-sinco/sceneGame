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
		#if sys
		return sys.FileSystem.exists(path);
		#end

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

	public static function getText(path:String):String
	{
		#if sys
		return sys.io.File.getContent(path);
		#end

		return Assets.getText(path);
	}
}
