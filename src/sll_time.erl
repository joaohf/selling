-module(sll_time).

%% API
-export([add/1,
         kkk/1]).

add(#{id := _Id, t := T} = Task) ->
    Ms = ms(T),

    _ = erlang:spawn(?MODULE, kkk, [{new, Ms, Task}]),
    
    ok.

kkk(finish) ->
    %io:format("K ~p end ~n",[self()]),
    ok;

kkk({periodic, #{id := _Id, interval := T} = Task}) ->
    Ms = ms(T),

    kkk({new, Ms, Task});
    
kkk({new, T, Task}) ->
    %io:format("K ~p T: ~p Task ~p~n", [self(), T, Task]),
    receive
    after
        T ->
            kkk('selling.time':'run-tasks!'(Task))
    end,
    ok.

ms(T) ->
    erlang:floor(math:ceil(T * 1000)).
