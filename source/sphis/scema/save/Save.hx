package sphis.scema.save;

import flixel.util.FlxSave;
import haxe.Json;
import polymod.fs.MemoryZipFileSystem;
import polymod.fs.SysFileSystem;
import polymod.fs.ZipFileSystem;
import sphis.any.SimpleVersion;

using Reflect;

class Save
{
	public static var FILE_PATH:String = 'save.json';

	public static var DATA:Dynamic = {};

	public static var DEPRECATED_SAVEDATA_FIELDS_WITH_MSG:Map<SaveFields, String> = [];

	public static function emptySave()
	{
		return DATA.fields().length < 1;
	}

	public static function loadSave()
	{
		DATA = {};

		if (!Paths.exists(Paths.getDataFile(FILE_PATH)))
			return;

		DATA = Json.parse(Paths.getText(Paths.getDataFile(FILE_PATH)));
	}

	public static function initalizeSave()
	{
		loadSave();

		if (!emptySave())
			trace("loaded save data: " + DATA);

		handleEmptySave();
		updateSave();

		trace("updated save data: " + DATA);

		save();

		trace('Save data fields: ');
		for (field in DATA.fields())
		{
			var depricatedMsg = '';

			if (DEPRECATED_SAVEDATA_FIELDS_WITH_MSG.exists(field))
			{
				depricatedMsg += " (Deprecated" + DEPRECATED_SAVEDATA_FIELDS_WITH_MSG.get(field) + ")";
			}

			trace(' * ' + field + " : " + getSaveData(field) + depricatedMsg);
		}
	}

	public static function handleEmptySave()
	{
		if (DATA == null)
			loadSave();
		if (!emptySave())
			return;

		setSaveData(VERSION, GeneralConstants.VERSION);
		setSaveData(SIMPLE_VERSION, true);
	}

	public static function updateSave()
	{
		switch (getSaveData(VERSION))
		{
			case "0.0.18":
				setSaveData(SIMPLE_VERSION, true);

			default:
				trace("Save data version " + SimpleVersion.convertToSingleLetters(getSaveData(VERSION)) + " has no updateSave case");
		}

		setSaveData(VERSION, GeneralConstants.VERSION);
		trace("Updated to version " + SimpleVersion.convertToSingleLetters(getSaveData(VERSION)));
	}

	public static function getSaveData(field:SaveFields):Dynamic
	{
		if (DATA.hasField(field))
			return DATA.getProperty(field);

		return null;
	}

	public static function setSaveData(field:SaveFields, value:Dynamic)
	{
		DATA.setProperty(field, value);

		save();
	}

	public static function save()
	{
		trace("Saving...");

		#if sys
		sys.io.File.saveContent(Paths.getDataFile(FILE_PATH), Json.stringify(DATA, "\t"));
		#else
		new ZipFileSystem({}).addFileBytes(Paths.getDataFile(FILE_PATH), Json.stringify(DATA, "\t"));
		#end
	}
}
