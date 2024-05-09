// Media Playing Functions
_global.cLoader = new MovieClipLoader();
var cListener:Object = new Object();
cListener.onLoadComplete = function(target_mc:MovieClip, httpStatus:Number):Void {
    log("Completed Loading " + target_mc);
}
cListener.onLoadStart = function(targetMC:MovieClip) {
	log("Began loading: " + targetMC);
}
cListener.onLoadError = function(targetMC:MovieClip, errorCode:String) {
	log("Could not load " + targetMC + ", \"" + errorCode + "\"");
}

_global.cLoader.addListener(cListener);

this.createEmptyMovieClip("cContainer", this.getDepth(consoleBG)-2);
this.createEmptyMovieClip("cMenu", this.getDepth(consoleBG)-1);
// This file contains all menu called functions
#include "menuFunctions.as"

var playMovie = function(id,src,name):Void {
	// Cinema Playback
	log("Id = " + id);
	log("Src = " + src);
	log("Name = " + name);
	// cContainer = clip container
	_global.cLoader.loadClip(src, cContainer);
}

var playMap = function(id,src,name):Void {
	// Map Playback
	log("Id = " + id);
	log("Src = " + src);
	log("Name = " + name);
	_global.cLoader.loadClip(src, cContainer);
}


var playMenu = function(id,src,name):Void {
	buildMenu(src);
}

var finished = function(type) {
	if(!type) {
		log("- Clearing Clip Container - ");
		cLoader.unloadClip(cContainer);
	} else {
		log("- Clearing Menu - ");
		cLoader.unloadClip(cMenu);
	}
	_global.musicPlay.stop();
	playGame();
}

var buildMenu = function(src) {
	var menuArray:Array = new Array();
	var menuXML:XML = new XML();
	menuXML.ignoreWhite = true;
	menuXML.load(src);
	
	menuXML.onLoad = function() {
		var menuBG = "Menu/"+this.firstChild.attributes.bg;
		log(menuBG);
		var menuTitle = this.firstChild.attributes.title;
		var titleAtt:Array = this.firstChild.attributes.titleAtt.split(",");
		var menuFont = this.firstChild.attributes.font;
		var nodes = this.firstChild.childNodes;
		var elementsNum = nodes.length;
		cMenu.createEmptyMovieClip("bgContainer",-50);
		_global.cLoader.loadClip(menuBG, cMenu.bgContainer);
		cMenu.createTextField("mTitle", -49, titleAtt[2],titleAtt[3],titleAtt[4],titleAtt[5]);
		cMenu.mTitle.selectable = false;
		cMenu.mTitle.html = true;
		cMenu.mTitle.htmlText = "<font size=\""+titleAtt[1]+"\" color=\"#"+titleAtt[0]+"\">"+menuTitle+"</font>";
		if(this.firstChild.attributes.music) {
			music(this.firstChild.attributes.music);
		}
		
		
		
		for(i=0;i<elementsNum;i++) {
			var newButName = "button"+i;
			var newTextName = "buttonText"+i;
			var buttonUIName = "buttonDecal"+i;
			cMenu.createEmptyMovieClip(newButName, i);
			cMenu["button"+i].createEmptyMovieClip("buttonDecal", this.getNextHighestDepth());
			pointer = "Menu/"+nodes[i].attributes.ui;
			log(pointer);
			_global.cLoader.loadClip(pointer, cMenu["button"+i].buttonDecal);
			cMenu["button"+i].createTextField(newTextName, this.getNextHighestDepth(),0,0,nodes[i].attributes.label.length+60,25);
			log(nodes[i].attributes.label.length);
			textRef = cMenu["buttonText"+i].buttonDecal;
			log(textRef);
			cMenu["button"+i]["buttonText"+i].text = nodes[i].attributes.label;
			cMenu["button"+i]["buttonText"+i].selectable = false;
			cMenu["button"+i]._x = nodes[i].attributes.x;
			cMenu["button"+i]._y = nodes[i].attributes.y;
			
			cMenu["button"+i].onPress =	eval(nodes[i].attributes.func);
			//cMenu["button"+i].onPress = soundfx("dem0/"+nodes[i].attributes.snd);
			
			
		}
	}
}