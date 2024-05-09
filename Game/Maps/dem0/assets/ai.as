//VERSION 8 "Farfor Edition"
_global.dudeRef = _root.cContainer.dude;
var ai_move = function( aWho, aX, aY )
{
	var angle = Math.atan2( -(aY - aWho._y), aX - aWho._x );
	var angle_delta = angle - aWho.oldangle;
	
	//Temp stun hack
	if( getTimer() - aWho.lastStun < aWho.recoverTime )
		return;
	
	//Oh man..
	if( angle_delta > 0 )
		aWho.speed_angle += (aWho.friction + aWho.friction_mod) * (aWho.accel + aWho.accel_mod);
	else
		aWho.speed_angle -= (aWho.friction + aWho.friction_mod) * (aWho.accel + aWho.accel_mod);
	
	angle += 0.001 * aWho.speed_angle;
	
	if( Math.abs(getTimer() - aWho.lastupdate) > aWho.rxn_time )
	{
		aWho.oldangle = angle;
		aWho.lastupdate = getTimer() + aWho.rxn_time;
	}
	
	aWho._x += Math.cos( angle ) * aWho.maxspeed;
	aWho._y -= Math.sin( angle ) * aWho.maxspeed;
	aWho._rotation = -angle * 57.295779513082320876798154814105;
}

//Generic "on Death" function.
var ai_generic_death = function()
{
	delete _global.gActors[this.id];			//JF: Free up this slot
	newScore = 500*multiScore;					// KH: All for the cool scoring system
	_global.totalScore += 500*multiScore;
	_global.multiKillCount++;
	_global.rpgExp += 2;	// +UI Update
	scoreJumper(newScore, this._x, this._y);	// KH" The neato number effect
	this.removeMovieClip();
}

//=========================
// AI DURKA DURKA JIHAD
//=========================
var ai_durkadurkajihad_main = function()
{
	if( this.health < 0 )
	{
		createExplosion( this, 150, this._x, this._y );	
		this.onEnterFrame = ai_generic_death;
	}
	
	var delta_x = this._x - this.atarget._x;
	var delta_y = this._y - this.atarget._y;
	if( Math.sqrt( (delta_x * delta_x) + (delta_y * delta_y) ) > 75 )
	{
		ai_move( this, this.atarget._x, this.atarget._y);
	}
	else
	{
		createExplosion( this, 200, this._x, this._y );	
		this.onEnterFrame = ai_generic_death;	//JF: I think it's best to leave this here; you know, for safety.
	}
}

var ai_durkadurkajihad_init = function()
{
	//Initializes the Durka Durka Ai routine.
	this.atarget = dudeRef; //Player is prayer.
	this.accel = 2;
	this.accel_mod = 0;
	this.friction = 0.3;
	this.friction_mod = 0;
	this.boost_scale = 1.5;
	this.speed_x = 0;
	this.speed_y = 0;
	this.speed_angle = 0;
	this.maxspeed = 6;
	this.epsilon = 0.5;
	this.goal_x = 0;
	this.goal_y = 0;
	this.oldangle = 0;
	this.lastupdate = 0;
	this.rxn_scale = 0.5;
	this.rxn_time = 1000;
	this.lastStun = 0;
	this.recoverTime = 50;
	this.onEnterFrame = ai_durkadurkajihad_main;
}

//=========================
// AI ZOMBIE
//=========================
var ai_zombie_init = function()
{
	this.atarget = dudeRef; //Player is prayer.
	this.accel = 2;
	this.accel_mod = 0;
	this.friction = 0.3;
	this.friction_mod = 0;
	this.boost_scale = 1.5;
	this.speed_x = 0;
	this.speed_y = 0;
	this.speed_angle = 0;
	this.maxspeed = 3;
	this.epsilon = 0.5;
	this.goal_x = 0;
	this.goal_y = 0;
	this.oldangle = 0;
	this.lastupdate = 0;
	this.rxn_scale = 0.5;
	this.rxn_time = 1000;
	this.lastStun = 0;
	this.recoverTime = 200;
	this.onEnterFrame = ai_zombie_main;
}

var ai_zombie_main = function()
{
	if( this.health < 0 )
		this.onEnterFrame = ai_generic_death;
	
	//This causes the ai to run straight up the player, and attack relentlessly.
	var delta_x = this._x - this.atarget._x;
	var delta_y = this._y - this.atarget._y;
	if( Math.sqrt( delta_x * delta_x + delta_y * delta_y ) > 5 )
		ai_move( this, this.atarget._x, this.atarget._y );
	else
		painToAllThingsMortal( this, this.atarget, gInflictiondevice_blade, 30 );	//Should probably do an attack sequence instead, but...
}

//=========================
// AI SHOOTER
//=========================
var ai_shooter_init = function()
{
	this.atarget = dudeRef; //Player is prayer.
	this.accel = 2;
	this.accel_mod = 0;
	this.friction = 0.3;
	this.friction_mod = 0;
	this.boost_scale = 1.5;
	this.speed_x = 0;
	this.speed_y = 0;
	this.speed_angle = 0;
	this.maxspeed = 6;
	this.epsilon = 0.5;
	this.goal_x = 0;
	this.goal_y = 0;
	this.oldangle = 0;
	this.lastupdate = 0;
	this.rxn_scale = 0.5;
	this.rxn_time = 1000;
	this.ashootprob = Math.random() * 1;
}

var ai_shooter_main = function()
{
	//This ai tries to stay a little ways away from the player and shoots randomly.
	var delta_x = this._x - this.atarget._x;
	var delta_y = this._y - this.atarget._y;
	var distance = Math.sqrt( delta_x * delta_x + delta_y * delta_y );
	if( distance < 50 )
		ai_move( this, this.atarget._x, this.atarget._y );
	
	//Shoot at player, if the player gets closer, panic and shoot more often.
	if( Math.random() > this.ashootprob + (1/distance) )
	{
		//Face player and shoot.
		var offset = [0,0];
		this._rotation = Math.atan2( delta_y, delta_x ) * (180 / Math.PI);
		shootSpread( Math.ceil( Math.random() * 6 ), this, offset, (Math.random() * 3)+(distance*0.01), 5, gDepthOffset_Projectiles )
	}
}