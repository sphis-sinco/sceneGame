package sphis.scema.gui.buttons;

import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
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

	override public function new(params:GuiTextButtonParameters)
	{
		super();

		button = new GuiButton(params);
		text_field = GuiText.drawText(params?.text_content ?? "N/A");
		text_field.fieldWidth = button.snappedWidth;

		add(button);
		add(text_field);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		text_field.setPosition(button.x + ((button.snappedWidth + text_field.width) / 2), button.y + ((button.snappedHeight + text_field.height) / 2));
	}
}
