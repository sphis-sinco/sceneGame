package sphis.scema.gui.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;
import sphis.scema.gui.buttons.GuiTextButton;
import sphis.scema.gui.text.GuiShadowText;
import sphis.scema.gui.text.GuiText;

class GuiState extends FlxState
{
	public var debugText:GuiShadowText;

	override function create()
	{
		super.create();

		debugText = new GuiShadowText("", 0, 0);
		debugText.text_field.alignment = LEFT;
		add(debugText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if F3_MENU
		debugText.visible = FlxG.keys.anyPressed([getDebugKey()]);
		#end

		if (debugText.visible)
			debugText.text = getDebugInfoString();
	}

	public function getDebugKey():FlxKey
	{
		return F3;
	}

	public function getDebugInfo()
	{
		return {
			component_count: this.members.length,
			scema: Application.current.meta.get("version"),
		}
	}

	public function getDebugInfoString():String
	{
		var text:String = "";

		for (field in Reflect.fields(getDebugInfo()))
		{
			text += field + " : " + Reflect.getProperty(getDebugInfo(), field) + "\n";
		}

		return text;
	}

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
