package sphis.scema;

import flixel.FlxG;
import flixel.math.FlxPoint;
import sphis.scema.gui.hearts.HeartsGroup;
import sphis.scema.gui.states.GuiState;

class PlayState extends GuiState
{
	public var hearts:HeartsGroup;

	public var slide_x:Int = 0;

	override public function create()
	{
		super.create();

		hearts = new HeartsGroup(20, new FlxPoint(2, FlxG.height - (32 + 2)));
		add(hearts);
		hearts.updateHealthIcons();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if HEART_RANDOM_KEY
		if (FlxG.keys.justReleased.R)
			hearts.setHealth(FlxG.random.int(GuiConstants.MIN_HEALTH, GuiConstants.MAX_HEALTH));
		#end
	}

	override function getDesiredDebugInfoOrder():Array<String>
	{
		var order = super.getDesiredDebugInfoOrder();

		order.push("lb_2");
		order.push("player_health");
		order.push("player_slide");

		return order;
	}

	override public function getDebugInfo()
	{
		var info = super.getDebugInfo();

		info.lb_2 = "\n";
		info.player_health = hearts.health;
		info.player_slide = slide_x;

		return info;
	}
}
