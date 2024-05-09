//VERSION 10 "Chadwardenn Edition"

import mx.transitions.Tween;
import mx.transitions.easing.*;

_global.gRef = this;

var createDecal = function( aType, aScale, aX, aY )
{
	var regionId;
	var depth;
	var i;
	//Figure out decal region.
	if( aX <= Stage.width*0.5 )
		regionID = 1;
	else
		regionID = 0;
		
	if( aY > Stage.height*0.5 )
		regionID += 2;
	
	//Check to see if we're too close to be added. Do some managing while we're at it.
	for( i = 0; i < gDecalRegions[regionID].length; i++ )
	{
		//Do some managing
		//JF: TODO - I hate how this works. Tweak it later.
		gDecalRegions[regionID][i]._alpha -= 0.1;
		if( gDecalRegions[regionID][i]._alpha <= 0 )
		{
			gDecalRegions[regionID][i].removeMovieClip();
			gDecalRegions[regionID].splice( gDecalRegions[regionID][i].id, 1 );
		}
		
		//See if we can plot a decal.
		if( Math.abs( aX - gDecalRegions[regionID][i]._x ) < aScale * 0.5 )
			if( Math.abs( aY - gDecalRegions[regionID][i]._y ) < aScale * 0.5 )
				return "No dice."
	}
	
	if( gDecalRegions[regionID].length >= Math.floor(gMaxDecals * 0.25) )
		gDecalRegions[regionID].pop();	//Pop off the oldest.

	//Spawn a new decal
	depth = gDepthOffset_Decals + Math.floor(gDepthOffset_Decals * 0.25) + gDecalRegions[regionID+4];
	switch( aType )
	{
	default:
	case 0:	//Blood
		this.attachMovie( "blood", "decalme"+depth, depth );
		break;
	case 1:	//Crater
		this.attachMovie( "crater", "decalme"+depth, depth );
		this["decal"+depth].cacheAsBitmap = true;
		break;
	}
	
	this["decalme"+depth]._x = aX;
	this["decalme"+depth]._y = aY;
	this["decalme"+depth]._xscale = aScale;
	this["decalme"+depth]._yscale = aScale;
	this["decalme"+depth].id = gDecalRegions[regionID+4];
	gDecalRegions[regionID].unshift( this["decalme"+depth] );
	gDecalRegions[regionID+4]++;
	
	return this["decalme"+depth];
}

//JF: CHANGE - Made compatiable with new system of doings, added two new properties    // "chadwardenn" update
var createExplosion = function( aOwner, aScale, aX, aY )
{
	playSound("explosion", 6, 1, aX, aY, false);
	var i;	
	
	createDecal( gDecalType_explosion, aScale * 1.5, aX, aY );
	this.attachMovie( "explodeme", "explodeme"+gProjectiles, gDepthOffset_Projectiles + gProjectiles );
	
	this["explodeme"+gProjectiles]._x = aX;
	this["explodeme"+gProjectiles]._y = aY;
	this["explodeme"+gProjectiles]._xscale = aScale;
	this["explodeme"+gProjectiles]._yscale = aScale;
	this["explodeme"+gProjectiles].owner = aOwner;
	this["explodeme"+gProjectiles].scale = aScale;
	this["explodeme"+gProjectiles].classname = "explosion";
	
	for( i = 0; i < gActors.length; i++ )
	{
		if( this["explodeme"+gProjectiles].hitTest( gActors[i] ) )
		{
			var delta_x = this["explodeme"+gProjectiles]._x - gActors[i]._x;
			var delta_y = this["explodeme"+gProjectiles]._y - gActors[i]._y;
			var distance = Math.abs( Math.sqrt( delta_x * delta_x + delta_y * delta_y ) );
			painToAllThingsMortal( aOwner, gActors[i], gInflictiondevice_grenade, Math.ceil( (aScale*0.5 - distance*0.5) * 2 )  )
		}
	}
	gProjectiles++;
}

var createActor = function( aMaxHealth, aHealth, aMaxArmor, aArmor, aMaxStamina, aStamina, aImmunities, aAIType )
{
	if( gEntities > gMaxEntities )
		gEntities = 0;
		
	this.attachMovie("npc", "npc"+gEntities, _global.gDepthOffset_Entities+gEntities, {});
	this["npc"+gEntities].aname = gActorNames[Math.floor(Math.random()*gActorNames.length)];
	this["npc"+gEntities].maxhealth = aMaxHealth;
	this["npc"+gEntities].health = aHealth;
	this["npc"+gEntities].maxarmor = aMaxArmor;
	this["npc"+gEntities].armor = aArmor;
	this["npc"+gEntities].maxstamina = aMaxStamina;
	this["npc"+gEntities].stamina = aStamina;
	this["npc"+gEntities].immunities = aImmunities;
	this["npc"+gEntities].classname = "enemy";

	switch( aAIType )	
	{
	default:
		break;
	case 0:
		break;
	case 1:
		this["npc"+gEntities].gotoAndStop("Jihadist");
		this["npc"+gEntities].onEnterFrame = ai_durkadurkajihad_init;
		break;
	case 2:
		this["npc"+gEntities].gotoAndStop("Zombie");
		this["npc"+gEntities].onEnterFrame = ai_zombie_init;
		break;
	case 3:
		this["npc"+gEntities].gotoAndStop("Shooter");
		this["npc"+gEntities].onEnterFrame = ai_shooter_init;
		break;
	}
	
	//JF: This is the best I've managed thus far. The array length is fixed at the max number of enemies.
	//New actors are added at the first unoccupied slot encountered. When they die, they release their position, thus completing the cycle of life.
	for( var i = 1; i < gActors.length; i++ )
	{
		if( gActors[i] == undefined )
		{
			this["npc"+gEntities].id = i;
			gActors[i] = this["npc"+gEntities];
			break;
		}
	}
	gEntities++;
	return this["npc"+gEntities];
}

//JF: CHANGE - Made compatiable with new system of doings		// "chadwardenn" update
var BulletCallback = function()
{
	if( this._x > Stage.width || this._x < 0 || this._y > Stage.height || this._y < 0 )
		this.removeMovieClip();
		
	var i;
	for( i = 1; i < gActors.length; i++ )
	{
		if( this.hitTest( gActors[i] ) )
		{
			painToAllThingsMortal( this.owner, gActors[i], this.damage_type, this.damage );
			this.removeMovieClip();
			break;
		}
	}
	for( i = 0; i < lvl_entities.length; i++ )
	{
		if( gRef[lvl_entities[i]].hitTest( this._x, this._y, true ) )
		{
			this.removeMovieClip();
			break;
		}
	}
	//if( lvl_map[Math.floor( this._x / Number(lvl_nodeSize) )][Math.floor( this._y / Number(lvl_nodeSize) )] > 0)
		//this.removeMovieClip();
		
	this._x += Math.cos( this._rotation + this.variance ) * this.speed;
	this._y += Math.sin( this._rotation + this.variance ) * this.speed;
}

var shootBullet = function( aOwner, aOffset, aOffsetDegrees, aSpeed, aVariance, aDevice, aDamage, aFuckWithOrigin )
{
	if( gProjectiles >= gMaxProjectiles )
		gProjectiles = 0;
	
	var ang = aOwner._rotation * 0.017453292519943295769236907684886;
	this.attachMovie( "bullet", "bullet"+gProjectiles, gDepthOffset_Projectiles + gProjectiles );
	//this.attachMovie("bullet", "bullet"+gProjectiles, this.getNextHighestDepth(), {_x: (aOwner._x + (Math.cos( aOwner._rotation ) * aOffset[0])), _y: (aOwner._y + (Math.sin( aOwner._rotation ) * aOffset[1]))});
	this["bullet"+gProjectiles].variance = Math.random() * aVariance;
	this["bullet"+gProjectiles].owner = aOwner;
	this["bullet"+gProjectiles].damage_type = aDevice;
	this["bullet"+gProjectiles].damage = aDamage;
	this["bullet"+gProjectiles].classname = "bullet";
	this["bullet"+gProjectiles].speed = aSpeed;
	if( aFuckWithOrigin )
	{
		this["bullet"+gProjectiles]._x = aOwner._x + (Math.cos( ang ) * ((aOwner._x/Stage.width) - aOffset[0] + Math.random() * 10) - Math.sin( ang ) * ((aOwner._y/Stage.height) - aOffset[1] + Math.random() * 10));
		this["bullet"+gProjectiles]._y = aOwner._y + (Math.sin( ang ) * ((aOwner._x/Stage.width) - aOffset[0] + Math.random() * 10) + Math.cos( ang ) * ((aOwner._y/Stage.height) - aOffset[1] + Math.random() * 10));
	}
	else
	{
		this["bullet"+gProjectiles]._x = aOwner._x + (Math.cos( ang ) * ((aOwner._x/Stage.width) - aOffset[0]) - Math.sin( ang ) * ((aOwner._y/Stage.height) - aOffset[1]));
		this["bullet"+gProjectiles]._y = aOwner._y + (Math.sin( ang ) * ((aOwner._x/Stage.width) - aOffset[0]) + Math.cos( ang ) * ((aOwner._y/Stage.height) - aOffset[1]));
	}
	this["bullet"+gProjectiles]._rotation = ((aOwner._rotation + aOffsetDegrees) - aVariance * 25) * 0.017453292519943295769236907684886;
	this["bullet"+gProjectiles].onEnterFrame = BulletCallback;
	gProjectiles++;
	return this["bullet"+gProjectiles];
}

/*var shootSpread = function( aCount, aOwner, aOffset, aOffsetDegrees, aSpeed, aVariance, aDevice, aDamage, aType )
{
	var i;
	if( aType == gSpreadType_none )
	{
		for( i = 0; i < aCount; i++ )
		{
			shootBullet( aOwner, aOffset, (i + aOffsetDegrees) + step, aSpeed, aVariance, aDevice, aDamage );
		}
	}
	else if( aType == gSpreadType_sin )
	{
		for( i = 0; i < aCount; i++ )
		{
			shootBullet( aOwner, aOffset, i + (aOffsetDegrees * Math.sin( getTime() )), aSpeed, aVariance, aDevice, aDamage );
		}
	}
}*/

var messageCallback = function()
{
	this._alpha -= this.lifetick;
	if( this._alpha <= 0 )
	{
		var i;
		for( i=0; i <= gMessages; i++ )
			new Tween( this["deathmc"+gMessages], "_y", Strong.easeOut, this["deathmc"+gMessages]._y, this["deathmc"+gMessages]._y-25, 45, false); // Id liek to make it mathematical instead of hardcoded
		this.removeMovieClip();
	}
}

var broadcastDeath = function( aAttacker, aVictim, aInflictionDevice )
{
	//JF: Did some house keeping here.
	if( gMessages >= gMaxMessages )
		gMessages = 0; 
	
	//trace("bcDeath: aAttacker = " + aAttacker + ", aVictim = " + aVictim + ", aInflictionDevice = " + aInflictionDevice);
	//Create a pretty text field for it.
	this.createEmptyMovieClip("deathmc"+gMessages, gDepthOffset_Messages + gMessages);
	deathmcRef = this["deathmc"+gMessages];
	deathmcRef.onEnterFrame = messageCallback;
	deathmcRef._x = 452;		// KH +UI Update, 
	deathmcRef._y = gMessages * 25;
	deathmcRef.lifetick = 1;
	deathmcRef.cacheAsBitmap = true;
	
	deathmcRef.createTextField("deathM"+gMessages, -5000, 0, 0, 450, 25 );
	textRef = this["deathmc"+gMessages]["deathM"+gMessages];
	textRef.selectable = false;
	textRef.autoSize = true;
	textRef.html = true;
	gMessages++;
	
	//Create a message
	var msg;
	if( aInflictionDevice == gInflictiondevice_blade )
		msg = gDeathStrings_blade[Math.ceil(Math.random()*gDeathStrings_blade.length)-1];
	else if( aInflictionDevice == gInflictiondevice_pistol )
		msg = gDeathStrings_pistol[Math.ceil(Math.random()*gDeathStrings_pistol.length)-1];
	else if( aInflictionDevice == gInflictiondevice_machinegun )
		msg = gDeathStrings_machinegun[Math.ceil(Math.random()*gDeathStrings_machinegun.length)-1];
	else if( aInflictionDevice == gInflictiondevice_shotgun )
		msg = gDeathStrings_shotgun[Math.ceil(Math.random()*gDeathStrings_shotgun.length)-1];
	else if( aInflictionDevice == gInflictiondevice_grenade )
		msg = gDeathStrings_grenade[Math.ceil(Math.random()*gInflictiondevice_grenade.length)-1];
	else if( aInflictionDevice == gInflictiondevice_world )
		msg = gDeathStrings_world[Math.ceil(Math.random()*gInflictiondevice_world.length)-1];
		
	textRef.htmlText = "<b><font color=\"#FFFFFF\">"+msg+"</font></b>";
	var strip = function(symbol, target)
	{
		var replace = msg.indexOf ( symbol );
		if(replace > -1)
		{
			textRef.replaceText( replace, replace+symbol.length, target);
			msg = textRef.text;
		}
	}
	strip("@v", aVictim);
	strip("@a", aAttacker);
	
	return deathmcRef;
}

var painToAllThingsMortal = function( aAttacker, aVictim, aInflictionDevice, aDamage )
{
	if( aVictim == aAttacker && aInflictionDevice != gInflictiondevice_grenade )
		return;
		
	if( !(aVictim.immunities & aInflictionDevice) )
	{
		var damage_dealt = aDamage;
		if( aVictim.armor > 0 )
		{
			damage_dealt = Math.ceil( aDamage * 0.8 );
			aVictim.health -= damage_dealt;
			aVictim.armor -= aDamage - damage_dealt;
			if( aVictim.armor < 0 )
				aVictim.armor = 0;
		}
		else
		{
			aVictim.health -= damage_dealt;
		}
		
		if( aVictim.health <= 0 ) {
			//trace("aAttacker = " + aAttacker.aname + ", aVictim = " + aVictim.aname + ", aInflictionDevice = " + aInflictionDevice);
			broadcastDeath(aAttacker.aname, aVictim.aname, aInflictionDevice );
		}
		
		aVictim.lastStun = getTimer();
		//trace( "Fucked " + aVictim.aname + " out of " + damage_dealt + " hp." );
	}
}

//
//MAJOR TO DO
//GET EVERYTHING BELOW HERE UP TO SPEED.
//
var PowerUpCallback = function()
{
	if( this.hitTest( this.dood ) )
	{
		switch( aType )
		{
			default:
			case 0:
				this.dood.health += 15;	//Small health
				break;
			case 1:
				this.dood.armor += 1;	//Armor shard
				break;
			case 2:
				this.dood.stamina += 20;	//Small stamina recovery
				break;
			case 3:
				this.dood.health += 25;	//Large health
				break;
			case 4:
				this.dood.armor += 25;	//Small armor
				break;
			case 5:
				this.dood.maxstamina += 30;	//Large stamina recovery
				break;
			case 6:
				this.dood.armor += 50;	//Large armor
				break;
		}
		gEntities--;
		this.removeMovieClip();
	}
}

var createPowerUp = function( aX, aY, aType )
{
	switch( aType )
	{
		default:
		case 0:
			this.attachMovie( "healthup", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;
		case 1:
			this.attachMovie( "armorup", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;
		case 2:
			this.attachMovie( "staminaup", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;			
		case 3:
			this.attachMovie( "healthup_large", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;
		case 4:
			this.attachMovie( "armorup_small", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;
		case 5:
			this.attachMovie( "staminaup_large", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;
		case 6:
			this.attachMovie( "armorup_big", "ent"+gEntities, gDepthOffset_Entities + gEntities );
			break;
	}
	this["ent"+gEntities]._x = aX;
	this["ent"+gEntities]._y = aY;
	this["ent"+gEntities].atype = aType;
	this["ent"+gEntities].onEnterFrame = PowerUpCallback;
	gEntities++;
	return newPowerup;
}




// KH: Fun Incrementing Score Counter


_global.fcounterText = new TextFormat();
fcounterText.size	= 20;
fcounterText.color	= 0xFFFFFF;

_global.fmulti = new TextFormat();
fmulti.size			= 33;
fmulti.color		= 0xFFFFFF;
fmulti.italic		= false;
fmulti.bold			= false;
fmulti.underline	= false;



var createCounter = function() {
	this.createTextField("counter", 23000, Stage.width-125, 572, 250, 45);
	_global.counterRef 		= this.counter;
	counterRef.autoSize		= true;
	counterRef.selectable 	= false;
	counterRef.text 		= _global.currentScore.toString();
	counterRef.setTextFormat(fcounterText);
	
	this.createTextField("multiIndicator", 25000, 584, 560, 40, 41);
	_global.multiRef 	= this.multiIndicator;
	multiRef.autoSize	= true;
	multiRef.selectable	= false;
	multiRef.text 		= "1x";
	multiRef.setTextFormat(fmulti);
	
	counterRef.cacheAsBitmap = true;
	multiRef.cacheAsBitmap = true;
}
var updateCounter = function() {
	if(currentScore < totalScore) {
		currentScore += (Math.ceil(Math.random()*150));
		_global.counterRef.text = currentScore.toString();
		counterRef.setTextFormat(fcounterText);
	} else if(currentScore >= totalScore) {
		currentScore = totalScore;
		_global.counterRef.text = currentScore.toString();
		counterRef.setTextFormat(fcounterText);
	}
	//updateIndicators();
	if(multiKillCount <= multiKillT1) {
		multiScore = 1;
		_global.multiRef.text = "2x";
		multiRef.setTextFormat(fmulti);
		fcounterText.color = 0xFFFFFF;
	} else if(multiKillCount <= multiKillT2) {
		multiScore = 2;
		_global.multiRef.text = "3x";
		fmulti.italic = true;
		fmulti.color = 0xFF0000;
		multiRef.setTextFormat(fmulti);
	} else if(multiKillCount <= multiKillT3) {
		multiScore = 3;
		_global.multiRef.text = "4x";
		multiRef.setTextFormat(fmulti);
	} else if(multiKillCount <= multiKillT4) {
		multiScore = 4;
		_global.multiRef.text = "5x";
		multiRef.setTextFormat(fmulti);
	} else if(multiKillCount <= multiKillT5) {
		multiScore = 5;
		_global.multiRef.text = "6x";
		multiRef.setTextFormat(fmulti);
	} else if(multiKillCount <= multiKillT6) {
		multiScore = 10;
		_global.multiRef.text = "10x";
		multiRef.setTextFormat(fmulti);
		Dementia();
	}
}

createCounter();

var updateID = setInterval(this, "updateCounter", 10);

var Dementia = function() {
	trace("Dementia Mode Unlocked");
}

var scoreJump = function()
{
	var tListener:Object = new Object();
	this._alpha -= this.stationary;
	thisRef = this;
	var scoreJumpT:Tween;
	if(this._x >= 630 && this._y >= 556) {
		this.removeMovieClip();
	}
	scoreJumpT.onMotionFinished = function() 
	{
		thisRef.removeMovieClip();
	}
	if( this._alpha <= 0 )
	{
		if(this.isMoving == false) {
			this.isMoving = true;
			var scoreJumpT:Tween = new Tween(this, "_y", Strong.easeOut, this._y, 560, 45, false); // Id liek to make it mathematical instead of hardcoded
			new Tween(this, "_x", Strong.easeOut, this._x, 634, 45, false);
			scoreJumpT.onMotionFinished = function() {
				//trace("Remove");
				thisRef.removeMovieClip();
			}
		}
	}
}

var scoreJumper = function(jScore,jX,jY) {
	this.createEmptyMovieClip("sjmc"+scoreJumpID, gDepthOffset_Messages + scoreJumpID);
	sjmcRef = this["sjmc"+scoreJumpID];
	sjmcRef._x = jX;
	sjmcRef._y = jY;
	sjmcRef.onEnterFrame = scoreJump;
	sjmcRef.stationary = 2;
	sjmcRef.isMoving = false;
	sjmcRef.cacheAsBitmap = true;
	
	sjmcRef.createTextField("sj"+scoreJumpID, this.getNextHighestDepth(), 0, 0, 20, 20);
	sjRef = this["sjmc"+scoreJumpID]["sj"+scoreJumpID];
	sjRef.autoSize = true;
	sjRef.selectable = false;
	sjRef.text = "+"+jScore+"!";
	sjRef.setTextFormat(fcounterText);
	
	
	scoreJumpID++;
	
	return sjmcRef;
}


