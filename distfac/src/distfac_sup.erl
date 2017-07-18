%%%-------------------------------------------------------------------
%% @doc distfac top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(distfac_sup).

-behaviour(supervisor).
-include("distfac.hrl").
%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).


%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Connector = ?CHILD(distfac_conn, worker, []),
    Super_slave = ?CHILD(distfac_sup_slave, supervisor, []),
    Fac_srv = ?CHILD(distfac_srv, worker, []),
    {ok, { {one_for_all, 1, 5}, [Super_slave, Connector, Fac_srv]} }.

%%====================================================================
%% Internal functions
%%====================================================================
