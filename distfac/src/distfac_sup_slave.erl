-module(distfac_sup_slave).
-include("distfac.hrl").
-compile(export_all).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Proc)->  start_child(Proc, []).
start_child(0, Acc) -> Acc;
start_child(Proc, Acc) ->
    Child_Proc =  ?CHILDWor(make_ref(),fac_ser, worker, []),
    {ok, Pid } = supervisor:start_child(?SERVER, Child_Proc),
    start_child(Proc - 1, [Pid|Acc]).


init([]) ->
    {ok, { {one_for_one, 1, 5}, []}}.