-define(CHILD(I, Type, Ar), {I, {I, start_link, Ar}, permanent, 5000, Type, [I]}).
-define(LOG(Msg,Arg), io:format(Msg ++ "~n",Arg)).
-define(CHILDWor(I,Mod, Type, Ar), {I, {Mod, start_link, Ar}, permanent, 5000, Type, [Mod]}).
-define(SERVER, ?MODULE).
-define(PROC, erlang:system_info(logical_processors_available)).
-define(NODES, ['a@buin-Aspire-5733Z','b@buin-Aspire-5733Z','c@buin-Aspire-5733Z']).