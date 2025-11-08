package sphis.scema.gui.states.options;

import flixel.FlxG;
import flixel.util.FlxColor;

class GuiOptions extends GuiState
{
	override public function new()
	{
		super('options/');
	}

	override function create()
	{
		super.create();

		FlxG.camera.fade(FlxColor.BLACK, .25, true);
	}
}
