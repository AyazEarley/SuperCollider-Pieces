(
SynthDef(\pluck, {
	|freq = 440, amp = 0.2, gate = 1, pan = 0|
	var env, sig;

	env = EnvGen.kr(Env.adsr(0.01, 0.2, 0.02, 0.5), gate, doneAction: 2);
	sig = SinOsc.ar(freq) * env * amp;
	sig = Pan2.ar(sig, pan);

	Out.ar(0, sig);
}).add;
)


(
SynthDef(\AMsynth, {
	|freq = 440, modFreq = 4, amp = 0.2, depth = 0.5, gate = 1, pan = 0|
	var env, sig, car, mod;

	car = SinOsc.ar(freq);
	mod = SinOsc.ar(modFreq);

	env = EnvGen.kr(Env.adsr(0.1, 0.2, 1, 3), gate, doneAction: 2);
	sig = SinOsc.ar(freq) * (1 + (mod * depth)) / (1 + depth);
	sig = Pan2.ar(sig * env * amp, pan);

	Out.ar(0, sig);
}).add;
)

(
SynthDef(\bass, {
	|freq = 110, modFreq = 0.5, amp = 0.3, gate = 1, pan = 0, depth = 0.2, out = 0|
	var env, sig, car, mod;

	car = SinOsc.ar(freq);
	mod = SinOsc.ar(modFreq);
	env = EnvGen.kr(Env.adsr(5, 1, 1, 3), gate, doneAction: 2);

	sig = SinOsc.ar(freq) * (1 + (mod * depth)) / (1 + depth);
	sig = Pan2.ar(sig * env * amp, pan);

	Out.ar(out, sig);

}).add;
)

(
SynthDef(\reverb, { |in = 0, out = 0, mix = 0.4, room = 0.8, damp = 0.5|
    var sig = In.ar(in, 2);
    sig = FreeVerb2.ar(sig[0], sig[1], mix, room, damp);
    Out.ar(out, sig);
}).add;
)

(
SynthDef(\fm, {
    arg freq=440, ratio=3.5, index=3, amp=0.3, pan=0, out=0,
        atk=0.001, dur=6, modDur=2.5;

    var env, modEnv, mod, car, sig;

    env = EnvGen.kr(Env.perc(atk, dur, 1, -6), doneAction: 2);

    modEnv = EnvGen.kr(Env.perc(atk, modDur, 1, -4));

    mod = SinOsc.ar(freq * ratio) * freq * ratio * index * modEnv;
    car = SinOsc.ar(freq + mod);

    sig = car * env * amp;
    sig = Pan2.ar(sig, pan);

    Out.ar(out, sig);
}).add;
)

x = Synth(\pluck, [\freq, 660]);
x.set(\gate, 0);

(
~revBus = Bus.audio(s, 2);

~srcGroup = Group.new;
~fxGroup = Group.after(~srcGroup);

~reverb = Synth(\reverb, [\in, ~revBus, \out, 0, \mix, 1.0], ~fxGroup);

Synth(\bass, [\freq, 32.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);
)


Synth(\bass, [\freq, 44.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);
Synth(\bass, [\freq, 51.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);
Synth(\bass, [\freq, 49.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);

(

~revBus = Bus.audio(s, 2);

~srcGroup = Group.new;
~fxGroup = Group.after(~srcGroup);

~reverb = Synth(\reverb, [\in, ~revBus, \out, 0, \mix, 1.0], ~fxGroup);

Routine {
	Synth(\bass, [\freq, 32.midicps, \out, ~revBus, \amp, 0.03], ~srcGroup);
	4.wait;
	Synth(\bass, [\freq, 44.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);
	8.wait;
	Synth(\bass, [\freq, 51.midicps, \out, ~revBus, \amp, 0.04], ~srcGroup);
	4.wait;
	Synth(\bass, [\freq, 49.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);
	8.wait();
	Pbind(\instrument, \AMsynth,
		\dur, 3,
		\degree, Pseq([
			[0,1,2,4,6],
			[3,5,7,1,4],
			[0,1,2,4],
			[0,1,6,4],

		], inf),
		\octave, 5,
		\modFreq, 1,
		\amp, 0.0075,
		\depth, 0.2
	).play;
	12.wait();
	Pbind(
		\instrument, \fm,
		\ratio, 3.2,
		\index, 3.5,
		\dur, 3,
		\degree, Pxrand([0,6,2,4,\r,\r], inf),
		\octave, 6,
		\amp, 0.001
	).play;
	10.wait();
	Pbind(
		\instrument, \fm,
		\ratio, 3.5,
		\index, 3.5,
		\dur, 2.2,
		\degree, Pxrand([0,6,2,1,4,\r,\r], inf),
		\octave, 5,
		\amp, 0.001
	).play;
	5.wait();
	Pbind(
		\instrument, \fm,
		\ratio, 3.2,
		\index, 3.5,
		\dur, 2.4,
		\degree, Pxrand([0,6,1,5,2,4,\r,\r], inf),
		\octave, 7,
		\amp, 0.001
	).play;
	5.wait();
	Pbind(
		\instrument, \fm,
		\ratio, 3.345,
		\index, 3.5,
		\dur, 1.6,
		\degree, Pxrand([0,3,6,1,5,2,4,\r,\r,\r], inf),
		\octave, 7,
		\amp, 0.003
	).play;
	5.wait();
	Pbind(
		\instrument, \fm,
		\ratio, 3.345,
		\index, 3.5,
		\dur, 1.2,
		\degree, Pxrand([0,3,6,1,4,2,6,\r], inf),
		\octave, 7,
		\amp, 0.003
	).play;
	Pbind(
		\instrument, \fm,
		\ratio, 3.345,
		\index, 3.5,
		\dur, 1,
		\degree, Pxrand([0,3,1,5,2,6,\r], inf),
		\octave, 7,
		\amp, 0.003
	).play;
	4.wait();
	Pbind(
		\instrument, \fm,
		\ratio, 3,
		\index, 3.345,
		\dur, 0.8,
		\degree, Pxrand([0,6,6,0,2,4,\r,\r], inf),
		\octave, 6,
		\amp, 0.004
	).play;

	2.wait();

	//|freq = 440, modFreq = 4, amp = 0.2, depth = 0.5, gate = 1, pan = 0|
}.play
)


/*
Pbind(
	\instrument, \bass

).add;
)
*/

/*
Pbind(

	\instrument, \AMsynth,
	\dur, 2,
	\degree, Pseq([
		[0,2,4,5],
		[3,5,7,2],

	], 3),
	\octave, 5,
	\amp, 0.05

).play;
	*/

