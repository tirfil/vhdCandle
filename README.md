# vhdCandle

based on https://cpldcpu.com/2013/12/08/hacking-a-candleflicker-led/ and 
http://picatout-jd.blogspot.fr/2013/12/chandelle-electronique.html (french).

LED is fully emitting (100%) 50% of the time. For the other 50% of time, LED brigthness is between 50% and 100%.
Flickering update objective is about 15 Hertz.

Randomization is operated by a LFSR 17-bit.
A new 5 bit PWM signal is generated every 2.62 ms.
32 x 2.62 ms = 83.84 ms -> 12 Hertz.

12 leds prototype for Xmas:

![Watch the video](https://github.com/tirfil/vhdCandle/blob/master/MEDIA/CIMG7627.JPG)(https://github.com/tirfil/vhdCandle/blob/master/MEDIA/CIMG7626.AVI)

