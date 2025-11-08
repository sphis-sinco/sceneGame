package sphis.scema.slides;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.Json;
import sphis.scema.code.CodeRunner;
import sphis.scema.gui.buttons.GuiTextButton;
import sphis.scema.slides.SlideData.SlidePropData;

using StringTools;
using sphis.scema.slides.SlideComponents;

class SlideProps extends FlxTypedGroup<FlxBasic>
{
	public var slide_data:SlideData;

	public var prop_ids:Array<String> = [];

	public var prop_animation_offsets:Map<String, Map<String, Array<Float>>> = [];
	public var prop_animation_conditions:Map<String, Map<String, Array<String>>> = [];

	public var prop_id_to_index:Map<String, Int> = [];

	public var start_variables:Map<String, Dynamic> = [];

	override public function new(slide_path:String, start_variables:Map<String, Dynamic>)
	{
		super();
		slide_data = cast Json.parse(Paths.getText(Paths.getSlideFile(slide_path)));

		this.start_variables = start_variables;
		loadProps();
	}

	public function loadProps()
	{
		if (slide_data == null)
			return;

		if (this.members.length > 0)
		{
			for (prop in this.members)
			{
				this.members.remove(prop);
				prop.destroy();
			}
		}

		prop_animation_conditions.clear();
		prop_animation_offsets.clear();
		prop_animation_offsets.clear();

		prop_ids = [];

		slide_data.props.sort((prop1, prop2) ->
		{
			return FlxSort.byValues(FlxSort.ASCENDING, prop1.z_index, prop2.z_index);
		});

		var i = 1;
		for (prop in slide_data.props)
		{
			if (prop.id == null)
			{
				skippedSlidePropGeneration("" + i, MISSING_ID);
				i++;
				continue;
			}

			if (prop_ids.contains(prop.id))
			{
				skippedSlidePropGeneration(prop.id + " (Prop #" + i + ")", DUPLICATE_ID);
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

			if (prop.screencenter_settings != null)
			{
				if (prop.screencenter_settings.screencenter_position_offset != null)
				{
					if (prop.screencenter_settings.screencenter_position_offset.length < 2)
					{
						skippedSlidePropGeneration(prop.id, INCOMPLETE_SCREENCENTER_POSITION_OFFSET_FIELD);
						i++;
						continue;
					}
				}
			}

			if (prop.visible_conditions != null)
			{
				var code_runner = new CodeRunner();
				code_runner.initVars();

				for (condition in prop.visible_conditions)
				{
					if (condition.code == null)
					{
						skippedSlidePropGeneration(prop.id, MISSING_CODE);
						i++;
						continue;
					}

					var condition_result:Bool = cast code_runner.run(condition.code, start_variables);

					if (!condition_result && condition.high_priority)
					{
						skippedSlidePropGeneration(prop.id, FALSE_VISIBLE_CONDITION_HIGH_PRIORITY);
						i++;
						continue;
					}
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

			if (prop.prop_type == "button")
			{
				if (!parseButtonProp(prop))
				{
					i++;
					continue;
				}
			}

			i++;
		}

		trace("Generated " + this.members.length + " prop(s)");
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

	function parseButtonProp(prop:SlidePropData):Bool
	{
		if (prop.button_settings == null)
		{
			skippedSlidePropGeneration(prop.id, MISSING_BUTTON_SETTINGS);
			return false;
		}

		if (prop.button_settings.text_content == null)
		{
			skippedSlidePropGeneration(prop.id, MISSING_BUTTON_TEXT_CONTENT);
			return false;
		}

		if (prop?.button_settings?.text_shadow_color != null)
			prop.button_settings.text_shadow_color = getPropColor(cast prop?.button_settings?.text_shadow_color);
		if (prop.position != null)
		{
			prop.button_settings.position = new FlxPoint(prop.position[0], prop.position[1]);
		}
		else
		{
			prop.button_settings.position = new FlxPoint();
		}

		var button_prop = new GuiTextButton(prop.button_settings);

		if (prop.screencenter_settings.screencenter)
		{
			button_prop.button.screenCenter();

			if (prop.screencenter_settings.screencenter_position_offset != null)
			{
				button_prop.button.x += prop.screencenter_settings.screencenter_position_offset[0];
				button_prop.button.y += prop.screencenter_settings.screencenter_position_offset[1];
			}
		}

		button_prop.script_runner_additional_variables = start_variables;

		prop_id_to_index.set(prop.id, this.members.length);
		add(button_prop);

		prop_ids.push(prop.id);
		trace("Created Button Prop: " + prop.id);
		return true;
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

		if (slide_data.getComponent('universal_image_path_prefix') != null)
			prop.graphic_settings.image_path = Std.string(slide_data.getComponent('universal_image_path_prefix')) + prop.graphic_settings.image_path;

		if (!Paths.exists(Paths.getImageFile(prop.graphic_settings.image_path)))
		{
			skippedSlidePropGeneration(prop.id, NONEXISTANT_IMAGE_PATH, {
				REASON_IMAGE_PATH: prop.graphic_settings.image_path
			});
			return false;
		}

		graphic_prop.loadGraphic(Paths.getImageFile(prop.graphic_settings.image_path));

		graphic_prop.color = getPropColor(prop.graphic_settings.color);

		if (prop.screencenter_settings.screencenter)
		{
			graphic_prop.screenCenter();

			if (prop.screencenter_settings.screencenter_position_offset != null)
			{
				graphic_prop.x += prop.screencenter_settings.screencenter_position_offset[0];
				graphic_prop.y += prop.screencenter_settings.screencenter_position_offset[1];
			}
		}

		if (prop.graphic_settings.animation_type != null)
		{
			return parseAnimatedImageGraphicProp(graphic_prop, prop);
		}

		prop_id_to_index.set(prop.id, this.members.length);
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
					var offsets = getPropAnimationOffsets(prop.id, animName);
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
							// graphic_prop.animation.play(animation);
							propPlayAnimation(prop.id, animation);
						}
					}
				});

				if (graphic_prop.animation.getNameList().contains(animation.name)
					&& doesPropAnimationHaveCondition(prop.id, animation.name, 'default'))
					graphic_prop.animation.play(animation.name);

				i++;
			}
		}

		prop_id_to_index.set(prop.id, this.members.length);
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

		graphic_prop.makeGraphic(prop.graphic_settings.width, prop.graphic_settings.height, getPropColor(prop.graphic_settings.color));

		if (prop.screencenter_settings.screencenter)
		{
			graphic_prop.screenCenter();

			if (prop.screencenter_settings.screencenter_position_offset != null)
			{
				graphic_prop.x += prop.screencenter_settings.screencenter_position_offset[0];
				graphic_prop.y += prop.screencenter_settings.screencenter_position_offset[1];
			}
		}

		prop_id_to_index.set(prop.id, this.members.length);
		add(graphic_prop);

		prop_ids.push(prop.id);
		trace("Created Make Graphic Prop: " + prop.id);
		return true;
	}

	function getPropColor(color_string:String):Null<FlxColor>
	{
		var color:Null<FlxColor> = FlxColor.WHITE;

		if (color_string != null)
		{
			if (!color_string.startsWith("#") && !color_string.startsWith("0x") && FlxColor.fromString(color_string) == null)
				color = FlxColor.fromString("0x" + color_string);
			else
				color = FlxColor.fromString(color_string);

			if (color == null)
				color = FlxColor.WHITE;
		}

		return color;
	}

	public function getPropAnimationConditions(prop:String, name:String):Array<String>
	{
		return prop_animation_conditions.get(prop).get(name);
	}

	public function doesPropAnimationHaveCondition(prop:String, name:String, condition:String):Bool
	{
		return getPropAnimationConditions(prop, name).contains(condition);
	}

	public function getPropAnimationOffsets(prop:String, name:String):Array<Float>
	{
		return prop_animation_offsets.get(prop).get(name);
	}

	public function propPlayAnimation(prop:String, animation:String)
	{
		var prop:FlxSprite = getGraphicProp(prop);
		if (prop != null)
			prop.animation.play(animation);
	}

	public function propsPauseAnimation()
	{
		for (prop in this.prop_ids)
		{
			var prop:FlxSprite = getGraphicProp(prop);
			if (prop != null)
				prop.animation.pause();
		}
	}

	public function propsUnpauseAnimation()
	{
		for (prop in this.prop_ids)
		{
			var prop:FlxSprite = getGraphicProp(prop);
			if (prop != null)
				prop.animation.resume();
		}
	}

	public function getGraphicProp(prop:String):FlxSprite
	{
		var prop = getProp(prop);
		var prop_class_name = Type.getClassName(Type.getClass(prop));

		if (prop_class_name.split('.')[prop_class_name.split('.').length - 1] == "FlxSprite")
			return cast prop;

		return null;
	}

	public function getButtonProp(prop:String):GuiTextButton
	{
		var prop = getProp(prop);
		var prop_class_name = Type.getClassName(Type.getClass(prop));

		if (prop_class_name.split('.')[prop_class_name.split('.').length - 1] == "GuiTextButton")
			return cast prop;

		return null;
	}

	public function buttonPropSetVariable(prop:String, variable:String, value:Dynamic)
	{
		var prop:GuiTextButton = getButtonProp(prop);

		prop.script_runner_additional_variables.set(variable, value);
	}

	public function getProp(prop:String):FlxBasic
	{
		return this.members[prop_id_to_index.get(prop)];
	}
}
