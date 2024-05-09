//VERSION 6, "unidentifiable liquid"
onClipEvent (load)
{
	var aname = "Player";
	var maxhealth = 100
	var health = 100;
	var maxarmor = 100;
	var armor = 100;
	var maxspeed = 4;
	var maxstamina = 1;
	var stamina = 1;
	var staminadec = 0.05;
	var staminarec = 0.1;
	var immunities = 0;
	var accel = 2;
	var currentspeed_x = 0;
	var currentspeed_y = 0;
	var olddir_x = -1; // 0 = left, 1 = right
	var olddir_y = -1; // 0 = up, 1 = down
	var boost_scale = 0.2;
	var epsilon = 1;
	var friction = 0.3;
	var delta = friction * accel;
	
	this.gotoAndStop(2);
}
onClipEvent (enterFrame)
{
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
	if( Key.isDown( Key.LEFT ) )
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
	if( Key.isDown( Key.RIGHT ) )
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
	if( Key.isDown( Key.UP ) )
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
	if( Key.isDown( Key.DOWN ) )
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
	if( !Key.isDown( Key.LEFT ) && !Key.isDown( Key.RIGHT ) )
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
	if( !Key.isDown( Key.UP ) && !Key.isDown( Key.DOWN ) )
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
onClipEvent (enterFrame)
{
	// rotation code, eventually
}
