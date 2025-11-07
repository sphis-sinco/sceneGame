package sphis.scema.gui.buttons;

import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;

typedef GuiTextButtonParameters =
{
	> GuiButtonParameters,

	var text_content:String;
}

class GuiTextButton extends FlxTypedGroup<FlxBasic>
{
	public var button:GuiButton;

	public var text_field:FlxText;
	public var text_field_shadow:FlxText;

	override public function new(params:GuiTextButtonParameters)
	{
		super();

		button = new GuiButton(params);

		text_field = GuiText.drawText(params?.text_content ?? "N/A");
		text_field.fieldWidth = button.snappedWidth;
		text_field.alignment = CENTER;

		text_field_shadow = GuiText.drawText(text_field.text);
		text_field_shadow.fieldWidth = text_field.fieldWidth;
		text_field_shadow.alignment = text_field.alignment;

		text_field_shadow.color = FlxColor.BLACK;
		text_field_shadow.alpha = 0.9;

		add(button);
		add(text_field_shadow);
		add(text_field);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		text_field.setPosition(button.x, button.y + ((button.height - text_field.height) / 2));
		text_field_shadow.setPosition(text_field.x + 2, text_field.y + 2);
	}
}
