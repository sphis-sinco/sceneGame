package sphis.scema.slides;

import sphis.scema.gui.buttons.GuiTextButton.GuiTextButtonParameters;

typedef SlideData =
{
	var props:Array<SlidePropData>;
	var code:SlideCodeData;
	var components:Array<SlideComponent>;
}

typedef SlideComponent =
{
	var name:String;
	var data:Dynamic;
}

typedef SlideCodeData =
{
	var ?onCreate:Array<String>;
	var ?onUpdate:Array<String>;
}

typedef SlidePropData =
{
	var id:String;
	var prop_type:String;

	var ?position:Array<Float>;

	var ?z_index:Int;

	var ?graphic_settings:SlidePropGraphicSettingsData;
	var ?button_settings:SlidePropButtonSettingsData;
}

typedef SlidePropButtonSettingsData = GuiTextButtonParameters;

typedef SlidePropGraphicSettingsData =
{
	var ?make_graphic:Bool;
	var ?screencenter:Bool;

	var ?width:Int;
	var ?height:Int;

	var ?image_path:String;

	var ?color:String;

	var ?screencenter_position_offset:Array<Float>;

	var ?animation_type:String;
	var ?animations:Array<SlidePropGraphicSettingsAnimationData>;
}

typedef SlidePropGraphicSettingsAnimationData =
{
	var name:String;

	var ?prefix:String;

	var ?framerate:Int;
	var ?looped:Bool;
	var ?flip_x:Bool;
	var ?flip_y:Bool;

	var ?conditions:Array<String>;

	var ?offsets:Array<Float>;
}
