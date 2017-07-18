-module(distfac).
-export([start/0, calc/1]).

start() -> 
    application:start(distfac).
calc(Num) ->
    distfac_srv:fact(Num).