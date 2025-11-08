package sphis.scema.save;

import flixel.util.FlxSave;

using Reflect;

class Save
{
	public static var SAVE_NAME:String = 'Scema';
	public static var SAVE_PATH:String = 'Sphis';

	public static var SAVE:FlxSave;

	public static function initalizeSave()
	{
		SAVE = new FlxSave();
		SAVE.bind(SAVE_NAME, SAVE_PATH);

		handleEmptySave();
		updateSave();
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
