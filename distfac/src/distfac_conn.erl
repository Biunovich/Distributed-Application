-module(distfac_conn).
-include("distfac.hrl").
-compile(export_all).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

calc(Num) -> 
    gen_server:call(?MODULE, {Num}). 

get_pids() -> 
    gen_server:call(?MODULE, {get_pids}).

init([]) ->
    erlang:set_cookie(node(), leet),
    WorPid = distfac_sup_slave:start_child(?PROC),
    Nodes = connect_nodes(),
    ?LOG("Remote nodes ~p",[Nodes]),
    {ok, {WorPid, Nodes}}.

connect_nodes() ->
    [Node || Node <- ?NODES, net_kernel:connect_node(Node)].

handle_call({get_pids}, _From, State) ->
    {WorPid , _} = State,
    {reply, WorPid, State};

handle_call({Num},_From, State) ->
    Nodes = nodes(),
    RemPids = rempid([], Nodes),
    {MyPid, _} = State,
    AllPids = RemPids ++ MyPid,
    {reply, AllPids, {MyPid, Nodes}}.

rempid(Acc, []) -> Acc;
rempid(Acc, [H|T]) ->
    New = rpc:call(H, distfac_conn, get_pids, []),
    rempid(New ++ Acc, T).

terminate(Reason, State) ->
    ?LOG("TERMINATE ~p ~p",[Reason, State]). 
