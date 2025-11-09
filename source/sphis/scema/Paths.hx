package sphis.scema;

import lime.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
#end

class Paths
{
	public static function getImageFile(image:String):String
	{
		return 'assets/images/' + image + '.png';
	}

	public static function exists(path:String):Bool
	{
		#if sys
		return sys.FileSystem.exists(path);
		#end

		return Assets.exists(path);
	}

	public static function getDataFile(datafile:String):String
	{
		return 'assets/data/' + datafile;
	}

	public static function getSlideFile(slidefile:String):String
	{
		return getDataFile('slides/' + slidefile + ".json");
	}

	public static function getScriptFile(scriptfile:String):String
	{
		return 'assets/scripts/' + scriptfile + ".txt";
	}

	public static function getText(path:String):String
	{
		#if sys
		return sys.io.File.getContent(path);
		#end

		return Assets.getText(path);
	}

	public static function getSoundFile(soundFile:String):String
	{
		return 'assets/sounds/' + soundFile + ".wav";
	}

	public static function getMouseSoundFile(soundFile:String):String
	{
		return getSoundFile("mouse/" + soundFile);
	}

	public static function getTypeArray(type:String, type_folder:String, ext:Array<String>, paths:Array<String>,
			?foundFilesFunction:(Array<Dynamic>, String) -> Void = null):Array<String>
	{
		var arr:Array<String> = [];
		#if sys
		var arr_rawFileNames:Array<String> = [];
		var typePaths:Array<String> = paths;
		var typeExtensions:Array<String> = ext;

		var readFolder:Dynamic = function(folder:String, ogdir:String) {};

		var readFileFolder:Dynamic = function(folder:String, ogdir:String)
		{
			if (!FileSystem.isDirectory(ogdir + folder))
				return;

			for (file in FileSystem.readDirectory(ogdir + folder))
			{
				final endsplitter:String = !folder.endsWith('/') && !file.startsWith('/') ? '/' : '';
				for (extension in typeExtensions)
					if (file.endsWith(extension))
					{
						var path:String = ogdir + folder + endsplitter + file;
						path = path.replace('//', '/');

						// if (Defines.get('typeArray_dupeFilePrevention'))
						if (false)
						{
							if ((!arr_rawFileNames.contains(folder + endsplitter + file)) && !arr.contains(path))
							{
								arr_rawFileNames.push(folder + endsplitter + file);
								arr.push(path);
							}
						}
						else if (!arr.contains(path))
							arr.push(path);
					}

				if (!file.contains('.'))
					readFolder(file, ogdir + folder + endsplitter);
			}
		}

		readFolder = function(folder:String, ogdir:String)
		{
			if (!folder.contains('.'))
				readFileFolder(folder, ogdir);
			else
				readFileFolder(ogdir, '');
		}
		var readDir:Dynamic = function(directory:String)
		{
			if (exists(directory))
				for (folder in FileSystem.readDirectory(directory))
				{
					readFolder(folder, directory);
				}
		}

		for (path in typePaths)
		{
			readDir(path);
		}

		if (foundFilesFunction != null)
		{
			foundFilesFunction(arr, type);
		}
		else
		{
			trace('Found ' + arr.length + ' ' + type + ' files with paths: ' + paths);
			for (file in arr)
			{
				trace(' * ' + file);
			}
		}
		#end
		return arr;
	}
}
