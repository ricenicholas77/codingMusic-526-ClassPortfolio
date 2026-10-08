
Osc @ osc_list[4];

SinOsc a @=> osc_list[0];
TriOsc b @=> osc_list[1];
SawOsc c @=> osc_list[2];
SqrOsc d @=> osc_list[3];

.1 => dac.gain;

 [4, 6, 7, 11, 12] @=> int arp [];
 
fun int check_note(int old_note){
    Math.random2(0,4) => int new_note;
    while (new_note == old_note){
        Math.random2(0,4) => new_note;
    }
    return new_note;
    }
    
fun int check_osc(int old_i){
    Math.random2(0,3) => int new_i;
    while (new_i == old_i){
        Math.random2(0,3) => new_i;
    }
    return new_i;
    }

 
 0 => int i;
 0 => int note;

 while (true) {
     check_osc(i) => i;
     check_note(note) => note;
     if (i == 0) .3 => dac.gain;
     else .1 => dac.gain;
     osc_list[i] => dac;
     Math.mtof(arp[note] + 42) => osc_list[i].freq;
     300::ms => now;
     osc_list[i] =< dac;
 }