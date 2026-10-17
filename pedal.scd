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

	env = EnvGen.kr(Env.adsr(0.1, 0.2, 1, 0.5), gate, doneAction: 2);
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
SynthDef()

)

x = Synth(\bass, [\freq, 110]);
x.set(\gate, 0);

(
~revBus = Bus.audio(s, 2);

~srcGroup = Group.new;
~fxGroup = Group.after(~srcGroup);

~reverb = Synth(\reverb, [\in, ~revBus, \out, 0, \mix, 1.0], ~fxGroup);

Synth(\bass, [\freq, 32.midicps, \out, ~revBus, \amp, 0.02], ~srcGroup);
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

