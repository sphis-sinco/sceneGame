package sphis.scema.gui.hearts;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class HeartsGroup extends FlxTypedGroup<FlxSprite>
{
	public var health(default, set):Int;

	function set_health(health:Int):Int
	{
		if (health > GuiConstants.MAX_HEALTH)
			health = GuiConstants.MAX_HEALTH;

		if (health < GuiConstants.MIN_HEALTH)
			health = GuiConstants.MIN_HEALTH;

		updateHealthIcons();

		return health;
	}

	override public function new(health:Int)
	{
		super();

		this.health = health;
	}

	public function updateHealthIcons() {}
}
