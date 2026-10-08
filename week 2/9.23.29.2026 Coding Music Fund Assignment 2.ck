SinOsc a => dac;
.3 => dac.gain;
2::second + 0.4::second => dur quarter; //how to make time variables
 [4, 6, 7, 11, 12] @=> int arp [];
 
fun int check_note(int old_note){
    Math.random2(0,4) => int new_note;
    while (new_note == old_note){
        Math.random2(0,4) => new_note;
    }
    
    return new_note;
    }
   

 
 0 => int i;
 0 => int note;
 48 => int oct;
 0 => int rand;

 while (true) {
     i + 1 => i;
     check_note(note) => note;
     if (i == 5){
         0 => i;
         if (rand == 0){
         oct + 12 => oct;
         }
         else{
             oct - 12 => oct;
         }
     }
     Math.random2(0,1) => rand;      
     Math.mtof(arp[note] + oct) => a.freq;
     1::quarter => now; 
     }
