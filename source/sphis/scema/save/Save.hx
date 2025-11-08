package sphis.scema.save;

import flixel.util.FlxSave;

using Reflect;

class Save
{
	public static var SAVE_NAME:String = 'Scema';
	public static var SAVE_PATH:String = 'Sphis';

	public static var SAVE:FlxSave;

	public static var DEPRECATED_SAVEDATA_FIELDS_WITH_MSG:Map<SaveFields, String> = [VERSION => " since 0.0.12"];

	public static function initalizeSave()
	{
		SAVE = new FlxSave();
		SAVE.bind(SAVE_NAME, SAVE_PATH);

		handleEmptySave();
		updateSave();

		trace('Save data fields: ' + SAVE.data.fields());
		for (field in SAVE.data.fields())
		{
			var depricatedMsg = '';

			if (DEPRECATED_SAVEDATA_FIELDS_WITH_MSG.exists(cast field))
			{
				depricatedMsg += " (Deprecated" + DEPRECATED_SAVEDATA_FIELDS_WITH_MSG.get(cast field) + ")";
			}

			trace(' * ' + field + " : " + getSaveData(cast field) + depricatedMsg);
		}
	}

	public static function handleEmptySave()
	{
		if (SAVE == null)
			return;
		if (!SAVE.isEmpty())
			return;

		setSaveData(VERSION, GeneralConstants.VERSION);
	}

	public static function updateSave()
	{
		switch (getSaveData(VERSION))
		{
			default:
				trace("Save data version " + getSaveData(VERSION) + " has no updateSave case");
		}

		setSaveData(VERSION, GeneralConstants.VERSION);
	}

	public static function getSaveData(field:SaveFields):Dynamic
	{
		if (SAVE.data.hasField(cast field))
			return SAVE.data.field(cast field);

		return null;
	}

	public static function setSaveData(field:SaveFields, value:Dynamic)
	{
		SAVE.data.setField(cast field, value);
	}
}
