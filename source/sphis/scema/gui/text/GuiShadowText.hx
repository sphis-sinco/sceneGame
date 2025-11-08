package sphis.scema.gui.text;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GuiShadowText extends FlxTypedGroup<FlxText>
{
	public var text_field:FlxText;
	public var text_field_shadow:FlxText;

	public var shadow_padding:Int = 2;

	public var text(default, set):String;

	function set_text(text:String):String
	{
		text_field.text = text;
		text_field_shadow.text = text;

		return text;
	}

	public var x(default, set):Float;

	function set_x(x:Float):Float
	{
		text_field.x = x;
		text_field_shadow.x = x + shadow_padding;

		return x;
	}

	public var y(default, set):Float;

	function set_y(y:Float):Float
	{
		text_field.y = y;
		text_field_shadow.y = y + shadow_padding;

		return y;
	}

	public function setPosition(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}

	override public function new(text:String, ?size:Int = 16, ?x:Float = 0, ?y:Float = 0)
	{
		super();

		text_field = GuiText.drawTextWithSize(text ?? "N/A", size);
		text_field.alignment = CENTER;

		text_field_shadow = GuiText.drawTextWithSize(text_field.text, text_field.size);
		text_field_shadow.alignment = text_field.alignment;

		text_field_shadow.color = FlxColor.BLACK;
		text_field_shadow.alpha = 0.9;

		add(text_field_shadow);
		add(text_field);

		this.x = x;
		this.y = y;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		text_field_shadow.fieldWidth = text_field.fieldWidth;
		text_field_shadow.fieldHeight = text_field.fieldHeight;

		text_field_shadow.visible = text_field.visible;

		text_field_shadow.alignment = text_field.alignment;
		text_field_shadow.size = text_field.size;
		text_field_shadow.alpha = text_field.alpha - .1;
	}
}
