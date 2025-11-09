package sphis.scema.gui;

import flixel.FlxSprite;

class GuiSlider extends FlxSprite
{
	public var percent:Float = 0.0;

	override public function new()
	{
		super();

		loadGraphic(Paths.getImageFile('gui/slider'));
		scale.set(GuiConstants.UI_SCALE_MULTIPLIER, GuiConstants.UI_SCALE_MULTIPLIER);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		offset.x = percent * width;
	}
}
