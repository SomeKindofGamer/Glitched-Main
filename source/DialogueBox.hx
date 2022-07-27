package;

import flixel.math.FlxPoint;
import openfl.display.Shader;
import flixel.tweens.FlxTween;
import haxe.Log;
import flixel.input.gamepad.lists.FlxBaseGamepadList;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	// SHADER SHIT
	var curMod:String = '';
	var curshader:Dynamic;
	var blackScreen:FlxSprite;
	public static var randomNumber:Int;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeftGF:FlxSprite;
	var portraitLeftUnknownBF:FlxSprite;
	var portraitLeftFusionBF:FlxSprite;
	var portraitLeftDad:FlxSprite;
	var portraitLeftPump:FlxSprite;
	var portraitLeftSkid:FlxSprite;
	var portraitLeftPico:FlxSprite;
	var portraitLeftMom:FlxSprite;
	var portraitLeftSenpai:FlxSprite;
	var portraitLeftSenpaiHmm:FlxSprite;
	var portraitLeftSenpaiMad:FlxSprite;
	var portraitLeftSpirit:FlxSprite;
	var portraitRightBF:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitLeft:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'horrorland' | 'redemption' | 'end-of-time':
				FlxG.sound.playMusic(Paths.music('dialogue/ruinedfusion', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'cocoa' | 'eggnog':
				FlxG.sound.playMusic(Paths.music('dialogue/christmastalk', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'satin-panties' | 'high' | 'milf':
				FlxG.sound.playMusic(Paths.music('dialogue/wespace', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'pico' | 'philly' | 'blammed':
				FlxG.sound.playMusic(Paths.music('dialogue/shooter', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'spookeez' | 'south' | 'spooked-off':
				FlxG.sound.playMusic(Paths.music('dialogue/ahhscary', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'bopeebo' | 'fresh' | 'dadbattle':
				FlxG.sound.playMusic(Paths.music('dialogue/dadtalk', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'tutorial':
				FlxG.sound.playMusic(Paths.music('dialogue/tut', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'tutorial' | 'bopeebo' | 'fresh' | 'dadbattle' | 'spookeez' | 'south' | 'spooked-off' | 'pico' | 'philly' | 'blammed' | 'satin-panties' | 'high' | 'milf' | 'cocoa' | 'eggnog' | 'horrorland' | 'redemption' | 'end-of-time':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height - 200;
				box.x = -100;
				box.y = 375;
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		portraitLeftSpirit = new FlxSprite(-20, 40);
		portraitLeftSpirit.frames = Paths.getSparrowAtlas('weeb/spiritFaceForward');
		portraitLeftSpirit.animation.addByPrefix('enter', 'Senpai Portrait Enter instance', 24, false);
		portraitLeftSpirit.setGraphicSize(Std.int(portraitLeftSpirit.width * PlayState.daPixelZoom * 0.9));
		portraitLeftSpirit.updateHitbox();
		portraitLeftSpirit.scrollFactor.set();
		add(portraitLeftSpirit);
		portraitLeftSpirit.visible = false;
		
		portraitLeftSenpai = new FlxSprite(-20, 40);
		portraitLeftSenpai.frames = Paths.getSparrowAtlas('portraits/senpaiPortrait');
		portraitLeftSenpai.animation.addByPrefix('enter', 'Senpai Portrait Enter instance', 24, false);
		portraitLeftSenpai.setGraphicSize(Std.int(portraitLeftSenpai.width * PlayState.daPixelZoom * 0.9));
		portraitLeftSenpai.updateHitbox();
		portraitLeftSenpai.scrollFactor.set();
		add(portraitLeftSenpai);
		portraitLeftSenpai.visible = false;
		
		portraitLeftSenpaiHmm = new FlxSprite(-20, 40);
		portraitLeftSenpaiHmm.frames = Paths.getSparrowAtlas('portraits/senpaihmm');
		portraitLeftSenpaiHmm.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitLeftSenpaiHmm.setGraphicSize(Std.int(portraitLeftSenpaiHmm.width * PlayState.daPixelZoom * 0.9));
		portraitLeftSenpaiHmm.updateHitbox();
		portraitLeftSenpaiHmm.scrollFactor.set();
		add(portraitLeftSenpaiHmm);
		portraitLeftSenpaiHmm.visible = false;

		portraitLeftSenpaiMad = new FlxSprite(-20, 40);
		portraitLeftSenpaiMad.frames = Paths.getSparrowAtlas('portraits/senpaiangy');
		portraitLeftSenpaiMad.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitLeftSenpaiMad.setGraphicSize(Std.int(portraitLeftSenpaiMad.width * PlayState.daPixelZoom * 0.9));
		portraitLeftSenpaiMad.updateHitbox();
		portraitLeftSenpaiMad.scrollFactor.set();
		add(portraitLeftSenpaiMad);
		portraitLeftSenpaiMad.visible = false;

		portraitLeftDad = new FlxSprite(-50, 43);
		portraitLeftDad.frames = Paths.getSparrowAtlas('portraits/dadPortrait', 'shared');
		portraitLeftDad.animation.addByPrefix('enter', 'Dad Portrait Enter instance 1', 24, false);
		portraitLeftDad.setGraphicSize(Std.int(portraitLeftDad.width * PlayState.daPixelZoom * 0.15));
		portraitLeftDad.updateHitbox();
		portraitLeftDad.scrollFactor.set();
		add(portraitLeftDad);
		portraitLeftDad.visible = false;

		portraitLeftGF = new FlxSprite(-50, 43);
		portraitLeftGF.frames = Paths.getSparrowAtlas('portraits/gfPortrait', 'shared');
		portraitLeftGF.animation.addByPrefix('enter', 'GF Portrait Enter instance 1', 24, false);
		portraitLeftGF.setGraphicSize(Std.int(portraitLeftGF.width * PlayState.daPixelZoom * 0.15));
		portraitLeftGF.updateHitbox();
		portraitLeftGF.scrollFactor.set();
		add(portraitLeftGF);
		portraitLeftGF.visible = false;

		portraitLeftPump = new FlxSprite(-50, 43);
		portraitLeftPump.frames = Paths.getSparrowAtlas('portraits/pumpPortrait', 'shared');
		portraitLeftPump.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitLeftPump.setGraphicSize(Std.int(portraitLeftPump.width * PlayState.daPixelZoom * 0.15));
		portraitLeftPump.updateHitbox();
		portraitLeftPump.scrollFactor.set();
		add(portraitLeftPump);
		portraitLeftPump.visible = false;

		portraitLeftSkid = new FlxSprite(-50, 43);
		portraitLeftSkid.frames = Paths.getSparrowAtlas('portraits/skidPortrait', 'shared');
		portraitLeftSkid.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitLeftSkid.setGraphicSize(Std.int(portraitLeftSkid.width * PlayState.daPixelZoom * 0.15));
		portraitLeftSkid.updateHitbox();
		portraitLeftSkid.scrollFactor.set();
		add(portraitLeftSkid);
		portraitLeftSkid.visible = false;

		portraitLeftPico = new FlxSprite(-50, 43);
		portraitLeftPico.frames = Paths.getSparrowAtlas('portraits/picoPortrait', 'shared');
		portraitLeftPico.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitLeftPico.setGraphicSize(Std.int(portraitLeftPico.width * PlayState.daPixelZoom * 0.15));
		portraitLeftPico.updateHitbox();
		portraitLeftPico.scrollFactor.set();
		add(portraitLeftPico);
		portraitLeftPico.visible = false;

		portraitLeftMom = new FlxSprite(-50, 43);
		portraitLeftMom.frames = Paths.getSparrowAtlas('portraits/momPortrait', 'shared');
		portraitLeftMom.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitLeftMom.setGraphicSize(Std.int(portraitLeftMom.width * PlayState.daPixelZoom * 0.15));
		portraitLeftMom.updateHitbox();
		portraitLeftMom.scrollFactor.set();
		add(portraitLeftMom);
		portraitLeftMom.visible = false;

		portraitRightBF = new FlxSprite(-50, 40);
		portraitRightBF.frames = Paths.getSparrowAtlas('portraits/boyfriendPortrait', 'shared');
		portraitRightBF.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitRightBF.setGraphicSize(Std.int(portraitRightBF.width * PlayState.daPixelZoom * 0.15));
		portraitRightBF.updateHitbox();
		portraitRightBF.scrollFactor.set();
		add(portraitRightBF);
		portraitRightBF.visible = false;

		portraitLeftUnknownBF = new FlxSprite(-50, 43);
		portraitLeftUnknownBF.frames = Paths.getSparrowAtlas('portraits/boyfriendPortraitUnknown', 'shared');
		portraitLeftUnknownBF.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitLeftUnknownBF.setGraphicSize(Std.int(portraitLeftUnknownBF.width * PlayState.daPixelZoom * 0.15));
		portraitLeftUnknownBF.updateHitbox();
		portraitLeftUnknownBF.scrollFactor.set();
		add(portraitLeftUnknownBF);
		portraitLeftUnknownBF.visible = false;

		portraitLeftFusionBF = new FlxSprite(-50, 43);
		portraitLeftFusionBF.frames = Paths.getSparrowAtlas('portraits/FboyfriendPortrait', 'shared');
		portraitLeftFusionBF.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
		portraitLeftFusionBF.setGraphicSize(Std.int(portraitLeftFusionBF.width * PlayState.daPixelZoom * 0.15));
		portraitLeftFusionBF.updateHitbox();
		portraitLeftFusionBF.scrollFactor.set();
		add(portraitLeftFusionBF);
		portraitLeftFusionBF.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitLeft = new FlxSprite(0, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('hand_textbox', 'shared'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		//dialogue.x = 90;
		//add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// MEGA HARD CODING CUZ IM STUPDI
		if (curshader != null)
			{
				curshader.shader.uTime.value[0] += elapsed;
			}
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		curshader = null;
		switch (curMod)
		{
			case 'distort':
				/*var shad:Shaders.PulseEffect = new Shaders.PulseEffect();
				curshader = shad;
				shad.waveAmplitude = 1;
				shad.waveFrequency = 2;
				shad.waveSpeed = 1;
				shad.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000,100000);
				shad.shader.uampmul.value[0] = 1;*/
				PlayState.screenshader.Enabled = true;
			case 'undistort':
				PlayState.screenshader.Enabled = false;
			case 'distortbg':
				var shad:Shaders.DistortBGEffect = new Shaders.DistortBGEffect();
				curshader = shad;
				shad.waveAmplitude = 0.1;
				shad.waveFrequency = 5;
				shad.waveSpeed = 2;
				if (curCharacter != 'generic')
				{
					portraitLeft.shader = shad.shader;
					portraitRight.shader = shad.shader;
				}
			case 'setfont_normal':
				dropText.font = 'Pixel Arial 11 Bold';
				swagDialogue.font ='Pixel Arial 11 Bold';
			case 'setfont_code':
				dropText.font = Paths.font("barcode.ttf");
				swagDialogue.font = Paths.font("barcode.ttf");
			case 'setfont_vcr':
				dropText.font = Paths.font("vcr.ttf");
				swagDialogue.font = Paths.font("vcr.ttf");
			case 'to_black':
				FlxTween.tween(blackScreen, {alpha:1}, 0.25);
		}
		switch (curCharacter)
		{
			case 'dad':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dadText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				box.flipX = true;
				if (!portraitLeftDad.visible)
				{
					portraitLeftDad.visible = true;
					portraitLeftDad.animation.play('enter');
				}
			case 'gf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				box.flipX = true;
				if (!portraitLeftGF.visible)
				{
					portraitLeftGF.visible = true;
					portraitLeftGF.animation.play('enter');
				}
			case 'pico':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('picoText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				box.flipX = true;
				if (!portraitLeftPico.visible)
				{
					portraitLeftPico.visible = true;
					portraitLeftPico.animation.play('enter');
				}
			case 'mom':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('momText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				box.flipX = true;
				if (!portraitLeftMom.visible)
				{
					portraitLeftMom.visible = true;
					portraitLeftMom.animation.play('enter');
				}
			case 'pump':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('spookyText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				box.flipX = true;
				if (!portraitLeftPump.visible)
				{
					portraitLeftPump.visible = true;
					portraitLeftPump.animation.play('enter');
				}
			case 'skid':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('spookyText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				box.flipX = true;
				if (!portraitLeftSkid.visible)
				{
					portraitLeftSkid.visible = true;
					portraitLeftSkid.animation.play('enter');
				}
			case 'senpai':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				portraitLeftSenpaiMad.visible = false;
				if (!portraitLeftSenpai.visible)
				{
					portraitLeftSenpai.visible = true;
					portraitLeftSenpai.animation.play('enter');
				}
			case 'senpaihmm':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				portraitLeftSenpaiMad.visible = false;
				if (!portraitLeftSenpaiHmm.visible)
				{
					portraitLeftSenpaiHmm.visible = true;
					portraitLeftSenpaiHmm.animation.play('enter');
				}
			case 'senpaimad':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				portraitLeftSenpaiMad.visible = false;
				if (!portraitLeftSenpaiMad.visible)
				{
					portraitLeftSenpaiMad.visible = true;
					portraitLeftSenpaiMad.animation.play('enter');
				}
			case 'spirit':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
					portraitLeftDad.visible = false;
					portraitLeftGF.visible = false;
					portraitLeftPump.visible = false;
					portraitLeftSkid.visible = false;
					portraitRight.visible = false;
					portraitRightBF.visible = false;
					portraitLeftPico.visible = false;
					portraitLeftMom.visible = false;
					portraitLeftSenpai.visible = false;
					portraitLeftSenpaiHmm.visible = false;
					portraitLeftSenpaiMad.visible = false;
					portraitLeftSpirit.visible = false;
					if (!portraitLeftSpirit.visible)
					{
						portraitLeftSpirit.visible = true;
						portraitLeftSpirit.animation.play('enter');
					}
			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
				portraitLeftDad.visible = false;
				portraitLeftGF.visible = false;
				portraitLeftPump.visible = false;
				portraitLeftSkid.visible = false;
				portraitRight.visible = false;
				portraitRightBF.visible = false;
				portraitLeftPico.visible = false;
				portraitLeftMom.visible = false;
				portraitLeftSenpai.visible = false;
				portraitLeftSenpaiHmm.visible = false;
				portraitLeftSenpaiMad.visible = false;
				portraitLeftUnknownBF.visible = false;
				portraitLeftFusionBF.visible = false;
				box.flipX = false;
				if (!portraitRightBF.visible)
				{
					portraitRightBF.visible = true;
					portraitRightBF.animation.play('enter');
				}
			case 'unknownbf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('fusionText'), 0.6)];
				portraitRightBF.visible = false;
				portraitLeftUnknownBF.visible = false;
				portraitLeftFusionBF.visible = false;
				box.flipX = true;
				if (!portraitLeftUnknownBF.visible)
				{
					portraitLeftUnknownBF.visible = true;
					portraitLeftUnknownBF.animation.play('enter');
				}
			case 'fusionbf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('fusionText'), 0.6)];
				portraitRightBF.visible = false;
				portraitLeftUnknownBF.visible = false;
				portraitLeftFusionBF.visible = false;
				box.flipX = true;
				if (!portraitLeftFusionBF.visible)
				{
					portraitLeftFusionBF.visible = true;
					portraitLeftFusionBF.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curMod = splitName[0];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
