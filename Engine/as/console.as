// This is the console actionscript, takes down logging information and displays it
var consoleListener:Object = new Object();
consoleListener.onKeyDown = function() {
	var cKey = Key.getCode();
	if(cKey == 192) {
    	toggleConsole();
	}
};
Key.addListener(consoleListener);
var toggleConsole = function() {
	if(isConsole == true) {
		var twConsole:Tween = new Tween(consoleBG, "_y", Strong.easeOut, consoleBG._y, -consoleHeight, 24, false);
		isConsole=false;
	} else {
		var twConsole:Tween = new Tween(consoleBG, "_y", Strong.easeOut, consoleBG._y, 0, 24, false);
		isConsole=true;
	}
}
// Lets draw out what we need
this.createEmptyMovieClip("consoleBG", 999999998);
this.createEmptyMovieClip("consoleMask", 999999999);
var consoleHeight:Number = 150;						// We begin drawing out the console using the drawing API
consoleBG.lineStyle(1, 0, 100, false);
consoleBG.beginFill(0x454545, 65);
consoleBG.lineTo((Stage.width-2), 0.4);
consoleBG.lineTo((Stage.width-2), consoleHeight);
consoleBG.lineTo(0.4, consoleHeight);
consoleBG.lineTo(0.4, 0);
consoleMask.lineStyle(0, 0, 100, false);
consoleMask.beginFill(0x000000, 100);
consoleMask.lineTo((Stage.width-1), 0.5);
consoleMask.lineTo((Stage.width-1), (consoleHeight+1));
consoleMask.lineTo(0.5, (consoleHeight+1));
consoleMask.lineTo(0.5, 0);
consoleMask.endFill();
consoleBG.setMask(consoleMask);
consoleBG.cacheAsBitmap = true;

consoleBG.createTextField("logger", consoleBG.getNextHighestDepth(), 5, 5, consoleBG._width, consoleBG._height);
consoleBG.logger.selectable = true;
consoleBG.logger.multiline = true;
consoleBG.logger.text = "1: console logging system initialized....";
consoleBG.logger.textColor = 0xACBDEF; //JF: No more fucking eye strain.



// To move it...

var cNum:Number = 1;
_global.log = function(logText) {
	oldLog = consoleBG.logger.text;
	cNum++;
	newLog = consoleBG.logger.text + "\n" + cNum + ": " + logText;
	consoleBG.logger.text = newLog;
	consoleBG.logger.scroll+=50;
}

var isConsole:Boolean = true;




