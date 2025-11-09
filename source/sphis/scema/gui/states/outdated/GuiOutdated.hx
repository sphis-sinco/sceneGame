package sphis.scema.gui.states.outdated;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sphis.scema.gui.text.GuiText;

class GuiOutdated extends GuiState
{
	override public function new()
	{
		super('outdated/');
	}

	override function create()
	{
		super.create();

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
		dontcare.button.y = FlxG.height - dontcare.button.height * 1.1;
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
		careplusasked.button.y = FlxG.height - careplusasked.button.height * 1.1;
		careplusasked.button.x -= careplusasked.button.width;

		add(careplusasked);

		var prompt = drawShadowedText({text_content: "Your game is outdated!"
			+ "\n\n"
			+ "Your version is: "
			+ GeneralConstants.VERSION
			+ " and the current version is "
			+ OutdatedChecker.VERSION});

		prompt.text_field.screenCenter();
		add(prompt);
	}
}
