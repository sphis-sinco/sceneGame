package sphis.scema.code;

import haxe.io.Path;
import polymod.fs.ZipFileSystem;

class CodeGroup
{
	public var members:Array<CodeFileRunner> = [];

	public function new()
	{
		for (file in new ZipFileSystem({}).readDirectoryRecursive('assets/scripts/'))
		{
			var new_script_file = new CodeFileRunner(Path.withoutExtension(file));
			add(new_script_file);
		}
	}

	public function add(runner:CodeFileRunner)
	{
		members.push(runner);
	}

	public function runAll(?additional_variables:Map<String, Dynamic>)
	{
		for (file in members)
		{
			run(file.filepath, additional_variables);
		}
	}

	public function run(filepath:String, ?additional_variables:Map<String, Dynamic>)
	{
		for (file in members)
		{
			if (file.filepath == filepath)
				file.runFile(additional_variables);
		}
	}
}
