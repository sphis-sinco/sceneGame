package sphis.scema.gui.states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sphis.scema.gui.buttons.GuiTextButton;

class GuiOptions extends GuiState
{
	public var leave_button:GuiTextButton;

	override public function new()
	{
		super('options/');
	}

	override function create()
	{
		super.create();
		debugText.text_field_shadow.color = FlxColor.GRAY;

		FlxG.camera.fade(FlxColor.BLACK, .25, true);

		leave_button = createTextButton({
			text_content: "Leave",
			position: new FlxPoint(),

			pressed_callback_code: () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> new GuiMainMenu()));
			},

			width_scale_addition: 16,
			height_scale_addition: 3
		});

		leave_button.button.screenCenter();
		leave_button.button.y = FlxG.height - leave_button.button.height * 1.2;
		add(leave_button);
	}
}
