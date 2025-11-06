package sphis.scema;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import lime.app.Application;
import sphis.scema.gui.GuiConstants;
import sphis.scema.gui.GuiText;
import sphis.scema.gui.hearts.HeartsGroup;

class PlayState extends FlxState
{
	public var hearts:HeartsGroup;

	override public function create()
	{
		super.create();

		hearts = new HeartsGroup(20, new FlxPoint(2, FlxG.height - (16 + 2)));
		add(hearts);

		add(GuiText.drawText('Scema ' + Application.current.meta.get("version")));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.R)
			hearts.setHealth(FlxG.random.int(GuiConstants.MIN_HEALTH, GuiConstants.MAX_HEALTH));
	}
}
