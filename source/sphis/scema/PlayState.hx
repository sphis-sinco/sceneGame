package sphis.scema;

import flixel.FlxG;
import flixel.math.FlxPoint;
import sphis.scema.gui.hearts.HeartsGroup;
import sphis.scema.gui.states.GuiState;
import sphis.scema.slides.SlideProps;

class PlayState extends GuiState
{
	public var hearts:HeartsGroup;

	public var slide_path:String = "dummy";

	public var props:SlideProps;

	override public function create()
	{
		props = new SlideProps(slide_path);
		add(props);

		hearts = new HeartsGroup(20, new FlxPoint(2, FlxG.height - (32 + 2)));
		add(hearts);
		hearts.updateHealthIcons();

		super.create();
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
		order.push("player");

		order.push("lb_3");
		order.push("slide_path");
		order.push("slide");

		return order;
	}

	override public function getDebugInfo()
	{
		var info = super.getDebugInfo();

		info.lb_2 = "\n";

		info.player_health = hearts.health;

		info.lb_3 = "\n";

		info.slide_path = slide_path;

		info.slide_props = props.prop_ids;
		info.slide_prop_count = props.members.length;

		return info;
	}
}
