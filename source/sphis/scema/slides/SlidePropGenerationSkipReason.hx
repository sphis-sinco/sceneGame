package sphis.scema.slides;

enum abstract SlidePropGenerationSkipReason(String)
{
	var INCOMPLETE_POSITION_FIELD = "Incomplete Position Field";

	var MISSING_GRAPHIC_SETTINGS = "Missing graphic_settings Field";

	var MISSING_GRAPHIC_WIDTH = "Missing graphic_settings.width Field";
	var MISSING_GRAPHIC_HEIGHT = "Missing graphic_settings.height Field";
}
