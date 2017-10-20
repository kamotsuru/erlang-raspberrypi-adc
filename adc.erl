-module(print).
-compile(export_all).

-define(SPICLK, "11"). %% GPIOピン番号
-define(SPIMOSI, "10").
-define(SPIMISO, "9").
-define(SPICS, "8").
-define(LED, "25").

main() ->
 io:format("initializing...~n"),
 pi_gpio:set_pin_direction(?SPICLK, "out"),
 pi_gpio:set_pin_direction(?SPIMOSI, "out"),
 pi_gpio:set_pin_direction(?SPIMISO, "in"),
 pi_gpio:set_pin_direction(?SPICS, "out"),
 pi_gpio:set_pin_direction(?LED, "out"),
 mainloop().

mainloop() ->
 Val = readadc(0),
 io:format("~w~n", [Val]),
 case Val > 2500 of %% 取得値が一定値以上でLED点灯
  true -> pi_gpio:set_pin_value(?LED, "1");
  false -> pi_gpio:set_pin_value(?LED, "0")
 end,
 timer:sleep(500), 
 mainloop().

readadc(Adcnum) ->
 pi_gpio:set_pin_value(?SPICS, "1"),
 pi_gpio:set_pin_value(?SPICLK, "0"),
 pi_gpio:set_pin_value(?SPICS, "0"),
 ComOut = (Adcnum bor 16#18) bsl 3, %% スタートビット＋シングルエンドビットとのor, 左3ビットシフト
 loop1(ComOut, 5), %% 5ビット送信
 Adcout = 0,
 loop2(Adcout, 13). %% 13ビット読み込み


loop1(ComO, 0) -> ok;

loop1(ComO, N) ->
 case ComO band 16#80 of %% 8ビット目が1?
  16#80 -> pi_gpio:set_pin_value(?SPIMOSI, "1");
  16#0 -> pi_gpio:set_pin_value(?SPIMOSI, "0")
 end,
 ComO1 = ComO bsl 1,
 %%io:format("loop1:clockpin:High,Low~n"),
 pi_gpio:set_pin_value(?SPICLK, "1"),
 pi_gpio:set_pin_value(?SPICLK, "0"),
 loop1(ComO1, N-1).


loop2(AdcO, 0) ->
 pi_gpio:set_pin_value(?SPICS, "1"),
 %%io:format("cspin:High~n"),
 AdcO;

loop2(AdcO, K) ->
 %%io:format("loop2:clockpin:High,Low~n"),
 pi_gpio:set_pin_value(?SPICLK, "1"),
 pi_gpio:set_pin_value(?SPICLK, "0"),
 AdcO1 = AdcO bsl 1,
 H = pi_gpio:get_pin_value(?SPIMISO), %% GPIO9番ピンから値を読み込む
 %%io:format("misopin value: ~w~n", [H]),
 case K < 13 andalso H =:= 1 of %% 値が1?
  true ->
   %%io:format("adcout bor 0x1~n"),
   AdcO2 = AdcO1 bor 16#1;
  false ->
   %%io:format("adcout bor 0x0~n"),
   AdcO2 = AdcO1
 end,
 loop2(AdcO2, K-1).

%% ctrl-g
%% i
%% c
%% pi_gpio:release_pin("11"),
%% pi_gpio:release_pin("10"),
%% pi_gpio:release_pin("9"),
%% pi_gpio:release_pin("8"),
%% pi_gpio:release_pin("25").

