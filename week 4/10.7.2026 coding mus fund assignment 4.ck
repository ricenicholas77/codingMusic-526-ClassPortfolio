//sequencer
Gain master => dac;
SndBuf kick => master;
SndBuf hihat => master;
SndBuf snare => master;
SinOsc s => SinOsc m1 => Pan2 p1 => master;
SqrOsc sq => SinOsc m2 => master;
SndBuf2 fx => Delay d => Pan2 p2 => master;
d => master => d;


[44, 46, 47, 49, 51, 53, 54, 56] @=> int notes[]; //80, 70, 80, 70, 77, 75, 73, 75 68 71
.6 => master.gain; //sets the volume of whole piece

//load filesinto sndbuf
me.dir() + "/audio/audio/kick_01.wav" => kick.read;
me.dir() + "/audio/audio/hihat_01.wav" => hihat.read;
me.dir() + "/audio/audio/snare_01.wav" => snare.read;
me.dir() + "/audio/audio/stereo_fx_01.wav" => fx.read;

// set all playheads to end so no sound is made
kick.samples() => kick.pos;
hihat.samples() => hihat.pos;
snare.samples() => snare.pos;
fx.samples() => fx.pos;
.7 => d.gain;


// initialize counter variable


for(0 => int t; t < 5; t++)
{
    Std.mtof((notes[7]-48) * .3847) => m1.freq;
    Std.mtof((notes[7]- 48) * 1.2760) => m2.freq;
    <<<Std.mtof((notes[t]- 48) * 1.2760)>>>;
    <<<Std.mtof((notes[t]- 48) * .3847)>>>;
    1.8 => s.gain;
    1.7 => sq.gain;
    20 => m1.gain;
    15 => m2.gain;
    2 => s.sync;
    2=> sq.sync;
    0 => int counter;
    for(0 => int i; i < 48; i++)
    {
        
        30::second => d.max;
        // beat goes from 0 to 7 (8 positions)
        counter %  12=> int beat;
        Math.random2f(-1.0, 1.0) => p1.pan;
        Math.random2f(-1.0, 1.0) => p2.pan;
        // bass drum on 0 and 4
        if((beat == 0) || (beat == 2) ||(beat == 3) || (beat == 5) || (beat == 6) || (beat == 8) || (beat == 9) || (beat == 11) || (beat == 12))
        {
            0 => kick.pos;
            if (i%2)
            {
                23::ms => d.delay;
                d.clear();
            } 
        }
        
        
        //snare drim on 2 and 6 
        if((beat == 0) || (beat == 2) || (beat == 4) || (beat == 7) || (beat == 9) || (beat == 11))
        {
            0 => snare.pos; 
            Math.random2f(.6, 1.4) => snare.rate;
        }
        
        if ((beat == 0) || (beat == 3));
        {
            Std.mtof(notes[7]) => s.freq;
            Std.mtof(notes[7]) => sq.freq;
            50::ms => d.delay;
            d.clear();
        }
        
        if ((beat == 1) || (beat == 4))
        {
            Std.mtof(notes[1]) => s.freq;
            Std.mtof(notes[1]) => sq.freq;
            50::ms => d.delay;
            d.clear();
        }
        
        if (beat == 5)
        {
           Std.mtof(notes[5]) => s.freq;
           Std.mtof(notes[5]) => sq.freq;
        } 
        
        if ((beat == 7) || (beat == 10))
        {
            Std.mtof(notes[4]) => s.freq;
            Std.mtof(notes[4]) => sq.freq;
            50::ms => d.delay;
            d.clear();
        }
        
        if (beat == 8)
        {
            Std.mtof(notes[3]) => s.freq; 
            Std.mtof(notes[3]) => sq.freq;
        }
        
        if (beat == 11)
        {
            Std.mtof(notes[0]) => s.freq;
            Std.mtof(notes[0]) => sq.freq;
            50::ms => d.delay;
            d.clear();
        }
        
        if (beat == 12)
        {
            Std.mtof(notes[2]) => s.freq;
            Std.mtof(notes[2]) => sq.freq;
        }
        
        
        Math.random2f(.6, 1.0) => fx.gain;
        Math.random2f(.2, 1.8) => fx.rate;
        0 => fx.pos;
          
        // hihat
        0 => hihat.pos;
        .2 => hihat.gain;
        Math.random2f(.2,1.8) => hihat.rate;
        <<< "Counter: ", counter, "Beat: ", beat >>>;
        counter++; //counter + 1 => counter
        125::ms => now;
    }

    for(0 => int i; i < 48; i++)
    {
        30::second => d.max;
        // beat goes from 0 to 7 (8 positions)
        counter %  16=> int beat;
        
        // bass drum on 0 and 4
        if((beat == 0) || (beat == 2) ||(beat == 3) || (beat == 5) || (beat == 6) || (beat == 8) || (beat == 9) || (beat == 11) || (beat == 12) || (beat == 14) || (beat == 15))
        {
            0 => kick.pos;
        }
        
        //snare drim on 2 and 6 
        if((beat == 0) || (beat == 2) || (beat == 4) || (beat == 7) || (beat == 9) || (beat == 11) || (beat == 13) || (beat == 16))
        { 
            0 => snare.pos; 
            Math.random2f(.6, 1.4) => snare.rate;
            if (i%2)
            {
                23::ms => d.delay;
                d.clear();
            } 
        }
        
        if ((beat == 0) || (beat == 3));
        {
            Std.mtof(notes[7]+12) => s.freq;
            Std.mtof(notes[7]+12) => sq.freq;
            
        }
        
        if ((beat == 1) || (beat == 4))
        {
            Std.mtof(notes[1]+12) => s.freq;
            Std.mtof(notes[1]+12) => sq.freq;
            
        }
        
        if (beat == 5)
        {
           Std.mtof(notes[5]+12) => s.freq;
           Std.mtof(notes[5]+12) => sq.freq;
           50::ms => d.delay;
           d.clear();
        } 
        
        if ((beat == 7) || (beat == 10))
        {
            Std.mtof(notes[4]+12) => s.freq;
            Std.mtof(notes[4]+12) => sq.freq;
            50::ms => d.delay;
            d.clear();
            
        }
        
        if ((beat == 8) || (beat == 16))
        {
            Std.mtof(notes[3]+12) => s.freq; 
            Std.mtof(notes[3]+12) => sq.freq;
            50::ms => d.delay;
            d.clear();
        }
        
        if ((beat == 11) || (beat == 14))
        {
            Std.mtof(notes[0]+12) => s.freq;
            Std.mtof(notes[0]+12) => sq.freq;
            
        }
        
        if ((beat == 12)|| (beat == 15))
        {
            Std.mtof(notes[2]+12) => s.freq;
            Std.mtof(notes[2]+12) => sq.freq;
            50::ms => d.delay;
            d.clear();
        }
        
        Math.random2f(.6, 1.0) => fx.gain;
        Math.random2f(.2, 1.8) => fx.rate;
        0 => fx.pos;      
        
        // hihat
        0 => hihat.pos;
        .2 => hihat.gain;
        Math.random2f(.2,1.8) => hihat.rate;
        <<< "Counter: ", counter, "Beat: ", beat >>>;
        counter++; //counter + 1 => counter
        125::ms => now;
    }
}

0 => int counter;
    for(0 => int i; i < 32; i++)
    {
        d.clear();
        0 => s.gain;
        0 => sq.gain;
        0 => d.gain;
        .9 => kick.gain;
        .99 => snare.gain;
        counter %  16=> int beat;
        if((beat == 0) || (beat == 3) ||(beat == 7) || (beat == 10) || (beat == 12) || (beat == 14))
        {
            0 => kick.pos;
        }
        
        
        //snare drim on 2 and 6 
        if((beat == 2) || (beat == 5) || (beat == 8) || (beat == 11))
        {
            1 => snare.rate;
            0 => snare.pos;
        }

        counter++;
        125::ms => now;
    }
0 => kick.pos;
300::ms => now;