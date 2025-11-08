package sphis.scema.code;

import haxe.Log;
import lime.utils.Assets;

class CodeFileRunner extends CodeRunner
{
	public var filepath:String;
	public var file_content:String;

	override public function new(filepath:String, ?path_addtion:String)
	{
		if (filepath == null)
			return;

		this.filepath = Paths.getScriptFile(path_addtion + filepath);
		file_content = Paths.getText(this.filepath);

		super();
	}

	override function initVars()
	{
		super.initVars();

		variables.set("trace", (v, pos) ->
		{
			Log.trace(filepath + ": " + Std.string(v), null);
		});
	}

	public function runFile(additional_variable:Map<String, Dynamic>):Dynamic
	{
		return run(file_content, additional_variable);
	}
}
