package sphis.scema.gui.states.options;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sphis.scema.save.Save;

using Reflect;

typedef GuiOptionsData =
{
	var ?fade:Bool;

	var ?in_gameplay:Bool;
	var ?gameplay_slide:String;
}

class GuiOptions extends GuiState
{
	public var button_params:Array<GuiOptionEntry> = [];

	public var params:GuiOptionsData = {};

	override public function new(params:GuiOptionsData)
	{
		super('options/');

		this.params = params;

		if (this.params?.fade != null)
			FlxG.camera.fade(FlxColor.BLACK, .25, true);

		button_params = [
			{
				text_content: "Leave",
				position: new FlxPoint(0, FlxG.height * 0.425),
				pressed_callback_code: data ->
				{
					Save.save();
					if (this.params?.in_gameplay)
						FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> new PlayState(this.params?.gameplay_slide ?? "dummy/dummy")));
					else
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

					reload();
				},
				width_scale_addition: 24,
				height_scale_addition: 3
			},
			{
				text_content: "Volume: " + Save.getSaveData(VOLUME),
				position: new FlxPoint(60 + (60 * 4), 80),
				pressed_callback_code: data ->
				{
					var current_volume:Int = cast Save.getSaveData(VOLUME);
					current_volume += 10;
					if (current_volume > 100)
						current_volume = 0;

					Save.setSaveData(VOLUME, current_volume);

					reload();
				},
				width_scale_addition: 24,
				height_scale_addition: 3
			},
			{
				text_content: "Debug Text: " + Save.getSaveData(DEBUG_TEXT),
				position: new FlxPoint(60 + (60 * 8), 80),
				pressed_callback_code: data ->
				{
					var current_debug_text:Bool = cast Save.getSaveData(DEBUG_TEXT);
					Save.setSaveData(DEBUG_TEXT, !current_debug_text);

					reload();
				},
				width_scale_addition: 24,
				height_scale_addition: 3
			},
			{
				text_content: "Check Outdated: " + Save.getSaveData(CHECK_OUTDATED),
				position: new FlxPoint(60 + (60 * 12), 80),
				pressed_callback_code: data ->
				{
					var current_check_outdated:Bool = cast Save.getSaveData(CHECK_OUTDATED);
					Save.setSaveData(CHECK_OUTDATED, !current_check_outdated);

					reload();
				},
				width_scale_addition: 24,
				height_scale_addition: 3
			},
		];
	}

	public function reload()
	{
		FlxG.switchState(() -> new GuiOptions({
			fade: false
		}));
	}

	public var volume_slider:GuiSlider;

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

		volume_slider = new GuiSlider({
			target_offset: 200 - 15,
			percent: cast Save.getSaveData(VOLUME) / 100,
			position: [button_params[2].position.x + 15, button_params[2].position.y - 4]
		});
		add(volume_slider);

		super.create();
		debugText.text_field_shadow.color = FlxColor.GRAY;
	}
}
