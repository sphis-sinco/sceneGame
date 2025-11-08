package sphis.scema.slides;

enum abstract SlidePropGenerationSkipReason(String)
{
	var INCOMPLETE_POSITION_FIELD = "Incomplete position Field";
	var INCOMPLETE_SCREENCENTER_POSITION_OFFSET_FIELD = "Incomplete graphic_settings.screencenter_position_offset Field";
	var INCOMPLETE_ANIMATION_OFFSET_FIELD = "Incomplete graphic_settings.ANIMATIONS[${ANIMATION_INDEX}].offsets Field";

	var MISSING_ID = "Missing id Field";
	var MISSING_GRAPHIC_SETTINGS = "Missing graphic_settings Field";
	var MISSING_GRAPHIC_WIDTH = "Missing graphic_settings.width Field";
	var MISSING_GRAPHIC_HEIGHT = "Missing graphic_settings.height Field";
	var MISSING_IMAGE_PATH = "Missing graphic_settings.image_path Field";
	var MISSING_PROP_TYPE = "Missing prop_type Field";
	var MISSING_ANIMATIONS = "Missing graphic_settings.animations Field";
	var MISSING_ANIMATION_NAME = "Missing graphic_settings.animations[${ANIMATION_INDEX}].name Field";
	var MISSING_BUTTON_TEXT_CONTENT = "Missing button_settings.text_content Field";

	var NONEXISTANT_IMAGE_PATH = "${REASON_IMAGE_PATH} doesn't exist";
	var NONEXISTANT_ANIMATIONS = "graphic_settings.animations has no Entries";

	var DUPLICATE_ID = "id already used";
}
