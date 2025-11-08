package sphis.scema.code;

import haxe.io.Path;
import polymod.fs.ZipFileSystem;

using StringTools;

class CodeGroup
{
	public var members:Array<CodeFileRunner> = [];

	public function new(?starting_path_addtion:String)
	{
		for (file in new ZipFileSystem({}).readDirectoryRecursive('assets/scripts/' + starting_path_addtion))
		{
			var new_script_file = new CodeFileRunner(Path.withoutExtension(file), starting_path_addtion);
			add(new_script_file);
		}
	}

	public function add(runner:CodeFileRunner)
	{
		members.push(runner);
	}

	public function runAll(?additional_variables:Map<String, Dynamic>):Dynamic
	{
		for (file in members)
		{
			var runVal:Dynamic = run(file.filepath, additional_variables);

			if (runVal != null)
				return runVal;
		}

		return null;
	}

	public function run(filepath:String, ?additional_variables:Map<String, Dynamic>):Dynamic
	{
		for (file in members)
		{
			if (file.filepath == filepath)
			{
				var runVal:Dynamic = file.runFile(additional_variables);

				if (runVal != null)
					return runVal;
			}
		}

		return null;
	}

	public function getVariables():Map<String, Dynamic>
	{
		var vars:Map<String, Dynamic> = [];

		for (file in members)
		{
			for (key => value in file.variables)
			{
				vars.set(key, value);
			}
		}

		return vars;
	}
}
