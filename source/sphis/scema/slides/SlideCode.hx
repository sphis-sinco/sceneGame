package sphis.scema.slides;

import haxe.Json;
import haxe.Log;
import lime.utils.Assets;
import sphis.scema.gui.GuiConstants;

using StringTools;

class SlideCode
{
	public var slide_data:SlideData;

	public var variables:Map<String, Dynamic> = [];

	public function new(slide_path:String)
	{
		slide_data = cast Json.parse(Assets.getText(Paths.getSlideFile(slide_path)));

		parseCode(slide_data, slide_path);
	}

	public function parseCode(slide_data:SlideData, ?slide_path:String)
	{
		variables.clear();

		variables.set("Std", Std); // TODO: add a proxy for std
		variables.set("StringTools", StringTools);
		variables.set("Math", Math);
		variables.set("trace", (v, pos) ->
		{
			var str = '';

			str += (Paths.getSlideFile(slide_path) ?? slide_path);
			str += ": ";
			str += v;

			return Log.trace(str, null);
		});

		variables.set("Paths", Paths);
		variables.set("Main", Main);
		variables.set("GuiConstants", GuiConstants);

		var functions:Array<String> = Reflect.fields(slide_data.code);

		functions.remove("onCreate");
		functions.remove("onUpdate");

		for (field in functions)
			variables.set(field, _ -> onCustomFunction(field, _));
	}

	public function onCreate(?additional_variables:Map<String, Dynamic>)
	{
		onCustomFunction("onCreate", additional_variables);
	}

	public function onUpdate(?additional_variables:Map<String, Dynamic>)
	{
		onCustomFunction("onUpdate", additional_variables);
	}

	public function onCustomFunction(func:String, ?additional_variables:Map<String, Dynamic>):Dynamic
	{
		if (!Reflect.hasField(slide_data.code, func))
			return null;

		var functionCode:Array<String> = cast Reflect.getProperty(slide_data.code, func) ?? [];

		for (codeBlock in functionCode)
		{
			var runVal:Dynamic = run(codeBlock, additional_variables);

			if (runVal != null)
				return runVal;
		}

		return null;
	}

	public function run(script:String, ?additional_variables:Map<String, Dynamic>):Dynamic
	{
		var parser = new hscript.Parser();

		parser.allowJSON = true;
		parser.allowMetadata = true;
		parser.allowTypes = true;

		parser.preprocesorValues.set('debug', #if debug true #else false #end);

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
