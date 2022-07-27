#if sys
package;

import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.ui.FlxBar;
import haxe.Exception;
import haxe.Json;
import haxe.format.JsonParser;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import Section.SwagSection;
import Song;

using StringTools;

class PreloadingState extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var kadeLogo:FlxSprite;
	var gfDance:FlxSprite;

	public static var bitmapData:Map<String,FlxGraphic>;

	var images = [];
	var characters = [];
	var music = [];
	var charts = [];

	override function create()
	{

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();

		text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading...");
		text.size = 34;
		text.alignment = FlxTextAlign.CENTER;
		text.alpha = 0;

		kadeLogo = new FlxSprite(-150, -100);
		kadeLogo.frames = Paths.getSparrowAtlas('logoBumpin');
		kadeLogo.antialiasing = true;
		kadeLogo.animation.addByPrefix('bump', 'logo bumpin', 24);
		kadeLogo.animation.play('bump');
		kadeLogo.updateHitbox();
		// kadeLogo.screenCenter();
		// kadeLogo.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		
		kadeLogo.alpha = 0;

		#if cpp
			trace("caching images...");

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}

			trace("caching characters...");

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				characters.push(i);
			}

		trace("caching music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end

		toBeDone = Lambda.count(images) + Lambda.count(characters) + Lambda.count(music);

		var bar = new FlxBar(10,FlxG.height - 0,FlxBarFillDirection.LEFT_TO_RIGHT,FlxG.width,40,null,"done",0,toBeDone);
		bar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.PURPLE);

		add(bar);

		add(kadeLogo);
		add(text);

		trace('starting caching..');
		
		#if cpp
		// update thread

		sys.thread.Thread.create(() -> {
			while(!loaded)
			{
				if (toBeDone != 0 && done != toBeDone)
					{
						var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
						kadeLogo.alpha = alpha;
						text.alpha = alpha;
						text.text = "Loading... (" + done + "/" + toBeDone + ")";
					}
			}
		
		});

		// cache thread

		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		super.create();
	}

	var calledDone = false;

	override function update(elapsed) 
	{
		super.update(elapsed);
	}


	function cache()
	{
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/" + i);
			trace('id ' + replaced + ' file - assets/shared/images/' + i + ' ${data.width}');
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			done++;
		}
		
		for (i in characters)
			{
				var replaced = i.replace(".png","");
				var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
				trace('id ' + replaced + ' file - assets/shared/images/characters/' + i + ' ${data.width}');
				var graph = FlxGraphic.fromBitmapData(data);
				graph.persist = true;
				graph.destroyOnNoUse = false;
				bitmapData.set(replaced,graph);
				done++;
			}

		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			done++;
		}


		trace("Finished preloading...");

		loaded = true;

		trace(Assets.cache.hasBitmapData('GF_assets'));

		FlxG.switchState(new MainMenuState());
	}

}
#end