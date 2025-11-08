package sphis.scema;

import lime.app.Application;

class GeneralConstants
{
	public static var VERSION(default, null):String = Application.current.meta.get("version");
}
