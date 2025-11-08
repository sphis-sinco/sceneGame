package sphis.scema;

import flixel.FlxG;
import sphis.scema.gui.states.GuiMainMenu;
import sphis.scema.gui.states.GuiState;
import sphis.scema.save.Save;

class InitState extends GuiState
{
	override public function new()
	{
		super('initstate/');
	}

	override public function create()
	{
		super.create();

		Save.initalizeSave();

		FlxG.switchState(() -> new GuiMainMenu());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
