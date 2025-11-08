package sphis.scema.code;

import haxe.Log;
import lime.utils.Assets;

class CodeFileRunner extends CodeRunner
{
	public var filepath:String;
	public var file_content:String;

	override public function new(filepath:String)
	{
		if (filepath == null)
			return;

		this.filepath = Paths.getScriptFile(filepath);
		file_content = Assets.getText(this.filepath);

		super();
	}

	override function initVars()
	{
		super.initVars();

		variables.set("trace", (v, pos) ->
		{
			Log.trace(filepath + ": " + v, null);
		});
	}

	public function runFile(additional_variable:Map<String, Dynamic>)
	{
		run(file_content, additional_variable);
	}
}
