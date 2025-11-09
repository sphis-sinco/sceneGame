package sphis.scema.gui.states.outdated;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class GuiOutdated extends GuiState
{
	override public function new()
	{
		super('outdated/');
	}

	override function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, .25, true);

		var dontcare = createTextButton({
			text_content: "Proceed anyway",
			position: new FlxPoint(),

			pressed_callback_code: data ->
			{
				FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> new GuiMainMenu()));
			},

			width_scale_addition: 24,
			height_scale_addition: 3
		});
		dontcare.button.screenCenter();
		dontcare.button.y = FlxG.height - dontcare.button.height * 2;
		dontcare.button.x += dontcare.button.width;

		add(dontcare);

		var careplusasked = createTextButton({
			text_content: "Update now",
			position: new FlxPoint(),

			pressed_callback_code: data ->
			{
				FlxG.openURL("https://github.com/sphis-sinco/sceneGame/releases/latest/");
			},

			width_scale_addition: 24,
			height_scale_addition: 3
		});
		careplusasked.button.screenCenter();
		careplusasked.button.y = FlxG.height - careplusasked.button.height * 2;
		careplusasked.button.x -= careplusasked.button.width;

		add(careplusasked);

		var prompt = drawShadowedText({text_content: "Your game is outdated!"
			+ "\n\n"
			+ "Your version is: "
			+ GeneralConstants.VERSION_SUFFIXLESS
			+ " and the current version is "
			+ OutdatedChecker.GIT_INFO_DATA.version});

		if (OutdatedChecker.GIT_INFO_DATA.changelog.length > 0)
		{
			prompt.text += "\n\nVersion changelog:\n\n";

			for (entry in OutdatedChecker.GIT_INFO_DATA.changelog)
				prompt.text += entry + "\n";
		}

		prompt.text_field.screenCenter();
		add(prompt);

		super.create();
		debugText.text_field_shadow.color = FlxColor.GRAY;
	}
}
