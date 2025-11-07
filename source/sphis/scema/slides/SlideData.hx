package sphis.scema.slides;

typedef SlideData =
{
	var props:Array<SlidePropData>;
}

typedef SlidePropData =
{
	var id:String;
	var prop_type:String;

	var ?position:Array<Float>;

	var ?z_index:Int;

	var ?graphic_settings:SlidePropGraphicSettingsData;
}

typedef SlidePropGraphicSettingsData =
{
	var ?make_graphic:Bool;
	var ?screencenter:Bool;

	var ?width:Int;
	var ?height:Int;

	var ?image_path:String;

	var ?color:String;

	var ?screencenter_position_offset:Array<Float>;
}
