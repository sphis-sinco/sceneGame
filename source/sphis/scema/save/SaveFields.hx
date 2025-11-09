package sphis.scema.save;

enum abstract SaveFields(String) from String to String
{
	var VERSION = "version";
	var SIMPLE_VERSION = "simple_version";
	var VOLUME = "volume";
	var DEBUG_TEXT = "debug_text";
	var CHECK_OUTDATED = "check_outdated";
}
