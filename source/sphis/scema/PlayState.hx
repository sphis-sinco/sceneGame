package sphis.scema;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.Log;
import sphis.scema.gui.hearts.HeartsGroup;
import sphis.scema.gui.states.GuiState;
import sphis.scema.slides.SlideCode;
import sphis.scema.slides.SlideProps;

using Reflect;
using sphis.scema.slides.SlideComponents;

class PlayState extends GuiState
{
	public var hearts:HeartsGroup;

	public var slide_path:String = "dummy/dummy";

	public var slide_props:SlideProps;
	public var slide_code:SlideCode;

	public var paused:Bool = false;
	public var paused_blackbg:FlxSprite;
	public var paused_bg:FlxSprite;

	public var pausescreen_slide:{props:SlideProps, code:SlideCode};

	public static var instance:PlayState;

	public var checkPropAlphaShit = function(prop:FlxBasic, ?speed:Float, ?alpha:Float) {};
	public var pauseProps = function(prop:FlxBasic) {};

	override public function new(starting_slide_path:String = "dummy/dummy")
	{
		if (instance != null)
			instance = null;
		instance = this;

		pauseProps = function(prop)
		{
			if (prop.hasField('paused'))
			{
				prop.setField('paused', instance.paused);
			}
			if (prop.hasField('members'))
			{
				var prop_members:Array<FlxBasic> = prop.field('members');

				for (prop_member in prop_members)
					pauseProps(prop_member);
			}
		}

		checkPropAlphaShit = function(prop, ?speed, ?alpha)
		{
			if (prop.hasField('alpha'))
			{
				FlxTween.cancelTweensOf(prop);
				FlxTween.tween(prop, {alpha: ((paused) ? (alpha ?? 1.0) : 0.0)}, speed ?? .5, {
					ease: FlxEase.smootherStepInOut
				});
			}
			if (prop.hasField('members'))
			{
				var prop_members:Array<FlxBasic> = prop.field('members');

				for (prop_member in prop_members)
					checkPropAlphaShit(prop_member, speed, alpha);
			}
		}

		super('playstate/');

		this.slide_path = starting_slide_path ?? 'dummy/dummy';
	}

	override function getAdditionalVariables():Map<String, Dynamic>
	{
		var additional_variables = super.getAdditionalVariables();

		additional_variables.set("switch_slide", (new_slide:String) ->
		{
			FlxG.switchState(() -> new PlayState(new_slide));
		});
		additional_variables.set("trace", (v, pos) ->
		{
			Log.trace(Paths.getSlideFile(slide_path) + ": " + Std.string(v), null);
		});

		return additional_variables;
	}

	override public function create()
	{
		trace('Creating Slide');
		slide_props = new SlideProps(slide_path, getAdditionalVariables());
		add(slide_props);

		slide_code = new SlideCode(slide_path, getAdditionalVariables());

		trace('Creating GUI');
		hearts = new HeartsGroup(20, new FlxPoint(2, FlxG.height - (32 + 2)));
		if (SlideComponents.getComponent(slide_props.slide_data, 'hide_hearts') != true)
			add(hearts);
		hearts.updateHealthIcons();

		trace('Creating Pause Menu');
		initPauseMenu();

		togglePaused(true);

		FlxG.camera.fade(FlxColor.BLACK, .25, true);

		super.create();

		slide_code.onCreate(getAdditionalVariables());
	}

	public function initPauseMenu()
	{
		paused_blackbg = new FlxSprite();
		paused_blackbg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		paused_blackbg.alpha = .5;
		add(paused_blackbg);

		paused_bg = new FlxSprite();

		paused_bg.loadGraphic(Paths.getImageFile('fade'));
		paused_bg.color = FlxColor.WHITE;

		paused_bg.color = FlxColor.fromString(Std.string(script_files.getVariables().get("paused_bg_color"))) ?? FlxColor.WHITE;

		add(paused_bg);

		pausescreen_slide = {
			props: new SlideProps(null),
			code: new SlideCode(null),
		}

		pausescreen_slide.props.slide_data = Json.parse(Paths.getText(Paths.getDataFile('pausescreen.json')));
		pausescreen_slide.code.slide_data = pausescreen_slide.props.slide_data;

		pausescreen_slide.props.start_variables = getAdditionalVariables();
		pausescreen_slide.props.loadProps();

		pausescreen_slide.code.slide_data = pausescreen_slide.props.slide_data;
		pausescreen_slide.code.start_variables = getAdditionalVariables();
		pausescreen_slide.code.initVars();
		pausescreen_slide.code.parseCode();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if HEART_RANDOM_KEY
		if (FlxG.keys.justReleased.H)
			hearts.setHealth(FlxG.random.int(GuiConstants.MIN_HEALTH, GuiConstants.MAX_HEALTH));
		#end

		if (FlxG.keys.justReleased.ENTER)
		{
			togglePaused();
		}

		if (!paused)
			slide_code.onUpdate(getAdditionalVariables());
		else if (paused)
		{
			pausescreen_slide.code.onUpdate(getAdditionalVariables());

			if (slide_code.slide_data.getComponent("on_update_bypass_pause") == true)
				slide_code.onUpdate(getAdditionalVariables());
		}
	}

	public static function togglePaused(onStart:Bool = false)
	{
		final alphaVal = (onStart ? 1 / 100 : 0.5);

		if (!onStart)
			instance.paused = !instance.paused;

		#if !windows
		if (!instance.members.contains(instance.pausescreen_slide.props))
			instance.add(instance.pausescreen_slide.props);
		#end

		instance.checkPropAlphaShit(instance.paused_bg, alphaVal);
		instance.checkPropAlphaShit(instance.paused_blackbg, alphaVal, .5);
		instance.checkPropAlphaShit(instance.pausescreen_slide.props, alphaVal);

		if (onStart)
			return;

		instance.pauseProps(instance.slide_props);

		if (instance.paused)
		{
			instance.pausescreen_slide.code.onCreate(instance.getAdditionalVariables());
			instance.slide_props.propsPauseAnimation();
		}
		else
		{
			instance.slide_props.propsUnpauseAnimation();
		}
	}

	public function leave(state:FlxState)
	{
		FlxG.camera.fade(FlxColor.BLACK, .25, false, () -> FlxG.switchState(() -> state));
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
