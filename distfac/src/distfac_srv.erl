-module(distfac_srv).
-include("distfac.hrl").
-compile(export_all).

%%%%%% API
start_link() -> gen_server:start_link({local, ?MODULE},?MODULE, [],[]).

fact(Num) when is_integer(Num) and (Num >= 0) ->
    gen_server:call(?MODULE, {Num});
fact(_) -> 
    ?LOG("Wrong arguments",[]).

start_listner(0, Pid,Acc) -> 
    Res = lists:foldl(fun(X,Prod) -> X*Prod end, 1, Acc),
    Pid ! Res;
start_listner(Proc,Pid, Acc) ->
    receive 
        X -> ?LOG("Receive from Node ~p",[X]),
             start_listner(Proc - 1,Pid,[X|Acc])
end.

start_nodes(Start, Num, Proc, Pid, [H|WorPid]) when Start =< Proc ->
    ?LOG("START NODES ~p ~p ~p ~p ~p",[Start, Num, Proc, Pid, H]),
    H ! {Start, Num, Proc, Pid},
    start_nodes(Start + 1,Num, Proc, Pid, WorPid);
start_nodes(Start, _Num, Proc, _Pid, _WorPid) when Start > Proc ->
    ok.

%%%%%% Callbacks 
init([]) -> {ok, {}}.

handle_call({Num}, _From, State) ->
    AllPids = distfac_conn:calc(Num),
    Proc = erlang:length(AllPids),
    Pid = spawn(distfac_srv,start_listner,[Proc,self(), []]),
    start_nodes(1, Num, Proc,Pid, AllPids),
    receive
        Res -> Res
    end,
    {reply, Res, State}.
