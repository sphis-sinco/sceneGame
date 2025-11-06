package sphis.scema.gui.hearts;

import flixel.FlxSprite;

class HeartIcon extends FlxSprite
{
	override public function new(state:GuiIconStates)
	{
		super();

		loadGraphic(Paths.getImageFile('gui/heart'), true, 16, 16);

		animation.add('full', [0]);
		animation.add('half', [1]);
		animation.add('empty', [2]);

		updateState(state);
	}

	public function updateState(new_state:GuiIconStates)
	{
		animation.play(switch (new_state)
		{
			case FULL:
				'full';
			case HALF:
				'half';
			default:
				'empty';
		});
	}
}
