package sphis.scema.code;

import flixel.FlxG;
import flixel.util.FlxColor;
import haxe.Log;
import sphis.scema.gui.GuiConstants;
import sphis.scema.gui.states.GuiMainMenu;
import sphis.scema.save.Save;

using Reflect;

class CodeRunner
{
	public var variables:Map<String, Dynamic> = null;

	public var parser = new hscript.Parser();
	public var interp = new hscript.Interp();

	public function new()
	{
		initParser();

		initVars();
	}

	public function initParser()
	{
		parser = new hscript.Parser();

		parser.allowJSON = true;
		parser.allowMetadata = true;
		parser.allowTypes = true;
	}

	public function initVars()
	{
		if (variables == null)
			variables = new Map<String, Dynamic>();

		variables.clear();

		variables.set("Std", Std); // TODO: add a proxy for std
		variables.set("StringTools", StringTools);
		variables.set("Math", Math);
		variables.set("trace", (v, pos) ->
		{
			Log.trace(Std.string(v), null);
		});
		variables.set("Reflect", Reflect);

		variables.set("GuiMainMenu", GuiMainMenu);
		variables.set("PlayState", PlayState.instance);

		variables.set("Paths", Paths);
		variables.set("Main", Main);

		variables.set("GeneralConstants", GeneralConstants);
		variables.set("GuiConstants", GuiConstants);

		variables.set("PlayState", PlayState);

		variables.set("FlxG", FlxG);
		variables.set("FlxG.camera.fade", (color, duration, fade_in, on_complete, force) -> FlxG.camera.fade(color, duration, fade_in, on_complete, force));
		variables.set("FlxColor", {
			TRANSPARENT: FlxColor.TRANSPARENT,
			WHITE: FlxColor.WHITE,
			GRAY: FlxColor.GRAY,
			BLACK: FlxColor.BLACK,

			GREEN: FlxColor.GREEN,
			LIME: FlxColor.LIME,
			YELLOW: FlxColor.YELLOW,
			ORANGE: FlxColor.ORANGE,
			RED: FlxColor.RED,
			PURPLE: FlxColor.PURPLE,
			BLUE: FlxColor.BLUE,
			BROWN: FlxColor.BROWN,
			PINK: FlxColor.PINK,
			MAGENTA: FlxColor.MAGENTA,
			CYAN: FlxColor.CYAN,

			colorLookup: FlxColor.colorLookup,

			fromInt: FlxColor.fromInt,
			fromRGB: FlxColor.fromRGB,
			fromRGBFloat: FlxColor.fromRGBFloat,
			fromCMYK: FlxColor.fromCMYK,
			fromHSB: FlxColor.fromHSB,
			fromHSL: FlxColor.fromHSL,
			fromString: FlxColor.fromString,

			getHSBColorWheel: FlxColor.getHSBColorWheel,

			interpolate: FlxColor.interpolate,
			gradient: FlxColor.gradient,
			multiply: FlxColor.multiply,
			add: FlxColor.add,
			subtract: FlxColor.subtract,

			object: new FlxColor(),
		});

		variables.set("Save", Save);

		variables.set("null", null);
		variables.set("true", true);
		variables.set("false", true);

		variables.set("defines", {
			debug: #if debug true #else false #end,
			TAIGO: #if TAIGO true #else false #end
		});
		variables.set("current_state", FlxG.state);
	}

	public function run(script:String, ?additional_variables:Map<String, Dynamic>):Dynamic
	{
		if (parser == null)
			initParser();

		var program = parser.parseString(script);

		var vars = variables?.copy() ?? [];
		try
		{
			for (key => value in additional_variables)
				vars.set(key, value);
		}
		catch (e) {}

		interp = new hscript.Interp();
		interp.variables = vars.copy();

		var execution = interp.execute(program);

		variables = interp.variables.copy();

		@:privateAccess
		for (key => value in interp.locals)
		{
			if (value.hasField("r"))
				variables.set(key, value.field("r"));
			else
			{
				trace(key + ": " + value);
				variables.set(key, value);
			}
		}

		return execution;
	}
}
