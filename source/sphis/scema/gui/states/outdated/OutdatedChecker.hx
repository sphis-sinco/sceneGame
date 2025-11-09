package sphis.scema.gui.states.outdated;

import haxe.Json;

using StringTools;

class OutdatedChecker
{
	public static var GAVE_OUTDATED_WARNING:Bool = false;
	public static var VERSION:String = "";

	static function can_check_for_updates():Bool
		return true; // TODO: add save data for this

	public static function check(url:String = null):Bool
	{
		if (GAVE_OUTDATED_WARNING)
			return false;

		if (url == null || url.length == 0)
			url = "https://raw.githubusercontent.com/sphis-sinco/sceneGame/main/.dev/.gitinfo";
		if (can_check_for_updates())
		{
			trace('checking for updates...');
			var http = new haxe.Http(url);
			http.onData = function(data:String)
			{
				var newVersion:GitInfoData = Json.parse(data) ?? {
					version: GeneralConstants.VERSION
				};
				VERSION = newVersion.version;

				trace("Git Version: " + newVersion.version);
				trace("Current Version: " + GeneralConstants.VERSION);

				if (newVersion.version != GeneralConstants.VERSION)
				{
					http.onData = null;
					http.onError = null;
					http = null;

					GAVE_OUTDATED_WARNING = true;
					return true;
				}
				return false;
			}
			http.onError = function(error)
			{
				trace('error: $error');
			}
			http.request();
		}

		return false;
	}
}
