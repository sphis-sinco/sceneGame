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
}
