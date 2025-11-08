package sphis.scema;

import flixel.FlxG;
import flixel.FlxState;
import sphis.scema.code.CodeGroup;
import sphis.scema.gui.states.GuiMainMenu;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();

		var scriptGroup = new CodeGroup('initstate/');
		scriptGroup.runAll();

		FlxG.switchState(() -> new GuiMainMenu());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
