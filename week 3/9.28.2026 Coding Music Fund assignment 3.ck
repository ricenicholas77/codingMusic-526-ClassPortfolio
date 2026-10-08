
//TriOsc c1 => SinOsc m1 => Gain g1 => ADSR Kenv => dac;
SinOsc c2 => SinOsc m2 => Gain g2 => ADSR S1env => dac;
TriOsc c3 => SinOsc m3=> g2;
SinOsc c4 => SinOsc m4 => ADSR Kenv => dac;
[72, 67, 65, 74, 67, 65, 69, 72, 74, 69] @=> int A[];
[.3, .4, .3, .2, .4, .2, .4, .3, .5] @=> float notes[];

[69, 72, 67, 72, 69, 72, 74, 69, 65, 67] @=> int B[];



//.1 => c1.gain;
1 => c2.gain;
//.1=> c3.gain;
1 => c4.gain;


for (0 => int i; i < A.cap()*2; i++){
    
    Kenv.set(20::ms, notes[i]::second, 0.0,15::ms);
    S1env.set (30::ms, notes[i]::second, 0.0, 15::ms);
    //Std.mtof(A[i])=> c1.freq;
    Std.mtof(B[i])=> c2.freq;
    //Std.mtof(B[i]-12)=> c3.freq;
    Std.mtof(A[i]-12)=> c4.freq;
    //Math.sin(Std.mtof(A[i]) * 1.73) => m1.freq;
    Math.sin(Std.mtof(B[i]) * 1.27)=> m2.freq;
    //Math.sin(Std.mtof(A[i]-12) * 1.63) => m3.freq;
    Math.sin(Std.mtof(B[i]-12) * 1.3847) => m4.freq;
    //100 => m1.gain;
    200 => m2.gain;
    //100 => m3.gain;
    200 => m4.gain;

    //2 =>m1.sync;
    2 =>m2.sync;
    //2 =>m3.sync;
    2 =>m4.sync;
    

    Kenv.keyOn();
    notes[i]::second => now;
    
    Kenv.keyOff();
    notes[i]::second => now;
    
    S1env.keyOn();
    100::ms => now;
    
    S1env.keyOff();
    100::ms => now;
}


