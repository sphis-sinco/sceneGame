package sphis.scema;

import flixel.FlxG;
import flixel.FlxState;
import sphis.scema.gui.states.GuiMainMenu;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.switchState(() -> new GuiMainMenu());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
