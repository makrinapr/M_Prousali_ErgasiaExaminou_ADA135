s.boot;

s.options.memSize_(2.pow(20));

s.reboot;



thisProcess.nowExecutingPath;
PathName(thisProcess.nowExecutingPath).parentPath;

~audiopath = PathName(thisProcess.nowExecutingPath).parentPath++ "audio/";
(
~b0 = Buffer.read(s,~audiopath ++ "pari.wav");
~b1 = Buffer.read(s,~audiopath ++ "mastechef.wav");
~b2 = Buffer.read(s,~audiopath ++ "sk.wav");
~b3 = Buffer.read(s,~audiopath ++ "ion.wav");
~b4 = Buffer.read(s,~audiopath ++ "ste.wav");
~b5 = Buffer.read(s,~audiopath ++ "bird.wav");
~b6 = Buffer.read(s,~audiopath ++ "ba1.wav");
~b7 = Buffer.read(s,~audiopath ++ "ba2.wav");
~b8 = Buffer.read(s,~audiopath ++ "ba3.wav");
~b9 = Buffer.read(s,~audiopath ++ "ba4.wav");
~b10 = Buffer.read(s,~audiopath ++ "ba5.wav");
~b11 = Buffer.read(s,~audiopath ++ "ba8.wav");
~b12 = Buffer.read(s,~audiopath ++ "ba9.wav");
~b13 = Buffer.read(s,~audiopath ++ "eidiseis3.wav");
~b14 = Buffer.read(s,~audiopath ++ "mc.wav");
~b15 = Buffer.read(s,~audiopath ++ "mc2.wav");
)


(
{


x = {
	arg amp =0.5,  buf=1 ,gate=1,freq=80,note=0.5, pan = rrand(-1.0,1.0);
	var sig,env,filtermod;
	filtermod = SinOsc.kr(note).range(20, 30);
	env= EnvGen.kr(Env.new([0,0.5,0.1,0.5,0],[12,10,8,7],[1,1,-1,3]));
	sig = FreqShift.ar(PlayBuf.ar(2,buf,0.1),freq*filtermod);
	sig= sig*amp*env;
	sig = Pan2.ar(sig,pan);
}.play;

y = {
	arg  buf=1,  da=2,rate=0.1,freq=1000 ;
	var sig,env;
	env= EnvGen.kr(Env.new([0,0.5,0.9,0.7,0],[ 10,10,10,13],[1,1,1]));
	sig =FreqShift.ar(PlayBuf.ar(2,buf,rate * -10.midiratio, doneAction:2),freq,1)*env;
	sig = FreeVerb.ar(sig,0.2,0.8,0.5);

	}.play;

10.0.wait;

z = {
	arg amp=2,buf=6,rate=0.7,winS=3,pitchR=1,pitchD=0.2;
	var sig,env;
	env= EnvGen.kr(Env.new([0,0.5,2,0],[13,9,6],[1,1,0]));
	sig = PitchShift.ar(PlayBuf.ar(2,buf,rate* -30.midiratio),winS,pitchR,pitchD);
    sig =sig*amp*env;

	}.play;

10.0.wait;
(
SynthDef(\tone,{
		arg buf=8, ampHz=2, rate=0.5, pan = 1.0, in=0.5, out=1,width=0.5,loop=0,maxenv=0.8 ;
		var sig,amp,env,envs;
		amp= LFPulse.kr(ampHz,0,width)*0.45;
		env= EnvGen.kr(Env.new([0,maxenv,0],[in,out]));
		sig= PlayBuf.ar(2,buf,rate,loop:loop);
		sig= sig*amp*env;
		sig = Pan2.ar(sig,pan);
		Out.ar(pan,sig);
		}).add;


t = Synth.new(\tone,
		[\ampHz,1,
			\in,4,
			\out,8,
			\width,2.5,
			\rate,1* - 15.midiratio,
			\pan,0]);

);
10.0.wait;

	x.set(\note,30);

1.8.wait;


b = {
	arg amp=0.5,buf=5,freq=440,rate=0.1 ;
	var sig,env,pitch;
	env= EnvGen.kr(Env.new([0,0.1,0.5,0],[ 5,10,10],[1,-5,0]));
	pitch = Pulse.kr(200,0,5,1);
    sig = FreqShift.ar(PlayBuf.ar(2,buf,rate ),freq*pitch);
	sig =sig*amp;
		}.play;

y.set(
	  \rate,0.5,
	  \room, 0.5,
	  \mix, 0.5,
	  \freq,500,

        );


5.6.wait;

SynthDef(\bufl3,{
	arg amp=0.2,  buf=10 ,rel=6,in=5;
	var sig,env;
		sig = PitchShift.ar(PlayBuf.ar(2,buf,BufRateScale.kr(buf)*0.5)* SinOsc.kr(50,0.5 , 5));
    env= EnvGen.kr(Env.new([0,1,0],[ in,rel],[2,2]));
		sig =sig*amp*env;
		Out.ar(0,sig);
	    Out.ar(1,sig);
		}).play;

6.0.wait;

(
	SynthDef.new(\beat,{
	arg buf=4, rate=1,impHz =2,amp=2,winS=0.5,pitchR= 2.0,pan=0 ;
	var sig,env,trig,spos,envsyn;
		trig = Impulse.kr(impHz);
		spos = TIRand.kr(0,BufFrames.kr(buf)-1,trig);
		env= EnvGen.kr(Env.new([0,1,0],[0.01,(1/impHz)-0.01],[1,-2]),trig);
		envsyn = EnvGen.kr(Env.new([0,0.7,0.5,0],[10,5,20],[1,2]));
	    sig= PlayBuf.ar(2,buf,rate,trig,spos);
		sig = sig*env*envsyn;
		sig = sig*amp;
		sig = Pan2.ar(sig,pan);
		Out.ar(0,sig);
		sig = sig*amp;

}).add;

	);

Array.rand(20,-12.0,10.0).do({
			arg n;
			Synth.new(\beat,
				[
					\buf,
					\rate, n.midiratio,
					\impHz,rrand(2.0,10.0),
					\amp,0.7,
					\pan,rrand(-1.0,1.0),
	]

	);
	});


3.0.wait;

SynthDef(\crackle,{
		arg  buf=2, amp=3,rel=1,in=1,rate=2,da=2,t_gate=1,pan= rrand(-1.0,1.0);
	var sig, env, spos;
    sig=PitchShift.ar(PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate),1,3.0,0.5, 0.2, 0.75,  0.0);
	env= EnvGen.kr(Env.new([0,0.5,1,0],[in,rel],[3,-3]));
	sig=sig*amp*env;
	sig = Pan2.ar(sig,pan);
	Out.ar(pan,sig);

		}).add;

  c = Routine({loop{ 4.wait;
	Synth(\crackle);
			}
		});
     c.play;


11.3.wait;

(	SynthDef(\pulse,{
		arg ampHz=2,buf=0,rate=0.2,mix=0.7,room=0.8,damp=0.25,in=3,dc=5,inc=10,f=10,l=5,o=5,w=10,rel=8,loop=1.0,width=0.5,envmax=2,envmed=1.5;
 var sig,amp,env;
	     env = EnvGen.kr(Env.new([0.1,envmax,0.5,envmed,0.6,0.1,0.5,envmed,0],[in,dc,inc,f,l,o,w,rel]));
	     sig = PlayBuf.ar(2,buf,rate,loop:loop);
	     amp = LFPulse.kr(ampHz,0,width)*1.5;
	     sig = sig* amp*env;
	     sig = FreeVerb.ar(sig,mix,room,damp);
		 Out.ar(0,sig);
         Out.ar(1,sig);
	}).add

			);

	p = Synth.new(\pulse);


15.6.wait;
(
	SynthDef(\newpulse,{
	arg buf=7,freq=150, amp=0.7,rate= 0.1,freqpi=20,width=0.6,in=9,out=30,loop=1.0;
	var sig,detunesig,env,pitch ;
	env = EnvGen.kr(Env.new([0.1,0.7,0.1],[in,out],[1,5]));
	pitch = Pulse.kr(freqpi,width);
	sig =FreqShift.ar(PlayBuf.ar(2,buf,rate,loop:loop ),LFNoise0.kr(0.45,1000)*pitch,0,[1,1]);
    sig = FreeVerb.ar(sig,1.3,0.9,0.8);
    sig = sig*amp*env;
	Out.ar(0,sig);
    Out.ar(1,sig);

			}).add

			);

	n = Synth.new(\newpulse, [\buf]);


c.stop;

12.0.wait;

	n.set(\rate,0.3,
		\freq,50,
		\freqpi,80,
	 	\width,0.9,
	 	\mix,0.5,
		\room,1.3

	 );

3.43.wait;

u = Synth.new(\pulse,[
		 \buf,11,
		\loop,0,
		\dc,10,
		\inc,0.5,
		\f,4.5,
		\w,4.5
	]);

9.11.wait;

y = {
	arg amp=1.5,  buf=12,rate=0.2,loop = 1.0;
	var sig,env,envs;
	env= EnvGen.kr(Env.sine(13), 1.0, 0.05,0.02);
		envs= EnvGen.kr(Env.new([0,0.5,1,0,1,0],[3,5,9,12,12.50],[1,5,-3,-1,4]));
    sig = PlayBuf.ar(2,buf,rate,loop:loop,)* SinOsc.kr([-2.midiratio,3.3,4.5,5],0, [13, 24, 12])*env;
	sig =sig*amp*envs;

		}.play;

11.89.wait;
			 o = Synth.new(\tone,[
			 	\ampHz,6,
			 	\in,1,
			 	\out,12,
				\maxenv,1.5,
			 	\width,0.85,
			 	\rate,0.3 * 5.midiratio,
			    \pan,0]);

1.25.wait;
			n.set(
			 	\loop,0,
			 	\rate,0.9,
			 	\freq,440,
			 	\freqpi,440,
			 	\width,0,

			 );

22.07.wait;

  y.set(\rate,0.8,
	    \amp,0.9,
	    );

		l = Synth.new(\pulse,[
			 	\buf,12,
		        \in,0.3,
		        \dc,0.5,
		        \inc,1.2,
		        \f,0.4,
	            \l,0.35,
		        \o,1.38,
		        \w,0.7,
		        \rel,17.0,
				\envmax,1.0,
			 	\rate,0.15 * 30.midiratio,
			 	\loop,1,
		        \ampHz,6,
			 	\width,0.3,
			 	\mix,0.25,
			 	\room,1.5,
			 	\damp,0.45,

			 ]);


5.28.wait;


	s = Synth.new(\pulse,[
			 	\buf,12,
				\in,1.0,
		        \dc,1.9,
				\envmax,0.4,
			 	\rate,0.3 * 30.midiratio,
			 	\loop,0,
				\ampHz,6,
			 	\width,0.45,
			 	\mix,0.25,
			 	\room,0.7,
			 	\damp,1.0,

			 ]);

2.90.wait;

	e = Synth.new(\pulse,[
			 	\buf,12,
			 	\rate,0.25 * 40.midiratio,
				\in,2,
		        \dc,0.1,
		        \inc,1.5,
		        \f,2.5,
	            \l,0.5,
		        \o,0.5,
		        \w,1.7,
		        \rel,1.0,
				\envmax,1.5,
				\envmed,1.0,
			 	\ampHz,3,
			 	\width,0.1,
			 	\mix,1.25,
			 	\room,0.5,
			 	\damp,0.55,
			 	\loop,1
			 ]);

   f = Synth.new(\pulse,[
			 	\buf,12,
			 	\rate,0.4 * -10.midiratio,
				\in,2,
		        \dc,0.1,
		        \inc,1.5,
		        \f,1.5,
	            \l,0.5,
		        \o,0.5,
		        \w,1.7,
		        \rel,1.0,
			 	\loop,1,
				\ampHz,3,
			 	\width,0.1,
			 	\mix,0.75,
			 	\room,0.68,
			 	\damp,2.5,

			 ]);

4.56.wait;


	g = Synth.new(\pulse,[
			 	\buf,12,
			 	\rate,0.7 * 10.midiratio,
				\in,0.3,
		        \dc,0.1,
		        \inc,1.0,
		        \f,0.5,
	            \l,0.5,
		        \o,0.5,
		        \w,3.7,
		        \rel,15.0,
			 	\ampHz,3,
			 	\width,0.1,
			 	\mix,0.75,
			 	\room,0.68,
			 	\damp,0.5,
			 	\loop,1
			 ]);


	6.47.wait;

(
		SynthDef(\buffer_sound,{
		arg amp=0.7,  buf=12 ,rate=0.7,envmax = 0.7,atk=1,rel=5.30,c1=1,c2=2;
		var sig,env;
		env= EnvGen.kr(Env.new([0,envmax,0],[ atk,rel],[c1,c2]));
		sig = PlayBuf.ar(2,buf,rate);
		sig =sig*amp;
		sig = sig*env;
		Out.ar(0,sig);
		Out.ar(1,sig);
			}).add
	);

r = Synth.new(\buffer_sound,[
				\buf,]);


5.71.wait;


SynthDef(\bufmix,{
				arg buf=15 ,rate=0.3, sus=0,rel=3,c1=1,c2=(-1),freq=440,rq=1,bpfmix=0,pan= 0,amp=0.8,atk=0;
		var sig,env;

		env = EnvGen.kr(Env.new([0,0.8,0.8,0],[ atk,sus,rel],[c1,0,c2]));
				sig = PlayBuf.ar(2,buf,rate*BufRateScale.ir(buf));
				sig = XFade2.ar(sig,BPF.ar(sig,freq,rq,1/rq.sqrt),bpfmix*2-1);
				sig = sig*env;

				sig = Pan2.ar(sig, pan,amp);
				 Out.ar(pan,sig);

	}).add;


	m = Routine({loop{

				rrand(1,3).wait;

(
				rrand(1,20).do{
					Synth(\bufmix,
						[

							\buf,[~b15,~b3].choose,
							\atk,exprand(2,3),
							\sus,1,
							\rel,exprand(2,3),
							\bpfmix,1,
							\freq,(Scale.lydian.degrees+60).choose.midicps*[1,2].choose,
							\rq,exprand(0.001,0.010),
							\rate,exprand(0.1,2.6),
							\pan,rrand(-1.0,1.0),

			]);}
			)
			}});

m.play;

9.50.wait;


	SynthDef(\buffer,{
		arg amp=0.5,  buf=15 ,rate=0.5;
		var sig,env,pitch;
        env= EnvGen.kr(Env.new([0,0.5,0],[ 1,5],[1,1]));
		pitch = Pulse.kr(20,0.5);
		sig =FreqShift.ar(PlayBuf.ar(2,buf,rate,loop:1.0 ),LFNoise0.kr(0.45,2000)*pitch,0,[1,1]);

		sig =sig*amp;
		sig =sig *env;
		Out.ar(0,sig);
		Out.ar(1,sig);
	}).add;





v = Routine({loop{
1.0.wait;

(
			Synth(\buffer,[~b15,~b14].choose,
						);
			)
			}});



v.play;


11.0.wait;

	v.stop;

s = Synth.new(\buffer_sound,[
				\buf,3,
				\envmax,0.3,
				\atk,1,
				\rel,10.50,
				\c1,1,
				\c2,1,
				\rate,1,
				\amp,1,
			]);
2.91.wait;

	q = Synth.new(\buffer_sound,[
		          \buf,13,
		          \envmax,0.3,
		          \atk,1.0,
		          \rel,3.0,
		          \rate,0.8,
		          \amp,0.3,
	]);


	s.set(\rate,0.5);


10.50.wait;


d = Synth.new(\buffer_sound,[
				\buf,10,
				\envmax,0.5,
				\atk,1,
				\rel,8.80,
			    \c1,-2,
				\c2,2,
				\rate,0.6,
				\amp,0.5,
			]);


6.58.wait;

m.stop;

3.3.wait;

Buffer.freeAll;

}.fork;
)


































