package sphis.scema.gui.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import lime.app.Application;
import sphis.scema.code.CodeGroup;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;
import sphis.scema.gui.buttons.GuiTextButton;
import sphis.scema.gui.text.GuiShadowText;
import sphis.scema.gui.text.GuiText;

using Reflect;
using StringTools;

class GuiState extends FlxState
{
	public var debugText:GuiShadowText;

	public var script_files:CodeGroup;

	override public function new(?starting_path_addtion:String)
	{
		super();

		script_files = new CodeGroup(starting_path_addtion);

		var guistate_script_files = new CodeGroup("guistate/");
		for (script in guistate_script_files.members)
		{
			script_files.add(script);
		}
		script_files.runAll(getAdditionalVariables());
	}

	public function getAdditionalVariables():Map<String, Dynamic>
	{
		return [
			"current_state" => this,
			"script_info" => {},
			"debug_script_info" => {},
			"pre_desired_info_order" => [],
			"post_desired_info_order" => []
		];
	}

	override function create()
	{
		super.create();

		debugText = new GuiShadowText("", 0, 0);

		debugText.text_field.alignment = LEFT;
		debugText.text_field.fieldWidth = FlxG.width;

		add(debugText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if F3_MENU
		if (FlxG.keys.anyPressed([getDebugKey()]))
			debugText.text = getInfoString(getDebugInfo());
		else
		#end
		debugText.text = getInfoString(getNonDebugInfo());
	}

	public function getDebugKey():FlxKey
	{
		return F3;
	}

	public function getNonDebugInfo():Dynamic
	{
		var info = {
			scema: Application.current.meta.get("version"),
		}

		if (script_files.getVariables().exists("script_info"))
		{
			var o:Dynamic = script_files.getVariables().get("script_info");
			for (e in o.fields())
				info.setProperty(e, o.getProperty(e));
		}

		return info;
	}

	public function getDebugInfo():Dynamic
	{
		var info:Dynamic = {
			fps: Main.fpsCounter.currentFPS,

			lb_1: "\n",

			component_count: this.members.length,
		};

		for (e in getNonDebugInfo().fields())
			info.setProperty(e, getNonDebugInfo().getProperty(e));

		if (script_files.getVariables().exists("debug_script_info"))
		{
			var o:Dynamic = script_files.getVariables().get("debug_script_info");
			for (e in o.fields())
				info.setProperty(e, o.getProperty(e));
		}

		return info;
	}

	public static var GUI_STATE_SORT_VALS = [];

	public function getDesiredInfoOrder():Array<String>
	{
		var order = [];

		if (script_files.getVariables().exists("pre_desired_info_order"))
		{
			var o:Array<String> = script_files.getVariables().get("pre_desired_info_order");
			for (e in o)
				order.push(e);
		}

		order.push("scema");
		order.push("fps");
		order.push("lb_1");
		order.push("component");

		if (script_files.getVariables().exists("post_desired_info_order"))
		{
			var o:Array<String> = script_files.getVariables().get("post_desired_info_order");
			for (e in o)
				order.push(e);
		}

		return order;
	}

	public function getInfoSort(entry_1:String, entry_2:String):Int
	{
		var entry_1_value = getDesiredInfoOrder().indexOf(entry_1);
		var entry_2_value = getDesiredInfoOrder().indexOf(entry_2);

		var e1_sortVal = "f3 debug entry: " + entry_1;
		var e2_sortVal = "f3 debug entry: " + entry_2;

		var e1_sortVal_reason = "";
		var e2_sortVal_reason = "";

		if (entry_1_value == -1)
		{
			entry_1_value = getDesiredInfoOrder().indexOf(entry_1.split("_")[0]);
			if (entry_1_value != -1)
				e1_sortVal_reason = " (prefix: " + entry_1.split("_")[0] + ")";
		}
		if (entry_2_value == -1)
		{
			entry_2_value = getDesiredInfoOrder().indexOf(entry_2.split("_")[0]);
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

	public function getInfoString(info:Dynamic):String
	{
		var text:String = "";

		var fields:Array<String> = info.fields();
		fields.sort(getInfoSort);

		for (field in fields)
		{
			final property = Std.string(info.getProperty(field));

			if (property != "\n")
				text += field + " : " + property + "\n";
			else
				text += "\n";
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
