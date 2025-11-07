package sphis.scema.slides;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import sphis.scema.slides.SlideData.SlidePropData;

using StringTools;

class SlideProps extends FlxTypedGroup<FlxBasic>
{
	public var slide_data:SlideData;

	override public function new(slide_path:String)
	{
		slide_data = cast Json.parse(Assets.getText(Paths.getSlideFile(slide_path)));

		super();

		for (prop in slide_data.props)
		{
			if (prop.position != null)
			{
				if (prop.position.length < 2)
				{
					skippedSlidePropGeneration(prop.id, INCOMPLETE_POSITION_FIELD);
					continue;
				}
			}

			if (prop.prop_type == "graphic")
			{
				if (!parseGraphicProp(prop))
					continue;
			}
		}
	}

	private function skippedSlidePropGeneration(prop_id:String, reason:SlidePropGenerationSkipReason)
	{
		trace("Skipped generation of slide prop: " + prop_id + " for reason: " + reason);
	}

	public function parseGraphicProp(prop:SlidePropData):Bool
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

	public function parseMakeGraphicProp(graphic_prop:FlxSprite, prop:SlidePropData):Bool
	{
		if (prop.graphic_settings.width == null || prop.graphic_settings.height == null)
		{
			if (prop.graphic_settings.width == null)
				skippedSlidePropGeneration(prop.id, MISSING_GRAPHIC_WIDTH);
			else
				skippedSlidePropGeneration(prop.id, MISSING_GRAPHIC_HEIGHT);
			return false;
		}

		var color = FlxColor.WHITE;

		if (prop.graphic_settings.color != null)
		{
			color = FlxColor.fromString(prop.graphic_settings.color);
		}

		graphic_prop.makeGraphic(prop.graphic_settings.width, prop.graphic_settings.height, color);

		if (prop.graphic_settings.screencenter)
		{
			graphic_prop.screenCenter();
		}

		add(graphic_prop);

		trace("Created Graphic Prop: " + prop.id);
		return true;
	}
}
