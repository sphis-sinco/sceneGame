package sphis.scema.save;

import haxe.Json;

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

		handleEmptySave();
		updateSave();

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

		setSaveData(VERSION, GeneralConstants.VERSION_SUFFIXLESS);
		setSaveData(SIMPLE_VERSION, true);
		setSaveData(VOLUME, 100);
		setSaveData(DEBUG_TEXT, true);
		setSaveData(CHECK_OUTDATED, true);
	}

	public static function updateSave()
	{
		switch (getSaveData(VERSION))
		{
			case "0.0.18":
				setSaveData(SIMPLE_VERSION, true);

			case "0.0.19":
				setSaveData(VOLUME, 100);

			case "0.0.21":
				setSaveData(DEBUG_TEXT, true);

			case "0.0.23":
				setSaveData(CHECK_OUTDATED, true);

			default:
				trace("Save data version " + getSaveData(VERSION) + " has no updateSave case");
		}

		setSaveData(VERSION, GeneralConstants.VERSION_SUFFIXLESS);
		trace("Updated to version " + getSaveData(VERSION));
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
		#if sys
		sys.io.File.saveContent(Paths.getDataFile(FILE_PATH), Json.stringify(DATA, "\t"));
		#else
		new ZipFileSystem({}).addFileBytes(Paths.getDataFile(FILE_PATH), Json.stringify(DATA, "\t"));
		#end
	}
}
