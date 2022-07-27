package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var bg:FlxSprite;
	var menuguy:FlxSprite;
	var curSelected:Int = 0;
	var blackstuff:FlxSprite;
	public var daColors:Array<String> = [
		'#9d69ff',
		'#ff5c5c',
		'#5eff61',
		'#ffff70',
		'#a3fff4',

	];
	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'extras', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay', 'extras', 'options'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";
	public static var vernightly:String = "";

	public static var kadeEngineVer:String = "1.1" + nightly;
	public static var gameVer:String = "2.2 " + vernightly;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var gfDance:FlxSprite;
	public static var finishedFunnyMove:Bool = false;

	// Secrets
	var charInputs:String = "";
	var cheatCode1:String = "48221";

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		charInputs = "";

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-100).loadGraphic(Paths.image('MenuThings/menubg'));
		bg.screenCenter();
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 1.15));
		bg.scrollFactor.set();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuguy = new FlxSprite();
		menuguy.frames = Paths.getSparrowAtlas('MenuThings/MenuFunnies');
		menuguy.animation.addByPrefix('freeplay', "freeplay", 24);
		menuguy.animation.addByPrefix('story mode', "story mode", 24);
		menuguy.animation.addByPrefix('options', "options", 24);
		menuguy.animation.play('story mode');
		menuguy.scrollFactor.set();
		menuguy.antialiasing = true;
		menuguy.screenCenter();
		FlxTween.tween(menuguy, {y: menuguy.y + 10}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(menuguy, {x: menuguy.x + 10}, 2, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.15});
		add(menuguy);

		blackstuff = new FlxSprite(-100).loadGraphic(Paths.image('MenuThings/menu_outline'));
		blackstuff.screenCenter();
		blackstuff.antialiasing = true;
		blackstuff.scrollFactor.set();
		blackstuff.x -= 500;
		add(blackstuff);
		FlxTween.tween(blackstuff, {x: blackstuff.x + 500}, 0.75, {ease: FlxEase.backInOut});

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			if (optionShit[i] == 'extras')
				{
					menuItem.frames = Paths.getSparrowAtlas('extras');
					menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
					menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				}
				else 
				{
					menuItem.frames = tex;
					menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
					menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				}
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.x = 70;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 25, 0, ("Glitch Engine " + kadeEngineVer), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var gameShit:FlxText = new FlxText(5, FlxG.height - 48, 0, ("Glitched-Sides " + gameVer), 12);
		gameShit.scrollFactor.set();
		gameShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(gameShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		// Code stuffs
		checkCodeInput();

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
				{
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound('confirmMenu'));
					
	
						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										FlxTween.tween(blackstuff, {x: blackstuff.x - 650}, 1.15, {ease: FlxEase.backInOut});
										spr.kill();
									}
								});
							}
							else
							{
								if (FlxG.save.data.flashing)
								{
									FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
									{
										FlxTween.tween(blackstuff, {x: blackstuff.x - 600}, 1.15, {ease: FlxEase.backInOut});
										goToState();
									});
								}
								else
								{
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										FlxTween.tween(blackstuff, {x: blackstuff.x - 600}, 1.15, {ease: FlxEase.backInOut});
										goToState();
									});
								}
							}
						});
					}
			}
	

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");
			case 'extras':
				FlxG.switchState(new ExtraSongState());

				trace("Extras Menu Selected");
			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
		{
				curSelected += huh;
				if (curSelected >= menuItems.length)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
	
				menuguy.animation.play(optionShit[curSelected]);
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromString(daColors[curSelected]));
				FlxG.camera.zoom = 1;
				FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');
	
				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
	
				}
	
				spr.updateHitbox();
			});
		}
		function checkCodeInput()
			{
				if (FlxG.keys.justPressed.ANY)
				{
					if (FlxG.keys.justPressed.ZERO)
					{
						charInputs += '0';
						trace("0");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.ONE)
					{
						charInputs += '1';
						trace("1");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.TWO)
					{
						charInputs += '2';
						trace("2");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.THREE)
					{
						charInputs += '3';
						trace("3");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.FOUR)
					{
						charInputs += '4';
						trace("4");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.FIVE)
					{
						charInputs += '5';
						trace("5");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.SIX)
					{
						charInputs += '6';
						trace("6");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.SEVEN)
					{
						charInputs += '7';
						trace("7");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.EIGHT)
					{
						charInputs += '8';
						trace("8");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
					else if (FlxG.keys.justPressed.NINE)
					{
						charInputs += '9';
						trace("9");
						FlxG.sound.play(Paths.sound('keyenter', 'shared'));
					}
		
					if (cheatCode1.startsWith(charInputs))
					{
						if (charInputs == cheatCode1)
						{
							FlxG.save.data.formidityUnlocked = true;
							FlxG.sound.play(Paths.sound('clickText', 'shared'));
						}
					}
					else
					{
						if (charInputs.length >= 5)
							
						charInputs = '';
					}
				}
			}
		}