package sphis.scema.gui;

import flixel.FlxSprite;

typedef GuiSliderData =
{
	var target_offset:Float;

	var ?percent:Float;

	var ?position:Array<Float>;
}

class GuiSlider extends FlxSprite
{
	public var target_offset:Float = 0;
	public var percent:Float = 0.0;

	override public function new(params:GuiSliderData)
	{
		super(params?.position[0] ?? 0, params?.position[1] ?? 0);

		this.target_offset = params?.target_offset ?? 0;
		this.percent = params?.percent ?? 0.0;

		loadGraphic(Paths.getImageFile('gui/slider'));
		scale.set(GuiConstants.UI_SCALE_MULTIPLIER, GuiConstants.UI_SCALE_MULTIPLIER);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		offset.x = -target_offset * percent;
	}
}
