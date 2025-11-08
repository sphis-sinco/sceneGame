package sphis.scema.gui.text;

import flixel.math.FlxPoint;
import flixel.text.FlxText;

class GuiText
{
	public static function drawText(text:String, ?position:FlxPoint)
	{
		var text = new FlxText(position?.x ?? 2, position?.y ?? 2, 0, text, 16);
		text.font = 'assets/fonts/Bitend DEMO.ttf';

		return text;
	}

	public static function drawTextWithSize(text:String, ?size:Null<Int>, ?position:FlxPoint)
	{
		var text = drawText(text, position);
		text.size = size ?? 16;

		return text;
	}
}
