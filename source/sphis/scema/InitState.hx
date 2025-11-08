package sphis.scema;

import flixel.FlxG;
import flixel.FlxState;
import sphis.scema.code.CodeGroup;
import sphis.scema.gui.states.GuiMainMenu;
import sphis.scema.gui.states.GuiState;

class InitState extends GuiState
{
	override public function new()
	{
		super('initstate/');
	}

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
