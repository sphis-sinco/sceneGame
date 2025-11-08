package sphis.scema.gui.states.options;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sphis.scema.save.Save;

using Reflect;

class GuiOptions extends GuiState
{
	public var button_params:Array<GuiOptionEntry> = [];

	override public function new(fade:Bool = true)
	{
		super('options/');

		if (fade)
			FlxG.camera.fade(FlxColor.BLACK, .25, true);

		button_params = [
			{
				text_content: "Leave",
				position: new FlxPoint(0, FlxG.height * 0.425),
				pressed_callback_code: data ->
				{
					FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> new GuiMainMenu()));
				},
				width_scale_addition: 16,
				height_scale_addition: 3,
				screencenter: true
			},
			{
				text_content: "Simple Version: " + Save.getSaveData(SIMPLE_VERSION),
				position: new FlxPoint(60, 80),
				pressed_callback_code: data ->
				{
					var current_simple_version:Bool = cast Save.getSaveData(SIMPLE_VERSION);
					Save.setSaveData(SIMPLE_VERSION, !current_simple_version);

					FlxG.switchState(() -> new GuiOptions(false));
				},
				width_scale_addition: 24,
				height_scale_addition: 3
			}
		];
	}

	override function create()
	{
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

		super.create();
		debugText.text_field_shadow.color = FlxColor.GRAY;
	}
}
