package sphis.scema.gui.states.outdated;

import haxe.Json;
import sphis.scema.save.Save;

using StringTools;

class OutdatedChecker
{
	public static var GAVE_OUTDATED_WARNING:Bool;
	public static var VERSION:String = "";

	public static function check(url:String = null)
	{
		if (GAVE_OUTDATED_WARNING)
			return;

		if (url == null || url.length == 0)
			url = "https://raw.githubusercontent.com/sphis-sinco/sceneGame/main/.dev/.gitinfo";
		if (Save.getSaveData(CHECK_OUTDATED) == true)
		{
			trace('checking for updates...');
			var http = new haxe.Http(url);
			http.onData = function(data:String)
			{
				var newVersion:GitInfoData = Json.parse(data) ?? {
					version: GeneralConstants.VERSION_SUFFIXLESS
				};
				VERSION = newVersion.version;

				trace("Git Version: " + newVersion.version);
				trace("Current Version: " + GeneralConstants.VERSION_SUFFIXLESS);

				if (newVersion.version != GeneralConstants.VERSION_SUFFIXLESS)
				{
					http = null;

					trace("OUTDATED");

					GAVE_OUTDATED_WARNING = true;
				}
			}
			http.onError = function(error)
			{
				trace('error: $error');
			}
			http.request();
		}
	}
}
