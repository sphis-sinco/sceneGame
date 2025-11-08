package sphis.scema.gui.states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sphis.scema.code.CodeGroup;
import sphis.scema.gui.buttons.GuiTextButton;

class GuiMainMenu extends GuiState
{
	public var play_button:GuiTextButton;
	public var options_button:GuiTextButton;

	public var script_files:CodeGroup;

	var variables:Map<String, Dynamic> = ["starting_state" => "dummy"];

	override public function new()
	{
		super();

		script_files = new CodeGroup('mainmenu/');
		script_files.runAll(variables);
	}

	override function create()
	{
		super.create();

		variables = script_files.getVariables();

		trace(variables.get("starting_state"));

		play_button = createTextButton({
			text_content: "Play",
			position: new FlxPoint(),

			pressed_callback: () ->
			{
				FlxG.switchState(() -> new PlayState(variables.get('starting_state')));
			},

			width_scale_addition: 16,
			height_scale_addition: 3
		});

		options_button = createTextButton({
			text_content: "Options...",
			position: new FlxPoint(),

			pressed_callback: () ->
			{
				trace('Hola');
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
