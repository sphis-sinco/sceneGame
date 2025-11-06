package sphis.scema.gui.hearts;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class HeartsGroup extends FlxTypedGroup<HeartIcon>
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

	public var position(default, set):FlxPoint;

	function set_position(position:FlxPoint):FlxPoint
	{
		for (heart in this.members)
		{
			heart.offset.x = position.x;
			heart.offset.y = position.y;
		}

		return position;
	}

	override public function new(health:Int, ?position:FlxPoint)
	{
		super();

		var i = 0;

		while (i < GuiConstants.MAX_HEALTH)
		{
			if (i % 2 == 0)
			{
				var heart:HeartIcon = new HeartIcon(EMPTY);
				heart.x = (12 * i);
				heart.ID = i;
				add(heart);
			}

			i++;
		}

		this.position = position ?? new FlxPoint();
		this.health = health;
	}

	public function updateHealthIcons()
	{
		for (heart in this.members)
		{
			if (health >= heart.ID)
				heart.updateState(FULL);
			else if (health == heart.ID - 1)
				heart.updateState(HALF);
			else
				heart.updateState(EMPTY);
		}
	}
}
