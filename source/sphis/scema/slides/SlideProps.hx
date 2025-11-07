package sphis.scema.slides;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.Json;
import lime.utils.Assets;
import sphis.scema.slides.SlideData.SlidePropData;

using StringTools;

class SlideProps extends FlxTypedGroup<FlxBasic>
{
	public var slide_data:SlideData;

	public var prop_ids:Array<String> = [];

	override public function new(slide_path:String)
	{
		slide_data = cast Json.parse(Assets.getText(Paths.getSlideFile(slide_path)));
		prop_ids = [];

		slide_data.props.sort((prop1, prop2) ->
		{
			return FlxSort.byValues(FlxSort.ASCENDING, prop1.z_index, prop2.z_index);
		});

		super();

		var i = 1;
		for (prop in slide_data.props)
		{
			if (prop.id == null)
			{
				skippedSlidePropGeneration("" + i, MISSING_ID);
				i++;
				continue;
			}

			if (prop.position != null)
			{
				if (prop.position.length < 2)
				{
					skippedSlidePropGeneration(prop.id, INCOMPLETE_POSITION_FIELD);
					i++;
					continue;
				}
			}

			if (prop.prop_type == "graphic")
			{
				if (!parseGraphicProp(prop))
				{
					i++;
					continue;
				}
			}

			i++;
		}
	}

	private function skippedSlidePropGeneration(prop_id:String, reason:SlidePropGenerationSkipReason)
	{
		var temp = "Skipped generation of ${PROP_PREFIX}${PROP_ID} for reason: ${REASON}";
		var message = temp.replace("${REASON}", cast reason);
		if (reason == MISSING_ID)
		{
			message = message.replace("${PROP_PREFIX}", "Prop #");
		}
		else
		{
			message = message.replace("${PROP_PREFIX}", "Slide Prop: ");
		}
		message = message.replace("${PROP_ID}", prop_id);

		trace(message);
	}

	function parseGraphicProp(prop:SlidePropData):Bool
	{
		if (prop.graphic_settings == null)
		{
			skippedSlidePropGeneration(prop.id, MISSING_GRAPHIC_SETTINGS);
			return false;
		}

		var graphic_prop:FlxSprite = new FlxSprite();

		if (prop.position != null)
		{
			graphic_prop.x = prop.position[0];
			graphic_prop.y = prop.position[1];
		}

		if (prop.graphic_settings.make_graphic)
		{
			return parseMakeGraphicProp(graphic_prop, prop);
		}

		return false;
	}

	function parseMakeGraphicProp(graphic_prop:FlxSprite, prop:SlidePropData):Bool
	{
		if (prop.graphic_settings.width == null || prop.graphic_settings.height == null)
		{
			if (prop.graphic_settings.width == null)
				skippedSlidePropGeneration(prop.id, MISSING_GRAPHIC_WIDTH);
			else
				skippedSlidePropGeneration(prop.id, MISSING_GRAPHIC_HEIGHT);
			return false;
		}

		var color:Null<FlxColor> = FlxColor.WHITE;

		if (prop.graphic_settings.color != null)
		{
			if (!prop.graphic_settings.color.startsWith("#")
				&& !prop.graphic_settings.color.startsWith("0x")
				&& FlxColor.fromString(prop.graphic_settings.color) == null)
				color = FlxColor.fromString("0x" + prop.graphic_settings.color);
			else
				color = FlxColor.fromString(prop.graphic_settings.color);

			if (color == null)
				color = FlxColor.WHITE;
		}

		graphic_prop.makeGraphic(prop.graphic_settings.width, prop.graphic_settings.height, color);

		if (prop.graphic_settings.screencenter)
		{
			graphic_prop.screenCenter();
		}

		add(graphic_prop);

		prop_ids.push(prop.id);
		trace("Created Make Graphic Prop: " + prop.id);
		return true;
	}
}
