package sphis.scema;

import lime.app.Application;

class GeneralConstants
{
	public static var VERSION(get, null):String;

	static function get_VERSION():String
	{
		return Application.current.meta.get("version");
	}
}
