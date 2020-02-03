-module(sll_index).

-behaviour(gen_server).

-type host() :: iodata().

-type service() :: iodata().

-type event() :: term().

-type hs(Host, Service) :: [Host | Service].

-opaque index() :: pid().

-export_type([index/0]).

%% API
-export([start/1,
         stop/1,
         start_link/1]).

-export([new/0,
         clear/1,
         remove/2,
         remove/3,
         values/1,
         put/4,
         get/2]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {dummy}).

start(Name) ->
   gen_server:start_child(Name).

stop(Name) ->
   gen_server:stop(Name, stop).

new() ->
    ets:new(p, [set, protected]).

-spec clear(Index :: index()) -> ok.
clear(Index) ->
    _ = ets:delete_all_objects(Index),
    ok.

-spec remove(Index :: index(), HostService :: hs(host(), service())) -> boolean().
remove(Index, HS) ->
    remove(Index, HS, undefined).

-spec remove(Index :: index(), HostService :: hs(host(), service()), Event :: event()) -> boolean().
remove(Index, [Host, Service] = HS, _Event) ->
    K = case ets:take(Index, HS) of
        [{HS, Event}] -> Event;
        _ -> undefined
    end,
    %io:format("remove ~p h ~p s ~p e ~p k ~p ~n", [Index, Host, Service, _Event, K]),
    K.

values(Index) ->
    F = fun({_, Event}, AccIn) ->
        [Event | AccIn]
    end,

    K = ets:foldr(F, [], Index),

    %io:format("values ~p ~p ~n", [Index, K]),
    
    K.


put(Index, Host, Service, Event) ->
    %io:format("put ~p ~p ~p ~p ~n", [Index, Host, Service, Event]),
    true = ets:insert(Index, {[Host, Service], Event}),
    Event.

-spec get(Index :: index(), HostService :: hs(host(), service())) -> term().
get(Index, [_Host, _Service] = HS) ->    
    K=case ets:lookup(Index, HS) of
        [{HS, Event}] -> Event;
        _ -> undefined
    end,

    %io:format("get ~p ~p ~p ~n", [Index, HS, K]),

    K.


start_link(Name) ->
   gen_server:start_link({local, Name}, ?MODULE, [], []).

init(_Args) ->
   {ok, #state{dummy=1}}.

handle_call(stop, _From, State) ->
   {stop, normal, stopped, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
   {noreply, State}.

handle_info(_Info, State) ->
   {noreply, State}.

terminate(_Reason, _State) ->
   ok.

code_change(_OldVsn, State, _Extra) ->
   {ok, State}.
