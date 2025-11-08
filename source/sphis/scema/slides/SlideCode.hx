package sphis.scema.slides;

import haxe.Json;
import sphis.scema.code.CodeFileRunner;

using StringTools;

class SlideCode extends CodeFileRunner
{
	public var slide_data:SlideData;

	public var start_variables:Map<String, Dynamic> = [];

	override public function new(filepath:String, start_variables:Map<String, Dynamic>)
	{
		super(null);
		this.start_variables = start_variables;

		this.filepath = Paths.getSlideFile(filepath);

		slide_data = cast Json.parse(Paths.getText(this.filepath));

		parseCode(slide_data);
	}

	override public function initVars()
	{
		super.initVars();

		for (key => value in start_variables)
		{
			variables.set(key, value);
		}
	}

	public function parseCode(slide_data:SlideData)
	{
		initVars();

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
}
