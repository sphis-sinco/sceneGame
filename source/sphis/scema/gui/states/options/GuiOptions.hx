package sphis.scema.gui.states.options;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sphis.scema.save.Save;

using Reflect;

class GuiOptions extends GuiState
{
	public var button_params:Array<GuiOptionEntry> = [];

	override public function new()
	{
		super('options/');

		button_params = [
			{
				text_content: "Leave",
				position: new FlxPoint(0, -FlxG.height * 0.9),
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
				position: new FlxPoint(20, 20),
				pressed_callback_code: data ->
				{
					var current_simple_version:Bool = cast Save.getSaveData(SIMPLE_VERSION);
					Save.setSaveData(SIMPLE_VERSION, !current_simple_version);

					data.field('text_field').field('text_field').setField('text', "Simple Version: " + Save.getSaveData(SIMPLE_VERSION));
				},
				width_scale_addition: 16,
				height_scale_addition: 3
			}
		];
	}

	override function create()
	{
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

		super.create();
		debugText.text_field_shadow.color = FlxColor.GRAY;
	}
}
