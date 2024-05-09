//VERSION 8 "Farfor Edition"
onClipEvent (load)
{
	var aname = "THE Player";
	// Moved Health to Engine Globals.as
	var maxarmor = 100;
	var armor = 100;
	var maxspeed = 6;
	var maxstamina = 1;
	var stamina = 1;
	var staminadec = 0.05;
	var staminarec = 0.1;
	var immunities = 0;
	var accel = 2;
	var accel_mod = 0;
	var currentspeed_x = 0;
	var currentspeed_y = 0;
	var olddir_x = -1; // 0 = left, 1 = right
	var olddir_y = -1; // 0 = up, 1 = down
	var boost_scale = 0.25;
	var epsilon = 1;
	var friction = 0.3
	var friction_mod = 0;
	var classname = "player";
	var delta = (friction + friction_mod) * (accel + accel_mod);
	
	//Fun shooting things!
	var offset = [-15,10];
	var pistol_ammo = 100;
	var machinegun_ammo = 100;
	var shotgun_ammo = 100;
	var currentWeapon = 1;
	var mouseDown = false;
	var RoF = 300; //Rate of fire
	var lastShot = 0;
	
	//
	this.gotoAndPlay(3);
	this.swapDepths( 350 ); //JF: Ma-ma-ma monster hack k k k. In a perfect world, we'd spawn the player through code, not have him sitting in the fla.
	_global.gActors[0] = this;	//JF: Hack #2, for the same reasons as above 
}
onClipEvent( mouseDown )
{
	this.mouseDown = true;
}
onClipEvent( mouseUp )
{
	if( currentWeapon == 0 )
		lastShot = 0;	//Reset for and uzi
	else if( currentWeapon == 1 )
		lastShot -= RoF ;//* 0.1; //click for faster pistol
		
	this.mouseDown = false;
}
onClipEvent (enterFrame)
{
	if( mouseDown )
	{
		if( getTimer() - lastShot > RoF )
		{
			this.muzzleFlash.gotoAndPlay(2);
			if( currentWeapon == 3 )
			{
				for( i = 0; i <= 12; i++ )
				_global.gRef.shootBullet(this, offset, 5, 8, 1, _global.gInflictiondevice_bullet, 50, true);
				playSound("shotgunfire", 0, 0.50, 0, 0, false );
			}
			else if( currentWeapon == 2 )
			{
				_global.gRef.shootBullet(this, offset, 5, 20, _global.gVariance_medium, _global.gInflictiondevice_bullet, 10, false );
				playSound("uzifire", 0, 0.50, 0, 0, false );
			}
			else if( currentWeapon == 1 )
			{
				_global.gRef.shootBullet(this, offset, 5, 15, _global.gVariance_small, _global.gInflictiondevice_bullet, 30, false );
				playSound("pistolfire", 0, 0.50, 0, 0, false );
			}
			lastShot = getTimer() + RoF;
		}
	}
	if( Key.isDown( 49 ) )
	{
		if( pistol_ammo > 0 )
		{
			offset = [-15,5];
			currentWeapon = 1;
			RoF = 300;
			this.gotoAndStop( "pistol" );
		}
	}
	if( Key.isDown( 50 ) )
	{
		if( machinegun_ammo > 0 && _global.uziMod == 1)	// +UI Update
		{
			offset = [-15,10];
			currentWeapon = 2;
			RoF = 50;
			this.gotoAndStop( "uzi" );
		}
	}
	if( Key.isDown( 51 ) )
	{
		if( shotgun_ammo > 0 && _global.shotgunMod == 1)	// +UI Update
		{
			offset = [-20,5];
			currentWeapon = 3;
			RoF = 550;
			this.gotoAndStop( "shotgun" );
		}
	}	
		
	//Sprint!
	if( Key.isDown( Key.SHIFT ) && stamina >= 0 )
	{
		maxspeed = 7;
		stamina -= staminadec;
	}
	else
	{
		if( stamina <= maxstamina )
		{
			stamina += staminarec;
		}
		else
		{
			stamina = maxstamina;
		}
		maxspeed = 4;
	}

	//Left/Right
	if( Key.isDown( 65 ) )
	{
		if( olddir_x != 0 )
		{
			//apply a little boost
			currentspeed_x -= Math.abs(delta) * boost_scale;
		}
		else
		{
			currentspeed_x -= delta;
		}
		if( currentspeed_x <= -maxspeed )
		{
			currentspeed_x = -maxspeed;
		}
		olddir_x = 0;
	}
	if( Key.isDown( 68 ) )
	{
		if( olddir_x != 1 )
		{
			//apply a little boost
			currentspeed_x += Math.abs(delta) * boost_scale;
		}
		else
		{
			currentspeed_x += delta;
		}
		if( currentspeed_x >= maxspeed )
		{
			currentspeed_x = maxspeed;
		}
		olddir_x = 1;
	}

	//Up/Down
	if( Key.isDown( 87 ) )
	{
		if( olddir_y != 0 )
		{
			//apply a little boost
			currentspeed_y -= Math.abs(delta) * boost_scale;
		}
		else
		{
			currentspeed_y -= delta;
		}
		if( currentspeed_y <= -maxspeed )
		{
			currentspeed_y = -maxspeed;
		}
		olddir_y = 0;
	}
	if( Key.isDown(83 ) )
	{
		if( olddir_y != 1 )
		{
			//apply a little boost
			currentspeed_y += Math.abs(delta) * boost_scale;
		}
		else
		{
			currentspeed_y += delta;
		}
		if( currentspeed_y >= maxspeed )
		{
			currentspeed_y = maxspeed;
		}
		olddir_y = 1;
	}
	if( !Key.isDown( 65 ) && !Key.isDown( 68 ) )
	{
		//Decellerate X
		if( currentspeed_x < 0 )
		{
		    currentspeed_x += delta;
		}
		else
		{
			currentspeed_x -= delta;
		}
		if( Math.abs( currentspeed_x ) <= epsilon )
		{
		    currentspeed_x = 0;
			olddir_x = -1; //Let them boost again since we stopped.
		}
	}
	if( !Key.isDown( 87 ) && !Key.isDown( 83 ) )
	{
		//Decellerate Y
		if( currentspeed_y < 0 )
		{
		    currentspeed_y += delta;
		}
		else
		{
			currentspeed_y -= delta;
		}
		if( Math.abs( currentspeed_y ) <= epsilon )
		{
		    currentspeed_y = 0;
			olddir_y = -1; //Let them boost again since we stopped.
		}
	}
	
	this._x += currentspeed_x;
	this._y += currentspeed_y;
}