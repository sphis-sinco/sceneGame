package sphis.scema.gui.states.options;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class GuiOptions extends GuiState
{
	public var button_params:Array<GuiOptionEntry> = [
		{
			text_content: "Leave",
			position: new FlxPoint(),
			pressed_callback_code: () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> new GuiMainMenu()));
			},
			width_scale_addition: 16,
			height_scale_addition: 3
		}
	];

	override public function new()
	{
		super('options/');
	}

	override function create()
	{
		super.create();
		debugText.text_field_shadow.color = FlxColor.GRAY;

		FlxG.camera.fade(FlxColor.BLACK, .25, true);

		for (params in button_params)
		{
			var buttonGrp = createTextButton(params);

			if (params.screencenter)
			{
				buttonGrp.button.screenCenter();

				buttonGrp.button.x += params.position.x;
				buttonGrp.button.y += params.position.y;
			}

			add(buttonGrp);
		}
	}
}
