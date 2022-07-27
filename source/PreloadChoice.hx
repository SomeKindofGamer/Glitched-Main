package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

class PreloadChoice extends MusicBeatState
{
	var PreloadChoice:FlxText;
	public var pressed:Int = 0;
	override function create()
	{
		#if desktop
		DiscordClient.changePresence("intro lol", null);
		#end
		super.create();

		FlxG.sound.playMusic(Paths.music('hehe'), 0);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		PreloadChoice = new FlxText(0, 0, FlxG.width,
			"Modified game client detected. \n Close the Client and delete it off your system. \n Press enter to download Glitched-Sides 2.1",
			32);
		PreloadChoice.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		PreloadChoice.screenCenter();
		add(PreloadChoice);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER) {
			CoolUtil.browserLoad('https://gamebanana.com/mods/322987');
		}
		super.update(elapsed);
	}
}
