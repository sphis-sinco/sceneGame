package sphis.scema.gui.hearts;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class HeartsGroup extends FlxTypedGroup<HeartIcon>
{
	var infoChanged:Bool = false;

	public var health:Int = 0;

	public function setHealth(health:Int)
	{
		if (health > GuiConstants.MAX_HEALTH)
			health = GuiConstants.MAX_HEALTH;

		if (health < GuiConstants.MIN_HEALTH)
			health = GuiConstants.MIN_HEALTH;

		this.health = health;
		this.infoChanged = true;
	}

	public var position(default, set):FlxPoint = new FlxPoint();

	function set_position(position:FlxPoint):FlxPoint
	{
		this.infoChanged = true;

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
				heart.ID = i + 2;
				this.add(heart);
			}

			i++;
		}

		this.position = position ?? new FlxPoint();
		setHealth(health);

		this.infoChanged = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.infoChanged)
			this.updateHealthIcons();
	}

	public function updateHealthIcons()
	{
		this.infoChanged = false;

		for (heart in this.members)
		{
			if (heart == null)
				continue;

			heart.x = this.position.x + (12 * (heart.ID - 2));
			heart.y = this.position.y;

			#if HEART_DEBUG
			trace(heart.ID + " : " + this.health);
			trace(this.position.x);
			trace((12 * (heart.ID - 2)));
			trace(heart.getPosition());
			#end

			if (this.health >= heart.ID)
				heart.updateState(FULL);
			else if (this.health == heart.ID - 1)
				heart.updateState(HALF);
			else
				heart.updateState(EMPTY);
		}
	}
}
