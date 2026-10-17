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
SynthDef(\midiSynth, {
	|midi = 75, amp = 0.2, gate = 1, pan = 0|

	var env, sig;

	env = EnvGen.kr(Env.adsr(0.01, 0.2, 0.02, 0.0), gate, doneAction: 2);
	sig = SinOsc.ar(midi.midicps) * env * amp;
	sig = Pan2.ar(sig, pan);

	Out.ar(0, sig);


}).add;
)

(
SynthDef(\midiSynthAM, {
	|pitch = 60, modFreq = 2, amp = 0.2, depth = 0.5, gate = 1, pan = 0|
	var env, sig, car, mod, freq;
	freq = pitch.midicps;

	car = SinOsc.ar(freq);
	mod = SinOsc.ar(modFreq);


	env = EnvGen.kr(Env.adsr(0.5, 1, 1, 3), gate, doneAction: 2);
	sig = SinOsc.ar(freq) * (1 + (mod * depth) / (1 + depth));
	sig = Pan2.ar(sig * env * amp, pan);

	Out.ar(0, sig);

}).add;
)

(
SynthDef(\bass, {
	|freq = 110, voices = 4, detune = 0.2; amp = 0.2, depth, gate = 1, pan = 0|

	var env, sig;

	env = EnvGen.kr(Env.adsr(3, 1, 1, 3), gate, doneAction: 2);
	sig =

}).add;
}

x = Synth(\pluck, [\freq, 330]);
x.set(\freq, 550);
x.set(\gate, 0);

y = Synth(\AMsynth, [\freq, 220, \modFreq, 0.5, \depth, 0.8]);
y.set(\gate, 0);

z = Synth(\midiSynthAM);
z.set(\gate, 0);


(
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

)


