package sphis.scema.code;

import flixel.FlxG;
import haxe.Log;
import sphis.scema.gui.GuiConstants;

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
		variables.set("null", null);

		variables.set("defines", {
			debug: #if debug true #else false #end,
			TAIGO: #if TAIGO true #else false #end
		});

		variables.set("PlayState", PlayState.instance);

		variables.set("Paths", Paths);
		variables.set("Main", Main);

		variables.set("GuiConstants", GuiConstants);

		variables.set("FlxG", FlxG);
	}

	public function run(script:String, ?additional_variables:Map<String, Dynamic>):Dynamic
	{
		if (parser == null)
			initParser();

		var program = parser.parseString(script);

		var vars = variables.copy();
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

		return execution;
	}
}
