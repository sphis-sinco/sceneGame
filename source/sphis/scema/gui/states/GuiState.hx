package sphis.scema.gui.states;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;
import sphis.scema.gui.buttons.GuiTextButton;
import sphis.scema.gui.text.GuiShadowText;
import sphis.scema.gui.text.GuiText;

class GuiState extends FlxState
{
	public function createTextButton(params:GuiTextButtonParameters):GuiTextButton
	{
		return new GuiTextButton(params);
	}

	public function createButton(params:GuiButtonParameters):GuiTextButton
	{
		return new GuiTextButton(cast params);
	}

	public function drawShadowedText(text:String, ?position:FlxPoint):GuiShadowText
	{
		return new GuiShadowText(text, position?.x ?? 0, position?.y ?? 0);
	}

	public function drawText(text:String, ?position:FlxPoint):FlxText
	{
		return GuiText.drawText(text, position);
	}

	public function drawColoredShadowedText(text:String, ?color:FlxColor = FlxColor.WHITE, ?position:FlxPoint):GuiShadowText
	{
		var text = new GuiShadowText(text, position?.x ?? 0, position?.y ?? 0);
		text.text_field.color = color;
		return text;
	}

	public function drawColoredText(text:String, ?color:FlxColor = FlxColor.WHITE, ?position:FlxPoint):FlxText
	{
		var text = GuiText.drawText(text, position);
		text.color = color;
		return text;
	}
}
