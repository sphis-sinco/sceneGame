package sphis.scema.slides;

class SlideComponents
{
	public static function getComponent(slide:SlideData, name:String):Dynamic
	{
		if (slide.components == null)
			return null;

		for (component in slide.components)
		{
			if (component.name == name)
				return component.data;
		}

		return null;
	}
}
