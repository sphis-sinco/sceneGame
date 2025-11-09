package sphis.scema.code;

import haxe.io.Path;
import polymod.fs.ZipFileSystem;

using StringTools;

#if sys
import sys.FileSystem;
#end

class CodeGroup
{
	public var members:Array<CodeFileRunner> = [];

	public function new(?starting_path_addition:String)
	{
		var path = 'assets/scripts/' + starting_path_addition + '/';

		#if !sys
		for (file in new ZipFileSystem({}).readDirectoryRecursive(path))
		#else
		var files = Paths.getTypeArray('Script File', 'scripts', ['.txt'], [path]);

		for (file in files)
		#end
		{
			var new_script_file = new CodeFileRunner(Path.withoutDirectory(Path.withoutExtension(file.replace("//", "/"))), starting_path_addition);
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
