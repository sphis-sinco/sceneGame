package sphis.scema.gui.states;

import flixel.FlxState;
import sphis.scema.gui.buttons.GuiButton.GuiButtonParameters;
import sphis.scema.gui.buttons.GuiTextButton;

class GuiState extends FlxState
{
	public function createTextButton(params:GuiTextButtonParameters):GuiTextButton
	{
		return new GuiTextButton(params);
	}

	public function createButton(params:GuiButtonParameters):GuiTextButton
	{
		return new GuiTextButton(cast params);
	}
}
