package sphis.scema;

import flixel.FlxG;
import lime.app.Application;
import polymod.util.DefineUtil;
import sphis.scema.gui.states.GuiMainMenu;
import sphis.scema.gui.states.GuiOptions;
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
		Application.current.onExit.add(l ->
		{
			Save.save();
		});

		var starting_state = DefineUtil.getDefineString("STARTING_STATE");

		switch (starting_state.toLowerCase())
		{
			case "gui_options":
				FlxG.switchState(() -> new GuiOptions());

			default:
				if (starting_state != null)
				{
					trace(starting_state + " has no case");
				}

				FlxG.switchState(() -> new GuiMainMenu());
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
