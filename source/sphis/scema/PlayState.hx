package sphis.scema;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sphis.scema.gui.hearts.HeartsGroup;
import sphis.scema.gui.states.GuiState;
import sphis.scema.slides.SlideCode;
import sphis.scema.slides.SlideProps;

using Reflect;
using sphis.scema.slides.SlideComponents;

class PlayState extends GuiState
{
	public var hearts:HeartsGroup;

	public var slide_path:String = "dummy";

	public var slide_props:SlideProps;
	public var slide_code:SlideCode;

	public var paused:Bool;
	public var paused_bg:FlxSprite;

	public static var instance:PlayState;

	override public function new(starting_slide_path:String = "dummy")
	{
		if (instance != null)
			instance = null;
		instance = this;

		super('playstate/');

		this.slide_path = starting_slide_path ?? 'dummy';
	}

	override public function create()
	{
		slide_props = new SlideProps(slide_path);
		add(slide_props);

		slide_code = new SlideCode(slide_path);

		hearts = new HeartsGroup(20, new FlxPoint(2, FlxG.height - (32 + 2)));
		add(hearts);
		hearts.updateHealthIcons();

		paused_bg = new FlxSprite();

		paused_bg.loadGraphic(Paths.getImageFile('fade'));
		paused_bg.color = FlxColor.WHITE;

		paused_bg.color = FlxColor.fromString(Std.string(script_files.getVariables().get("paused_bg_color"))) ?? FlxColor.WHITE;

		paused_bg.alpha = 0;
		add(paused_bg);

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

		if (FlxG.keys.justReleased.ENTER)
		{
			paused = !paused;

			FlxTween.cancelTweensOf(paused_bg);
			FlxTween.tween(paused_bg, {alpha: (paused) ? 1.0 : 0.0}, .5, {
				ease: FlxEase.smootherStepInOut
			});
		}

		if (!paused)
			slide_code.onUpdate(getAdditionalVariables());
		else if (paused)
		{
			if (slide_code.slide_data.getComponent("on_update_bypass_pause") == true)
				slide_code.onUpdate(getAdditionalVariables());
		}
	}

	override function getDesiredInfoOrder():Array<String>
	{
		var order:Array<String> = [];

		var pre_desired_info_order:Array<String> = [];
		if (slide_code.variables.exists("pre_desired_info_order"))
		{
			var o:Array<String> = slide_code.variables.get("pre_desired_info_order");
			for (e in o)
				pre_desired_info_order.push(e);
		}

		for (value in pre_desired_info_order)
			order.push(value);

		for (e in super.getDesiredInfoOrder())
			order.push(e);

		order.push("lb_2");
		order.push("player");

		order.push("lb_3");
		order.push("slide_path");
		order.push("slide");

		var post_desired_info_order:Array<String> = [];
		if (slide_code.variables.exists("post_desired_info_order"))
		{
			var o:Array<String> = slide_code.variables.get("post_desired_info_order");
			for (e in o)
				post_desired_info_order.push(e);
		}

		for (value in post_desired_info_order)
			order.push(value);

		return order;
	}

	override function getNonDebugInfo():Dynamic
	{
		var info = super.getNonDebugInfo();

		if (slide_code.variables.exists("script_info"))
		{
			var o:Dynamic = slide_code.variables.get("script_info");
			for (e in o.fields())
				info.setProperty(e, o.getProperty(e));
		}

		return info;
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

		info.slide_paused = paused;

		return info;
	}
}
