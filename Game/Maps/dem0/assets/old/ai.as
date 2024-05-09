//VERSION 6, "unidentifiable liquid"
_global.ai_move = function( aWho, aX, aY )
{
	//Straight forward move-to-target. no frills.
	var delta_x = aWho._x - aX;
	var delta_y = aWho._y - aY;
	var angle = Math.atan2( delta_y, delta_x ) * (180 / Math.PI);
	aWho._x += Math.cos( angle ) * aWho.speed;
	aWho._y -= Math.sin( angle ) * aWho.speed;
}

_global.ai_durkadurkajihad_init = function()
{
	this.atarget = this.dood; //Should always be player.
}

_global.ai_durkadurkajihad_main = function()
{
	//This causes the ai to run straight up the player, and within range, explode.
	var delta_x = this._x - this.atarget._x;
	var delta_y = this._y - this.atarget._y;
	if( Math.sqrt( delta_x * delta_x + delta_y * delta_y ) > 10 )
		ai_move( this, this.atarget._x, this.atarget._y );
	else
		createExplosion( this, this._x, this._y );
}

_global.ai_zombie_init = function()
{
	this.atarget = this.dood; //Should always be player.
}

_global.ai_zombie_main = function()
{
	//This causes the ai to run straight up the player, and attack relentlessly.
	var delta_x = this._x - this.atarget._x;
	var delta_y = this._y - this.atarget._y;
	if( Math.sqrt( delta_x * delta_x + delta_y * delta_y ) > 5 )
		ai_move( this, this.atarget._x, this.atarget._y );
	else
		painToAllThingsMortal( this, this.atarget, gInflictiondevice_blade, 30 );	//Should probably do an attack sequence instead, but...
}

_global.ai_shooter_init = function()
{
	this.atarget = this.dood; //Should always be player.
	this.ashootprob = Math.random() * 1;
}

_global.ai_shooter_main = function()
{
	//This ai tries to stay a little ways away from the player and shoots randomly.
	var delta_x = this._x - this.atarget._x;
	var delta_y = this._y - this.atarget._y;
	var distance = Math.sqrt( delta_x * delta_x + delta_y * delta_y )
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