package sphis.scema.gui.states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sphis.scema.code.CodeGroup;
import sphis.scema.gui.buttons.GuiTextButton;
import sphis.scema.gui.states.options.GuiOptions;

class GuiMainMenu extends GuiState
{
	public var play_button:GuiTextButton;
	public var options_button:GuiTextButton;

	override public function new()
	{
		super('mainmenu/');
	}

	override function create()
	{
		super.create();

		FlxG.camera.fade(FlxColor.BLACK, .25, true);

		play_button = createTextButton({
			text_content: "Play",
			position: new FlxPoint(),

			pressed_callback_code: () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(PlayState.new.bind(script_files.getVariables().get('starting_state'))));
			},

			width_scale_addition: 16,
			height_scale_addition: 3
		});

		options_button = createTextButton({
			text_content: "Options...",
			position: new FlxPoint(),

			pressed_callback_code: () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> new GuiOptions()));
			},

			width_scale_addition: 16,
			height_scale_addition: 3
		});

		play_button.button.screenCenter();
		play_button.button.y -= play_button.button.height;
		add(play_button);

		options_button.button.screenCenter();
		options_button.button.y += options_button.button.height;
		add(options_button);

		debugText.text_field_shadow.color = FlxColor.GRAY;
	}
}
