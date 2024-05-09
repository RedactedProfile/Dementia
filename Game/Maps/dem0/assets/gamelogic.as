//VERSION 8 "Farfor Edition"
var iID; // IntevalID
var iDuration:Number = 20; // Milliseconds before doing something
/*
function tracing() {

	//createActor(100, 30, 100, 10, 100, 50, 0, 1);
}

this.onMouseDown = function() {
	tracing();
	if(dude._currentframe == 2) {
		iID = setInterval(this, "tracing", 300);
	} else if(dude._currentframe == 3) {
		iID = setInterval(this, "tracing", 100);
	} else if(dude._currentframe == 4) {
		iID = setInterval(this, "tracing", 800);
	}
}*/



enemyGen.onPress = function() {
	//createActor( aMaxHealth, aHealth, aMaxArmor, aArmor, aMaxStamina, aStamina, aImmunities, aAIType )
	createActor(100, 30, 100, 10, 100, 50, 0, 1);
	//trace(aname + " " + gActorNames[12] + " " + gDeathStrings_blade[1]);
	
	// KH: Shall we use this function on an enemy yet?
	//broadcastDeath(_global.aname,gActorNames[Math.ceil(Math.random()*gActorNames.length)-1],gInflictiondevice_blade);
}

// KH: added the isVicotry If/Else
var makeEnemy = function() {
	if(gRef.isVictory == false) {
		var e = createActor(100, 30, 100, 10, 100, 50, 0, 1);
		e._x = Math.random() * Stage.width;
	} else {
		clearInterval(genEn);
	}
}

var genEn = setInterval(this, "makeEnemy", 1000);
