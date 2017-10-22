# erlang-raspberrypi-adc
##Installation Erlang to Raspberry Pi, and GPIO controle
Refer the following web sites to install Erlang to Raspberry Pi, and to control GPIO
[Raspberry Pi and Erlang - Part1](http://www.marksense.net/raspberry-pi-and-erlang-part-1/)
[Raspberry Pi and Erlang - Part2](http://www.marksense.net/raspberry-pi-and-erlang-part-2/)

<https://github.com/kamotsuru/erlang-raspberrypi-adc/blob/master/pi_gpio.erl>

##Retrieve analogue value from Raspberry Pi using Erlang
rewrote the python code to retrieve an analogue value from AD converter using SPI communication on section 6 of "Learning Electronic handiclafts in Raspberry Pi/ [Raspberry Piで学ぶ電子工作](http://bluebacks.kodansha.co.jp/special/rspi.html)," blue backs, Kodansha.
The above book describes the electronic circuit including photo register, AD converter, LED, and the python code.

<https://github.com/kamotsuru/erlang-raspberrypi-adc/blob/master/adc.erl>
