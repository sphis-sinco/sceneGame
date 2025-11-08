package sphis.scema.gui.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import lime.app.Application;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;
import sphis.scema.gui.buttons.GuiTextButton;
import sphis.scema.gui.text.GuiShadowText;
import sphis.scema.gui.text.GuiText;

using StringTools;

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

	public function getDebugInfo():Dynamic
	{
		return {
			scema: Application.current.meta.get("version"),
			fps: Main.fpsCounter.currentFPS,

			lb_1: "\n",

			component_count: this.members.length,
		}
	}

	public static var GUI_STATE_SORT_VALS = [];

	public function getDesiredDebugInfoOrder():Array<String>
	{
		return ["scema", "lb_1", "component"];
	}

	public function getDebugInfoSort(entry_1:String, entry_2:String):Int
	{
		var entry_1_value = getDesiredDebugInfoOrder().indexOf(entry_1);
		var entry_2_value = getDesiredDebugInfoOrder().indexOf(entry_2);

		var e1_sortVal = "f3 debug entry: " + entry_1;
		var e2_sortVal = "f3 debug entry: " + entry_2;

		var e1_sortVal_reason = "";
		var e2_sortVal_reason = "";

		if (entry_1_value == -1)
		{
			entry_1_value = getDesiredDebugInfoOrder().indexOf(entry_1.split("_")[0]);
			if (entry_1_value != -1)
				e1_sortVal_reason = " (prefix: " + entry_1.split("_")[0] + ")";
		}
		if (entry_2_value == -1)
		{
			entry_2_value = getDesiredDebugInfoOrder().indexOf(entry_2.split("_")[0]);
			if (entry_1_value != -1)
				e2_sortVal_reason = " (prefix: " + entry_2.split("_")[0] + ")";
		}

		e1_sortVal += " : " + entry_1_value + e1_sortVal_reason;
		e2_sortVal += " : " + entry_2_value + e2_sortVal_reason;

		if (!GUI_STATE_SORT_VALS.contains(e1_sortVal))
		{
			trace(e1_sortVal);
			GUI_STATE_SORT_VALS.push(e1_sortVal);
		}

		if (!GUI_STATE_SORT_VALS.contains(e2_sortVal))
		{
			trace(e2_sortVal);
			GUI_STATE_SORT_VALS.push(e2_sortVal);
		}

		return FlxSort.byValues(FlxSort.ASCENDING, entry_1_value, entry_2_value);
	}

	public function getDebugInfoString():String
	{
		var text:String = "";

		var fields:Array<String> = Reflect.fields(getDebugInfo());
		fields.sort(getDebugInfoSort);

		for (field in fields)
		{
			final property = Std.string(Reflect.getProperty(getDebugInfo(), field));

			if (property != "\n")
			{
				text += field + " : " + property + "\n";
			}
			else
			{
				text += "\n";
			}
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
