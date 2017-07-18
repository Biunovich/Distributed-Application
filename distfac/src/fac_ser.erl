-module(fac_ser).
-include("distfac.hrl").
-compile(export_all).

prod_part(Start, Num, Proc, Pid, WorPid) -> 
    gen_server:cast(WorPid ,{Start, Num, Proc, Pid}).

prod(Start, Num, Proc, Acc) when Start =< Num -> 
    prod(Start + Proc, Num, Proc, Acc*Start);
prod(Start, Num, _Proc, Acc) when Start > Num ->
    Acc.
start_link() ->
    ?LOG("Started node",[]),
    gen_server:start_link(?MODULE, [], []).
init([]) ->
    {ok, {}}.
handle_cast({Start,Num, Proc, Pid}, State) ->
    ?LOG("Received ~p ~p ~p",[Start,Num,Proc]),
    Pid ! prod(Start,Num,Proc,1),
    {noreply , State}.
handle_info({Start, Num, Proc, Pid}, State) ->
    Pid ! prod(Start,Num,Proc,1),
    {noreply, State}.
terminate(normal, _State) ->
    ?LOG("Worker died",[]).
