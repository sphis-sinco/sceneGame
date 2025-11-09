package sphis.scema;

import lime.app.Application;
import polymod.util.DefineUtil;

class GeneralConstants
{
	public static var VERSION_SUFFIXLESS(get, null):String;

	static function get_VERSION_SUFFIXLESS():String
	{
		return Application.current.meta.get("version");
	}

	public static var VERSION(get, null):String;

	static function get_VERSION():String
	{
		var version = VERSION_SUFFIXLESS;

		if (!DefineUtil.getDefineBool("INCLUDE_VERSION_SUFFIXES"))
			return version;

		if (DefineUtil.getDefineString("VERSION_SUFFIX", null) != null && DefineUtil.getDefineString("VERSION_SUFFIX", null) != "")
			version += "." + DefineUtil.getDefineString("VERSION_SUFFIX");

		return version;
	}
}
