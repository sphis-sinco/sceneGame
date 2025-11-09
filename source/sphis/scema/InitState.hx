package sphis.scema;

import flixel.FlxG;
import flixel.system.debug.log.LogStyle;
import lime.app.Application;
import polymod.util.DefineUtil;
import sphis.scema.gui.states.GuiMainMenu;
import sphis.scema.gui.states.GuiState;
import sphis.scema.gui.states.options.GuiOptions;
import sphis.scema.plugins.MouseSound;
import sphis.scema.plugins.VolumeManager;
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

		FlxG.debugger.toggleKeys = [];

		FlxG.sound.muteKeys = [];
		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];

		LogStyle.ERROR.openConsole = false;
		LogStyle.WARNING.openConsole = false;

		FlxG.plugins.addPlugin(new MouseSound());
		FlxG.plugins.addPlugin(new VolumeManager());

		Save.initalizeSave();
		Application.current.onExit.add(l ->
		{
			Save.save();
		}, true, 1000);

		var starting_state = DefineUtil.getDefineString("STARTING_STATE");

		switch (starting_state.toLowerCase())
		{
			case "gui_options", "options", "settings":
				FlxG.switchState(() -> new GuiOptions());

			default:
				if (starting_state != null && starting_state != "")
					trace(starting_state + " has no case");

				FlxG.switchState(() -> new GuiMainMenu());
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
