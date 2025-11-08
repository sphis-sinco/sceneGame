package sphis.scema.code;

import haxe.Log;

class CodeRunner
{
	public var variables:Map<String, Dynamic> = null;

	public function new()
	{
		initVars();
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
			Log.trace(v, null);
		});
	}

	public function run(script:String, ?additional_variables:Map<String, Dynamic>):Dynamic
	{
		var parser = new hscript.Parser();

		parser.allowJSON = true;
		parser.allowMetadata = true;
		parser.allowTypes = true;

		parser.preprocesorValues.set('debug', #if debug true #else false #end);
		parser.preprocesorValues.set('TAIGO', #if TAIGO true #else false #end);

		var program = parser.parseString(script);
		var interp = new hscript.Interp();

		var vars = variables.copy();
		try
		{
			for (key => value in additional_variables)
				vars.set(key, value);
		}
		catch (e) {}

		interp.variables = vars.copy();

		return interp.execute(program);
	}
}
