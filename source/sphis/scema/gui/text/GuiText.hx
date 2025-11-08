package sphis.scema.gui.text;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxText;

class GuiText
{
	public static var font(get, never):String;

	static function get_font():String
	{
		#if FONT_BITEND_DEMO
		return 'assets/fonts/Bitend DEMO.ttf';
		#end

		return FlxAssets.FONT_DEFAULT;
	}

	public static function drawText(text:String, ?position:FlxPoint)
	{
		var text = new FlxText(position?.x ?? 2, position?.y ?? 2, 0, text, 16);
		text.font = font;

		return text;
	}

	public static function drawTextWithSize(text:String, ?size:Null<Int>, ?position:FlxPoint)
	{
		var text = drawText(text, position);
		text.size = size ?? 16;

		return text;
	}
}
