 //VERSION 9 "Das Gut Edition"

_global.gRef 		= this;
_global.xmlExt 		= ".jag";				// the standard logic XML file extension
_global.defExt 		= ".def";				// the configuration files extnsion
_global.mapExt 		= ".swf";				// the map xml's file extension
_global.sptExt		= ".map";				// Map Script Extension
_global.swfExt		= ".swf";				// Source SWF Extension
_global.soundExt	= ".mp3";				// SoundFX, Voice overs, and Music share this extension
_global.soundDir 	= "sounds/sfx/";		// base sound effects directory
_global.voxDir 		= "sounds/vox";			// base voice over directory
_global.musicDir 	= "sounds/music/";		// base music directory
_global.scriptsDir 	= "scripts/";			// Scripts Directory
_global.mapDir 		= "maps/";				// base maps directory
_global.moviesDir	= "movies/";			// base movies dir, this can contain SWF and FLV files


if(!_root.cContainer) {
} else {
	log("were inside");
}

var g:LoadVars = new LoadVars();
g.onLoad = loadGlobals;
g.ignoreWhite = true;
g.load("gameConfig.cfg");
function loadGlobals(success:Boolean) {
	if(success) {
		log("Successfully loaded: gameConfig.cfg");
		_global.gMaxenemies = g.MaxEnemies;
		_global.gMaxMessages = g.MaxMessages;
		_global.gMaxProjectiles = g.MaxProjectiles;
		_global.gMaxParticles = g.MaxParticles;
		_global.gMaxItems = g.MaxItems;
		_global.gMaxDecals = g.MaxDecals;
		
		_global.gDepthOffset_Decals = g.doDecal;
		_global.gDepthOffset_Messages = g.doMessages;
		_global.gDepthOffset_Items = g.doItems;
		_global.gDepthOffset_Entities = g.doEntities;
		_global.gDepthOffset_Projectiles = g.doProjectiles;
		_global.gDepthOffset_Particles = g.doParticles;
		_global.gDepthOffset_Hud = g.doHud;
		_global.gDepthOffset_Cursor = g.doCursor;
		_global.gDepthOffset_Grid = g.doGrid;
		_global.gDepthOffset_Props = g.doProps;
			
		_global.gVariance_none = g.vNone;
		_global.gVariance_small = g.vSmall;
		_global.gVariance_medium = g.vMedium;
		_global.gVariance_large = g.vLarge;
		_global.gActorNames = g.Actors.split(",");
		
		_global.gDeathStrings_blade = g.DeathBlade.split(",");
		_global.gDeathStrings_pistol = g.DeathPistol.split(",");
		_global.gDeathStrings_machinegun = g.DeathUzi.split(",");
		_global.gDeathStrings_shotgun = g.DeathShotgun.split(",");
		_global.gDeathStrings_grenade = g.DeathNade.split(",");
		_global.gDeathStrings_world = g.DeathWorld.split(",");
		
	} else {
		trace("Couldn't find gameConfig");
		log("Failed loading gameConfig");
	}
}


////// KH +UI Update
// Now for some fun 
_global.rpgExp 		= 0;			// Beginning Experience
_global.nextLevel	= 25;			// Next level
_global.rpgLvl 		= 1;			// Beginning level
_global.meleeMod 	= 1;		// Availability, 0 = Locked, 1 = Unlocked
_global.pistolMod 	= 1;
_global.uziMod 		= 0;
_global.shotgunMod 	= 0;
_global.unlockUziMod = 5;		// unlock Uzi at Level 5, will bump up for real game
_global.unlockShotgun = 10;		// unlock shotgun at level 10, same as above
_global.maxhealth = 100
_global.health = 100;

_global.gainLvl = function() {
	rpgExp = 1;
	nextLevel = Math.round(nextLevel*2);
	rpgLvl++;
	playSound("lvlUp2", 5, 1, _global.dudeRef._x, _global.dudeRef._y, false);
	trace("nextLevel: " + nextLevel);
}

_global.uiCallback = function() {
	this.pStats.pHealth.gotoAndStop(Math.ceil((health/maxhealth)*100));
	this.pStats.pExp.gotoAndStop(Math.ceil((rpgExp/nextLevel)*100));
	//trace("rpgExp = " + rpgExp + ", nextLevel = " + nextLevel);
	//trace(uziMod);
	this.lvl = rpgLvl;
	if(meleeMod == 1 && this.indInv.indMelee._currentframe != 2)
		this.indInv.indMelee.gotoAndStop(2);
	if(pistolMod == 1 && this.indInv.indPistol._currentframe != 2)
		this.indInv.indPistol.gotoAndStop(2);
	if(uziMod == 1 && this.indInv.indUzi._currentframe != 2)
		this.indInv.indUzi.gotoAndStop(2);
	if(shotgunMod == 1 && this.indInv.indShotgun._currentframe != 2)
		this.indInv.indShotgun.gotoAndStop(2);
		
	if(_global.health <= 0)
		trace("player Kill");//killPlayer();
		
	if(rpgLvl >= unlockUziMod && _global.uziMod != 1)
		_global.uziMod = 1;
	if(rpgLvl >= unlockShotgun && _global.shotgunMod != 1)
		_global.shotgunMod = 1;
		
	if(rpgExp >= nextLevel) {
		//rpgExp = 0;			// Why is this forcing the value all the time after its called? makes no sense
		nextLevel = nextLevel*2;
		rpgLvl++;
		_root.cContainer.lvlUpMC.gotoAndPlay(2);
		playSound("lvlUp2", 5, 1, _global.dudeRef._x, _global.dudeRef._y, false);
		//trace("nextLevel: " + nextLevel);
	}
}




_root.attachMovie("arenaUI", "arenaui", this.getNextHighestDepth(), {_x: 0, _y: 0});
_root.arenaui.onEnterFrame = uiCallback;
_global.uiRef = _root.arenaui;
trace("RPG Elements Set");

////// END KH RPG THING


_global.curSnd		= "";
_global.curAssets	= "";
_global.curSrc		= ""; 

_global.cLoader = new MovieClipLoader();
var cListener:Object = new Object();
cListener.onLoadComplete = function(target_mc:MovieClip, httpStatus:Number):Void {
    log("Completed Loading " + target_mc);
	cContainer.setMask(cMask);
}
cListener.onLoadStart = function(targetMC:MovieClip) {
	log("Began loading: " + targetMC);
}
cListener.onLoadError = function(targetMC:MovieClip, errorCode:String) {
	log("Could not load " + targetMC + ", \"" + errorCode + "\"");
}

_global.cLoader.addListener(cListener);


this.createEmptyMovieClip("cContainer", this.getDepth(consoleBG)-2);

cContainer.lineStyle(0, 0, 100, false);
cContainer.beginFill(0xFFFFFF, 100);
cContainer.lineTo(0, 0);
cContainer.lineTo(Stage.width, 0);
cContainer.lineTo(Stage.width, Stage.height);
cContainer.lineTo(0, Stage.height);
cContainer.endFill();
this.createEmptyMovieClip("cMask", this.getDepth(consoleBG)-1);
cMask.lineStyle(0, 0, 100, false);
cMask.beginFill(0xFFFFFF, 100);
cMask.lineTo(0, 0);
cMask.lineTo(Stage.width, 0);
cMask.lineTo(Stage.width, Stage.height);
cMask.lineTo(0, Stage.height);
cMask.endFill();
cContainer.setMask(cMask);
_global.cContainerRef = cContainer;
_global.cMaskRef = cMask;





_global.map = function(src) {
	_global.curSrc = src;
	curSnd = soundDir + src;
	src = mapDir + src + "/" + src + mapExt;
	log("Src = " + src);
	log("curSnd = " + curSnd);
	cLoader.unloadClip(cContainer);
	cLoader.loadClip(src, cContainer);
	
}

map("mainMenu");







_global.gMessages = 0;
_global.gProjectiles = 0;
_global.gParticles = 0;
_global.gItems = 0;
_global.gDecals = 0;
_global.gEntities = 0;
_global.gProps = 0;

_global.gAI_None = 0;
_global.gAI_Durka = 1;
_global.gAI_Zombie = 2;
_global.gAI_Shooter = 3;

_global.gSpreadType_none = 0;
_global.gSpreadType_sin = 1;

_global.gDecalType_blood = 0;
_global.gDecalType_explosion = 1;

_global.totalScore = 0; 	// KH: The counter must reach this eventually
_global.currentScore = 0;	// KH: incrementing counter
_global.multiScore = 1;		// KH: Score Multiplier
_global.multiKillT1 = 10;	// KH: MultiKill Tier Multipliers, x2 Boring
_global.multiKillT2 = 25;	// x3 "Decent..."
_global.multiKillT3 = 90;	// x4 "Cool!"
_global.multiKillT4 = 130;	// x5 "Kick Ass!"
_global.multiKillT5 = 200;	// x6 "Superman!"
_global.multiKillT6 = 300;	// x10 "DementiaMode" unleashed! which increases firepower, rate, and boosts health. Until touched.
_global.multiKillCount = 0;	// KH: The amount of kills racked up before being touched
_global.scoreJumpID = 0;	// KH: Reference for Score jumpers




_global.gInflictiondevice_blade = (1<<0);
_global.gInflictiondevice_pistol = (1<<1);
_global.gInflictiondevice_machinegun = (1<<2);
_global.gInflictiondevice_shotgun = (1<<3);
_global.gInflictiondevice_grenade = (1<<4);

_global.shakeVelocity = 1; // Velocity multiplier for screen shakes

_global.gActors = new Array(50);	//List of actors
_global.gProps = new Array();	//List Things like pillars or crates.
_global.gDecalRegions = [
	new Array(),	//Top Right
	new Array(),	//Top left
	new Array(),	//Bottom left
	new Array(),	//Bottom right
	0,
	0,
	0,
	0
];
