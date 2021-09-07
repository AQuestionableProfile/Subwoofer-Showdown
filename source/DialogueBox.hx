package;

import flixel.system.FlxSound;
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

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var sound:FlxSound;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				sound = new FlxSound().loadEmbedded(Paths.music('Lunchbox'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
			case 'thorns':
				sound = new FlxSound().loadEmbedded(Paths.music('LunchboxScary'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
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
		switch (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'jazz-cup':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('meme/text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'neon':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('meme/text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'lost':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('meme/text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'jazz-cup-remix':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('doom/text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				
			case 'neon-remix':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('doom/text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

			case 'lost-remix':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('doom/text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			//Didn't need to bring these here.
			/*case 'chug jug with you':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('modstuff/bf_text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'ringside':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('modstuff/bf_text_bubbles');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);*/
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
			{
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
	
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

				//dummy code. DO NOT ATTEMPT TO LOAD THIS IN WEEK 6. (I don't even have the week set in StoryMenuState.hx)
				//unused and it's safe to add Week 6 in story mode.
				/*portraitRight2 = new FlxSprite(650, -90);
				portraitRight2.frames = Paths.getSparrowAtlas('weeb/CakeWot');
				portraitRight2.animation.addByPrefix('enter', 'Cake portrait enter', 24, false);
				portraitRight2.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
				portraitRight2.updateHitbox();
				portraitRight2.scrollFactor.set();
				add(portraitRight2);
				portraitRight2.visible = false;*/
	
				
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();
				add(box);
	
				box.screenCenter(X);
				portraitLeft.screenCenter(X);
	
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				add(handSelect);
			}
	
			switch (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase())
			{	
				case 'jazz-cup' | 'neon' | 'lost':
					portraitLeft = new FlxSprite(-20, 0);
					portraitLeft.frames = Paths.getSparrowAtlas('meme/maggiePortrait');
					portraitLeft.animation.addByPrefix('enter', 'Maggie Portrait Enter', 24, false);
					portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					add(portraitLeft);
					portraitLeft.visible = false;
			
					portraitRight = new FlxSprite(650, 150);
					portraitRight.frames = Paths.getSparrowAtlas('meme/bfnPortrait');
					portraitRight.animation.addByPrefix('enter', 'Boyfriendn portrait enter', 24, false);
					portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					add(portraitRight);
					portraitRight.visible = false;
			
					//dummy code.
					//unused.
					/*portraitRight2 = new FlxSprite(650, -90);
					portraitRight2.frames = Paths.getSparrowAtlas('meme/CakeWot');
					portraitRight2.animation.addByPrefix('enter', 'Cake portrait enter', 24, false);
					portraitRight2.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
					portraitRight2.updateHitbox();
					portraitRight2.scrollFactor.set();
					add(portraitRight2);
					portraitRight2.visible = false;*/
						
					box.animation.play('normalOpen');
					box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0));
					box.updateHitbox();
					add(box);

					
			
					box.screenCenter(X);
					portraitLeft.screenCenter(X);
				case 'jazz-cup-remix' | 'neon-remix' | 'lost-remix':
					portraitLeft = new FlxSprite(-20, 0);
					portraitLeft.frames = Paths.getSparrowAtlas('doom/maggiePortrait');
					portraitLeft.animation.addByPrefix('enter', 'Maggie Portrait Enter', 24, false);
					portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					add(portraitLeft);
					portraitLeft.visible = false;
			
					portraitRight = new FlxSprite(650, 150);
					portraitRight.frames = Paths.getSparrowAtlas('doom/bfnPortrait');
					portraitRight.animation.addByPrefix('enter', 'Boyfriendn portrait enter', 24, false);
					portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					add(portraitRight);
					portraitRight.visible = false;

					//dummy code.
					//unused.
					/*
					portraitRight2 = new FlxSprite(650, -90);
					portraitRight2.frames = Paths.getSparrowAtlas('doom/CakeWot');
					portraitRight2.animation.addByPrefix('enter', 'Cake portrait enter', 24, false);
					portraitRight2.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
					portraitRight2.updateHitbox();
					portraitRight2.scrollFactor.set();
					add(portraitRight2);
					portraitRight2.visible = false;*/
			
						
					box.animation.play('normalOpen');
					box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0));
					box.updateHitbox();
					add(box);

					
			
					box.screenCenter(X);
					portraitLeft.screenCenter(X);
			}
			//a bit of a dev story about this code here:
			//this was going to be in the mod as a bit of a funny joke; basically him telling me why these songs are in the mod.
			//I took the time to make this into a proper gag week, creating new portraits to represent Cake and I, writing the dialogue, adding the functional code...
			//but I ended up having to scrap the entire thing as Cake didn't really like this week being in the mod (though he found parts of the idea funny).
			//looking back, it was better not to add that week since there was no good reason to keep it in this mod.
			//anyway, back to omitting stuff.
			//ported.
			/*if (PlayState.SONG.song.toLowerCase()=='chug jug with you' || PlayState.SONG.song.toLowerCase()=='ringside')
				{
					portraitLeft = new FlxSprite(-20, 0);
					portraitLeft.frames = Paths.getSparrowAtlas('modstuff/mikiPortrait');
					portraitLeft.animation.addByPrefix('enter', 'Miki Portrait Enter', 24, false);
					portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					add(portraitLeft);
					portraitLeft.visible = false;
			
					portraitRight = new FlxSprite(650, -90);
					portraitRight.frames = Paths.getSparrowAtlas('modstuff/CakeHappy');
					portraitRight.animation.addByPrefix('enter', 'Boyfriendn portrait enter', 24, false);
					portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					add(portraitRight);
					portraitRight.visible = false;

					//hope this works.
					//works, but it's going unused now.
					portraitRight2 = new FlxSprite(650, -90);
					portraitRight2.frames = Paths.getSparrowAtlas('modstuff/CakeWot');
					portraitRight2.animation.addByPrefix('enter', 'Cake portrait enter', 24, false);
					portraitRight2.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0));
					portraitRight2.updateHitbox();
					portraitRight2.scrollFactor.set();
					add(portraitRight2);
					portraitRight2.visible = false;
			
						
					box.animation.play('normalOpen');
					box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0));
					box.updateHitbox();
					add(box);

				
		
					box.screenCenter(X);
					portraitLeft.screenCenter(X);
				}*/

			//I have zero clue who put this here, but when I deleted it the game wouldn't start. Words cannot describe my fucking confusion.
			if (PlayState.SONG.song.toLowerCase()=='jar')
			{	
				portraitLeft.frames = Paths.getSparrowAtlas('the jar');

		
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0));
				box.updateHitbox();
				add(box);
		
				box.screenCenter(X);
				portraitLeft.screenCenter(X);
			}


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
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
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

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						sound.fadeOut(2.2, 0);
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

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				//breaks the game if this isn't loaded into the songs. Adding dummy files now.
				//unused.
				//portraitRight2.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				//portraitRight2.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			//two of them.
			//never use this unless it's for the meme week. (no longer used.)
			/*case 'cake':
				portraitLeft.visible = false;
				//forgot to add this to prevent portrait stacks.
				portraitRight.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}*/
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
