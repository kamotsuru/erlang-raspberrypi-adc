-module(pi_gpio).

-compile(export_all).

-define(GPIO_PATH, "/sys/class/gpio/").
-define(GPIO, "gpio").

reserve_pin(Pin) ->
   ExportFile = string:concat(?GPIO_PATH, "export"),
   file:write_file(ExportFile, Pin, [append]).

release_pin(Pin) ->
   UnexportFile = string:concat(?GPIO_PATH, "unexport"),
   file:write_file(UnexportFile, Pin, [append]).

set_pin_direction(Pin, Direction) ->
   reserve_pin(Pin),
   file:write_file(direction_file(Pin), Direction, [append]).

set_pin_value(Pin, Value) ->
   file:write_file(value_file(Pin), Value, [append]).

get_pin_value(Pin) ->
   {ok, Value} = file:read_file(value_file(Pin)),
   {H, _} = string:to_integer(binary_to_list(Value)),
   H.

direction_file(Pin) ->
   string:concat(pin_path(Pin), "direction").

value_file(Pin) ->
   string:concat(pin_path(Pin), "value").

pin_path(Pin) ->
   PinFolder = string:concat(string:concat(?GPIO, Pin), "/"),
   string:concat(?GPIO_PATH, PinFolder).

