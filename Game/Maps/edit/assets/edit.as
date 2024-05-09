//VERSION 9 "Pappa cock"
//Globals
_global.gRef = this;

_global.gProj_name = "hardcock";
_global.gNode_size = 32;
_global.gX_Extent = 24;
_global.gY_Extent = 24;
_global.gMap = new Array();
_global.gEntities = new Array();
_global.gSpawners = new Array();
_global.gFloorImage = "teambjs.jpg";
_global.gBgm = "shitty_techno";
_global.gAuth = "";
_global.gDesc = "";
_global.gRules = "";

_global.gMouseDown = false;
_global.gLastTile = null;
_global.gPropSelected = false;
_global.gCurrentprop = null;
_global.gNumEntities = 0;
_global.gNumAssets = 0;
_global.gUM_Width = 0;
_global.gUM_Height = 0;
_global.gAnchor_x = null;
_global.gAnchor_y = null;
_global.gRotstep = 45;
_global.gCurrentRotStep = 3;
_global.gUsefulRotations = [
	1,
	10,
	25,
	45,
	90,
	180
];
	


_global.gKey_edit = false;
_global.gKey_new = false;
_global.gKey_entities = false;
_global.gKey_spawners = false;
_global.gKey_properties = false;

//KH: Gotta listen for the exact moment its done loader
_global.bgLoader = new MovieClipLoader();
var bgListener:Object = new Object();
bgListener.onLoadInit = function() {
	gRef.UserMap.bg._width = gNode_size * gX_Extent;
	gRef.UserMap.bg._height = gNode_size * gY_Extent;
	gRef.UserMap.bg._x -= (gRef.UserMap.bg._width/2);
	gRef.UserMap.bg._y -= (gRef.UserMap.bg._height/2);
}
bgLoader.addListener(bgListener);
// Flash is dumb and is calculating the same thing different ways, go figure
_global.bgLoader2 = new MovieClipLoader();
var bgListener2:Object = new Object();
bgListener2.onLoadInit = function() {
	gRef.UserMap.bg._width = gNode_size * gX_Extent;
	gRef.UserMap.bg._height = gNode_size * gY_Extent;
	gRef.UserMap.bg._x -= 0;
	gRef.UserMap.bg._y -= 0;
}
bgLoader2.addListener(bgListener2);



var cmMain:ContextMenu = new ContextMenu();
cmMain.hideBuiltInItems();
var cmiBackground1:ContextMenuItem = new ContextMenuItem("Background 1", onBackgroundSelect);
cmMain.customItems.push(cmiBackground1);
this.menu = cmMain;

var propz = function() {
	trace("Properties!");
//Export menu
	if( gRef.properting._visible )
	{
		gRef.properting._visible = false;
	}
	else
	{
		gRef.properting._visible = true;
		gRef.properting.floorimage.text = gFloorImage;
		gRef.properting.bgm.text = gBgm;
		gRef.properting.proj.text = gProj_name;
		gRef.properting.auth.text = gAuth;
		gRef.properting.desc.text = gDesc;
		gRef.properting.onEnterFrame = PropCallback;
	}
	gKey_properties = true;
}



//Create new scene
var CreateNewScene = function()
{
	var x, y;
	
	
	
	//Create new map container
	gRef.createEmptyMovieClip( "UserMap", gRef.getNextHighestDepth() );
	gRef.UserMap._x = Stage.width*0.5;
	gRef.UserMap._y = Stage.height*0.5;
	
	gRef.UserMap.createEmptyMovieClip("bg", -9999);	// KH
	bgLoader.loadClip(_global.gFloorImage, gRef.UserMap.bg);
	
	//Create new map data
	for( i = 0; i < gY_Extent; i++ )
	{
		gMap[i] = new Array();
		for( j = 0; j < gX_Extent; j++ )
		{
			gRef.UserMap.attachMovie( "tile", "y"+i+"x"+j, 100 + gRef.UserMap.getNextHighestDepth() );
			gRef.UserMap["y"+i+"x"+j]._x = j * gNode_size - gNode_size * Math.floor( (gX_Extent * 0.5) );
			gRef.UserMap["y"+i+"x"+j]._y = i * gNode_size - gNode_size * Math.floor( (gY_Extent * 0.5) );
			gRef.UserMap["y"+i+"x"+j]._xscale = 100 * gNode_size;
			gRef.UserMap["y"+i+"x"+j]._yscale = 100 * gNode_size;
			gRef.UserMap["y"+i+"x"+j].gotoAndStop( 1 );
			gMap[i][j] = 0;
		}
	}
	gUM_Width = gRef.UserMap._width;
	gUM_Height = gRef.UserMap._height;
	
	//Add menus
	gRef.attachMovie( "export", "exporting", gRef.getNextHighestDepth() );
	gRef.exporting._x = Stage.width * 0.5;
	gRef.exporting._y = Stage.height * 0.5;
	gRef.exporting._visible = false;
	
	
	gRef.attachMovie( "properties", "properting", gRef.getNextHighestDepth() );
	gRef.properting._x = Stage.width * 0.5;
	gRef.properting._y = Stage.height * 0.5;
	gRef.properting._visible = false;
	
	gRef.attachMovie( "newproj", "newprojecting", gRef.getNextHighestDepth() );
	gRef.newprojecting._x = Stage.width * 0.5;
	gRef.newprojecting._y = Stage.height * 0.5;
	gRef.newprojecting._visible = false;
	
	gRef.createEmptyMovieClip( "entitings", gRef.getNextHighestDepth() );
	gRef.entitings._x = 0;
	gRef.entitings._y = Stage.height * 0.9;
	gRef.entitings._visible = false;
	gRef.entitings.onEnterFrame = AssetCallback;
	
	gRef.createEmptyMovieClip( "spawnings", gRef.getNextHighestDepth() );
	gRef.spawnings._x = 0;
	gRef.spawnings._y = Stage.height * 0.9;
	gRef.spawnings._visible = false;
	
	gRef.attachMovie( "step", "annoyings", gRef.getNextHighestDepth() );
	gRef.annoyings._x = Stage.width;
	gRef.annoyings._y = Stage.height * 0.5;
	
	
	//Add some callbacks
	gRef.onMouseDown = MouseDownCallback;
	gRef.onMouseUp = MouseUpCallback;
	gRef.onEnterFrame = FrameCallBack;
	
	//Quick hack for deriving total number of assets.
	gRef.attachMovie( "assets", "assetings", gRef.getNextHighestDepth() );
	gNumAssets = gRef.assetings._totalframes;
	gRef.assetings.removeMovieClip();
	
	
	
}

var DestroyScene = function()
{
	gRef.UserMap.removeMovieClip();
	gRef.exporting.removeMovieClip();
	gRef.newprojecting.removeMovieClip();
	gRef.spawnings.removeMovieClip();
	gRef.entitings.removeMovieClip();
	gRef.properting.removeMovieClip();
	gRef.annoyings.removeMovieClip();
	gRef.bg.removeMovieClip();
	gNumEntities = 0;
}


//
//Call backs
//

//Button call backs
var StartButtonCallback = function()
{
	gProj_name = String( gRef.proj.text );
	gAuth = String( gRef.auth.text );
	gNode_size = Number( gRef.nodes.text );
	gX_Extent = Number( gRef.xext.text );
	gY_Extent = Number( gRef.yext.text );
	gDesc = String( gRef.desc.text );
	gRef.nextFrame();
	CreateNewScene();
}
this.startbutton.onRelease = StartButtonCallback;

var AssetButtonCallback = function()
{
	//if( this.hitTest( _parent._xmouse, _parent._ymouse, false ) )
	//{
		var depth = gRef.UserMap.getNextHighestDepth();

		if( gCurrentProp != null && gCurrentProp._name == "de" )
		{
			gCurrentProp.removeMovieClip();
			gCurrentProp = null;
		}

		gRef.UserMap.attachMovie( "assets", "de", depth );
		gRef.UserMap["de"].gotoAndStop( this.id );
		gRef.UserMap["de"]._alpha = 50;

		gCurrentProp = gRef.UserMap["de"];
	//}
}

//Menu callbacks
var ExportCallback = function()
{
	this.ho = "";
	this.ho += "&version=5&\n";
	this.ho += "&projname="+gProj_name+"&\n";
	this.ho += "&projdesc="+gDesc+"&\n";
	this.ho += "&author="+gAuth+"&\n";
	this.ho += "&nodesize="+gNode_size+"&\n";
	this.ho += "&xextent="+gX_Extent+"&\n";
	this.ho += "&yextent="+gY_Extent+"&\n";
	this.ho += "&map="+gMap+"&\n";
	this.ho += "&rules="+gRules+"&\n";	// KH
	this.ho += "&floorimage="+gFloorImage+"&\n";
	this.ho += "&backgroundmusic="+gBgm+"&\n";
	this.ho += "&eextent=4&\n";
	this.ho += "&entities="+gEntities+"&\n";
	this.ho += "&sextent=4&\n";
	this.ho += "&spawners="+"0,0,0,0"+"&\n";
	this.onEnterFrame = null;
}

var	NewpCallback = function()
{
	if( Key.isDown( 89 ) )
	{
		DestroyScene();
		gRef.prevFrame();
		this._visible = false;
	}
}
var AssetCallback = function()
{
	var i;
	for( i = 0; i < gNumAssets; i++ )
	{
		this.attachMovie( "assets", "asset"+i, this.getNextHighestDepth() );
		this["asset"+i].gotoAndStop( i+1 );
		this["asset"+i]._xscale = 25;
		this["asset"+i]._yscale = 25;
		this["asset"+i]._x = (i+1) * this["asset"+i]._xscale * 3;
		this["asset"+i]._y = 0;
		this["asset"+i].id = i+1;
		this["asset"+i].onRelease = AssetButtonCallback;
		
	}
	this.onEnterFrame = null;
}

var PropCallback = function()
{
	//Shhh... :>
	
	trace(gFloorImage);
	gBgm = this.bgm.text;
	gProj_name = this.proj.text;
	gAuth = this.auth.text;
	gDesc = this.desc.text;
	gRules = this.rules.text;
	// KH: Realtime Updater
	gFloorImage = this.floorimage.text;
	_global.bgLoader2.loadClip(gFloorImage, gRef.UserMap.bg);
}
	

//Global callbacks
var MouseDownCallback = function()
{
	gMouseDown = true;
	if( gCurrentProp != null )
	{
		var i, j;
		var tx, ty;
		var ntw = Math.floor( gCurrentProp._width / gNode_size );
		var nth = Math.floor( gCurrentProp._height / gNode_size );
		var ox = Math.floor( (gCurrentProp._x + gUM_Width * 0.5) / gNode_size );
		var oy = Math.floor( (gCurrentProp._y + gUM_Height * 0.5) / gNode_size );
		for( i = 0; i < nth; i++ )
		{
			for( j = 0; j < ntw; j++ )
			{
				tx = ox - Math.floor( ntw * 0.5) + j;
				ty = oy - Math.floor( nth * 0.5) + i;
				if( tx > gX_Extent )
					tx = gX_Extent;
				else if( tx < 0 )
					tx = 0;
				
				if( ty > gY_Extent )
					ty = gY_Extent;
				else if( ty < 0 )
					ty = 0;
					
				gMap[ty][tx] = 1;
				gRef.UserMap["y"+ty+"x"+tx].gotoAndStop( 2 );
			}
		}
		gCurrentProp._alpha = 100;
		if( gCurrentProp._name == "de" )
		{
			gCurrentProp.swapDepths( gRef.gUserMap.getNextHighestDepth() + gNumEntities++ );
			gCurrentProp._name = "ent"+String(gNumEntities-1);
			gCurrentProp.offset = gEntities.length;
			gEntities.push( gCurrentProp._currentframe );
			gEntities.push( gCurrentProp._rotation );
			gEntities.push( ox );
			gEntities.push( oy );
		}
		//Release
		gCurrentProp = null;
		return;
	}
	if( gCurrentProp == null )
	{
		var i;
		for( i = 0; i < gNumEntities; i++ )
		{
			if( gRef.UserMap["ent"+i].hitTest( gRef._xmouse, gRef._ymouse, true ) )
			{
				gCurrentProp = gRef.UserMap["ent"+i];
				break;
			}
		}
	}
}

var MouseUpCallback = function()
{
	gLastTile = null
	gMouseDown = false;
}

var updateMap = function()
{
	var i, j;	
	for( i = 0; i <= gY_Extent; i++ )
	{
		for( j = 0; j <= gX_Extent; j++ )
		{
			gLastTile = "y"+i+"x"+j;
			if( gMap[i][j] )
			{
				gRef.UserMap["y"+i+"x"+j].gotoAndStop( 2 );
				continue;
			}
			gRef.UserMap["y"+i+"x"+j].gotoAndStop( 1 );		
		}
	}
	gAnchor_x = null;
	gAnchor_y = null;
}

var FrameCallBack = function()
{
	//Move prop if we've got it
	if( gCurrentProp != null )
	{
		gCurrentProp._x = gRef.UserMap._xmouse;
		gCurrentProp._y = gRef.UserMap._ymouse;
	}
	
	//Don't do anything if shit's going down
	if( !gMouseDown || gRef.exporting._visible || gRef.newprojecting._visible || gRef.properting._visible || gRef.entitings._visible || gRef.spawnings._visible )
		return;
	
	//Entire edit mode
	if( Key.isDown( Key.SPACE ) )
	{
		//Get cursor position, clamp it in place
		var tx = Math.floor( (gRef.UserMap._xmouse + gUM_Width * 0.5) / gNode_size );
		var ty = Math.floor( (gRef.UserMap._ymouse + gUM_Height * 0.5) / gNode_size );
		if( tx > gX_Extent )
			tx = gX_Extent;
		else if( tx < 0 )
			tx = 0;
			
		if( ty > gY_Extent )
			ty = gY_Extent;
		else if( ty < 0 )
			ty = 0;
		
		/*//Drag selection
		if( Key.isDown( 68 ) )
		{	
			var i, j;
			if( gAnchor_x == null && gAnchor_y == null )
			{
				gAnchor_x = tx;
				gAnchor_y = ty;
			}
			var px = gAnchor_x - tx > 0 ? tx : gAnchor_x;
			var py = gAnchor_y - ty > 0 ? ty : gAnchor_y;
			var ppx = gAnchor_x - px > 0 ? gAnchor_x : tx;
			var ppy = gAnchor_y - py > 0 ? gAnchor_y : ty;	
			for( i = 0; i <= gY_Extent; i++ )
			{
				for( j = 0; j <= gX_Extent; j++ )
				{	
					if( (i >= py && i <= ppy) && (j >= px && j <= ppx) )
						gRef.UserMap["y"+i+"x"+j].gotoAndStop( 3 );
				}
			}
			return;
		}
		else if( (gAnchor_x != null && gAnchor_y != null) )
		{
			updateMap();
			return;
		}*/
		
		//Manual edit
		if( gLastTile != "y"+ty+"x"+tx )
		{
			if( gMap[ty][tx] )
			{
				gMap[ty][tx] = 0;
				gRef.UserMap["y"+ty+"x"+tx].gotoAndStop( 1 );
				
			}
			else
			{
				gMap[ty][tx] = 1;
				gRef.UserMap["y"+ty+"x"+tx].gotoAndStop( 2 );
			}
			gLastTile = "y"+ty+"x"+tx;
		}
		return;
	}
	/*//Reset the entire map. This is a bit wasteful, but it saves a lot of headaches.
	if( (gAnchor_x != null && gAnchor_y != null) )
	{
		updateMap();
		return;
	}*/
	
	var ms = 20;
	var dx = (Stage.width * 0.5 - gRef._xmouse) / Stage.width;
	var dy = (Stage.height * 0.5 - gRef._ymouse) / Stage.height;
	
	if( dx > 0 )
	{
		if( gRef.UserMap._x < Stage.width * 0.5 + Math.abs( Stage.width - gUM_Width ) * 0.5 )
			gRef.UserMap._x += dx * ms;
	}
	else
	{
		if( gRef.UserMap._x > Stage.width * 0.5 - Math.abs( Stage.width - gUM_Width ) * 0.5 )
			gRef.UserMap._x += dx * ms;
	}
	
	if( dy > 0 )
	{
		if( gRef.UserMap._y < Stage.height * 0.5 + Math.abs( Stage.height - gUM_Height ) * 0.5 )
			gRef.UserMap._y += dy * ms;
	}
	else
	{
		if( gRef.UserMap._y > Stage.height * 0.5 - Math.abs( Stage.height - gUM_Height ) * 0.5 )
			gRef.UserMap._y += dy * ms;
	}
}

//Retarded keyboard listern cause flash is so bad it's unbelievable. seriously Macromedia, what the flying fuck?
var kl = new Object();
kl.onKeyDown = function()
{
	if( !gKey_edit && !gRef.newprojecting._visible && !gRef.properting._visible && Key.isDown( 79 ) )
	{
		//Export menu
		if( gRef.exporting._visible )
		{
			gRef.exporting._visible = false;
		}
		else
		{
			gRef.exporting._visible = true;
			gRef.exporting.onEnterFrame = ExportCallback;
		}
		gKey_edit = true;
	}
	
	if( !gKey_new && Key.isDown( 78 ) )
	{
		//Export menu
		if( gRef.newprojecting._visible )
		{
			gRef.newprojecting._visible = false;
		}
		else
		{
			gRef.newprojecting._visible = true;
			gRef.newprojecting.onEnterFrame = NewpCallback;
		}
		gKey_new = true;
	}
	
	if( !gKey_spawners  && !gRef.newprojecting._visible && Key.isDown( 88 ) )
	{
		//Export menu
		if( gRef.spawnings._visible )
		{
			gRef.spawnings._visible = false;
		}
		else
		{
			gRef.spawnings._visible = true;
			//gRef.spawnings.onEnterFrame = NewpCallback;
		}
		gKey_spawners = true;
	}
	
	if( !gKey_entities && !gRef.newprojecting._visible && Key.isDown( 90 ) )
	{
		//Export menu
		if( gRef.entitings._visible )
			gRef.entitings._visible = false;
		else
			gRef.entitings._visible = true;
		gKey_entities = true;
	}
	
	if( !gKey_properties && !gRef.newprojecting._visible && Key.isDown( 80 ) )
	{
		//Export menu
		if( gRef.properting._visible )
		{
			gRef.properting._visible = false;
			gRef.properting.onEnterFrame = null;
		}
		else
		{
			gRef.properting._visible = true;
			gRef.properting.floorimage.text = gFloorImage;
			gRef.properting.bgm.text = gBgm;
			gRef.properting.proj.text = gProj_name;
			gRef.properting.auth.text = gAuth;
			gRef.properting.desc.text = gDesc;
			gRef.properting.onEnterFrame = PropCallback;
		}
		gKey_properties = true;
	}
		
	if( Key.isDown( 107 ) )
	{
		if( gCurrentRotStep < gUsefulRotations.length-1 )
			gRotstep = gUsefulRotations[++gCurrentRotStep];
		
		log( "Rotation step: " + gRotstep );
		gRef.annoyings.step.text = gRotstep;
		gRef.annoyings.gotoAndPlay( 2 );
	}
	
	if( Key.isDown( 109 ) )
	{
	
		if( gCurrentRotStep > 0 )
			gRotstep = gUsefulRotations[--gCurrentRotStep];
	
		log( "Rotation step: " + gRotstep );
		gRef.annoyings.step.text = gRotstep;
		gRef.annoyings.gotoAndPlay( 2 );
	}
	
	if( Key.isDown( 83 ) && gCurrentProp != null )
		gCurrentProp._rotation -= gRotstep;
		
	if( Key.isDown( 65 ) && gCurrentProp != null )
		gCurrentProp._rotation += gRotstep;
	
	if( Key.isDown( 67 ) && gCurrentProp != null )
	{
		if( gCurrentProp._name != "de" )
		{
			log( "deleting entity " + gCurrentProp._name );
			gNumEntities--;
		}
		gCurrentProp.removeMovieClip();
		gCurrentProp = null;
	}
}

kl.onKeyUp = function()
{
	if( !Key.isDown( 79 ) )
		gKey_edit = false;
	if( !Key.isDown( 78 ) )
		gKey_new = false;
	if( !Key.isDown( 88 ) )
		gKey_entities = false;
	if( !Key.isDown( 90 ) )
		gKey_spawners = false;
	if( !Key.isDown( 80 ) )
		gKey_properties = false;
}
Key.addListener( kl );