package sphis.scema.gui.buttons;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;

typedef GuiTextButtonParameters =
{
	> GuiButtonParameters,

	var text_content:String;

	var ?pressed_callback:Void->Void;
}

class GuiTextButton extends FlxTypedGroup<FlxBasic>
{
	public var pressed_callback:Void->Void;

	public var button:GuiButton;
	public var button_highlight:GuiButton;

	public var text_field:FlxText;
	public var text_field_shadow:FlxText;

	override public function new(params:GuiTextButtonParameters)
	{
		super();

		this.pressed_callback = params.pressed_callback;

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

		text_field = GuiText.drawText(params?.text_content ?? "N/A");
		text_field.fieldWidth = button.snappedWidth;
		text_field.alignment = CENTER;

		text_field_shadow = GuiText.drawText(text_field.text);
		text_field_shadow.fieldWidth = text_field.fieldWidth;
		text_field_shadow.alignment = text_field.alignment;

		text_field_shadow.color = FlxColor.BLACK;
		text_field_shadow.alpha = 0.9;

		add(button);
		add(button_highlight);

		add(text_field_shadow);
		add(text_field);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		button_highlight.setPosition(button.x, button.y);
		text_field.setPosition(button.x, button.y + ((button.height - text_field.height) / 2));
		text_field_shadow.setPosition(text_field.x + 2, text_field.y + 2);

		button_highlight.visible = FlxG.mouse.overlaps(button);
		button.visible = !FlxG.mouse.overlaps(button);

		if (FlxG.mouse.justReleased && button_highlight.visible && pressed_callback != null)
		{
			pressed_callback();
		}
	}
}
