// package sphis.onescirne.ui;
package sphis.scema.gui.buttons;

import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import tracedinpurple.ui.FlxScaledSliceSprite;

typedef GuiButtonParameters =
{
	var position:FlxPoint;

	var ?general_scale_addition:Int;
	var ?width_scale_addition:Int;
	var ?height_scale_addition:Int;

	var ?graphic:GuiButtonGraphicParameters;
}

typedef GuiButtonGraphicParameters =
{
	var ?image_path:String;
	var ?corner_radius:Int;
}

class GuiButton extends FlxScaledSliceSprite
{
	override public function new(params:GuiButtonParameters)
	{
		var ui_base_graphic = FlxGraphic.fromAssetKey(Paths.getImageFile(((params.graphic?.image_path != null) ? params.graphic?.image_path : ('gui/button'))));
		var ui_base_corner_radius = params.graphic?.corner_radius ?? 4;
		var ui_base_slice = new FlxRect(ui_base_corner_radius, ui_base_corner_radius, Std.int(ui_base_graphic.width / 2), Std.int(ui_base_graphic.height / 2));

		super(ui_base_graphic, ui_base_slice, GuiConstants.UI_SCALE_MULTIPLIER + (params.general_scale_addition - 1),
			ui_base_slice.width * (GuiConstants.UI_SCALE_MULTIPLIER + params.general_scale_addition + params.width_scale_addition),
			ui_base_slice.height * (GuiConstants.UI_SCALE_MULTIPLIER + params.general_scale_addition + params.height_scale_addition));

		this.setPosition(params.position.x, params.position.y);
	}
}
