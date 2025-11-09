package sphis.scema;

import lime.app.Application;
import polymod.util.DefineUtil;

class GeneralConstants
{
	public static var VERSION(get, null):String;

	static function get_VERSION():String
	{
		var version = Application.current.meta.get("version");

		if (DefineUtil.getDefineString("VERSION_SUFFIX", null) != null && DefineUtil.getDefineString("VERSION_SUFFIX", null) != "")
		{
			version += "." + DefineUtil.getDefineString("VERSION_SUFFIX");
		}

		return version;
	}
}
