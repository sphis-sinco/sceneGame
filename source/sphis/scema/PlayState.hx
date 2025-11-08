package sphis.scema;

import flixel.FlxG;
import flixel.math.FlxPoint;
import polymod.fs.ZipFileSystem;
import sphis.scema.code.CodeFileRunner;
import sphis.scema.code.CodeGroup;
import sphis.scema.code.CodeRunner;
import sphis.scema.gui.hearts.HeartsGroup;
import sphis.scema.gui.states.GuiState;
import sphis.scema.slides.SlideCode;
import sphis.scema.slides.SlideProps;

class PlayState extends GuiState
{
	public var hearts:HeartsGroup;

	public var slide_path:String = "dummy";

	public var slide_props:SlideProps;
	public var slide_code:SlideCode;

	public var script_files:CodeGroup;

	override public function create()
	{
		slide_props = new SlideProps(slide_path);
		add(slide_props);

		script_files = new CodeGroup();
		script_files.runAll(getAdditionalVariables());

		slide_code = new SlideCode(slide_path);

		hearts = new HeartsGroup(20, new FlxPoint(2, FlxG.height - (32 + 2)));
		add(hearts);
		hearts.updateHealthIcons();

		super.create();

		slide_code.onCreate(getAdditionalVariables());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if HEART_RANDOM_KEY
		if (FlxG.keys.justReleased.R)
			hearts.setHealth(FlxG.random.int(GuiConstants.MIN_HEALTH, GuiConstants.MAX_HEALTH));
		#end

		slide_code.onUpdate(getAdditionalVariables());
	}

	public function getAdditionalVariables():Map<String, Dynamic>
	{
		return ["slide_path" => this.slide_path, "hearts" => this.hearts];
	}

	override function getDesiredInfoOrder():Array<String>
	{
		var order = super.getDesiredInfoOrder();

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

		info.component_count_with_props = this.members.length + slide_props.members.length;

		info.lb_2 = "\n";

		info.player_health = hearts.health;

		info.lb_3 = "\n";

		info.slide_path = slide_path;

		info.slide_props = slide_props.prop_ids;
		info.slide_prop_count = slide_props.members.length;

		return info;
	}
}
