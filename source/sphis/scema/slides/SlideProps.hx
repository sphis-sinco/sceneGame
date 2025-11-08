package sphis.scema.slides;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
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
	public var prop_animation_offsets:Map<String, Map<String, Array<Float>>> = [];
	public var prop_animation_conditions:Map<String, Map<String, Array<String>>> = [];

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

			// trace("Attempting creation of " + prop.id);

			if (prop.position != null)
			{
				if (prop.position.length < 2)
				{
					skippedSlidePropGeneration(prop.id, INCOMPLETE_POSITION_FIELD);
					i++;
					continue;
				}
			}

			if (prop.prop_type == null)
			{
				skippedSlidePropGeneration(prop.id, MISSING_PROP_TYPE);
				i++;
				continue;
			}

			if (prop.prop_type == "graphic")
			{
				if (prop.graphic_settings.screencenter_position_offset != null)
				{
					if (prop.graphic_settings.screencenter_position_offset.length < 2)
					{
						skippedSlidePropGeneration(prop.id, INCOMPLETE_SCREENCENTER_POSITION_OFFSET_FIELD);
						i++;
						continue;
					}
				}

				if (!parseGraphicProp(prop))
				{
					i++;
					continue;
				}
			}

			i++;
		}

		trace("Generated " + this.members.length + " prop(s)");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private function skippedSlidePropGeneration(prop_id:String, reason:SlidePropGenerationSkipReason, ?data:Dynamic)
	{
		var temp = "Skipped generation of ${PROP_PREFIX}${PROP_ID} for reason: ${REASON}";
		var message = temp.replace("${REASON}", cast reason);

		if (data?.REASON_IMAGE_PATH != null)
			message.replace("${REASON_IMAGE_PATH}", data.REASON_IMAGE_PATH);

		if (data?.ANIMATION_INDEX != null)
			message.replace("${ANIMATION_INDEX}", data.ANIMATION_INDEX);

		if (data?.ANIMATION_NAME != null)
			message.replace("${ANIMATION_NAME}", data.ANIMATION_NAME);

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

		return parseImageGraphicProp(graphic_prop, prop);
	}

	function parseImageGraphicProp(graphic_prop:FlxSprite, prop:SlidePropData):Bool
	{
		if (prop.graphic_settings.image_path == null)
		{
			skippedSlidePropGeneration(prop.id, MISSING_IMAGE_PATH);
			return false;
		}

		if (!Paths.exists(Paths.getImageFile(prop.graphic_settings.image_path)))
		{
			skippedSlidePropGeneration(prop.id, NONEXISTANT_IMAGE_PATH, {
				REASON_IMAGE_PATH: prop.graphic_settings.image_path
			});
			return false;
		}

		graphic_prop.loadGraphic(Paths.getImageFile(prop.graphic_settings.image_path));

		graphic_prop.color = getPropColor(prop);

		if (prop.graphic_settings.screencenter)
		{
			graphic_prop.screenCenter();

			if (prop.graphic_settings.screencenter_position_offset != null)
			{
				graphic_prop.x += prop.graphic_settings.screencenter_position_offset[0];
				graphic_prop.y += prop.graphic_settings.screencenter_position_offset[1];
			}
		}

		if (prop.graphic_settings.animation_type != null)
		{
			return parseAnimatedImageGraphicProp(graphic_prop, prop);
		}

		add(graphic_prop);

		prop_ids.push(prop.id);
		trace("Created Image Graphic Prop: " + prop.id);

		return true;
	}

	function parseAnimatedImageGraphicProp(graphic_prop:FlxSprite, prop:SlidePropData):Bool
	{
		if (prop.graphic_settings.animations == null)
		{
			skippedSlidePropGeneration(prop.id, MISSING_ANIMATIONS);
			return false;
		}

		if (prop.graphic_settings.animations.length == 0)
		{
			skippedSlidePropGeneration(prop.id, NONEXISTANT_ANIMATIONS);
			return false;
		}

		if (prop.graphic_settings.animation_type == "xml")
		{
			graphic_prop.frames = FlxAtlasFrames.fromSparrow(Paths.getImageFile(prop.graphic_settings.image_path),
				Paths.getImageFile(prop.graphic_settings.image_path).replace("png", "xml"));

			var i = 1;
			for (animation in prop.graphic_settings.animations)
			{
				if (animation.name == null)
				{
					skippedSlidePropGeneration(prop.id, MISSING_ANIMATION_NAME, {
						ANIMATION_INDEX: i
					});
					i++;
					return false;
				}

				if (animation.offsets != null)
				{
					if (animation.offsets.length < 2)
					{
						skippedSlidePropGeneration(prop.id, INCOMPLETE_ANIMATION_OFFSET_FIELD, {
							ANIMATION_INDEX: i
						});
						i++;
						return false;
					}
				}

				if (!prop_animation_conditions.exists(prop.id))
					prop_animation_conditions.set(prop.id, []);

				if (!prop_animation_offsets.exists(prop.id))
					prop_animation_offsets.set(prop.id, []);

				prop_animation_conditions.get(prop.id).set(animation.name, []);
				prop_animation_offsets.get(prop.id).set(animation.name, []);

				graphic_prop.animation.addByPrefix(animation.name, animation.prefix, animation?.framerate ?? 24, animation?.looped ?? true, animation?.flip_x,
					animation?.flip_y);

				prop_animation_conditions.get(prop.id).set(animation.name, animation.conditions ?? []);
				prop_animation_offsets.get(prop.id).set(animation.name, animation.offsets ?? [0, 0]);

				graphic_prop.animation.onBegin.add(animName ->
				{
					var offsets = prop_animation_offsets.get(prop.id).get(animName);
					graphic_prop.offset.set(offsets[0], offsets[1]);
				});

				graphic_prop.animation.onFinish.add(animName ->
				{
					// 'finished ' + animName

					for (animation in graphic_prop.animation.getNameList())
					{
						// 'checking ' + animation + ' for after-' + animName

						if (doesPropAnimationHaveCondition(prop.id, animation, 'after-' + animName))
						{
							// 'moved to ' + animation
							graphic_prop.animation.play(animation);
						}
					}
				});

				if (graphic_prop.animation.getNameList().contains(animation.name)
					&& doesPropAnimationHaveCondition(prop.id, animation.name, 'default'))
					graphic_prop.animation.play(animation.name);

				i++;
			}
		}

		add(graphic_prop);

		prop_ids.push(prop.id);
		trace("Created Animated Image Graphic Prop: " + prop.id);

		return true;
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

		graphic_prop.makeGraphic(prop.graphic_settings.width, prop.graphic_settings.height, getPropColor(prop));

		if (prop.graphic_settings.screencenter)
		{
			graphic_prop.screenCenter();

			if (prop.graphic_settings.screencenter_position_offset != null)
			{
				graphic_prop.x += prop.graphic_settings.screencenter_position_offset[0];
				graphic_prop.y += prop.graphic_settings.screencenter_position_offset[1];
			}
		}

		add(graphic_prop);

		prop_ids.push(prop.id);
		trace("Created Make Graphic Prop: " + prop.id);
		return true;
	}

	function getPropColor(prop:SlidePropData):Null<FlxColor>
	{
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

		return color;
	}

	public function getPropAnimationCondition(prop:String, name:String):Array<String>
		return prop_animation_conditions.get(prop).get(name);

	public function doesPropAnimationHaveCondition(prop:String, name:String, condition:String):Bool
		return prop_animation_conditions.get(prop).get(name).contains(condition);
}
