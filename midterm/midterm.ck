// Create HID object and message container
Hid hi;
HidMsg msg;
Gain master;

WvOut2 recorder;
me.dir() + "/midterm_recording.wav" => recorder.wavFilename;
LPF filter;
filter => recorder => dac;
adc => LiSa lisa;
lisa => recorder;

SndBuf2 fx => Delay d => Pan2 p2 => master;

0.5::second => d.max;
200::ms => d.delay;
.7 => d.gain;

d=> master => d;
master => filter;

me.dir() + "/audio/audio/stereo_fx_01.wav" => fx.read;
fx.samples() => fx.pos;


0 =>int device;
[60, 64, 67, 71, 72, 67, 64, 60] @=> int scale[];
0 => int note;
if( !hi.openJoystick( device ) ) {
    me.exit();
}

<<< "joystick open:", hi.name() >>>;
120 => float BPM;
dur quarterNote;
dur sixteenthNote;
dur thirtysecondNote;

fun void updateClock(float bpm){
    if(bpm <=0)120 => bpm;
    (60.0/bpm)::second =>quarterNote;
    quarterNote/4.0 => sixteenthNote;
    quarterNote/8.0 => thirtysecondNote;
}
updateClock(BPM);

    
10::second => lisa.duration;
30 => lisa.maxVoices;
lisa.feedback(0);
lisa.loop(0);

1000.0 => filter.freq;
1.0 => filter.Q;

1 => int isRecording;
0 => int activeBuf;
0 => int beatTrigger;
3.0 => float intervalLength;
dur updateInterval;

fun void Inputs(){
    while( true ) {      
        while( hi.recv( msg ) ) {
            if( msg.isButtonDown() && msg.which == 14) {
                 Math.random2f(-1.0, 1.0) => p2.pan;
                if (isRecording== 1) {
                    0 => isRecording;
                    <<< "!!! Live Recording PAUSED - Buffers Locked !!!" >>>;
                } else {
                    1 => isRecording;
                    <<< "+++ Live Recording RESUMED +++" >>>;
                }
            }
              if( msg.isButtonDown() && msg.which == 1 ) {
                note + 1 => note;
                if( note >= scale.size() ) 0 => note; 
                <<< "Changed Note to ", scale[note] >>>;
            }
            
           
            if( msg.isButtonDown() && msg.which == 2 ) {
                note - 1 => note;
                if( note < 0 ) scale.size() - 1 => note;
                <<< "note:",scale[note] >>>;
            }   
            if( (msg.isAxisMotion() && (Math.fabs(msg.axisPosition) > 0.05)) && (msg.which == 1)) {
                ((msg.axisPosition + 1.0) * 0.5) => float normalizedBPM;
                60.0 + (normalizedBPM * 180.0) => BPM;
                updateClock(BPM);
                <<< "BPM set to:", BPM>>>; 
              }  
            if( (msg.isAxisMotion() && (Math.fabs(msg.axisPosition) > 0.05)) && (msg.which == 2 )) {
                ((msg.axisPosition + 1.0) * 0.5) => float normalizedCutoff;
                80.0 + (Math.pow(normalizedCutoff, 3) * 11920.0) => float cutoff;
                cutoff => filter.freq;
                <<< "cutoff changed to", cutoff>>>;
            }
            if( (msg.isAxisMotion() && (Math.fabs(msg.axisPosition) > 0.05)) && (msg.which == 5 )) {
                ((msg.axisPosition + 1.0) * 0.5) => float normalizedQ;
                1.0 + (normalizedQ * 19.0) => filter.Q;
                <<< "resonance changed to", filter.Q>>>;
            }
         }
         10::ms =>now;
      }
   }

fun void sequencer(){
    1::second => now;
    while( true ) {
        note + 1 => note;
        if( note >= scale.size() ) 0 => note;
        1 => beatTrigger;
        if (thirtysecondNote <= 0::ms) 125::ms =>thirtysecondNote;
        thirtysecondNote => now;
    
}
}

fun void recordingLoop(){
    while(true){
        intervalLength::second => updateInterval;
        if (isRecording == 1){
            if (activeBuf == 0){
                lisa.recPos(updateInterval);
                lisa.record(1);
                updateInterval => now;
                lisa.record(0);
                1 => activeBuf;
                }
            else{
                lisa.recPos(0::second);
                lisa.record(1);
                updateInterval => now;
                lisa.record(0);
                0 => activeBuf;
            }
           <<< "--- Buffer Updated! Playing from section:", activeBuf, "---" >>>;
        }
        else{
            updateInterval => now;
            (activeBuf +1)%2=> activeBuf;          
            }
        }
    }
    
fun void granularSynth() {
    1::second => now; 
    
    while( true ) {
        if(beatTrigger == 1){
            0 => beatTrigger;
            lisa.getVoice() => int voice;
            for( 0 => int i; i < 4; i++ ) {
                if (voice > -1) {
                    intervalLength => float maxWin;
                    activeBuf * maxWin => float baseSec;
                    Math.random2f(baseSec, baseSec + (maxWin *.9)) :: second => dur voicePos;
                    lisa.playPos(voice,voicePos);
                    Math.random2(0, scale.size() - 1) => int randIndex;
                    (scale[randIndex] / Std.mtof(60)) => float rateFactor;
                    lisa.rate(voice, rateFactor);
                    
                    Math.random2f(40.0, 150.0)::ms => dur grainDur;
                    lisa.value(voice, grainDur);
                    
                    lisa.voiceGain(voice, 0.6);
                    lisa.rampUp(voice, grainDur * 0.15);
                    lisa.rampDown(voice,grainDur * 0.35);
                    
                   lisa.play(voice, 1);
                   }
                }
             }
             12::ms=>now;
          }
       }

fun void wavetableSynth() {
    1::second => now;
    lisa.getVoice() => int wtVoice;
    if(wtVoice < 0) { return; }
    
    // Set a baseline pitch rate
    lisa.rate(wtVoice, 1.0);
    lisa.voiceGain(wtVoice, 0.9);
    lisa.loop(wtVoice, 1); // Enable looping for this specific voice
    
    0.0 => float scanPos;
    0.005 => float attackSpeed;
    while( true ) {
        scale[note] => float freq;
        if(freq<= 0) 220.0 =>freq;
        1::second/freq => dur cycPeriod;
        intervalLength => float maxWin;
        activeBuf * maxWin=> float baseSec;
        scanPos + attackSpeed => scanPos;
        if ( scanPos > 1.0) 0.0=> scanPos;
        baseSec + (scanPos * (maxWin - (cycPeriod/1::second)))=> float offsetSec;
        offsetSec::second => dur tableStart;
        tableStart + cycPeriod => dur tableEnd;
        
        lisa.rampUp(wtVoice, 5::ms);
        lisa.loopStart(wtVoice,tableStart);
        lisa.loopEnd(wtVoice, tableEnd);
        
        lisa.playPos(wtVoice, tableStart);
        lisa.play(wtVoice, 1);
        
        10::ms => now;
    }
}

spork~ Inputs();
spork~ sequencer();
spork~ recordingLoop();
spork~ granularSynth();
spork~ wavetableSynth();

// Keep main process alive indefinitely
while( true ) {
    30::second => now;
}
filter =< recorder;
lisa =< recorder;