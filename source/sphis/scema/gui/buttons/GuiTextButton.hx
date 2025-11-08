package sphis.scema.gui.buttons;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import sphis.scema.code.CodeRunner;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;
import sphis.scema.gui.text.GuiShadowText;
import sphis.scema.slides.SlideData.SlidePropTextSettingsData;

typedef GuiTextButtonParameters =
{
	> GuiButtonParameters,

	> SlidePropTextSettingsData,

	var ?pressed_callback:Array<String>;
	var ?pressed_callback_code:Void->Void;
}

class GuiTextButton extends FlxTypedGroup<FlxBasic>
{
	public var pressed_callback:Array<String>;
	public var pressed_callback_code:Void->Void;

	public var button:GuiButton;
	public var button_highlight:GuiButton;

	public var text_field:GuiShadowText;

	public var script_runner:CodeRunner;
	public var script_runner_additional_variables:Map<String, Dynamic> = [];

	override public function new(params:GuiTextButtonParameters)
	{
		super();

		this.pressed_callback = params.pressed_callback;
		this.pressed_callback_code = params.pressed_callback_code;

		script_runner = new CodeRunner();
		script_runner.initVars();

		button = new GuiButton(params);

		if (params?.graphic?.image_path != null && Paths.exists(params?.graphic?.image_path + "-highlight"))
			params.graphic.image_path = params.graphic.image_path += "-highlight";
		else
		{
			params.graphic = {
				corner_radius: 4,
				image_path: "gui/button-highlight"
			};
		}

		button_highlight = new GuiButton(params);

		text_field = new GuiShadowText(params);
		text_field.text_field.fieldWidth = button.snappedWidth;
		text_field.text_field.alignment = CENTER;

		add(button);
		add(button_highlight);

		add(text_field);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		button_highlight.setPosition(button.x, button.y);
		text_field.setPosition(button.x, button.y + ((button.height - text_field.text_field.height) / 2));

		button_highlight.visible = FlxG.mouse.overlaps(button);
		button.visible = !FlxG.mouse.overlaps(button);

		if (FlxG.mouse.justReleased && button_highlight.visible)
		{
			if (pressed_callback != null)
			{
				for (line in pressed_callback)
					script_runner.run(line, script_runner_additional_variables);
			}
			if (pressed_callback_code != null)
				pressed_callback_code();
		}
	}
}
