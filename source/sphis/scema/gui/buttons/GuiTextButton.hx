package sphis.scema.gui.buttons;

import flixel.text.FlxText;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;

typedef GuiTextButtonParameters =
{
	> GuiButtonParameters,

	var text:String;
}

class GuiTextButton extends GuiButton
{
	public var text:FlxText;

	override public function new(params:GuiTextButtonParameters)
	{
		super(params);

		text = new FlxText(0, 0, 0,);
	}
}
