package sphis.scema.gui.states;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import lime.app.Application;
import sphis.scema.gui.buttons.GuiTextButton;

class GuiMainMenu extends GuiState
{
	public var play_button:GuiTextButton;
	public var options_button:GuiTextButton;

	override function create()
	{
		super.create();

		play_button = createTextButton({
			text_content: "Play",
			position: new FlxPoint(),

			pressed_callback: () ->
			{
				trace('Hola');
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

		var versionText = drawColoredShadowedText('Scema ' + Application.current.meta.get("version"), FlxColor.WHITE);
		versionText.text_field_shadow.color = FlxColor.GRAY;
		add(versionText);
	}
}
