// Create our Audio Channels
this.createEmptyMovieClip("musicContainer", 99999999999999999999 );
//this.createEmptyMovieClip("sndSoundFX", this.getNextHighestDepth());
//this.createEmptyMovieClip("sndVox", this.getNextHighestDepth());
//_global.musicPlay = new Sound(musicContainer);
//_global.soundFX = new Sound(sndSoundFX);

//New line of sound channels.
_global.snd_player = new Sound();
_global.snd_player.x = 0;
_global.snd_player.y = 0;
_global.snd_player.stats = 0;

_global.snd_npc1 = new Sound();
_global.snd_npc1.x = 0;
_global.snd_npc1.y = 0;
_global.snd_npc1.stats = 0;

_global.snd_npc2 = new Sound();
_global.snd_npc2.x = 0;
_global.snd_npc2.y = 0;
_global.snd_npc2.stats = 0;

_global.snd_npc3 = new Sound();
_global.snd_npc3.x = 0;
_global.snd_npc3.y = 0;
_global.snd_npc3.stats = 0;

_global.snd_npc4 = new Sound();
_global.snd_npc4.x = 0;
_global.snd_npc4.y = 0;
_global.snd_npc4.stats = 0;

_global.snd_npc5 = new Sound();
_global.snd_npc5.x = 0;
_global.snd_npc5.y = 0;
_global.snd_npc5.stats = 0;

_global.snd_world = new Sound();
_global.snd_world.x = 0;
_global.snd_world.y = 0;
_global.snd_world.stats = 0;

_global.snd_music = new Sound();

//Constants identifiers
_global.chan_player = 0;
_global.chan_npc1 = 1;
_global.chan_npc2 = 2;
_global.chan_npc3 = 3;
_global.chan_npc4 = 4;
_global.chan_npc5 = 5;
_global.chan_world = 6;
_global.chan_music = 7;
_global.gSndStatus_Dead = 0;
_global.gSndStatus_Alive = 1;

//Fun things
_global.gMaster_Volume = 100;
_global.gListener = _root;
_global.gListener_eardist = 5;


//Plays a sound on a channel at the given position
_global.playSound = function ( bSnd, aChannel, aVolume, aX, aY, aLoop ) {
	
	aSnd = soundDir + bSnd + soundExt;
	//log(aSnd);
	
	//Figure out what channel we're using
	var channel;
	switch( aChannel )
	{
	default:
	case 0:
		channel = _global.snd_player;
		break;
	case 1:
		channel = _global.snd_npc1;
		break;
	case 2:
		channel = _global.snd_npc2;
		break;
	case 3:
		channel = _global.snd_npc3;
		break;
	case 4:
		channel = _global.snd_npc4;
		break;
	case 5:
		channel = _global.snd_npc5;
		break;
	case 6:
		channel = _global.snd_world;
		break;
	case 7:
		aSnd = musicDir + bSnd + soundExt;
		channel = _global.snd_music;
		break;
	}
		
	channel.onLoad = function(success:Boolean)
	{
		if(success) 
		{
			//log("Playing sound: " + aSnd);
			if( aLoop )
			{
				channel.onSoundComplete = function()
				{
					channel.start();
				};
			}
			channel.setVolume( _global.gMaster_Volume * aVolume );
			channel.start();
		}
		else 
		{
			log("Could not play: " + aSnd + ", there was an issue loading.");
			return;
		}
	}
	channel.loadSound( aSnd, true );
	channel.x = aX;	//For Positional Audio
	channel.y = aY;	//For Positional Audio
	channel.stats = gSndStatus_Alive;
}

//Stops a sound playing on a channel
var stopSound = function( aChannel )
{
	var channel;
	switch( aChannel )
	{
	default:
	case 0:
		channel = _global.snd_player;
		break;
	case 1:
		channel = _global.snd_npc1;
		break;
	case 2:
		channel = _global.snd_npc2;
		break;
	case 3:
		channel = _global.snd_npc3;
		break;
	case 4:
		channel = _global.snd_npc4;
		break;
	case 5:
		channel = _global.snd_npc5;
		break;
	case 6:
		channel = _global.snd_world;
		break;
	case 7:
		channel = _global.snd_music;
		break;
	}
	channel.stop();
	channel.stats = gSndStatus_Dead;
}

//Updates positional stats
var updateChannel = function( aChannel, aX, aY )
{
	var channel;
	switch( aChannel )
	{
	default:
	case 0:
		channel = _global.snd_player;
		break;
	case 1:
		channel = _global.snd_npc1;
		break;
	case 2:
		channel = _global.snd_npc2;
		break;
	case 3:
		channel = _global.snd_npc3;
		break;
	case 4:
		channel = _global.snd_npc4;
		break;
	case 5:
		channel = _global.snd_npc5;
		break;
	case 6:
		channel = _global.snd_world;
		break;
	case 7:
		channel = _global.snd_music;
		break;
	}
	channel.x = aX;
	channel.y = aY;
}

var adjustVolume = function ( aChannel, aVol ) 	// KH +UI Update
{
	var channel;
	switch( aChannel )
	{
	default:
	case 0:
		channel = _global.snd_player;
		break;
	case 1:
		channel = _global.snd_npc1;
		break;
	case 2:
		channel = _global.snd_npc2;
		break;
	case 3:
		channel = _global.snd_npc3;
		break;
	case 4:
		channel = _global.snd_npc4;
		break;
	case 5:
		channel = _global.snd_npc5;
		break;
	case 6:
		channel = _global.snd_world;
		break;
	case 7:
		channel = _global.snd_music;
		break;
	}
	
	channel.setVolume(aVol);
}

var renderPositionalAudio = function( aDistScale )
{
	var i;
	var channel;
	for( i = 0; i < 6; i++ )
	{
		//lol. Hi again.
		switch( i )
		{
		default:
		case 0:
			channel = _global.snd_player;
			break;
		case 1:
			channel = _global.snd_npc1;
			break;
		case 2:
			channel = _global.snd_npc2;
			break;
		case 3:
			channel = _global.snd_npc3;
			break;
		case 4:
			channel = _global.snd_npc4;
			break;
		case 5:
			channel = _global.snd_npc5;
			break;
		case 6:
			channel = _global.snd_world;
			break;
		}
		
		//Don't do anything for dead channels
		if( channel.stats == gSndStatus_Dead )
			continue;
			
		//Set volume
		var distx = (gListener._x - channel.x) / Stage.width;
		var disty = (gListener._y - channel.y) / Stage.height;
		var fuckme = Math.abs( Math.sqrt( (distx * distx) + (disty * disty) ) ); //Mmm... delicious square root.
		channel.setVolume( gMaster_Volume * (1 - fuckme)  );
		
		//Set transform
		var pan = 100 * ((channel.x/Stage.width) * (gListener._x/Stage.width) + (channel.y/Stage.height) * (gListener._y/Stage.height) );
		var transform = new Object();
		transform.ll = 100 - pan;	//Here
		transform.lr = 0;	//Not here
		transform.rr = 0;	//Nor here
		transform.rl = 100 - transform.ll;	//And Here
		trace( transform.ll );
		trace( transform.rl );
		channel.setTransform( transform );
	}
}

log("Sound Functions Initialized and ready to go...");