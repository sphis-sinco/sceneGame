package sphis.scema.gui;

import flixel.FlxSprite;

class GuiSlider extends FlxSprite
{
	public var target_offset:Float = 0;
	public var percent:Float = 0.0;

	override public function new(target_offset:Float = 100, ?percent:Float = 0, X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		this.target_offset = target_offset;
		this.percent = percent;

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
