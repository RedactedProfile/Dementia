// Arena Level Generator 
// VERSION 2 "YOU'RE WINNER Edition"

lvlThis = this;

var genInit = function(success:Boolean) 
{
	if(success)
	{
		log("Successfully Loaded: " + scriptPath);
		_global.lvl_genVersion	= lvlData.version;
		_global.lvl_mapName		= lvlData.projname;
		_global.lvl_mapDesc		= lvlData.projdesc;
		_global.lvl_author		= lvlData.author;
		_global.lvl_rules		= lvlData.rules.split(",");
		_global.lvl_bgImage		= lvlData.floorimage;
		_global.lvl_bgMusic		= lvlData.backgroundmusic;
		_global.lvl_nodeSize	= lvlData.nodesize;
		_global.lvl_xExtent		= lvlData.xextent;
		_global.lvl_yExtent		= lvlData.yextent;
		_global.lvl_eExtent		= lvlData.eextent;
		_global.lvl_sExtent		= lvlData.sextent;
		_global.lvl_pExtent		= lvlData.pextent;	//JF: Added for player spawn
		_global.lvl_entities	= lvlData.entities.split(",");
		_global.lvl_spawners	= lvlData.spawners.split(",");
		_global.lvl_playerstart	= lvlData.playersstart.split(",");	//JF: Added for player spawn
		_global.lvl_map			= lvlData.map.split(",");
		_global.lvl_nextMap		= lvlData.nextMap; // KH: added for logical loading of next map
		verControl();
		ruleSetup();
	} else
	{
		log("Error code E0u812");
		log("-- Error loading: " + scriptPath);
		log("-- Reason: Script file doesn't exist");
		log("-- Aborting level, restarting...");
		map("mainMenu");
	}
}

	// Versioning Control
var verControl = function() 
{
	switch(lvl_genVersion)
	{
		case "5":
			genLevel5();
			break;
		default:
			log("Warning code W1337");
			log("-- Level Generator Error");
			log("-- Generator version \"" + lvl_genVersion + "\" does not exist");
			log("-- defaulting to v5");
			// Instead of booting lets just have it default to the first logical choice
			lvl_genVersion = 5;
			verControl();
			break;
	}
}

	// Level Generation v5
var genLevel5 = function()
{
	var i, j;
	var mp = new Array();
	var ep = new Array();
	var sp = new Array();
	var gProps = 0; //JF: lol wtf. global variable don't work.
	
	_global.totalScore = 0; // KH: Resetting the total score so that when one load another map, the score isn't lingering
	// Loading the Background
	if(_root.cContainer) 
	{
		// Cause nothing is relative to this SWF anymore once loaded through the engine
		lvl_bgImage = "Maps/" + _global.curSrc + "/" + lvl_bgImage;
	}
	bgLoader.loadClip(lvl_bgImage, lvlThis.bg);
	
	// music
	playSound(lvl_bgMusic, 7, 1, 0, 0, true );
	
	// Preparing the Map Data
	mp.length = Number(lvl_yExtent);
	for( i = 0; i < lvl_map.length; i += Number(lvl_xExtent) )
	{
		mp[i/Number(lvl_xExtent)] = new Array();
		for( j = 0; j < Number(lvl_xExtent); j++ )
			mp[i/Number(lvl_xExtent)][j] = lvl_map[i+j];
	}
	lvl_map = mp;
	delete mp;
	
	for( i = 0; i < lvl_entities.length; i += Number(lvl_eExtent) )
	{
		lvlThis.attachMovie( "assets", "prop"+gProps, gDepthOffset_Props + gProps );
		lvlThis["prop"+gProps].gotoAndStop( Number(lvl_entities[i]) );
		lvlThis["prop"+gProps]._rotation = Number(lvl_entities[i+1]);
		lvlThis["prop"+gProps]._x = ((Number(lvl_nodeSize ) * Number( lvl_xExtent )) * 0.5 ) + Number(lvl_entities[i+2]);
		lvlThis["prop"+gProps]._y = ((Number(lvl_nodeSize ) * Number( lvl_yExtent )) * 0.5 ) + Number(lvl_entities[i+3]);
		ep.push( lvlThis["prop"+gProps]._name );
		gProps++;
	}
	lvl_entities = ep;
	delete ep;
	
	for( i = 0; i < lvl_spawners.length; i += Number(lvl_sExtent) )
	{
		sp[i/Number(lvl_sExtent)] = new Array();
		sp[i/Number(lvl_sExtent)][0] = Number(i);		//Rotation
		sp[i/Number(lvl_sExtent)][1] = Number(i+1);		//X
		sp[i/Number(lvl_sExtent)][2] = Number(i+2);		//Y
	}
	lvl_spawners = sp;
	delete sp;
	
	// Title Card Sequence
	lvlThis.attachMovie("titleCard", "titleCard", 99999, {_x: 0, _y: 0});
	_global.tcRef = titleCard;
	titleCard.lvlTitle = lvl_mapName;
	titleCard.lvlAuth = lvl_author;
	titleCard.lvlDesc = lvl_mapDesc;
	titleCard.life = 0;
	titleCard.death = false;
	titleCard.onEnterFrame = titleCardCallback;
}

var titleCardCallback = function() 
{
	if(tcRef.death == false) 
	{
		if(tcRef.life <= 60) 
		{
			//trace(life);
			tcRef.life++;
		} 
		else 
		{
			new Tween(tcRef, "_alpha", Strong.easeOut, 100, 0, 45, false);
			new Tween(tcRef.lvlTitleRef, "_x", Strong.easeOut, tcRef.lvlTitleRef._x, -300, 45, false);
			new Tween(tcRef.lvlAuthRef, "_x", Strong.easeOut, tcRef.lvlAuthRef._x, Stage.width+tcRef.lvlAuthRef._width, 45, false);
			tcRef.death = true;
		}
	}
	if(tcRef._alpha <= 0) {
		tcRef._visible = false;
		tcRef.onEnterFrame = null;
	}
}


var bgLoader:MovieClipLoader = new MovieClipLoader();
var bgListener:Object = new Object();
bgListener.onLoadInit = function() 
{
	//trace("An asstonn of calculations go hither");
	/*
	gRef.UserMap.bg._width = gNode_size * gX_Extent;
	gRef.UserMap.bg._height = gNode_size * gY_Extent;
	gRef.UserMap.bg._x -= (gRef.UserMap.bg._width/2);
	gRef.UserMap.bg._y -= (gRef.UserMap.bg._height/2);
	*/
	lvlThis.bg._x = 0;
	lvlThis.bg._y = 0;
}
bgListener.onLoadError = function()
{
	log("Warning code W80085");
	log("-- Couldn't load Background Image, ");
	log("-- Reasons: ");
	log("-- 1. Invalid path or wrong filename");
	log("-- 2. Invalid file format, only compatible with JPG, PNG, and SWF");
}
bgLoader.addListener(bgListener);

this.createEmptyMovieClip("bg", -20);

var lvlData = new LoadVars();
lvlData.ignoreWhite = true;
lvlData.onLoad = genInit;
if(_root.cContainer) 
{
	scriptPath = "Maps/" + _global.curSrc + "/" + _global.curSrc + _global.sptExt;
} else 
{
	scriptPath = "dem0.map";
}
lvlData.load(scriptPath);


// Victory Conditions
var youWin = function() {
	playSound("victory", 7, 1, 0, 0, false);
	win.play();
	gRef.isVictory = true;
}

// Level Rules
var att1, att2, att3, att4, att5, att6, att7, att8;	// Allows up to 8 attributes
gRef.isVictory = false;
var pointRaceCallback = function() {
	if(totalScore >= att1) {
		youWin();
		lvlThis.onEnterFrame = null;
	}
}

var ruleSetup = function() {
	trace(lvl_rules);
	var myFunc = lvl_rules[0];
	lvl_rules.shift();
	switch(myFunc)
	{
		default:
		break;
		case "pointRace":
			att1 = lvl_rules[0];
			lvlThis.onEnterFrame = pointRaceCallback;
			break;
	}
}