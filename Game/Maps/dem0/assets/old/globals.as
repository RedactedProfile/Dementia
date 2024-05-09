
// VERSION 6
_global.createActor = function( aMaxHealth, aHealth, aMaxArmor, aArmor, aMaxStamina, aStamina, aImmunities )
{
	var newActor = _parent.attachMovie( "npc", _root.getNextHighestDepth() );
	newActor.aname = gActorNames[Math.floor(Math.random()*gActorNames.length)-1];
	newActor.maxhealth = aMaxHealth;
	newActor.health = aHealth;
	newActor.maxarmor = aMaxArmor;
	newActor.armor = aArmor;
	newActor.maxstamina = aMaxStamina;
	newActor.stamina = aStamina;
	newActor.immunities = aImmunities;
	gActors.push( newActor );
	return newActor;
}

_global.BulletCallback = function()
{
	if( this._x > Stage.width || this._x < 0 || this._y > Stage.height || this._y < 0 )
		this.removeMovieClip();
		
	this._x += this.variance + Math.cos( this._rotation ) * this.speed;
	this._x -= this.variance + Math.sin( this._rotation ) * this.speed;
}
_global.shootBullet = function( aOwner, aOffset, aOffsetDegrees, aSpeed, aVariance, aDevice )
{
	if( gProjectiles >= gMaxProjectiles )
		//There comes a time in a man's life when he needs to clean up after himself.
		gProjectiles = 0;
	var newBullet = _parent.attachMovie( "bullet", gDepthOffset_Projectiles + gProjectiles );
	newBullet.variance = Math.random() * aVariance;
	newBullet.owner = aOwner;
	newBullet.damage_type = aDevice;
	newBullet._x = aOwner._x + (Math.cos( aOwner._rotation ) * aOffset[0]);		//LOL ROTATE ME ABOUT ORIGIN.
	newBullet._y = aOwner._y + (Math.sin( aOwner._rotation ) * aOffset[1]);
	newBullet._rotation = aOwner._rotation + aOffsetDegrees;
	newBullet.onEnterFrame = BulletCallback();
	return newBullet;
}
_global.shootSpread = function( aCount, aOwner, aOffset, aOffsetDegrees, aSpeed, aDevice )
{
	var i;
	for( i = 0; i < aCount; i++ )
	{
		shootBullet( aOwner, aOffset, i + aOffsetDegrees, aSpeed, aDevice );
	}
}

_global.painToAllThingsMortal = function(aAattacker, aVictim, aInflictionDevice, aDamage )
{
	var armor_proc = 0.8;
	if( victim.immunities & aInflictionDevice )
	{
		var damage_dealt = Math.ceil( aDamage * armor_proc );
		if( victim.armor > 0 )
		{
			victim.health -= damage_dealt;
			victim.armor -= aDamage - damage_dealt;
			if( victim.armor < 0 )
				victim.armor = 0;
		}
		else
		{
			victim.health -= aDamage;
		}
		
		if( victim.health < 0 )
			broadcastDeath( aAttacker, aVictim, aInflictionDevice );
	}
}

_global.createExplosion = function( aOwner, aX, aY )
{
	var i;
	var explosion = _parent.attachMovie( "explodeme", gDepthOffset_Projectiles + gProjectiles );
	explosion._x = aX;
	explosion._y = aY;
	for( i = 0; i < gActors.length; i++ )
	{
		if( explosion.hitTest( gActors[i] ) ) {
			painToAllThingsMortal( aOwner, gActors[i], gInflictiondevice_grenade, 90 );
		}
	}
}


/*
//VERSION 5.5, "Flipper dies"
_global.gMaxenemies = 5;
_global.gMaxMessages = 5;
_global.gMessages = 0;
_global.gMaxProjectiles = 3000;
_global.gProjectiles = 0;
_global.gMaxParticles = 1000;
_global.gParticles = 0;
_global.gActors = new Array();	//List of actors
_global.gProps = new Array();	//List Things like pillars or crates.

_global.gInflictiondevice_blade = (1<<0);
_global.gInflictiondevice_pistol = (1<<1);
_global.gInflictiondevice_machinegun = (1<<2);
_global.gInflictiondevice_shotgun = (1<<3);
_global.gInflictiondevice_grenade = (1<<4);

_global.gDepthOffset_Messages = 0;
_global.gDepthOffset_Entities = 5;
_global.gDepthOffset_Projectiles = 100;
_global.gDepthOffset_Particles = 5000;
_global.gDepthOffset_Hud = 9998;
_global.gDepthOffset_Cursor = 9999;

_global.gVariance_none = 0;
_global.gVariance_small = 0.001;
_global.gVariance_medium = 0.01;
_global.gVariance_large = 0.1;

_global.gActorNames = [
	"Alex",
	"Clint",
	"Lonnie",
	"Josh",
	"Joey",
	"Kyle",
	"Tyler",
	"Kunaal",
	"Bill",
	"Ted",
	"Frank",
	"Justin",
	"Ryan",
	"Joseph",
	"Diddy",
	"Oliver",
	"Austin",
	"Hans",
	"Steve",
	"Jackson",
	"Johnson",
	"Gabe",
	"Noel",
	"Sean",
	"<I'm Cool> Dean",
	"leet d00d",
	"omg hax",
	"ps3 sux",
	"how play gaem?",
	"Ben",
	"Beefy",
	"Hai I use internets",
	"lax",
	"I <3 pen0rz",
	"Arrogant Weeaboo"
];

_global.gDeathStrings_blade = [
	"%v got too close to %a.",
	"%v should have probably reconsidered rush tactics.",
	"%a showed %v what makes him tick."
];

_global.gDeathStrings_pistol = [
	"%v just got pistOwned by %a",
	"%a killed %v"
];

_global.gDeathStrings_machinegun = [
	"%v said hello to %a's little friend"
];

_global.gDeathStrings_shotgun = [
	"%v was perforated by %a's shotgun",
	"%v has become an air-conditioner by %a",
	"%a just murdered %v with straight prejudice"
];

_global.gDeathStrings_grenade = [
	"%v sucked on %a's grenades",
	"%v didn't have the stones to run away",
	"%a blowed up %v"
];

var createActor = function( aMaxHealth, aHealth, aMaxArmor, aArmor, aMaxStamina, aStamina, aImmunities )
{
	var newActor = _parent.attachMovie( "npc", _root.getNextHighestDepth() );
	newActor.aname = gActorNames[Math.floor(Math.random()*gActorNames.length)-1];
	newActor.maxhealth = aMaxHealth;
	newActor.health = aHealth;
	newActor.maxarmor = aMaxArmor;
	newActor.armor = aArmor;
	newActor.maxstamina = aMaxStamina;
	newActor.stamina = aStamina;
	newActor.immunities = aImmunities;
	gActors.push( newActor );
	return newActor;
}

var BulletCallback = function()
{
	if( this._x > Stage.width || this._x < 0 || this._y > Stage.height || this._y < 0 )
		this.removeMovieClip();
		
	this._x += this.variance + Math.cos( this._rotation ) * this.speed;
	this._x -= this.variance + Math.sin( this._rotation ) * this.speed;
}
var shootBullet = function( aOwner, aOffset, aOffsetDegrees, aSpeed, aVariance, aDevice )
{
	if( gProjectiles >= gMaxProjectiles )
		//There comes a time in a man's life when he needs to clean up after himself.
		gProjectiles = 0;
	var newBullet = _parent.attachMovie( "bullet", gDepthOffset_Projectiles + gProjectiles );
	newBullet.variance = Math.random() * aVariance;
	newBullet.owner = aOwner;
	newBullet.damage_type = aDevice;
	newBullet._x = aOwner._x + (Math.cos( aOwner._rotation ) * aOffset[0]);		//LOL ROTATE ME ABOUT ORIGIN.
	newBullet._y = aOwner._y + (Math.sin( aOwner._rotation ) * aOffset[1]);
	newBullet._rotation = aOwner._rotation + aOffsetDegrees;
	newBullet.onEnterFrame = BulletCallback();
	return newBullet;
}
var shootSpread = function( aCount, aOwner, aOffset, aOffsetDegrees, aSpeed, aDevice )
{
	var i;
	for( i = 0; i < aCount; i++ )
	{
		shootBullet( aOwner, aOffset, i + aOffsetDegrees, aSpeed, aDevice );
	}
}
var messageCallback = function()
{
	this._alpha -= this.lifetick;
	if( this._alpha <= 0 )
	{
		gMessages--;
		this.removeMovieClip();
	}
}

var broadcastDeath = function( aAttacker, aVictim, aInflictionDevice )
{
	if( gMessages >= gMaxMessages )
		return "no dice";
	//Create a pretty text field for it.
	this.createTextField( "messagemeplz"+gMessages, gMessages );
	newTextField.selectable = false;
	newTextField.align = "R";
	newTextField._x = Stage.width;
	newTextField._y = gMessages + 15;
	this["messagemeplz"+gMessages].selectable = false;
	this["messagemeplz"+gMessages].align="R";
	this["messagemeplz"+gMessages].border=true;
	this["messagemeplz"+gMessages]._x = 10;
	this["messagemeplz"+gMessages]._y = 0;
	this["messagemeplz"+gMessages]._width = 450;
	this["messagemeplz"+gMessages]._height = 300;
	
	//Create a message
	if( aInflictionDevice == gInflictiondevice_blade )
		newTextField.text = gDeathStrings_blade[Math.floor(Math.random()*gDeathStrings_blade.length)-1];
	else if( aInflictionDevice == gInflictiondevice_pistol )
		newTextField.text = gDeathStrings_pistol[Math.floor(Math.random()*gDeathStrings_blade.length)-1];
	else if( aInflictionDevice == gInflictiondevice_machinegun )
		newTextField.text = gDeathStrings_machinegun[Math.floor(Math.random()*gDeathStrings_blade.length)-1];
	else if( aInflictionDevice == gInflictiondevice_shotgun )
		newTextField.text = gDeathStrings_shotgun[Math.floor(Math.random()*gDeathStrings_blade.length)-1];
	else if( aInflictionDevice == gInflictiondevice_grenade )
		newTextField.text = gDeathStrings_grenade[Math.floor(Math.random()*gDeathStrings_blade.length)-1];
	
	var victim = message.indexOf( "%v" );
	newTextField.replaceText( victim, 2, aVictim.aname );
	var attacker = message.indexOf( "%a" );
	newTextField.replaceText( victim, 2, aAttacker.aname );
	
	//Finish up
	newTextField.lifetick = 3;
	newTextField.onEnterFrame = messageCallback;
	gMessages++;
	return newTextField;
}

var painToAllThingsMortal = function( aAattacker, aVictim, aInflictionDevice, aDamage )
{
	var armor_proc = 0.8;
	if( victim.immunities & aInflictionDevice )
	{
		var damage_dealt = Math.ceil( aDamage * armor_proc );
		if( victim.armor > 0 )
		{
			victim.health -= damage_dealt;
			victim.armor -= aDamage - damage_dealt;
			if( victim.armor < 0 )
				victim.armor = 0;
		}
		else
		{
			victim.health -= aDamage;
		}
		
		if( victim.health < 0 )
			broadcastDeath( aAttacker, aVictim, aInflictionDevice );
	}
}
*/
